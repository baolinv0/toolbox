% CameraCalibrationTool Main class for the Camera Calibrator App
%    
%    This object implements the core routines in Camera Calibrator App.
%    All the callbacks that you see in the UI are implemented below.
%
%    NOTES
%    =====
%    1. To invoke the tool, follow these steps:
%       >>  tool = vision.internal.calibration.tool.CameraCalibrationTool;
%       >>  tool.show();       
%       or simply invoke cameraCalibrator.m
%
%    2. To manage tool instances and to be able to close all tools, 
%       a persistent variable is used. It is protected by mlock. That means
%       that clear classes will not unload this class unless all UI 
%       instances are closed. At that point, the tool calls munlock and a
%       "clear classes" command can actually unload the class from memory.
%       You can always verify if the class is fully unlocked by calling:
%       >> mislocked vision.internal.calibration.tool.CameraCalibrationTool
%
%    3. Naming conventions
%       a. Main set of callbacks for tool-strip buttons use simple verbs,
%          e.g. calibrate, export, saveSession, etc.
%       b. Smaller callback use the verb "do", e.g. doKeyPress,
%          doEditCallback, etc.
%       c. Methods are camel-cased.

% Copyright 2012-2015 The MathWorks, Inc.

classdef CameraCalibrationTool < vision.internal.uitools.ToolStripApp
    
    properties(Access=private)
        
        % Tool group management
        CalibrationTab
        ImageCaptureTab

        % Stereo or single camera
        IsStereo = false;
        
        % Handles the MainImage figure
        MainImageDisplay; 
        ReprojectionErrorsDisplay;
        ExtrinsicsDisplay;
        
        % The item below is just a dummy cache for storing Java related
        % items that would otherwise break by going out of scope
        Misc

        % Handle to the Java's JList which holds all the boards. It must        
        % be available throughout the class so that one can obtain the
        % currently selected board
        JBoardList
        
        MinBoards = 2; % minimum number of boards required for calibration     
        
        CurrentBoard = [];
               
        OpenSessionPath;
        
        % A flag indicating that doSelection() is in progress to prevent
        % doDeleteKey from executing.
        StillDrawing = false;
        
        % Only use in stereo calibrator because for camera calibrator
        % imgetfile remembers the last directory.
        LastStereoImagesDirs = {};
    end
    
        
    
    properties (Access=public, Hidden)
        ImagePreviewDisplay;        
    end
    %----------------------------------------------------------------------
    % Public methods
    %----------------------------------------------------------------------
    methods (Access='public')
        
        %------------------------------------------------------------------
        function this = CameraCalibrationTool(isStereo)
            if nargin == 0
                isStereo = false;
            end
            
            this.IsStereo = isStereo;
            
            import vision.internal.calibration.*;
            
            % generate a name for this tool; we need a unique string for
            % each instance
            [~, name] = fileparts(tempname);
            
            if isStereo
                title = vision.getMessage('vision:caltool:StereoToolTitle');
            else
                title = vision.getMessage('vision:caltool:ToolTitle');
            end
            
            this.ToolGroup = toolpack.desktop.ToolGroup(name, title);
            
            this.CalibrationTab = tool.CalibrationTab(this, isStereo);
            add(this.ToolGroup, getToolTab(this.CalibrationTab), 1);
            
            this.displayInitialDataBrowserMessage();
            
            this.SessionManager = ...
                vision.internal.calibration.tool.CalibrationSessionManager;
            this.SessionManager.AppName = title;
            this.SessionManager.IsStereo = this.IsStereo;
                
            
            this.Session = tool.Session; % initialize the session object
            if isStereo
                this.Session.ExportVariableName = 'stereoParams';
            end
            
            this.setDefaultCameraModelOptions();
                        
            % handle closing of the group
            this.setClosingApprovalNeeded(true);
            addlistener(this.ToolGroup, 'GroupAction', ...
                @(es,ed)doClosingSession(this, es, ed));
            
            % manageToolInstances
            this.addToolInstance();
            
            % set the path for opening sessions to the current directory
            this.OpenSessionPath = pwd;
        end
                
        %------------------------------------------------------------------
        function show(this)
            
            this.removeViewTab();
            this.ToolGroup.open();                        
            
            % create figures and lay them out the way that we want them
            imageslib.internal.apputil.ScreenUtilities.setInitialToolPosition(this.getGroupName());
            
            % create default window layout
            this.createDefaultLayout();
            
            % the call below affects data browser's width
            this.resetDataBrowserLocation();
            
            % update all button states to indicate the tool's state
            this.updateButtonStates();
            
            drawnow();
        end

    end % public methods

    %----------------------------------------------------------------------
    % Many of the methods below are public because they are used by tests
    % or by CalibrationTab, but they still should not be used outside of
    % these two areas.
    %----------------------------------------------------------------------
    methods (Access='public', Hidden)
        
        %------------------------------------------------------------------
        % Each instance of the tool has a unique name.  You can use this
        % method to get the name
        %------------------------------------------------------------------
        function name = getGroupName(this)
            name = this.ToolGroup.Name;
        end
        
        %------------------------------------------------------------------
        % New session button callback
        %------------------------------------------------------------------
        function newSession(this)                    
            % First check if we need to save anything before we wipe
            % existing data
            isCanceled = this.processSessionSaving();
            if isCanceled
                return;
            end

            % Wipe the UI clean
            this.resetAll;                       

            % Reset the camera model as well
            this.setDefaultCameraModelOptions();
            
            this.CalibrationTab.enableNumRadialCoefficients();
            
            % Update the button states
            this.updateButtonStates();
            
        end
        
        %------------------------------------------------------------------
        % Open session button callback
        %------------------------------------------------------------------
        function openSession(this)

            % First check if we need to save anything before we wipe
            % existing data
            isCanceled = this.processSessionSaving();
            if isCanceled
                return;
            end
            
            calFilesString = vision.getMessage('vision:caltool:CalibrationSessionFiles');
            allFilesString = vision.getMessage('vision:uitools:AllFiles');
            selectFileTitle = vision.getMessage('vision:uitools:SelectFileTitle');
            
            [filename, pathname] = uigetfile( ...
                {'*.mat', [calFilesString,' (*.mat)']; ...
                '*.*', [allFilesString, ' (*.*)']}, ...
                selectFileTitle, this.OpenSessionPath);
            
            wasCanceled = isequal(filename,0) || isequal(pathname,0);
            if wasCanceled
                return;
            end            
            
            % preserve the last path for next time
            this.OpenSessionPath = pathname;            

            % Indicate that this is going to take some time
            setWaiting(this.ToolGroup, true);
            
            this.processOpenSession(pathname, filename)
                       
            setWaiting(this.ToolGroup, false);
        end
        
        %------------------------------------------------------------------
        % Save session button callback
        %------------------------------------------------------------------
        function saveSession(this, fileName)
            
            % If we didn't save the session before, ask for the filename
            if nargin < 2
                if isempty(this.Session.FileName)
                    fileName = vision.internal.uitools.getSessionFilename(...
                        this.SessionManager.DefaultSessionFileName);
                    if isempty(fileName)
                        return;
                    end
                else
                    fileName = this.Session.FileName;
                end
            end
            
            this.Session.CameraModel = this.CalibrationTab.CameraModel; 
            this.SessionManager.saveSession(this.Session, fileName);
        end

        %------------------------------------------------------------------
        function saveSessionAs(this)
            fileName = vision.internal.uitools.getSessionFilename(...
                this.SessionManager.DefaultSessionFileName);
            if ~isempty(fileName)
                this.saveSession(fileName);
            end
        end       
        
        %------------------------------------------------------------------
        % Add images/Add images from file button callback
        %------------------------------------------------------------------
        function addImages(this)
            if this.Session.hasAnyBoards()
                [files, isUserCanceled] = getImageFiles(this);
                if isUserCanceled
                    return;
                end
                addImagesToExistingSession(this, files);
            else
                [files, squareSize, units, isUserCanceled] = ...
                    getImageFilesAndSquareSize(this);
                if isUserCanceled
                    return;
                end
                addImagesToNewSession(this, files, squareSize, units);
            end
        end
        
        %------------------------------------------------------------------
        % Add images from camera button callback
        %------------------------------------------------------------------        
        function addImagesFromCamera(this)
            existingTabs = this.ToolGroup.TabNames;
            
            % If image capture tab is not in the toolgroup, add it and bring
            % focus to it.
            if ~any(strcmp(existingTabs,'ImageCaptureTab'))
                if isempty(this.ImageCaptureTab)
                    this.ImageCaptureTab = vision.internal.calibration.tool.ImageCaptureTab(this);
                    addlistener(this.ImageCaptureTab, 'CloseTab', @(~,~)closeImageCaptureTab(this));
                end
                add(this.ToolGroup, getToolTab(this.ImageCaptureTab), 2);
            end
            % Create the device and launch preview.
            this.ImageCaptureTab.createDevice;

            this.ToolGroup.SelectedTab = vision.getMessage('vision:caltool:ImageCaptureTabName');
            this.ImagePreviewDisplay.makeFigureVisible();
            
            % Disable buttons in calibration tab.
            this.CalibrationTab.updateTabStatus(false);
            
            % Update camera property states.
            this.ImageCaptureTab.updatePropertyStates();
        end        
        
        %------------------------------------------------------------------
        % Add images from camera to a session. 
        %------------------------------------------------------------------        
        function addImagesFromCameraToSession(this, files)
            
            if this.Session.hasAnyBoards()
                addImagesToExistingSession(this, files);
            else
                [squareSize, units] = this.getSquareSize();
                isUserCanceled = isempty(squareSize);                
                if isUserCanceled
                    this.displayInitialDataBrowserMessage;
                    return;
                end
                addImagesToNewSession(this, files, squareSize, units);
            end            
        end
        
        %------------------------------------------------------------------
        % Calibrate button callback
        %------------------------------------------------------------------
        function ok = calibrate(this)
            
            ok = true;
            
            % set the cursor to "busy" to indicate that the
            % calibration process may take some time
            setWaiting(this.ToolGroup, true)            
            
            % get camera model options
            this.Session.CameraModel = this.CalibrationTab.CameraModel;            
            
            try 
                imagesUsed = calibrate(this.Session);
            catch calibEx
                errordlg(calibEx.message, ...
                    vision.getMessage('vision:caltool:CalibrationFailedTitle'), ...
                    'modal');
                setWaiting(this.ToolGroup, false); % reset the cursor
                
                resetCalibration(this.Session);
                this.updateButtonStates();                
                
                ok = false; % indicate failure
                return;
            end

            setWaiting(this.ToolGroup, false); % reset the cursor
            
            % check if some images might have been rejected
            if ~all(imagesUsed)
                % this code path is not very likely

                % warn the user about image removal
                warndlg(getString(message('vision:caltool:badBoards', sum(~imagesUsed))));
                
                removeIndex = find(~imagesUsed);
                list = this.JBoardList;
                
                this.Session.BoardSet.removeBoard(removeIndex); %#ok<FNDSB>
                
                list.setListData(this.Session.BoardSet.BoardIcons);
                
                % select first image on the list after board removal
                list.setSelectedIndex(1);
            end
            
            % update session state
            this.updateButtonStates();
                                    
            % display calibration results
            this.updatePlots();                        
            
            % redisplay the board; this time with the undistort button
            this.drawBoard();
        end
        
        %------------------------------------------------------------------
        % Export button callback
        %------------------------------------------------------------------        
        function export(this)

            if this.IsStereo
                paramsPrompt = vision.getMessage(...
                    'vision:caltool:StereoParamsExportPrompt');
            else
                paramsPrompt = vision.getMessage(...
                    'vision:caltool:CameraParamsExportPrompt');
            end
            
            exportDlg = vision.internal.calibration.tool.ExportDlg(...
                this.getGroupName(), paramsPrompt, ...
                this.Session.ExportVariableName, ...
                this.Session.ExportErrorsVariableName, ...
                this.Session.ShouldExportErrors);
            
            wait(exportDlg);
            
            if ~exportDlg.IsCanceled
                assignin('base', exportDlg.ParamsVarName, this.Session.CameraParameters);
                % display the camera parameters at the command prompt
                evalin('base', exportDlg.ParamsVarName);
                
                if exportDlg.ShouldExportErrors
                    assignin('base', exportDlg.ErrorsVarName, ...
                        this.Session.EstimationErrors);
                    evalin('base',  exportDlg.ErrorsVarName);
                end
                
                % remember the current variable name
                this.Session.ExportVariableName = exportDlg.ParamsVarName;
                this.Session.ExportErrorsVariableName = exportDlg.ErrorsVarName;
                this.Session.ShouldExportErrors = exportDlg.ShouldExportErrors;
            end            
        end        
        
        %------------------------------------------------------------------
        % Layout button callback
        %------------------------------------------------------------------
        function layout(this)                        
            this.closeAllFigures();            
            this.resetDataBrowserLocation();
            drawnow;
            this.createDefaultLayout();
                        
            % if we have data, restore plots
            if this.Session.hasAnyBoards
                if this.Session.isCalibrated()
                    
                    % reset the plots to their original state
                    this.Session.ExtrinsicsView = 'CameraCentric';
                    this.Session.ErrorsView = 'BarGraph';
                    
                    this.updatePlots();
                end
                this.drawBoard();                
            end
            
            % Zoom buttons are affected if the main image is restored
            this.updateButtonStates();
        end
        
        %------------------------------------------------------------------
        % Help button callback
        %------------------------------------------------------------------
        function help(this)

            mapfile_location = fullfile(docroot,'toolbox',...
                'vision','vision.map');
            
            if this.IsStereo
                doc_tag = 'visionStereoCalibrator';
            else
                doc_tag = 'visionCameraCalibrator';   
            end
            
            helpview(mapfile_location, doc_tag);
        end

 
        % Codegen button callback
        %------------------------------------------------------------------
        function generateCode(this)
            codeString = generateCode(this.Session);
            
            % Output the generated code to the MATLAB editor
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            editorDoc = matlab.desktop.editor.newDocument(codeString);
            editorDoc.smartIndentContents;

        end

        %------------------------------------------------------------------
        % This method is used for testing
        %------------------------------------------------------------------
        function setClosingApprovalNeeded(this, in)
            this.ToolGroup.setClosingApprovalNeeded(in);
        end
        
        %------------------------------------------------------------------
        % This callback updates session state when the camera model UI 
        % elements are changed
        %------------------------------------------------------------------
        function cameraModelChanged(this)
            if ~isCalibrated(this.Session) || ...
                ~isequal(this.Session.CameraModel, this.CalibrationTab.CameraModel)
            
                this.Session.CanExport = false;
                this.Session.IsChanged = true;                
            else
                this.Session.CanExport = true;
                this.Session.IsChanged = false;
            end
            this.updateButtonStates();
        end        
        
        %------------------------------------------------------------------
        function doOptimizationOptions(this)            
            dlg = vision.internal.calibration.tool.OptimizationOptionsDlg(...
                this.getGroupName(), this.Session.OptimizationOptions);
            wait(dlg);
            
            if isempty(this.Session.OptimizationOptions)
                this.Session.OptimizationOptions.InitialIntrinsics = [];
                this.Session.OptimizationOptions.InitialDistortion = [];
            end
                
            if ~isequal(dlg.OptimizationOptions, this.Session.OptimizationOptions)
                this.Session.OptimizationOptions = dlg.OptimizationOptions;                
                
                if isempty(this.Session.OptimizationOptions.InitialDistortion)
                    this.CalibrationTab.enableNumRadialCoefficients();
                else
                    numCoeffs = numel(this.Session.OptimizationOptions.InitialDistortion);
                    this.Session.CameraModel.NumDistortionCoefficients = numCoeffs;
                    this.CalibrationTab.disableNumRadialCoefficients(numCoeffs);
                end
                
                % This drawnow is necessary. Otherwise there is a timing
                % issue that prevents the session flags from being set
                % correctly.
                drawnow();
                this.Session.IsChanged = true;
                this.Session.CanExport = false;   
            end
            
            this.updateButtonStates();
        end
            
        %------------------------------------------------------------------
        function delete(this)
            
            this.ToolGroup.close(); % close the UI            
            this.closeAllFigures(); % shut down all figures  
            
            drawnow();  % allow time for closing of all figures
        end
                
        %------------------------------------------------------------------
        function deleteToolInstance(this)
           this.manageToolInstances('delete', this);           
        end       

        %------------------------------------------------------------------
        function processOpenSession(this, pathname, filename)
            this.resetAll();  % Start fresh            
            
            session = this.SessionManager.loadSession(pathname, filename);          
            if isempty(session)
                return;
            end
            
            this.Session = session;

            % Restore the state of the buttons related to the camera model
            this.restoreCameraModel();

            if ~isempty(this.Session.BoardSet)
                % Proceed only if the BoardsSet was initialized at least
                % once; even if it doesn't hold any boards
            
                this.updateImageStrip(this.Session.BoardSet.BoardIcons); % Restore image strip
                this.updatePlots(); % Restore calibration plots if available
                this.drawBoard(); % Display first board on the list                

                % Preserve the CanExport flag before setting the options
                % which triggers a callback that resets the flag
                keepExportFlag = this.Session.CanExport;
                                
                % Restore the CanExport flag
                this.Session.CanExport = keepExportFlag;
                
                % Update main UI buttons
                this.updateButtonStates();  
                
                if isempty(this.Session.OptimizationOptions) || ...
                    isempty(this.Session.OptimizationOptions.InitialDistortion)
                    this.CalibrationTab.enableNumRadialCoefficients();
                else
                    this.CalibrationTab.disableNumRadialCoefficients(...
                        numel(this.Session.OptimizationOptions.InitialDistortion));
                end
            end
            
            this.Session.IsChanged = false; % we just loaded it now
            
        end
        
    end
    
    %----------------------------------------------------------------------
    % Private methods
    %----------------------------------------------------------------------
    methods (Access='private')

        %------------------------------------------------------------------
        function setDefaultCameraModelOptions(this)
            numRadialCoeffs = 2;
            computeSkew = false;
            computeTangentialDist = false;
            
            this.CalibrationTab.setCameraModelOptions(numRadialCoeffs, ...
                computeSkew, computeTangentialDist);
                        
            drawnow; % lets the button callback fire before we change
                     % the session state below
            
            this.Session.IsChanged = false;        
        end        
        
        %------------------------------------------------------------------
        function restoreCameraModel(this)
            
            % Restore the calibration configuration button states
            computeSkew = this.Session.CameraModel.ComputeSkew;
            computeTangentialDist = ...
                this.Session.CameraModel.ComputeTangentialDistortion;
            numRadialCoeffs = ...
                this.Session.CameraModel.NumDistortionCoefficients;
            
            this.CalibrationTab.setCameraModelOptions(numRadialCoeffs, ...
                computeSkew, computeTangentialDist);
            
            % Give the cameraModelChanged callback enough time to fire
            drawnow;
            
        end       
                
        %------------------------------------------------------------------
        function doZoom(this, src, ~) % (src, evnt)            
            drawnow();
            
            if ~this.MainImageDisplay.isAxesValid()
                return;
            end
            
            this.MainImageDisplay.makeHandleVisible();
            % remove the listeners while we manipulate button
            % selections
            this.removeZoomListeners();
            drawnow();
            
            switch (src.Name)
                case 'btnZoomIn'                    
                    state = this.CalibrationTab.ZoomPanel.ZoomInButtonState;
                    this.MainImageDisplay.setZoomInState(state);
                    this.CalibrationTab.ZoomPanel.resetButtons();
                    drawnow();
                    this.CalibrationTab.ZoomPanel.ZoomInButtonState = state;
                    
                 case 'btnZoomOut'
                    state = this.CalibrationTab.ZoomPanel.ZoomOutButtonState;
                    this.MainImageDisplay.setZoomOutState(state);
                    this.CalibrationTab.ZoomPanel.resetButtons();
                    drawnow();
                    this.CalibrationTab.ZoomPanel.ZoomOutButtonState = state;
                        
                 case 'btnPan'
                    state = this.CalibrationTab.ZoomPanel.PanButtonState;
                    this.MainImageDisplay.setPanState(state);
                    this.CalibrationTab.ZoomPanel.resetButtons();
                    drawnow();
                    this.CalibrationTab.ZoomPanel.PanButtonState = state;
                        
            end
            
            % let the button selections re-draw
            drawnow();
            
            % add back the listeners
            this.addZoomListeners();
            this.MainImageDisplay.makeHandleInvisible();
            
        end % doZoom
        
        %--------------------------------------------------------------
        function addZoomListeners(this)
            this.CalibrationTab.ZoomPanel.addListeners(@this.doZoom);
        end
        
        %--------------------------------------------------------------
        function removeZoomListeners(this)

            if ~isempty(this.Session.BoardSet) && (this.Session.BoardSet.NumBoards > 0)
                this.CalibrationTab.ZoomPanel.removeListeners();
                drawnow();
            end
        end
        
        %------------------------------------------------------------------
        function displayInitialDataBrowserMessage(this) 
            
            if this.IsStereo
                msg = vision.getMessage(...
                    'vision:caltool:LoadImagesFirstMsgStereo'); 
            else
                msg = vision.getMessage(...
                    'vision:caltool:LoadImagesFirstMsg'); 
            end
            
            % Use Java list to display the message
            label = javaObjectEDT('javax.swing.JLabel', ...
                {msg});
            
            label.setName('InitialDataBrowser');
            
            % Add JList to a panel container
            layout = java.awt.BorderLayout;
            panel = javaObjectEDT('javax.swing.JPanel', layout);
            
            % Use nice white background just like the rest of the tool
            panel.setBackground(java.awt.Color.white);
            
            % Add the panel to the tool group
            panel.add(label, java.awt.BorderLayout.NORTH);
            this.ToolGroup.setDataBrowser(panel);
            
            drawnow();
        end
        
        %------------------------------------------------------------------
        function isCanceled = processSessionSaving(this)
            
            isCanceled = false;
            
            sessionChanged = this.Session.IsChanged;
            
            yes    = vision.getMessage('vision:uitools:Yes');
            no     = vision.getMessage('vision:uitools:No');
            cancel = vision.getMessage('vision:uitools:Cancel');
            
            if sessionChanged
                selection = this.askForSavingOfSession();
            else
                selection = no;
            end
            
            switch selection
                case yes
                    this.saveSession();
                case no
                    
                case cancel
                    isCanceled = true;
            end            
        end
        
        %------------------------------------------------------------------
        function [files, isUserCanceled] = getImageFiles(this)
            isUserCanceled = false;
            if this.IsStereo
                [squareSize, units] = getInitialSquareSize(this);
                if isempty(this.LastStereoImagesDirs)
                    this.LastStereoImagesDirs{1} = pwd();
                    this.LastStereoImagesDirs{2} = pwd();
                end
                loadDlg = ...
                    vision.internal.calibration.tool.LoadStereoImagesDlg(...
                    this.getGroupName(), this.LastStereoImagesDirs{1},...
                    this.LastStereoImagesDirs{2}, squareSize, units);
                disableSquareSize(loadDlg);
                wait(loadDlg);
                files = loadDlg.FileNames;
                this.LastStereoImagesDirs{1} = loadDlg.Dir1;
                this.LastStereoImagesDirs{2} = loadDlg.Dir2;
                if isempty(files)
                    isUserCanceled = true;
                end
            else
                [files, isUserCanceled] = imgetfile('MultiSelect', true);                
            end
        end
        
        %------------------------------------------------------------------
        function [files, squareSize, units, isUserCanceled] = ...
                getImageFilesAndSquareSize(this)

            if this.IsStereo
                [squareSize, units] = getInitialSquareSize(this);
                if isempty(this.LastStereoImagesDirs)
                    this.LastStereoImagesDirs{1} = pwd();
                    this.LastStereoImagesDirs{2} = pwd();
                end
                loadDlg = ...
                    vision.internal.calibration.tool.LoadStereoImagesDlg(...
                    this.getGroupName(), this.LastStereoImagesDirs{1},...
                    this.LastStereoImagesDirs{2}, squareSize, units);
                wait(loadDlg);
                files = loadDlg.FileNames;
                squareSize = loadDlg.SquareSize;
                units = loadDlg.Units;
                this.LastStereoImagesDirs{1} = loadDlg.Dir1;
                this.LastStereoImagesDirs{2} = loadDlg.Dir2;
                isUserCanceled = isempty(files);
            else
                [files, isUserCanceled] = imgetfile('MultiSelect', true);
                if isUserCanceled
                    squareSize = [];
                    units = '';
                else
                    [squareSize, units] = this.getSquareSize();
                    isUserCanceled = isempty(squareSize);
                end                    
            end
        end
        
        function closeImageCaptureTab(this)
            % Remove the tab.
            removeTab(this.ToolGroup, 'ImageCaptureTab');
            
            % Close the preview.
            closePreview(this.ImageCaptureTab);
            
            % @TODO: Update the controls
            this.ImagePreviewDisplay.makeFigureInvisible();
            
            % Update button status
            this.CalibrationTab.updateTabStatus(true);
            this.updateButtonStates;
        end
        

        function status = isLiveImageCaptureRunning(this)
            status = false;
            % If capture is running return true.
            if ( this.isLiveImageCaptureOpen && this.ImageCaptureTab.CaptureFlag)
                    status = true;
            end        
        end
        
        function status = isLiveImageCaptureOpen(this)
            % Do not honor this if live capture is running.
            existingTabs = this.ToolGroup.TabNames;

            status = false;
            % If capture tab is open return true.
            if (~this.IsStereo && ...
                any(strcmp(existingTabs,'ImageCaptureTab')) )
                    status = true;
            end        
        end
        
    end
    
    methods(Access=public, Hidden)
        %------------------------------------------------------------------
        function  imageStats = addImagesToNewSession(this,...
                files, squareSize, units)
            
            import vision.internal.calibration.*;
            try
                setWaiting(this.ToolGroup, true);
                this.Session.BoardSet = ...
                    tool.BoardSet(files, squareSize, units);
                setWaiting(this.ToolGroup, false); % reset the cursor
                
                drawnow();
                
                % Let the user know how many boards were detected is some
                % were missed
                imageStats.numProcessed  = size(files, 2);
                imageStats.numAdded      = this.Session.BoardSet.NumBoards;
                imageStats.numDuplicates = 0;
                showAddImageStatsDlg(this, imageStats);
                updateAfterAddingImages(this);
            catch loadingEx
                
                if ~isvalid(this)
                    % we already went through delete sequence; this can
                    % happen if the images did not yet load and someone
                    % already closed the tool
                    return;
                end
                
                setWaiting(this.ToolGroup, false); % reset the cursor
                errordlg(loadingEx.message, ...
                    vision.getMessage('vision:caltool:LoadingBoardsFailedTitle'), ...
                    'modal');
                % Manage the image strip
                if this.Session.hasAnyBoards()
                    this.updateImageStrip(this.Session.BoardSet.BoardIcons);
                else
                    this.displayInitialDataBrowserMessage;
                end
            end
        end
    end
       
    methods(Access=private)
        function updateAfterAddingImages(this)                        
            % Manage the image strip
            this.updateImageStrip(this.Session.BoardSet.BoardIcons);
            
            % Update session state
            this.Session.CanExport = false;
            this.Session.IsChanged = true;
            if ~this.isLiveImageCaptureOpen
                this.updateButtonStates();
            end
            
            % Update displays
            this.updatePlots();
            this.drawBoard();
        end

        %------------------------------------------------------------------
        function imageStats = addImagesToExistingSession(this, files)
            try
                setWaiting(this.ToolGroup, true);
                % We are adding to an existing board set
                previousNumBoards = this.Session.BoardSet.NumBoards;
                imageStats.numDuplicates = this.Session.BoardSet.addBoards(files);
                imageStats.numAdded  = this.Session.BoardSet.NumBoards - ...
                    previousNumBoards;
                imageStats.numProcessed = size(files, 2);
                
                setWaiting(this.ToolGroup, false); % reset the cursor
                showAddImageStatsDlg(this, imageStats);
                updateAfterAddingImages(this);
            catch loadingEx
                
                if ~isvalid(this)
                    % we already went through delete sequence; this can
                    % happen if the images did not yet load and someone
                    % already closed the tool
                    return;
                end
                
                setWaiting(this.ToolGroup, false); % reset the cursor
                errordlg(loadingEx.message, ...
                    vision.getMessage('vision:caltool:LoadingBoardsFailedTitle'), ...
                    'modal');
                % Manage the image strip
                if this.Session.hasAnyBoards()
                    this.updateImageStrip(this.Session.BoardSet.BoardIcons);
                else
                    this.displayInitialDataBrowserMessage;
                end                
            end
        end
            
        %------------------------------------------------------------------
        function showAddImageStatsDlg(this, imageStats)
            
            if imageStats.numAdded == imageStats.numProcessed
                % nothing to display
                return;
            end
            
            rejectedFileNames = this.Session.BoardSet.LastNonDetectedPathNames;
            if this.IsStereo
                statsDlg = ...
                    vision.internal.calibration.tool.AddImageStatsStereoDlg(...
                    this.getGroupName(), imageStats, rejectedFileNames);
            else
                statsDlg = vision.internal.calibration.tool.AddImageStatsDlg(...
                    this.getGroupName(), imageStats, rejectedFileNames);
            end
            wait(statsDlg);
        end
        
        %------------------------------------------------------------------
        function drawBoard(this)
            % What if the figure has been closed?
            if ~ishandle(this.MainImageDisplay.Fig)
                return;
            end
            
            boardIdx = this.getSelectedBoardIndex();
            if boardIdx > 0
                board = this.Session.BoardSet.getBoard(boardIdx);
                this.MainImageDisplay.drawBoard(board, boardIdx, ...
                    this.Session.CameraParameters);
            end
        end

        %------------------------------------------------------------------
        % Puts the image strip in focus
        %------------------------------------------------------------------
        function setFocusOnBoards(this)
            
            drawnow;
            this.JBoardList.requestFocus;
        end

        %------------------------------------------------------------------
        % Returns true if recalibration is a valid option
        %------------------------------------------------------------------
        function ret = canRecalibrate(this)
            
            idxMultiselect = this.getSelectedBoardIndices();
            ret = (this.Session.BoardSet.NumBoards - ...
                length(idxMultiselect)) >= this.MinBoards;
            
            ret = this.Session.isCalibrated() && ret;
        end        
    end
    methods(Access=public)
        %------------------------------------------------------------------
        % Set up management of the image strip
        %------------------------------------------------------------------
        function updateImageStrip(this, icons, varargin)
            % Populate the list with board thumbnails and file names
            this.JBoardList = javaObjectEDT('javax.swing.JList');
            this.JBoardList.setName('ImageStrip');
            
            % Manipulate the cell renderer to display both icons and text
            isIdDisplayed = true;
            isTextRightOfIcon = ~this.IsStereo;
            cellRenderer = ...
                com.mathworks.toolbox.vision.ImageStripCellRenderer(...
                isIdDisplayed, isTextRightOfIcon);
            
            this.JBoardList.setCellRenderer(cellRenderer);
            
            this.JBoardList.setListData(icons);
            
            % Add the list to a panel container
            layout = javaObjectEDT('java.awt.BorderLayout');
            dataPanel = javaObjectEDT('javax.swing.JPanel', layout);

            dataScrollPane = javaObjectEDT('javax.swing.JScrollPane', ...
                this.JBoardList);
            dataScrollPane.setWheelScrollingEnabled(true);

            % Add the panel to the tool group
            dataPanel.add(dataScrollPane, java.awt.BorderLayout.CENTER);
            this.ToolGroup.setDataBrowser(dataPanel);
            
            selectedIndex = 0;
            if (nargin==3)
                selectedIndex = varargin{1};
            end
            this.JBoardList.setSelectedIndex(selectedIndex); % select first image            
            this.JBoardList.ensureIndexIsVisible(selectedIndex); % select first image
            
            % Add a listener for handling file selections
            this.addSelectionListener();
            
            popupListener = addlistener(this.JBoardList, 'MousePressed', ...
                @doPopup);

            keyListener = addlistener(this.JBoardList, 'KeyPressed', ...
                @doDeleteKey);
            
            % Store handles to prevent going out of scope
            this.Misc.PopupListener      = popupListener;
            this.Misc.KeyListener        = keyListener;            
            
            % Other listeners to consider: ComponentKey, Key, Mouse
            
            % Store handles to prevent going out of scope
            this.Misc.DataPanel          = dataPanel;
            %--------------------------------------------------------------
            function doDeleteKey(~, hData)
               if hData.getExtendedKeyCode == 127 % delete code
                    
                   if isLiveImageCaptureRunning(this)
                       return;
                   end
                   
                   % Return if doSelection() is in progress. Otherwise
                   % the session may become inconsistent, causing an error.
                   if this.StillDrawing
                       return;
                   end
                   
                   % If we are in a session with a valid calibration data
                   % ask the user if they want to recalibrate and give them
                   % an option to bail out; otherwise, don't bother and
                   % simply delete the boards
                   if this.canRecalibrate()
                       question = vision.getMessage('vision:caltool:ConfirmRecalibration');
                       title = vision.getMessage('vision:caltool:RecalibrateTitle');
                       yes = vision.getMessage('vision:uitools:Yes');
                       cancel = vision.getMessage('vision:uitools:Cancel');
                       buttonName = questdlg(question, title, yes, cancel, yes);
                       if ~strcmp(buttonName, yes)
                           return;
                       end
                   end
                   
                   % CTRL-DEL will also end up here
                   idxMultiselect = this.getSelectedBoardIndices();
                   this.processRemoveAndRecalibrate(idxMultiselect);
               end
            end
            
            %--------------------------------------------------------------
            function doPopup(~, hData)
                
                if hData.getButton == 3 % right-click
                    
                    % Do not honor this if live capture is running.
                    if isLiveImageCaptureRunning(this)
                        return;
                    end
                        
                    % Get the list widget
                    list = hData.getSource;
                    
                    % Get current mouse location
                    point = hData.getPoint();
                    
                    % Figure out the index of the board immediately under 
                    % the mouse button
                    jIdx = list.locationToIndex(point); % 0-based java idx
                    
                    idx = jIdx + 1;                    
                                        
                    % Figure out the index list in the case of multi-select
                    idxMultiselect = this.getSelectedBoardIndices();

                    if ~any(idx == idxMultiselect)
                        % If the mouse is not over the selected area;
                        % select whatever is under the mouse and override
                        % the multi-selection index
                        list.setSelectedIndex(jIdx);
                        idxMultiselect = idx;
                    end
                                        
                    % Create a popup
                    if this.canRecalibrate()
                        item = vision.getMessage('vision:caltool:RemoveAndRecalibrate');
                        itemName = 'removeAndRecalibrateItem';
                    else
                        item = vision.getMessage('vision:uitools:Remove');
                        itemName = 'removeItem';
                    end
                    
                    menuItemRemove = javaObjectEDT('javax.swing.JMenuItem',...
                         item);
                    
                    menuItemRemove.setName(itemName);
                   
                    actionListener = addlistener(menuItemRemove,'Action',...
                        @removeAndRecalibrate); % main popup callback
                    
                    % Prevent it from going out of scope
                    this.Misc.PopupActionListener = actionListener;

                    jmenu = javaObjectEDT('javax.swing.JPopupMenu');
                    
                    jmenu.add(menuItemRemove);

                    % Display the popup
                    jmenu.show(list, point.x, point.y);
                    jmenu.repaint;
                
                end

                %----------------------------------------------------------
                % Note: the recalibration is done only if there was a prior
                % valid calibration done.  If the boards were only loaded
                % without hitting "calibrate" button, the re-calibration is
                % not invoked.
                %----------------------------------------------------------
                function removeAndRecalibrate(~,~)
                    
                    this.processRemoveAndRecalibrate(idxMultiselect)
                end %removeAndRecalibrate
            end % doPopup
            
        end % updateImageStrip
        
        % File selection handler
        %----------------------------------------
        function doSelection(this, ~, hData) % ~ was hSrc
            
            % Do not honor this if live capture is running.
            if isLiveImageCaptureRunning(this)
                return;
            end
            
            if this.Session.BoardSet.NumBoards == 0
                return
            end
            
            if hData.getSource.isSelectionEmpty == 1
                return
            end
            
            if this.getSelectedBoardIndex() < 1
                return;
            end
           
            if ~hData.getValueIsAdjusting
                % Poor man's lock. Set a flag indicating that doSelection()
                % is in progress to prevent doDeleteKey() from modifying
                % the session.
                this.StillDrawing = true;
                
                this.updatePlots();
                this.drawBoard();
                this.setFocusOnBoards();
                
                this.StillDrawing = false;
            end
        end
        
        %------------------------------------------------------------------
        function processRemoveAndRecalibrate(this, idxMultiselect)
            
            list = this.JBoardList;
            
            this.Session.BoardSet.removeBoard(idxMultiselect);
            this.Session.IsChanged = true;
            
            this.updateButtonStates();
            
            jLowestIdx = idxMultiselect(1)-1;
            
            if this.Session.BoardSet.NumBoards ~= 0
                list.setListData(this.Session.BoardSet.BoardIcons);
                
                if jLowestIdx ~= 0
                    newIdx = jLowestIdx -1;
                else
                    newIdx = 0;
                end
                
                list.setSelectedIndex(newIdx); % one before
            else
                this.resetAll;
            end
            
            % Update the UI before proceeding further
            drawnow;
            
            % Recalibrate
            if this.Session.isCalibrated()
                if this.Session.HasEnoughBoards
                    isOK = this.calibrate();
                    if ~isOK
                        this.resetCalibrationResults();
                    end
                else
                    this.resetCalibrationResults();
                end
            end
        end
        
        %------------------------------------------------------------------
        % returns index of the selected board
        %------------------------------------------------------------------
        function idx = getSelectedBoardIndex(this)
            idx = double(this.JBoardList.getSelectedIndex);
            idx = idx+1; % make it one based
        end
        
        %------------------------------------------------------------------
        function [idx, jIdx] = getSelectedBoardIndices(this)
            idx = double(this.JBoardList.getSelectedIndices);
            jIdx = idx; % 0-based java index
            idx = idx+1; % make it one based
        end
        
        %------------------------------------------------------------------
        %  Gets the UI to the starting point, as if nothing has been loaded
        %------------------------------------------------------------------
        function resetAll(this)
            % reset the session
            this.Session.reset();
            
            % reset the message in the data browser
            this.displayInitialDataBrowserMessage();
            
            % wipe the visible figures
            this.MainImageDisplay.wipeFigure();
            this.ReprojectionErrorsDisplay.wipeFigure();
            this.ExtrinsicsDisplay.wipeFigure();
                      
            % Reset the image capture tab.
            if ~isempty(this.ImageCaptureTab)
                this.ImageCaptureTab.resetAll();
            end
            
            % update buttons
            this.updateButtonStates();
        end

        %------------------------------------------------------------------
        % Unlike resetAll(), this method resets all but the image data.
        % It will wipe the calibration results.
        %------------------------------------------------------------------
        function resetCalibrationResults(this)

            % wipe the calibration portion of the Session
            this.Session.resetCalibration();
                       
            % wipe the results figures
            this.ReprojectionErrorsDisplay.wipeFigure();
            this.ExtrinsicsDisplay.wipeFigure();
            
            this.updateButtonStates();
            
            % redraw the board since the reprojection data is no longer
            % available
            this.drawBoard();
        end        
        
        %------------------------------------------------------------------
        % Calibration requires at least two boards. This routine grays out
        % the calibration button if there are fewer than MinBoards boards.
        %------------------------------------------------------------------
        function updateButtonStates(this)
            
            % Calibration tab
            if ~isempty(this.Session.BoardSet)                
                if (this.Session.BoardSet.NumBoards < this.MinBoards)
                    % gray out the calibration button
                    this.Session.HasEnoughBoards = false;
                else
                    this.Session.HasEnoughBoards = true;
                end
            end
        
            this.CalibrationTab.updateButtonStates(this.Session);            
            
            if ~isempty(this.Session.BoardSet) && (this.Session.BoardSet.NumBoards > 0)
                this.enableZoomButtons(true);
            else
                this.enableZoomButtons(false);
            end

        end

        %------------------------------------------------------------------
        function enableZoomButtons(this, enable)            
            if enable
                if ~this.CalibrationTab.ZoomPanel.IsEnabled
                    this.CalibrationTab.ZoomPanel.enableButtons();
                    this.addZoomListeners();
                end
            else
                this.removeZoomListeners();
                this.CalibrationTab.ZoomPanel.resetButtons();
                this.CalibrationTab.ZoomPanel.disableButtons();
            end
            
        end
        
        %------------------------------------------------------------------
        % Implements the dialog which asks for checkerboard square size
        %------------------------------------------------------------------
        function [squareSize, units] = getSquareSize(this)
            [initSquareSize, initUnits] = getInitialSquareSize(this);
            
            squareSizeDlg = vision.internal.calibration.tool.SquareSizeDlg(...
                this.getGroupName(), initSquareSize, initUnits);
            wait(squareSizeDlg);
            
            if ~squareSizeDlg.IsCanceled
                squareSize = squareSizeDlg.SquareSize;
                units = squareSizeDlg.Units;
            else
                squareSize = []; % return empty to indicate what happened
                units = '';
            end
        end

        %--------------------------------------------------------------
        function [initSquareSize, initUnits] = getInitialSquareSize(this)
            if isempty(this.Session.BoardSet)
                initSquareSize = 25;
                initUnits = 'mm';
            else
                initSquareSize = this.Session.BoardSet.SquareSize;
                initUnits = this.Session.BoardSet.Units;
            end
        end
        
        %--------------------------------------------------------------
        function doOKKeyPress(~, ~, evd)
                 
            switch(evd.Key)
                case {'return','space','escape'}
                    uiresume(gcbf);
            end
        end
                        
        %------------------------------------------------------------------
        function updatePlots(this)
            
            if this.Session.isCalibrated() % has calibration results
                this.plotExtrinsics;
                this.plotErrors;
            else
                this.ReprojectionErrorsDisplay.lockFigure();
                this.ExtrinsicsDisplay.lockFigure();
            end                
        end
                
        %------------------------------------------------------------------
        function highlightIndex = getHighlightIndex(this)
        
            if this.Session.isCalibrated()
                % This can happen when adding new images to the bottom
                % of the image stack.  In that case, we do not have
                % anything to highlight for the brand new boards
                boardIndex = this.getSelectedBoardIndices();
                highlightIndex = ...
                    boardIndex(boardIndex <= ...
                    this.Session.CameraParameters.NumPatterns);
            else
                highlightIndex = [];
            end
        end
        
        %------------------------------------------------------------------
        function plotExtrinsics(this, varargin)
            displayFigure = this.ExtrinsicsDisplay;
            % What if the figure has been closed?
            if ~ishandle(displayFigure.Fig)
                return;
            end
            
            if ~isValidAxes(displayFigure)
                displayFigure.createAxes(...
                    @()onSwitchView(this, displayFigure, 'CameraCentric'), ...
                    @()onSwitchView(this, displayFigure, 'PatternCentric'));                
            end
            plotGraph(this, displayFigure);
            drawnow();                              
        end
        
        %------------------------------------------------------------------        
        function plotErrors(this, varargin)          
            displayFigure = this.ReprojectionErrorsDisplay;
            % What if the figure has been closed?
            if ~ishandle(displayFigure.Fig)
                return;
            end
                
            if ~isValidAxes(displayFigure)
                displayFigure.createAxes();
                if ~this.IsStereo
                    displayFigure.addViewSwitchButton(...
                        @()onSwitchView(this, displayFigure,'BarGraph'), ...
                        @()onSwitchView(this, displayFigure, 'ScatterPlot'));
                end
            end
            
            plotGraph(this, displayFigure);
            drawnow();            
        end
        
        %--------------------------------------------------------------
        function plotGraph(this, displayFigure)
            plot(displayFigure, ...
                this.Session.CameraParameters, this.getHighlightIndex(), ...
                @(h, ~)onClickPlot(this, displayFigure, h), ...
                @(h, ~)onClickPlotSelected(this, displayFigure, h));
        end
        
        %--------------------------------------------------------------
        function onSwitchView(this, displayFigure, newView)
            displayFigure.switchView(newView);
            this.Session.ErrorsView = newView;
            plotGraph(this, displayFigure);
        end
        
        %------------------------------------------------------------------
        function onClickPlot(this, displayFigure, h)
            [clickedIdx, selectionType] = getSelection(displayFigure, h);
            processClick(this, selectionType, clickedIdx);
        end
        
        %------------------------------------------------------------------
        function onClickPlotSelected(this, displayFigure, h)
            [clickedIdx, selectionType] = getSelection(displayFigure, h);
            processSelectedClick(this, selectionType, clickedIdx);
        end
        
        %------------------------------------------------------------------
        function processClick(this,selectionType,clickedIdx)
            
            % Remove selection listener, because we are going to
            % trigger a selection in the image browser programmatically
            this.removeSelectionListener();

            switch(selectionType)
                case 'alt'
                    % control-click or right-click
                    prevIdx = this.getSelectedBoardIndices();
                    this.JBoardList.setSelectedIndices([prevIdx; clickedIdx]-1);
                case 'normal'
                        % plain click
                        this.JBoardList.setSelectedIndex(clickedIdx - 1);
                case 'extend'
                    % shift-click
                    prevIdx = this.getSelectedBoardIndices();
                    dists = abs(prevIdx - clickedIdx);
                    [~, prevIdxIdx] = min(dists);
                    prevIdx = prevIdx(prevIdxIdx);
                    this.JBoardList.setSelectedIndices((min(prevIdx,clickedIdx):max(prevIdx,clickedIdx))-1);
            end
            this.updatePlots();
            this.drawBoard();
            this.setFocusOnBoards();

            % Add the selection listener back
            this.addSelectionListener();

            drawnow;
        end
        
        %------------------------------------------------------------------
        function processSelectedClick(this,selectionType,clickedIdx)
            
            switch(selectionType)
                case 'alt'
                    % control-click or right-click on a selected bar should
                    % deselect it
                    selectedIdx = this.getSelectedBoardIndices();  
                    if numel(selectedIdx) > 1
                        selectedIdx(selectedIdx == clickedIdx) = [];
                        this.JBoardList.setSelectedIndices(selectedIdx - 1);
                    end
                case 'normal'
                    this.JBoardList.setSelectedIndex(clickedIdx - 1);
                case 'extend'
                    prevIdx = this.getSelectedBoardIndices();
                    dists = abs(prevIdx - clickedIdx);
                    dists(dists == 0) = inf;
                    [~, prevIdxIdx] = min(dists);
                    prevIdx = prevIdx(prevIdxIdx);
                    this.JBoardList.setSelectedIndices((min(prevIdx,clickedIdx):max(prevIdx,clickedIdx))-1);
            end
        end
        
        %------------------------------------------------------------------
        % Remove selection listener from the image browser
        % Needed for enabling click-ability on the reprojection errors bar
        % graph.
        function removeSelectionListener(this)
            if ishandle(this.Misc.SelectionListener)
                delete(this.Misc.SelectionListener);            
            end
        end
        
        %------------------------------------------------------------------
        % Add selection listener to the image browser handle the update of
        % the image display and the graphs.
        function addSelectionListener(this)
            this.Misc.SelectionListener = addlistener(this.JBoardList, ...
                'ValueChanged', @this.doSelection);
        end

        %------------------------------------------------------------------
        function outSession = getSession(this)
            outSession = this.Session;
        end
        
        %------------------------------------------------------------------
        function resetDataBrowserLocation(this)
            
            % restore data browser to its original location
            md = com.mathworks.mlservices.MatlabDesktopServices.getDesktop;
            md.setClientLocation('DataBrowserContainer', this.getGroupName(), ...
                com.mathworks.widgets.desk.DTLocation.create('W'))        
        end
                        
        %------------------------------------------------------------------
        function addToolInstance(this)
            this.manageToolInstances('add', this);
        end
        
        %------------------------------------------------------------------
        function doClosingSession(this, group, event)
            if strcmp(event.EventData.EventType, 'CLOSING') && ...
                    group.isClosingApprovalNeeded
                this.closingSession(group)
            end                        
        end                              
              
        %------------------------------------------------------------------
        function closingSession(this, group)
                        
            sessionChanged = this.Session.IsChanged;
            
            yes    = vision.getMessage('vision:uitools:Yes');
            no     = vision.getMessage('vision:uitools:No');
            cancel = vision.getMessage('vision:uitools:Cancel');
            
            if sessionChanged
                selection = this.askForSavingOfSession();
            else
                selection = no;
            end
            
            switch selection
                case yes
                    this.saveSession();
                    group.approveClose
                    this.deleteToolInstance();
                case no,
                    group.approveClose
                    this.deleteToolInstance();
                case cancel
                    group.vetoClose
                otherwise
                    group.vetoClose
            end

        end               
        
        %------------------------------------------------------------------
        function closeAllFigures(this)
                         
            % clean up the preview figure
            if ~isempty(this.ImagePreviewDisplay)
                existingTabs = this.ToolGroup.TabNames;

                % If image capture tab is not in the toolgroup, add it and bring
                % focus to it.
                if any(strcmp(existingTabs,'ImageCaptureTab'))
                    this.ImageCaptureTab.closePreview();
                end
                this.ImagePreviewDisplay.close();
            end
            
            % clean up the figures
            this.MainImageDisplay.close();
            this.ReprojectionErrorsDisplay.close();
            this.ExtrinsicsDisplay.close();
        end
        
        %------------------------------------------------------------------
        function createDefaultLayout(this)                        
            % create all the required figures
            if this.IsStereo
                this.MainImageDisplay = ...
                    vision.internal.calibration.tool.StereoCalibrationImageDisplay(this.getGroupName());
            else
                this.MainImageDisplay = ...
                    vision.internal.calibration.tool.SingleCalibrationImageDisplay;
                this.ImagePreviewDisplay = ...
                    vision.internal.calibration.tool.ImagePreview;
                this.addFigure(this.ImagePreviewDisplay.Fig);
            end
            this.ReprojectionErrorsDisplay = ...
                vision.internal.calibration.tool.ReprojectionErrorsDisplay;
            this.ExtrinsicsDisplay = ...
                vision.internal.calibration.tool.ExtrinsicsDisplay;
                                   
            this.addFigure(this.ReprojectionErrorsDisplay.Fig);
            this.addFigure(this.MainImageDisplay.Fig);
            this.addFigure(this.ExtrinsicsDisplay.Fig);
            
            grpname = this.getGroupName();
            
            md = com.mathworks.mlservices.MatlabDesktopServices.getDesktop;
            
            % Going first to one windows helps with default layout 
            % restoration
            md.setDocumentArrangement(grpname, md.TILED, ...
                java.awt.Dimension(1,1));
            
            % Set desired layout; Main figure fills the entire first column
            md.setDocumentArrangement(grpname, md.TILED, ...
                java.awt.Dimension(2,2));            % sets the grid
            
            if this.IsStereo
                md.setDocumentColumnSpan(grpname, 0, 0, 2); % joins grid elements
                
                % Make the first row wider
                md.setDocumentRowHeights(grpname, [0.6, 0.4]); % values must add to 1
            else
                md.setDocumentRowSpan(grpname, 0, 0, 2); % joins grid elements
                
                % Make the first column wider
                md.setDocumentColumnWidths(grpname, [0.7, 0.3]); % values must add to 1
            end
            % Assign documents to their proper tiles
            loc1 = com.mathworks.widgets.desk.DTLocation.create(0); % Tile 0            
            loc2 = com.mathworks.widgets.desk.DTLocation.create(1); % Tile 1
            loc3 = com.mathworks.widgets.desk.DTLocation.create(2); % Tile 2
            loc4 = com.mathworks.widgets.desk.DTLocation.clone(loc1);

            md.setClientLocation(this.MainImageDisplay.Title, grpname, loc1);
            md.setClientLocation(this.ReprojectionErrorsDisplay.Title, grpname, loc2);
            md.setClientLocation(this.ExtrinsicsDisplay.Title,     grpname, loc3);           
            if ~this.IsStereo
                md.setClientLocation(this.ImagePreviewDisplay.Title, grpname, loc4);
            end
            
            % Turn on the visibility
            this.MainImageDisplay.makeFigureVisible();
            this.ReprojectionErrorsDisplay.makeFigureVisible();
            this.ExtrinsicsDisplay.makeFigureVisible();
            
            existingTabs = this.ToolGroup.TabNames;
            
            % If image capture tab is not in the toolgroup, add it and bring
            % focus to it.
            if any(strcmp(existingTabs,'ImageCaptureTab'))
                this.ImageCaptureTab.preview();
                this.ImagePreviewDisplay.makeFigureVisible();                
            end
                        
            set(this.MainImageDisplay.Fig, 'DeleteFcn',...
                @deleteMainImage);
            %--------------------------------------------------------------
            function deleteMainImage(~, ~)
                
                this.enableZoomButtons(false);
            end  
            
        end % createDefaultLayout
                
    end
  
    %----------------------------------------------------------------------
    % Static public methods
    %----------------------------------------------------------------------    
    methods (Static)
        
        %------------------------------------------------------------------
        function deleteAllTools
            vision.internal.calibration.tool.CameraCalibrationTool.manageToolInstances('deleteAll');
        end
        
        %------------------------------------------------------------------
        function deleteAllToolsForce
            vision.internal.calibration.tool.CameraCalibrationTool.manageToolInstances('deleteAllForce');
        end
    end
    
    %----------------------------------------------------------------------
    % Static private methods
    %----------------------------------------------------------------------
    methods (Access='private', Static)
        %------------------------------------------------------------------
        % Manages a persistent variable for the purpose of tracking the
        % tool instances.
        %------------------------------------------------------------------
        function manageToolInstances(action, varargin)
            
            mlock();
            
            persistent toolArray;
            
            switch action
                case 'add'
                    if isempty(toolArray) % first time
                        toolArray = varargin{1};
                    else
                        % add to existing array
                        toolArray(end+1) = varargin{1};
                    end
                case 'delete'
                    for i=1:length(toolArray)
                        this = varargin{1};
                        if strcmp(this.getGroupName(), toolArray(i).getGroupName())
                            toolArray(i) = [];
                            delete(this); % self-destruct
                            break;
                        end                        
                    end
                    
                case 'deleteAll'
                    % wipe backwards since toolArray will be shrinking
                    for i = length(toolArray):-1:1
                        delete(toolArray(i));
                    end
                    toolArray = [];
                    
                case 'deleteAllForce'
                    % wipe backwards since toolArray will be shrinking
                    for i = length(toolArray):-1:1
                        setClosingApprovalNeeded(toolArray(i), false);
                        delete(toolArray(i));
                    end
                    toolArray = [];
            end
            
            % if all tools are closed, permit clearing of the class; this
            % is helpful during development of the tool
            if isempty(toolArray)                
                munlock();
            end
            
        end                
        
        %------------------------------------------------------------------
        function selection = askForSavingOfSession

            yes    = vision.getMessage('vision:uitools:Yes');
            no     = vision.getMessage('vision:uitools:No');
            cancel = vision.getMessage('vision:uitools:Cancel');            
           
            selection = questdlg(vision.getMessage('vision:uitools:SaveSessionQuestion'), ...
                vision.getMessage('vision:uitools:SaveSessionTitle'), ...
                yes, no, cancel, yes);
            
            if isempty(selection) % dialog was destroyed with a click
                selection = cancel;
            end
        end

    end
        
end

