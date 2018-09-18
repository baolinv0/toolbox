% TrainingDataLabelerTool Main class for the trainingImageLabeler App
%    
%    This object implements the core routines in trainingImageLabeler App.
%    All the callbacks that you see in the UI are implemented below.

classdef TrainingDataLabelerTool < vision.internal.uitools.ToolStripApp
    
    properties(Access = 'private')
        
        % Tool group management
        LabelingTab
        
        % UI state
        
        FigureHandles   % Handles to all the figures
        AxesTags        % Takes a string for tagging the Axes 
        ImageMode       % Takes a string to identify the mode while drawing ROIs
        MaxNumIcons     % Takes a maximum number of image icons that can be shown in the full sized UI
        CopiedROIs      % Store co-ordinates for selected ROIs
        InsideNudge     % Indicate whether an ROI nudge operation is going on
        
        % The item below is just a dummy cache for storing Java related
        % items that would otherwise break by going out of scope
        Misc

        % Handle to the Java's JList which holds all the boards. It must        
        % be available throughout the class so that one can obtain the
        % currently selected board
        JImageList
        ImageStrip
        
        OpenSessionPath;
                
        % variables needed to control HG/Java synchronization
        IsInteractionDisabledByScrollCallback = false;
        IsBrowserInteractionEnabled = true;
    end
    
    properties(Access = 'private', Constant = true)
        
        % Default ROI color value (required when an ROI gets un-selected)
        DefaultROIColor = [0.2824 0.2824 0.9725];
    end
    %======================================================================
    
    %----------------------------------------------------------------------
    % Public methods
    %----------------------------------------------------------------------
    methods (Access = 'public')
        
        %------------------------------------------------------------------
        function this = TrainingDataLabelerTool()
            import vision.internal.cascadeTrainer.*;
            
            % generate a name for this tool; we need a unique string for
            % each instance
            [~, name] = fileparts(tempname);
            title = vision.getMessage('vision:trainingtool:ToolTitle');
            this.ToolGroup = toolpack.desktop.ToolGroup(name, title);
                        
            this.LabelingTab = tool.LabelingTab(this);
            add(this.ToolGroup, getToolTab(this.LabelingTab), 1);
            
            this.displayInitialDataBrowserMessage(...
                vision.getMessage('vision:trainingtool:LoadImagesFirstMsg'));
            
            this.SessionManager = vision.internal.uitools.SessionManager;
            this.SessionManager.AppName = 'Training Image Labeler';
            this.SessionManager.SessionField = 'labelingSession';
            this.SessionManager.SessionClass = 'vision.internal.cascadeTrainer.tool.Session';
            
            this.Session = vision.internal.cascadeTrainer.tool.Session; % initialize the session object
            
            this.MaxNumIcons = 13;
            
            % initialize all the figures
            this.FigureHandles.MainImage = [];
            
            % initialize Axes tags
            this.AxesTags.MainImage = 'TrainingImageAxes';
            
            % initialize ImageMode
            this.ImageMode = 'ROImode';
            
            % handle closing of the tool group
            this.setClosingApprovalNeeded(true);
            addlistener(this.ToolGroup, 'GroupAction',...
                @(es,ed)doClosingSession(this, es, ed));
            
            % manageToolInstances
            this.addToolInstance();
            
            % set the path for opening sessions to the current directory
            this.OpenSessionPath = pwd;
            
            % Initialize bounding box co-ordinates
            this.CopiedROIs = [];
            
            this.InsideNudge = 0;
            
        end
        
        %------------------------------------------------------------------
        function show(this)
                    
            this.removeViewTab();
            this.removeDocumentTabs();
            
            % open the tool
            this.ToolGroup.open();
            
            % create figures and lay them out the way we want them
            imageslib.internal.apputil.ScreenUtilities.setInitialToolPosition(this.getGroupName());

            % create default window layout
            this.createDefaultLayout();
                       
            % update button states to indicate the tool's current state
            this.updateButtonStates();
                        
            drawnow();
        end

        %------------------------------------------------------------------
        function removeDocumentTabs(this)

            group = this.ToolGroup.Peer.getWrappedComponent;

            % Leave only a single document window without a tab and other
            % decorations
            group.putGroupProperty(com.mathworks.widgets.desk.DTGroupProperty.SHOW_SINGLE_ENTRY_DOCUMENT_BAR, false);
            % the line below cleans up the title of the app once there is only a single document in place            
            group.putGroupProperty(com.mathworks.widgets.desk.DTGroupProperty.APPEND_DOCUMENT_TITLE, false);
        end
       
        
    end % public methods
    
    %======================================================================
    
    methods (Access = 'public', Hidden)
        
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
            
            % First check if we need to save anything before wiping the
            % existing data
            isCanceled = this.processSessionSaving();
            if isCanceled
                return;
            end
            
            % Wipe the UI clean
            this.resetAll();
            
            % Update Button states
            this.updateButtonStates();            
                        
            % Update Status text
            this.setStatusText();
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
            
            trainingFilesString = vision.getMessage...
                ('vision:trainingtool:LabelingSessionFiles');
            allFilesString = vision.getMessage('vision:uitools:AllFiles');
            selectFileTitle = vision.getMessage('vision:uitools:SelectFileTitle');
            
            [filename, pathname] = uigetfile( ...
                {'*.mat', [trainingFilesString,' (*.mat)']; ...
                '*.*', [allFilesString, ' (*.*)']}, ...
                selectFileTitle, this.OpenSessionPath);
            
            wasCanceled = isequal(filename,0) || isequal(pathname,0);
            if wasCanceled
                return;
            else
                % preserve the last path for next time
                this.OpenSessionPath = pathname;
            end
            
            % Indicate that this is going to take some time
            setWaiting(this.ToolGroup, true);
            
            preserveExistingSession = false;
            
            this.processOpenSession(pathname, filename, preserveExistingSession);
            
            this.setStatusText();
                       
            setWaiting(this.ToolGroup, false);

        end
        
        %------------------------------------------------------------------
        % Add multiple sessions to current session button callback
        % Not yet implemented fully (wait to see if this is a needed
        % feature
        %------------------------------------------------------------------
        function addToCurrentSession(this)
        
            trainingFilesString = vision.getMessage...
                ('vision:trainingtool:LabelingSessionFiles');
            allFilesString = vision.getMessage('vision:uitools:AllFiles');
            selectFileTitle = vision.getMessage('vision:uitools:SelectFileTitle');
            
            [filename, pathname] = uigetfile( ...
                {'*.mat', [trainingFilesString,' (*.mat)']; ...
                '*.*', [allFilesString, ' (*.*)']}, ...
                selectFileTitle, this.OpenSessionPath);
            
            wasCanceled = isequal(filename,0) || isequal(pathname,0);
            if wasCanceled
                return;
            else
                % preserve the last path for next time
                this.OpenSessionPath = pathname;
            end
            
            setWaiting(this.ToolGroup, true);
            
            preserveExistingSession = true;
            
            this.processOpenSession(pathname, filename, preserveExistingSession);
            
            this.setStatusText();

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
        % Add images button callback
        %------------------------------------------------------------------
        function addImages(this)
            
            % Get image file names
            [files, isUserCanceled] = imgetfile('MultiSelect', true);
            if isUserCanceled
                return;
            end
            addImagesToSession(this, files);

        end
        
        %------------------------------------------------------------------
        % Add images to a session
        %------------------------------------------------------------------
        function addImagesToSession(this, files)
            
            % If a single file is selected convert the string into a cell
            % array before passing it to the Session object
            if ~isa(files, 'cell') 
                files = {files};
            end
            
            try               
                setWaiting(this.ToolGroup, true);

                % Add images to the session object 
                startingIndex = this.Session.ImageSet.addImagesToSession(files);
                if isempty(startingIndex)
                    setWaiting(this.ToolGroup, false);
                    dlg = warndlg(...
                        getString(message('vision:trainingtool:NoImagesAddedMessage')),...
                        getString(message('vision:trainingtool:NoImagesAddedTitle')),...
                        'modal');
                    uiwait(dlg);
                    return; % This would indicate presence of duplicates
                end 
                   
                this.Session.IsChanged = true;

                if ~this.Session.hasAnyImages()
                    setWaiting(this.ToolGroup, false);
                    errordlg('No valid image files found',...
                        vision.getMessage...
                        ('vision:trainingtool:LoadingImagesFailedTitle'), 'modal');                    
                    drawnow;                    
                    return;
                end
                                
                % Mange the image strip
                this.updateImageStrip();                                
                
                drawnow();
                
                % Update selection in the list
                this.setSelectedImageIndex(startingIndex)
                this.makeSelectionVisible(startingIndex)
                                
                % Update session state
                this.Session.IsChanged = true;
                this.Session.CanExport = this.getExportStatus();
                this.updateButtonStates();

                % Update displays
                this.drawImages();
                this.setStatusText();
                
                setWaiting(this.ToolGroup, false);
                               
            catch loadingEx
                
                if ~isvalid(this)
                    % we already went through delete sequence; this can
                    % happen if the images did not yet load and someone
                    % already closed the tool
                    return;
                end
                
                setWaiting(this.ToolGroup, false); % if it errors out set the toolgroup busy to false
                
                errordlg(loadingEx.message,...
                    vision.getMessage('vision:trainingtool:LoadingImagesFailedTitle'),...
                    'modal');                
                return;
            end

        end        
        
        
        
        
        %------------------------------------------------------------------
        % Zoom In Button callback
        %------------------------------------------------------------------        
        function doZoomIn(this, varargin)
            
            hFig = this.FigureHandles.MainImage;
            
            set(hFig,'HandleVisibility','on');
            
            if ~isempty(hFig) % if axes is in place
                this.resetPointerBehavior();
                
                % Disable zoom if enabled, to set context menus (context
                % menus cannot be set when zoom is on)
                if strcmp(this.ImageMode, 'Zoom')
                    zoom(hFig, 'off');
                end
                h = zoom(hFig);
                set(h, 'Direction', 'in');
                % create context menus
                this.installContextMenu('ZoomIn', h);
                zoom(hFig, 'inmode');
            end
            drawnow();
            set(hFig, 'HandleVisibility', 'off');
            this.ImageMode = 'Zoom';

            this.setFocusOnImages();            
        end
        
        %------------------------------------------------------------------
        % Zoom Out buttons callback
        %------------------------------------------------------------------
        function doZoomOut(this, varargin)
            
            hFig = this.FigureHandles.MainImage;
            
            set(hFig,'HandleVisibility','on');
            
            if ~isempty(hFig) % if axes is in place
                this.resetPointerBehavior();
                
                % Disable zoom if enabled, to set context menus (context
                % menus cannot be set when zoom is on)
                if strcmp(this.ImageMode, 'Zoom')
                    zoom(hFig, 'off');
                end
                h = zoom(hFig);
                set(h, 'Direction', 'out');
                % create context menus
                this.installContextMenu('ZoomOut', h);
                zoom(hFig, 'outmode');
            end
            drawnow();
            set(hFig,'HandleVisibility','off');
            this.ImageMode = 'Zoom';
            
            this.setFocusOnImages();
        end
        
        %------------------------------------------------------------------
        % Pan Button callback
        %------------------------------------------------------------------
        function doPan(this, varargin)
                        
            hFig = this.FigureHandles.MainImage;            
            set(hFig,'HandleVisibility','on');
            tag = this.AxesTags.MainImage;
            hAxes = findobj(hFig, 'Type','axes','Tag',tag);
            
            if ~isempty(hAxes) % if axes is in place
                drawnow();
                
                this.resetPointerBehavior();
                
                h = pan(hFig);
                this.installContextMenu('Pan', h);
                set(h, 'Enable', 'on');
            end
            drawnow();
            set(hFig,'HandleVisibility','off');
            this.ImageMode = 'Pan';
           
            this.setFocusOnImages();
        end
        
        %------------------------------------------------------------------
        % Add ROIs callback
        %------------------------------------------------------------------
        function doAddROI(this, varargin)

            hFig = this.FigureHandles.MainImage;            
            
            set(hFig,'HandleVisibility','on');
            tag = this.AxesTags.MainImage;
            hAxes = findobj(hFig, 'Type','axes','Tag',tag);
            
            if ~isempty(hAxes) % if axes is in place
                hImage = findobj(hFig, 'Type', 'image');
                switch this.ImageMode
                    case 'Zoom'
                        zoom(hFig, 'off');
                    case 'Pan'
                        pan(hFig, 'off');
                end
                set(hImage, 'ButtonDownFcn', @this.imageClick);
                
                this.installContextMenu('ROI', hImage);
                
                this.setPointerToCross();
            end
            
            this.ImageMode = 'ROImode';
            drawnow();
            set(hFig,'HandleVisibility','off');
            
            this.setFocusOnImages();
        end
        
        %------------------------------------------------------------------
        % Export button callback
        %------------------------------------------------------------------        
        function export(this)
            
            if ~this.Session.ImageSet.areAllImagesLabeled()
                choice = questdlg(vision.getMessage('vision:trainingtool:UnlabeledImagesPrompt'),...
                    vision.getMessage('vision:trainingtool:UnlabeledImagesTitle'),...
                    vision.getMessage('vision:trainingtool:ExportROIs'),...
                    vision.getMessage('vision:trainingtool:ContinueLabeling'),...
                    vision.getMessage('vision:trainingtool:ContinueLabeling'));
                % Handle of the dialog is destroyed by the user
                % closing the dialog or the user pressed cancel
                if isempty(choice) || ...
                        strcmp(choice, vision.getMessage('vision:trainingtool:ContinueLabeling')) 
                    return;
                end
            end

            prompt = getString(message('vision:uitools:ExportPrompt'));
            exportDlg = vision.internal.cascadeTrainer.tool.ExportDlg(...
                this.getGroupName(), prompt, this.Session.ExportVariableName);
            wait(exportDlg);
            
            % Close up the modal dialog
            if ~exportDlg.IsCanceled 
                varName = exportDlg.VarName;
                this.Session.ImageSet.setROIBoundingBoxes();
                assignin('base', varName, this.Session.ImageSet.ROIBoundingBoxes);
                
                % display the camera parameters at the command prompt
                evalin('base', varName);
                
                % remember the current variable name
                this.Session.ExportVariableName = varName;
            end
            
            drawnow;                        
        end

        %------------------------------------------------------------------
        % Help button callback
        %------------------------------------------------------------------
        function help(~)

            mapfile_location = fullfile(docroot,'toolbox',...
                'vision','vision.map');
            doc_tag = 'visionTrainingImageLabeler';
            
            helpview(mapfile_location, doc_tag);
        end
        
       %------------------------------------------------------------------
       function delete(this)
           this.ToolGroup.close(); % close the UI
           this.closeAllFigures(); % shut down all figures           
                      
           drawnow();  % allow time for closing of all figures
       end
        
        %------------------------------------------------------------------
        function deleteToolInstance(this)
            imageslib.internal.apputil.manageToolInstances('remove',...
                'trainingImageLabeler', this);
            delete(this);
        end
        
        %------------------------------------------------------------------
        function addToolInstance(this)
            imageslib.internal.apputil.manageToolInstances('add',...
                'trainingImageLabeler', this);           
        end
        
        %------------------------------------------------------------------
        % This method is used for testing
        %------------------------------------------------------------------
        function setClosingApprovalNeeded(this, in)
            this.ToolGroup.setClosingApprovalNeeded(in);
        end
        
        %------------------------------------------------------------------
        function processOpenSession(this, pathname, filename,...
                preserveExistingSession)
                                    
            isNewSession = false;
            session = this.SessionManager.loadSession(pathname, filename);          
            if isempty(session)
                return;
            end
            
            if ~preserveExistingSession
                this.resetAll();  % Start fresh
                this.Session.FileName = [pathname, filename];
                isNewSession = true;
            end
                        
            % use the loaded session
            if ~this.Session.ImageSet.hasAnyImages()
                this.Session = session;
                selectedIndex = 1;
                
                % Initialize 'IsROISelected' for loaded session
                for i = 1: length(this.Session.ImageSet.ImageStruct)
                    this.Session.ImageSet.IsROISelected{end+1} = ...
                        false(size(this.Session.ImageSet.ImageStruct(i)...
                        .objectBoundingBoxes,1),1);
                end
            else
                % index of the first element of the added session
                selectedIndex = numel(this.Session.ImageSet.ImageStruct)+1; % matlab based index
                
                addedImages = this.Session.ImageSet.addImageStructToCurrentSession(...
                    session.ImageSet.ImageStruct, ...
                    session.ImageSet.AreThumbnailsGenerated);
                % Return if no new images are added
                if ~addedImages
                    return;
                end
                this.Session.IsChanged = true;
            end
            
            if ~isempty(this.Session.ImageSet.ImageStruct)
                
                this.updateImageStrip(); % Restore image strip
                
                this.setSelectedImageIndex(selectedIndex);
                this.makeSelectionVisible(selectedIndex);

                this.drawImages(); % Display the first image on the list
            end
            
            this.Session.CanExport = this.getExportStatus();
            this.updateButtonStates();
            if isNewSession
                this.Session.IsChanged = false;
            end
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
                         
            % clean up the figures
            if ishandle(this.FigureHandles.MainImage)
                set(this.FigureHandles.MainImage,'HandleVisibility','on');
                close(this.FigureHandles.MainImage);
            end
            
        end
        
        %------------------------------------------------------------------
        function createDefaultLayout(this)

            % create all the required figures
            this.FigureHandles.MainImage = this.makeFig();
            this.addFigure(this.FigureHandles.MainImage);
                        
            % Turn on the visibility
            set(this.FigureHandles.MainImage,'Visible','on');
                        
        end % createDefaultLayout
        
        %------------------------------------------------------------------
        
        function resetDataBrowserLocation(this)
            
            % restore data browser to its original location
            md = com.mathworks.mlservices.MatlabDesktopServices.getDesktop;
            md.setClientLocation('DataBrowserContainer', this.getGroupName(), ...
                com.mathworks.widgets.desk.DTLocation.create('W'))        
        end
        
    end
    
    %=======================================================================
    
    %----------------------------------------------------------------------
    % Static public methods
    %----------------------------------------------------------------------    
    methods (Static)
        
        %------------------------------------------------------------------
        function deleteAllTools
            imageslib.internal.apputil.manageToolInstances('deleteAll',...
                'trainingImageLabeler');
        end
        
    end
    
    %======================================================================
    
    %----------------------------------------------------------------------
    % Private methods
    %----------------------------------------------------------------------
    methods (Access = 'private')

        %------------------------------------------------------------------
        function ret = getExportStatus(this)
            if isempty(this.Session.ImageSet.ImageStruct)
                ret = false;
            else
                bboxes = {this.Session.ImageSet.ImageStruct.objectBoundingBoxes};
                if unique(cellfun(@isempty, bboxes))
                    ret = false;
                else
                    ret = true;
                end
            end
        end
        
        %------------------------------------------------------------------
        %  Gets the UI to the starting point, as if nothing has been loaded
        %------------------------------------------------------------------
        function resetAll(this)
            
            % reset the message in the data browser
            this.displayInitialDataBrowserMessage(...
                vision.getMessage('vision:trainingtool:LoadImagesFirstMsg'));
            
            % wipe the visible figures
            this.wipeFigure(this.FigureHandles.MainImage);
            
            % reset the session
            this.Session.reset();
            
            this.updateButtonStates();
            
        end

        %------------------------------------------------------------------
        function displayInitialDataBrowserMessage(this, msg)            
            
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
        % Training Data Labeler app requires at least one image with
        % an ROI. This routine grays out the export button and all the 
        % buttons in the mode section if there are no images / images 
        % without any ROIs.
        %------------------------------------------------------------------
        function updateButtonStates(this)
            
            this.Session.CanExport = this.getExportStatus();
            this.LabelingTab.updateButtonStates(this.Session);
            
        end
        
        %------------------------------------------------------------------
        function wipeFigure(this, fig)
            if ishandle(fig)
                set(fig,'HandleVisibility','on');
                
                clf(fig); % clean out figure content
                
                zoom(fig, 'off');
                pan(fig, 'off');
                resetCallbacks();
                
                % turn off the visibility
                set(fig,'HandleVisibility','off');                
            end
            
            %----------------------------------------
            function resetCallbacks
                % remove any hanging callbacks
                set(fig,'WindowButtonMotionFcn',[])
                set(fig,'WindowButtonUpFcn',[])
                set(fig,'WindowButtonDownFcn',[])
                set(fig,'WindowKeyPressFcn',[])
                set(fig,'WindowKeyReleaseFcn',[])
                
                % install listeners that temporarily block use of the
                % image browser
                iptaddcallback(fig,'WindowButtonDownFcn',@mouseClick);
                iptaddcallback(fig,'WindowButtonUpFcn',@mouseRelease);
                
                %----------------------------------------
                function mouseClick(~,~)
                    if ~this.IsInteractionDisabledByScrollCallback
                        this.setBrowserInteractionEnabled(false);
                    end
                end
                
                %----------------------------------------
                function mouseRelease(~,~)                    
                    if ~this.IsInteractionDisabledByScrollCallback
                        this.setBrowserInteractionEnabled(true);
                        drawnow();
                    end                    
                end
                
            end % end of resetCallbacks
                        
        end % end of wipeFigure        
        
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
        % This function can suspend and resume interaction with the
        % image browser.  This is particularly useful for synchronizing
        % Java UI with MATLAB's functions.
        %------------------------------------------------------------------
        function setBrowserInteractionEnabled(this, isEnabled)            
            
            if isempty(this.Session.ImageSet.ImageStruct)
                return;
            end
            
            scrollPane = this.ImageStrip.getImageScrollPane();
            this.IsBrowserInteractionEnabled = isEnabled;
            
            if isEnabled
                javaMethod('enableImageScrolling', this.ImageStrip);                
            else
                javaMethod('disableImageScrolling', this.ImageStrip);
            end
            
            javaMethodEDT('setEnabled', scrollPane, isEnabled);
            javaMethodEDT('setWheelScrollingEnabled', scrollPane, isEnabled);            
        end
        
        %------------------------------------------------------------------
        % Set up management of the image strip
        %------------------------------------------------------------------
        function updateImageStrip(this)
                        
            this.ImageStrip = javaObject('com.mathworks.toolbox.vision.ImageStrip');
            this.JImageList = javaMethod('getImageList', this.ImageStrip);
            
            jfirstVisibleIndex = this.JImageList.getFirstVisibleIndex();
            jlastVisibleIndex  = this.JImageList.getLastVisibleIndex();
            
            if jfirstVisibleIndex == -1
                jfirstVisibleIndex = 0;
            end
            
            if jlastVisibleIndex == -1 
                % By default, a full sized viewport can hold approx 13
                % icons, if the number of images selected is lesser than
                % that set it as the last visible index.
                jlastVisibleIndex = min(numel(this.Session.ImageSet.ImageStruct)-1,...
                    this.MaxNumIcons); 
            end
            
            for ind = jfirstVisibleIndex:jlastVisibleIndex
                this.Session.ImageSet.updateImageListEntry(ind);
                javaMethodEDT('setListData', this.JImageList, ...
                    {this.Session.ImageSet.ImageStruct.ImageIcon});
            end
            
            dataPanel = this.ImageStrip.getImagePanel();
            this.ToolGroup.setDataBrowser(dataPanel);
            
            % Add a listener for handling file selections
            this.addSelectionListener();
            
            popupListener = addlistener(this.JImageList, 'MousePressed', ...
                @doPopup);
            
            keyListener = addlistener(this.JImageList, 'KeyPressed', ...
                @doInterceptKeyPress);
            
            % Use the handle command to convert the Java object to a 
            % handle object.
            scrollCallback = handle(this.ImageStrip.getScrollCallback);
            
            % Connect the callback to a nested function. The callback
            % class requires 'delayed' as the listener type.
            scrollListener = handle.listener(scrollCallback, 'delayed', @doScroll);
            
            mouseMotionListener = addlistener(this.JImageList, 'MouseMoved', ...
                @this.setStatusText);
            
            % Store handles to prevent going out of scope
            this.Misc.PopupListener       = popupListener;
            this.Misc.KeyListener         = keyListener;
            this.Misc.DataPanel           = dataPanel;
            this.Misc.ScrollListener      = scrollListener;
            this.Misc.MouseMotionListener = mouseMotionListener;
                        
            this.setStatusText();
                        
            %--------------------------------------------------------------
            function doScroll(~, ~)
                if this.Session.ImageSet.areAllIconsGenerated()
                    return;
                end
                                
                drawnow(); % update Java UI components before proceeding
                this.setBrowserInteractionEnabled(false);
                this.IsInteractionDisabledByScrollCallback = true;
                
                jfirstVisibleIndex = this.JImageList.getFirstVisibleIndex();
                jlastVisibleIndex = this.JImageList.getLastVisibleIndex();               
                
                for index = jfirstVisibleIndex:jlastVisibleIndex                   
                    doUpdate = this.Session.ImageSet.updateImageListEntry(index);
                    
                    if doUpdate
                        
                        % Do not move the "setWaiting" outside of the for loop!
                        % It will cause the down/up arrows on the scrollbar
                        % to misbehave
                        setWaiting(this.ToolGroup, true); % turn on waiting pointer
                        
                        selectedIndex = this.getSelectedImageIndex();
                
                        javaMethodEDT('setListData', this.JImageList, ...
                            {this.Session.ImageSet.ImageStruct.ImageIcon});                        
                        
                        this.setSelectedImageIndex(selectedIndex);
                        drawnow();
                    end
                end
                
                this.setBrowserInteractionEnabled(true);
                this.IsInteractionDisabledByScrollCallback = false;
                setWaiting(this.ToolGroup, false); % turn off waiting pointer
                drawnow();
            end
            
            %--------------------------------------------------------------
            function doInterceptKeyPress(~, hData)
                
                if this.IsBrowserInteractionEnabled
                    if hData.getKeyCode == hData.VK_DELETE
                        doDeleteKey();
                    elseif hData.isControlDown() && hData.isShiftDown() && hData.getKeyCode() == hData.VK_R
                        doCounterClockwiseRotationKey();
                    elseif hData.isControlDown() && hData.getKeyCode() == hData.VK_R
                        doClockwiseRotationKey();
                    elseif hData.getKeyCode == hData.VK_ESCAPE
                        % Hitting escape takes you back to ROI drawing mode
                        this.selectROIMode();
                    end
                end
            end            
                        
            %--------------------------------------------------------------
            function doDeleteKey()                               
                % CTRL-DEL will also end up here
                idxMultiselect = this.getSelectedImageIndices();
                this.processRemove(idxMultiselect);
            end
            
            %--------------------------------------------------------------
            function doClockwiseRotationKey()
                idxMultiselect = this.getSelectedImageIndices();
                this.rotateClockwise(idxMultiselect);
                
            end
            
            %--------------------------------------------------------------
            function doCounterClockwiseRotationKey()
                idxMultiselect = this.getSelectedImageIndices();
                this.rotateCounterClockwise(idxMultiselect);
            end
            %--------------------------------------------------------------
            function doPopup(~, hData)
                
                if hData.getButton == 3 % right-click

                    % Get the list widget
                    list = hData.getSource;
                    
                    % Get current mouse location
                    point = hData.getPoint();
                    
                    % Figure out the index of the board immediately under 
                    % the mouse button
                    jIdx = list.locationToIndex(point); % 0-based java idx
                    
                    idx = jIdx + 1;                    
                                        
                    % Figure out the index list in the case of multi-select
                    idxMultiselect = this.getSelectedImageIndices();

                    if ~any(idx == idxMultiselect)
                        % If the mouse is not over the selected area;
                        % select whatever is under the mouse and override
                        % the multi-selection index
                        this.setSelectedImageIndex(idx);
                        idxMultiselect = idx;
                    end
                                        
                    % Create a popup
                    
                    % Removing Images
                    item = vision.getMessage('vision:uitools:Remove');
                    itemName = 'removeItem';
                    
                    menuItemRemove = javaObjectEDT('javax.swing.JMenuItem',...
                         item);
                    menuItemRemove.setName(itemName);
                    
                    % Added Accelerators 
                    jRemoveKeyStroke = javaMethodEDT('getKeyStroke', 'javax.swing.KeyStroke', 'DELETE');
                    menuItemRemove.setAccelerator(jRemoveKeyStroke);
                    
                    % Rotating an Image
                    item1 = vision.getMessage('vision:trainingtool:RotateImage');
                    itemName1 = 'rotateImage';
                    
                    menuRotate = javaObjectEDT('javax.swing.JMenu', ...
                        item1);
                    menuRotate.setName(itemName1);
                    
                    item2 = vision.getMessage('vision:trainingtool:RotateClockwise');
                    itemName2 = 'rotateClockWise';
                    
                    subMenuRotateClockwise = javaObjectEDT('javax.swing.JMenuItem', ...
                        item2);
                    subMenuRotateClockwise.setName(itemName2);
                    jRotateClockwiseKeyStroke = javaMethodEDT(...
                        'getKeyStroke', 'javax.swing.KeyStroke', 'control R');
                    subMenuRotateClockwise.setAccelerator(jRotateClockwiseKeyStroke);
                    menuRotate.add(subMenuRotateClockwise);
                    
                    item3 = vision.getMessage('vision:trainingtool:RotateCounterClockwise');
                    itemName3 = 'rotateCounterClockWise';
                    
                    subMenuRotateCounterClockwise = javaObjectEDT('javax.swing.JMenuItem', ...
                        item3);
                    subMenuRotateCounterClockwise.setName(itemName3);
                    jRotateCounterClockwiseKeyStroke = javaMethodEDT(...
                        'getKeyStroke', 'javax.swing.KeyStroke', 'control shift R');
                    subMenuRotateCounterClockwise.setAccelerator(jRotateCounterClockwiseKeyStroke);
                    menuRotate.add(subMenuRotateCounterClockwise);
                    
                    
                    % Sorting by Number of ROIs
                    item = vision.getMessage('vision:trainingtool:SortListByNumROIs');
                    itemName = 'SortByNumROIs';
                    
                    menuItemToSortByROIs = javaObjectEDT('javax.swing.JMenuItem',...
                        item);
                    menuItemToSortByROIs.setName(itemName);
       
                    removeActionListener = addlistener(menuItemRemove,'Action',...
                        @remove); % main popup callback
                    
                    rotateClockwiseListener = addlistener(subMenuRotateClockwise, ...
                        'Action', @rotClockwise);
                    rotateCounterClockwiseListener = addlistener(...
                        subMenuRotateCounterClockwise, 'Action', @rotCounterClockwise);
                    
                    sortByROIsActionListener = addlistener(menuItemToSortByROIs, 'Action', ...
                        @sortByNumROIs); 
                    
                    % Prevent it from going out of scope
                    this.Misc.PopupActionListener = [removeActionListener sortByROIsActionListener ...
                        rotateClockwiseListener rotateCounterClockwiseListener];

                    jmenu = javaObjectEDT('javax.swing.JPopupMenu');
                    
                    jmenu.add(menuItemRemove);
                    jmenu.add(menuRotate);
                    jmenu.addSeparator();
                    jmenu.add(menuItemToSortByROIs);


                    % Display the popup
                    jmenu.show(list, point.x, point.y);
                    jmenu.repaint;
                
                end
                
                %----------------------------------------------------------
                % Nested Functions
                %----------------------------------------------------------
                function sortByNumROIs(~,~)
                    boundingBoxes = {this.Session.ImageSet.ImageStruct.objectBoundingBoxes};
                    [rows, ~] = cellfun(@size, boundingBoxes);
                    [~, indices] = sortrows(rows');
                    this.Session.ImageSet.AreThumbnailsGenerated = ...
                        this.Session.ImageSet.AreThumbnailsGenerated(indices);
                    this.Session.ImageSet.ImageStruct = ...
                        this.Session.ImageSet.ImageStruct(indices);
                    this.Session.ImageSet.IsROISelected = ...
                        this.Session.ImageSet.IsROISelected(indices);
                    
                    % edit: The following lines are being done in many
                    % places. Consider refactoring it into a function. 
                    
                    jfirstVisibleIndex = this.JImageList.getFirstVisibleIndex();
                    jlastVisibleIndex = this.JImageList.getLastVisibleIndex();
                    for index = jfirstVisibleIndex:jlastVisibleIndex
                        this.Session.ImageSet.updateImageListEntry(index);
                        javaMethodEDT('setListData', this.JImageList, ...
                            {this.Session.ImageSet.ImageStruct.ImageIcon});
                    end
                    
                    % Scroll to the first unlabeled image after sorting and
                    % select it. 
                    this.setSelectedImageIndex(1);
                    this.makeSelectionVisible(1);
                    drawnow;
                end
                %----------------------------------------------------------
                function remove(~,~)
                    this.processRemove(idxMultiselect)
                end %remove
                %----------------------------------------------------------
                function rotClockwise(~,~)
                    this.rotateClockwise(idxMultiselect);
                end
                %----------------------------------------------------------
                function rotCounterClockwise(~,~)
                    this.rotateCounterClockwise(idxMultiselect);
                end
                %----------------------------------------------------------
            end % doPopup
            
        end % updateImageStrip
        
        %------------------------------------------------------------------
        % Add selection listener to the image browser to handle the update of
        % the image display.
        %------------------------------------------------------------------        
        function addSelectionListener(this)
            
            selectionCallback = handle(this.ImageStrip.getSelectionCallback);
            
            % Connect the callback to a class function. The callback
            % class requires 'delayed' as the listener type.
            selectionListener = handle.listener(selectionCallback, ...
                'delayed', @this.doSelection);

            this.Misc.SelectionListener = selectionListener;
        end
        
        % File selection handler
        %----------------------------------------
        function doSelection(this, ~, ~)
            if ~this.Session.hasAnyImages()
                return
            else                        
                if ishandle(this.FigureHandles.MainImage)
                    
                    if ~this.IsInteractionDisabledByScrollCallback
                        drawnow();
                        setWaiting(this.ToolGroup, true);
                        this.setBrowserInteractionEnabled(false);
                    end

                    this.selectROIMode();
                    this.wipeFigure(this.FigureHandles.MainImage);                    
                    this.drawImages();
                    this.setStatusText();
                    
                    if ~this.IsInteractionDisabledByScrollCallback
                        drawnow();
                        this.setBrowserInteractionEnabled(true);
                        setWaiting(this.ToolGroup, false);
                    end

                end
            end
        end
        
        %------------------------------------------------------------------
        function setPointerToCross(this)
            
            hFig = this.FigureHandles.MainImage;
            hImage = findobj(hFig, 'Type', 'image');
            
            enterFcn = @(figHandle, currentPoint)...
                set(figHandle, 'Pointer', 'cross');
            iptSetPointerBehavior(hImage, enterFcn);
            iptPointerManager(hFig);
        end

        %------------------------------------------------------------------
        function resetPointerBehavior(this)            
            
            hFig = this.FigureHandles.MainImage;
            hImage = findobj(hFig, 'Type', 'image');
            
            iptSetPointerBehavior(hImage, []);
            iptPointerManager(hFig);
        end
        
        %------------------------------------------------------------------
        % selection can be 'ROI', 'ZoomIn', 'ZoomOut', or 'Pan'
        %------------------------------------------------------------------
        function installContextMenu(this, selection, hImage)
        
            choices = {'off','on'};
            
            hFig = this.FigureHandles.MainImage;
                        
            hCmenu = uicontextmenu('Parent', hFig);
            pasteUIMenu = uimenu(hCmenu, 'Label', 'Paste', 'Callback', @this.pasteSelectedROIs);   % context menu for Paste
            if isempty(this.CopiedROIs)
                set(pasteUIMenu,'Enable','off');
            end
            uimenu(hCmenu, 'Label', 'ROI-mode', ...
                'Checked', choices{strcmp(selection,'ROI')+1}, 'Callback', @this.selectROIMode);
            uimenu(hCmenu, 'Label', 'Zoom In', ...
                'Checked', choices{strcmp(selection,'ZoomIn')+1}, 'Callback', @this.selectZoomInMode);
            uimenu(hCmenu, 'Label', 'Zoom Out', ...
                'Checked', choices{strcmp(selection,'ZoomOut')+1}, 'Callback', @this.selectZoomOutMode);
            uimenu(hCmenu, 'Label', 'Pan', ...
                'Checked', choices{strcmp(selection,'Pan')+1}, 'Callback', @this.selectPanMode);
            set(hImage, 'UIContextMenu', hCmenu);                       
        end
        
    end
    
    %======================================================================
    
    methods (Access = 'public', Hidden)
        %------------------------------------------------------------------
        function drawImages(this)
                        
            if ~ishandle(this.FigureHandles.MainImage)
                return; % figure was destroyed 
            end
            
            % Handle the case of wiping the data out
            if isempty(this.Session.ImageSet.ImageStruct)
                return; % this can happen in rapid testing
            end                        
                        
            currentIndex = this.getSelectedImageIndex();            
                        
            try % image can disappear from the disk
                [imageMatrix, imageLabel] = this.Session.ImageSet.getImages(currentIndex);
                set(this.FigureHandles.MainImage,...
                    'HandleVisibility', 'on');
            catch missingFileEx
                errordlg(missingFileEx.message,...
                    vision.getMessage...
                    ('vision:trainingtool:LoadingImagesFailedTitle'), 'modal');
                return;
            end

            tag = this.AxesTags.MainImage;
            hAxes = findobj(this.FigureHandles.MainImage,...
                'Type','axes','Tag',tag);
            
            if isempty(hAxes) || ~ishandle(hAxes) % add an axes if needed                
                hAxes = axes('Parent', this.FigureHandles.MainImage,...
                    'Tag', tag);
            end

            hImage = imshow(imageMatrix,'InitialMagnification', 'fit',...
                'Parent', hAxes, 'Border', 'tight');            
            
            set(hImage, 'buttondownfcn', @this.imageClick);            
            
            % Install context menu again. Have to do it twice because the
            % pointer behavior code prevents the context menus from
            % showing up immediately after images are loaded.
            this.installContextMenu('ROI', hImage);
            
            % add title
            title(hAxes, imageLabel, 'Interpreter', 'none');
                        
            % set pointer behavior to cross when hovering over the image
            this.setPointerToCross();
            
            % Disable overwriting to put on the ROIs
            set(hAxes, 'NextPlot', 'add');
            
            % Display the ROIs before resetting axes properties
            if ~isempty(this.Session.ImageSet.ImageStruct(currentIndex).objectBoundingBoxes)
                this.redrawBoundingBoxes(hAxes, currentIndex);
            end
            
            % resets all axes properties to default values
            set(hAxes, 'NextPlot', 'replace');
            set(hAxes, 'Tag', tag); % add tag after reset

            set(this.FigureHandles.MainImage, 'HandleVisibility', 'callback');
            
            
        end % drawImages
            
        %------------------------------------------------------------------
        function redrawBoundingBoxes(this, hAxes, index)
            
            currentIndex = this.getSelectedImageIndex();           
            boundingBoxes = this.Session.ImageSet.ImageStruct...
                (index).objectBoundingBoxes;
            selectedROIs = this.Session.ImageSet.IsROISelected{currentIndex};
            hImage = findobj(hAxes, 'Type', 'image');
            
            % Restore selection of ROIs across multiple images
            for i = 1:size(boundingBoxes, 1)
                roi = iptui.imcropRect(hAxes, boundingBoxes(i,:)...
                    -[0.5 0.5 0 0],hImage);
                roiPatch = findobj(roi, 'type', 'patch');
                
                if selectedROIs(i)
                    this.selectROI(roi, roiPatch);
                end
                this.enhanceROIAppearence(roi);
            end
            
        end
        
        %------------------------------------------------------------------
        function imageClick(this, varargin)
            mouseClickType = get(this.FigureHandles.MainImage, 'SelectionType');
            
            if strcmp(mouseClickType, 'normal')
                this.drawROI();
            end
            
        end
                
        %---------------------------------------------------------------
        function drawROI(this, varargin)
            
            hAxes = findobj(this.FigureHandles.MainImage, ...
                'Tag', this.AxesTags.MainImage, 'Type', 'Axes');
            
            hImage = findobj(hAxes, 'Type', 'image');
            
            % Un-select any selected ROIs upon drawing a new one
            roiSelected = findall(hAxes, 'tag', 'imrect','Selected','on');
            roiPatches = findall(roiSelected, 'Type', 'Patch');
            if ~isempty(roiSelected)
                this.unSelectROI(roiSelected, roiPatches);
            end
            
            try
                % the drawnow() below is critical since in rapid-fire drawing
                % not having it can lead to de-synchronization of events
                drawnow();                 
                roi = vision.internal.cascadeTrainer.tool.imrectButtonDown(hImage);
            catch
                roi = [];
            end
            
            if isempty(roi)
                return;
            end
                      
            % Left click on the image does not create empty ROIs
            roiPos = roi.getPosition();
            if ~any(roiPos(3:4))
                roi.delete();
                this.updateSessionObject();
                return;
            end
            
            this.setROI(roi);
            
            drawnow(); % Finish all the drawing before moving on

        end
    
        %------------------------------------------------------------------
        function setROI(this, roi)
        
            this.enhanceROIAppearence(roi);
            this.updateSessionObject();
            this.Session.CanExport = this.getExportStatus();
            this.updateButtonStates();
            
        end
    end
    
   %=======================================================================
 
   methods (Access = 'private')
       
       %-------------------------------------------------------------------
       function selectROIMode(this, varargin)
           this.LabelingTab.selectROIMode();
           drawnow();
       end
       
       %-------------------------------------------------------------------
       function selectZoomInMode(this, varargin)
           this.LabelingTab.selectZoomInMode();
       end
       
       %-------------------------------------------------------------------
       function selectZoomOutMode(this, varargin)
           this.LabelingTab.selectZoomOutMode();
       end
       
       %-------------------------------------------------------------------
       function selectPanMode(this, varargin)
           this.LabelingTab.selectPanMode();
       end
       
       %-------------------------------------------------------------------
       function setStatusText(this, varargin)
           % Set the status bar to indicate the number of images labeled
           % by the user.
           md = com.mathworks.mlservices.MatlabDesktopServices.getDesktop;
           f = md.getFrameContainingGroup(this.getGroupName());
           
           if isempty(f)
               % Bail out if we can't grab the frame.  Apparently, this 
               % can happen when testing on the MAC g1130360.
               return;
           end           
           
           if this.Session.hasAnyImages()
               
               totalNumImages = numel(this.Session.ImageSet.ImageStruct);
               bboxes = {this.Session.ImageSet.ImageStruct.objectBoundingBoxes};
               numImagesLabeled = numel(find(~cellfun(@isempty, bboxes)));
               
               boundingBoxes = {this.Session.ImageSet.ImageStruct.objectBoundingBoxes};
               [numROIsPerImage, ~] = cellfun(@size, boundingBoxes);
               totalNumROIs = sum(numROIsPerImage);
               
               statusText{1} = vision.getMessage...
                   ('vision:trainingtool:NumImagesLabeled',...
                   numImagesLabeled, totalNumImages);
               
               statusText{2} = vision.getMessage...
                   ('vision:trainingtool:NumTotalROIs',totalNumROIs);
               
               % setStatusText called by paste operation
               if ~isempty(varargin) && strcmp(varargin{1},'paste')
                   pasteRoiNums = varargin{2};
                   statusText{3} = vision.getMessage...
                       ('vision:trainingtool:LastPasteOp',...
                       pasteRoiNums(2), pasteRoiNums(1));
               end
               
               statusText = strjoin(statusText, '    ');
               
               javaMethodEDT('setStatusText', f, statusText);
           else
               % clear the status text
               javaMethodEDT('setStatusText', f, '');
           end
       end
       
       %-------------------------------------------------------------------
       % Set color of ROIs
       function setROIColor(~, handles, color)
          
          roiObj = arrayfun(@iptgetapi, handles);
          arrayfun(@(x) x.setColor(color), roiObj);
          
       end
       
       %-------------------------------------------------------------------
        function enhanceROIAppearence(this, roi)
            
            roiPosition = roi.getPosition;
            
            % Get Axes handle of the ROI's parent
            parentAxesHandle = ancestor(get(roi, 'parent'), 'axes');
            
            % Specify the order in which objects are drawn to avoid Z
            % buffer fighting (which messes up the patch color when we
            % select an ROI and zoom into the image)
            set(parentAxesHandle, 'SortMethod', 'childorder');
            
            hImage = findobj(parentAxesHandle, 'Type', 'image');            
            [y_extent, x_extent, ~] = size(get(hImage,'CData'));
            
            % Get image boundaries
            xLimit = [0.5 x_extent+0.5];
            yLimit = [0.5 y_extent+0.5];
            
            % Simulate a close ROI button in the parent axes
            delIconSize = 40;
            xOffset = 0;
            yOffset = 0;
            
            delIcon = text('parent',parentAxesHandle,...
                'pos',[roiPosition(1)+roiPosition(3)+xOffset roiPosition(2)+yOffset delIconSize],...
                'string','\fontsize{4} \bf\fontsize{6}X\rm\fontsize{4} ',...
                'tag','delIcon',...
                'edgecolor','w',...
                'color','w',...
                'backgroundcolor',[0.7 0 0],...
                'horizontalalignment','center',...
                'buttondownfcn',@doDeleteROI);
            
            % Store the delete icon's handle
            set(roi,'UserData',delIcon);
            
            % Set SelectionHighlight property to OFF
            % This is required to ensure that the IMRECT corner marker does
            % not block the delete text box
            set(roi, 'SelectionHighlight','off');
            roiChildren = get(roi, 'Children');
            set(roiChildren, 'SelectionHighlight','off');
            
            % Anonymous function for setting mouse pointer to arrow while
            % hovering over delete button.
            
            enterFcn = @(figHandle, currentPoint)...
                set(figHandle, 'Pointer', 'arrow');
            
            iptSetPointerBehavior(delIcon, enterFcn);
            iptPointerManager(this.FigureHandles.MainImage);
            
            % Set patch properties
            roiPatch = findall(roi, 'Type', 'Patch');
            set(roiPatch, 'FaceAlpha', 0.5);
            
            % Set patch callback to select/ unselect ROIs
            iptaddcallback(roiPatch, 'ButtonDownFcn', @clickOnROI);
            
            % Set patch context menu
            patchRightClick = uicontextmenu('Parent',...
                this.FigureHandles.MainImage);
            set(roiPatch, 'UIContextMenu', patchRightClick);
            uimenu(patchRightClick,'Label','Copy', ...
                'Callback', @this.copySelectedROIs);
            uimenu(patchRightClick,'Label','Cut', ...
                'Callback', @this.cutSelectedROIs);
            
            % Constrain drawing of ROIs
            doConstrainROI();
            
            l = findobj(roi, 'type', 'line');
            contextMenuHandle = get(l(1), 'UIContextMenu');
            delete(contextMenuHandle);
            
            % Add callback to reposition delete button if moved
            roi.addNewPositionCallback(@doRepositionDeleteButton);

            this.updateButtonStates();          
            
            % Nested Subfunctions of enhanceROIAppearence
            %----------------------------------------------------------
            function clickOnROI(~,~)
                
                clickType = get(this.FigureHandles.MainImage,...
                    'SelectionType');
                leftClick = strcmp(clickType, 'normal');
                ctrlPressed = strcmp(get(this.FigureHandles.MainImage,...
                    'CurrentModifier'), 'control');
                rightClick = strcmp(clickType,'alt')& isempty(ctrlPressed);
                ctrlClick = strcmp(clickType,'alt')& ~isempty(ctrlPressed);
                
                if leftClick || rightClick
                    if strcmp(get(roi, 'Selected'), 'off');           
                        roiHandles = findall(parentAxesHandle, 'tag',...
                            'imrect','Selected','on');
                        if ~isempty(roiHandles)
                            roiPatches = findall(roiHandles,'Type',...
                                'Patch');
                            this.unSelectROI(roiHandles, roiPatches);
                        end
                        this.selectROI(roi, roiPatch);
                    end
                elseif ctrlClick
                    if strcmp(get(roi, 'Selected'),'off')
                        this.selectROI(roi, roiPatch);
                    else
                        this.unSelectROI(roi, roiPatch);
                    end
                end
                drawnow;
                this.updateSessionObject();
                
            end
            %----------------------------------------------------------
            function doDeleteROI(~, ~)
                delete(delIcon)
                delete(roi);
                this.updateSessionObject();
                this.Session.CanExport = this.getExportStatus();
                this.updateButtonStates();
            end
            
            %----------------------------------------------------------
            function doConstrainROI(~, ~)
                                
                if roiPosition(1) < xLimit(1) % Drawn beyond left axis
                    roi.setPosition([xLimit(1) roiPosition(2) ...
                        roiPosition(3)-(xLimit(1)-roiPosition(1)) roiPosition(4)]);
                elseif roiPosition(1)+roiPosition(3) > xLimit(2) % Drawn beyond right axis
                    roi.setPosition([roiPosition(1) roiPosition(2) ...
                        xLimit(2)-roiPosition(1) roiPosition(4)]);
                elseif roiPosition(2) < yLimit(1) % Drawn above top axis
                    roi.setPosition([roiPosition(1) yLimit(1) ...
                        roiPosition(3)  roiPosition(4)-(yLimit(1)-roiPosition(2))]);
                elseif roiPosition(2)+roiPosition(4) > yLimit(2) % Drawn above bottom axis
                    roi.setPosition([roiPosition(1) roiPosition(2) ...
                        roiPosition(3) yLimit(2)-roiPosition(2)]);
                end
                
            end
                        
            %----------------------------------------------------------
            function doRepositionDeleteButton(newPosition)
                
                set(delIcon,'pos',...
                    [newPosition(1)+newPosition(3)+xOffset ...
                    newPosition(2)+yOffset delIconSize]);
                % check if upper left border is outside axes
                if newPosition(1)+xOffset < min(xLimit) || ...
                        newPosition(1)+xOffset > max(xLimit)|| ...
                        newPosition(2)+yOffset < min(yLimit)|| ...
                        newPosition(2)+yOffset > max(yLimit)
                    set(delIcon,'Visible','off');
                else
                    set(delIcon,'Visible','on');
                end
                
                % Do not update session obj if nudge operation is going on
                if ~this.InsideNudge
                    this.updateSessionObject();
                end
            end % end of doRepositionDeleteButton
            
        end % end of enhanceROIAppearence
                
        %------------------------------------------------------------------
        
        % Change patch and bounding box colors to indicate selection
        function selectROI(this, roi, roiPatch)
            % Change patch color to yellow
            set(roiPatch, 'FaceColor', 'y');
            set(roi, 'Selected','on');
            
            % Change bounding box color to black
            if isa(roi, 'imrect')
                roi.setColor('k');
            else
                this.setROIColor(roi, 'k');
            end
        end
        %------------------------------------------------------------------
        
        % Change patch and bounding box colors to indicate de-selection
        function unSelectROI(this, roi, roiPatch)
            % Change patch color to none
            set(roiPatch, 'FaceColor', 'none');
            set(roi, 'Selected','off');
            
            % Change bounding box color to default
            if isa(roi, 'imrect')
                roi.setColor(this.DefaultROIColor);
            else
                this.setROIColor(roi, this.DefaultROIColor);
            end
        end
        %------------------------------------------------------------------
        function updateSessionObject(this)
            
            currentIndex = this.getSelectedImageIndex;
            hAxes = findobj(this.FigureHandles.MainImage, 'Type', 'axes');
            currentROIs = findall(hAxes, 'tag', 'imrect');
            
            % Return if no ROIs
            if isempty(currentROIs)
                this.Session.CanExport = false;
            end
            boundingBoxes = zeros(numel(currentROIs),4);
            selectedROIs = false(numel(currentROIs),1);
            for i = 1:numel(currentROIs)
                boundingBoxes(i,:) = getPos(currentROIs(i));
                if strcmp(get(currentROIs(i), 'Selected'),'on')
                    selectedROIs(i) = true;
                end
            end
            
            needsUpdate = ...
                this.Session.ImageSet.updateBoundingBoxes(currentIndex,...
                boundingBoxes, selectedROIs);
            
            this.Session.IsChanged = needsUpdate;            
            
            % Increment the ROI count on the icon description
            this.Session.ImageSet.updateIconDescription(currentIndex);
            % update the status bar to refresh the progress in labeling
            this.setStatusText();
            javaMethodEDT('updateUI', this.JImageList); % Force an update of the list
            
            this.Session.CanExport = true;
            
            %--------------------------------------------------------------
            function bbox = getPos(ROI)
                bbox = iptgetapi(ROI);
                bbox = round(feval(bbox.getPosition));
            end 
            
        end
        
        %------------------------------------------------------------------
        % returns index of the selected Image
        %------------------------------------------------------------------
        function idx = getSelectedImageIndex(this)
            idx = double(javaMethodEDT('getSelectedIndex', this.JImageList));
            idx = idx+1; % make it one based
        end

        %------------------------------------------------------------------
        function setSelectedImageIndex(this, index) % assumes 1-based index
            javaMethodEDT('setSelectedIndex', this.JImageList, index-1);
        end

        %------------------------------------------------------------------
        function makeSelectionVisible(this, index)
            javaMethodEDT('ensureIndexIsVisible', this.JImageList, index-1);
        end
        
        %------------------------------------------------------------------
        function [idx, jIdx] = getSelectedImageIndices(this)
            idx = double(this.JImageList.getSelectedIndices);
            jIdx = idx; % 0-based java index
            idx = idx+1; % make it one based
        end
        
        %------------------------------------------------------------------
        function processRemove(this, idxMultiselect)
            
            % create a warning that asks if you're sure to remove
            
            % Display different warnings based on whether multiple images
            % are selected or just a single image is selected.
            
            if numel(idxMultiselect) > 1
                choice = questdlg(vision.getMessage('vision:trainingtool:RemoveImagesPrompt'),...
                    vision.getMessage('vision:trainingtool:RemoveImagesTitle'),...
                    vision.getMessage('vision:uitools:Remove'),...
                    vision.getMessage('vision:uitools:Cancel'),...
                    vision.getMessage('vision:uitools:Cancel'));
            elseif (numel(idxMultiselect) == 1)
                choice = questdlg(vision.getMessage('vision:trainingtool:RemoveImagePrompt'),...
                    vision.getMessage('vision:trainingtool:RemoveImageTitle'),...
                    vision.getMessage('vision:uitools:Remove'),...
                    vision.getMessage('vision:uitools:Cancel'),...
                    vision.getMessage('vision:uitools:Cancel'));
                    
            end
            
            % Handle of the dialog is destroyed by the user
            % closing the dialog or the user pressed cancel
            if isempty(choice) || ...
                    strcmp(choice, 'Cancel')
                return;
            end
            
            this.Session.ImageSet.removeImage(idxMultiselect);
            
            this.Session.IsChanged = true;
                        
            jLowestIdx = idxMultiselect(1)-1;
            
            if this.Session.hasAnyImages()
                javaMethodEDT('setListData', this.JImageList, {this.Session.ImageSet.ImageStruct.ImageIcon});
                
                if jLowestIdx ~= 0
                    newIdx = jLowestIdx;
                else
                    newIdx = 1;
                end
                
                this.setSelectedImageIndex(newIdx);
                drawnow();
                
            else
                this.resetAll;
            end
            
            
            % Update the UI before proceeding further
            drawnow;
            
        end
        
        %------------------------------------------------------------------
        function rotateClockwise(this, idxMultiselect)
            
            % create a warning that asks if you're sure to overwrite
            % rotated image
            
            % Display different warnings based on whether multiple images
            % are selected or just a single image is selected.
            
            if numel(idxMultiselect) > 1
                choice = questdlg(vision.getMessage('vision:trainingtool:RotateImagesPrompt'),...
                    vision.getMessage('vision:trainingtool:RotateImagesTitle'),...
                    vision.getMessage('vision:trainingtool:Continue'),...
                    vision.getMessage('vision:uitools:Cancel'),...
                    vision.getMessage('vision:uitools:Cancel'));
            elseif (numel(idxMultiselect) == 1)
                choice = questdlg(vision.getMessage('vision:trainingtool:RotateImagePrompt'),...
                    vision.getMessage('vision:trainingtool:RotateImageTitle'),...
                    vision.getMessage('vision:trainingtool:Continue'),...
                    vision.getMessage('vision:uitools:Cancel'),...
                    vision.getMessage('vision:uitools:Cancel'));
            end
            
            % Handle of the dialog is destroyed by the user
            % closing the dialog or the user pressed cancel
            if isempty(choice) || ...
                    strcmp(choice, 'Cancel')
                return;
            end
            
            rotationType = 'Clockwise';
            this.Session.ImageSet.rotateImages(idxMultiselect, rotationType);
            
            this.Session.IsChanged = true;
            
            javaMethodEDT('setListData', this.JImageList, {this.Session.ImageSet.ImageStruct.ImageIcon});
            
            this.setFocusOnImages();
            
            this.setSelectedImageIndex(idxMultiselect(1)); % pick the first index
            
            drawnow();
            
            this.drawImages();
            
        end
        
        %------------------------------------------------------------------
        function rotateCounterClockwise(this, idxMultiselect)
             % create a warning that asks if you're sure to overwrite
             % rotated image
            
            % Display different warnings based on whether multiple images
            % are selected or just a single image is selected.
            
            if numel(idxMultiselect) > 1
                choice = questdlg(vision.getMessage('vision:trainingtool:RotateImagesPrompt'),...
                    vision.getMessage('vision:trainingtool:RotateImagesTitle'),...
                    vision.getMessage('vision:trainingtool:Continue'),...
                    vision.getMessage('vision:uitools:Cancel'),...
                    vision.getMessage('vision:uitools:Cancel'));
            elseif (numel(idxMultiselect) == 1)
                choice = questdlg(vision.getMessage('vision:trainingtool:RotateImagePrompt'),...
                    vision.getMessage('vision:trainingtool:RotateImageTitle'),...
                    vision.getMessage('vision:trainingtool:Continue'),...
                    vision.getMessage('vision:uitools:Cancel'),...
                    vision.getMessage('vision:uitools:Cancel'));
            end
            
            % Handle of the dialog is destroyed by the user
            % closing the dialog or the user pressed cancel
            if isempty(choice) || ...
                    strcmp(choice, 'Cancel')
                return;
            end
            rotationType = 'CounterClockwise';
            this.Session.ImageSet.rotateImages(idxMultiselect, rotationType);
            
            this.Session.IsChanged = true;
            
            javaMethodEDT('setListData', this.JImageList, ...
                {this.Session.ImageSet.ImageStruct.ImageIcon});
            
            this.setFocusOnImages();
            this.setSelectedImageIndex(idxMultiselect(1)); % pick the first index
            drawnow;
            this.drawImages();
            
        end
        
        %------------------------------------------------------------------
        % Puts the image strip in focus
        %------------------------------------------------------------------
        function setFocusOnImages(this)
             %drawnow;
             if ishandle(this.JImageList)
                javaMethodEDT('requestFocus', this.JImageList);
             end
        end
        
        %------------------------------------------------------------------
        % Creates a figure with properties desired by the Training Data labeler 
        % tool  UI
        %------------------------------------------------------------------
        function fig = makeFig(this)
            fig = figure('Resize', 'off', 'Visible','off', ...
                'NumberTitle', 'off', 'Name', '', 'HandleVisibility',...
                'callback', 'Color','white','IntegerHandle','off',...
                'BusyAction', 'cancel', 'Interruptible', 'off');
            iptaddcallback(fig,'KeyPressFcn',@this.doFigKeyPress);
        end

        %------------------------------------------------------------------
        % Pressing a key in the main figure, will send you through this
        % code
        %------------------------------------------------------------------
        function doFigKeyPress(this,~,src)
            
            if ~this.Session.hasAnyImages()
                % Nothing to do if none of the images are loaded.
                return;
            end
                        
            modifierKeys = {'control', 'command'};
            
            if strcmp(src.Modifier, modifierKeys{ismac+1})
                switch src.Key
                    case 'a'
                        this.selectAllROIs();
                    case 'c'
                        this.copySelectedROIs();
                    case 'v'
                        if ~isempty(this.CopiedROIs)
                            this.pasteSelectedROIs;
                        end
                    case 'x'
                        this.cutSelectedROIs();
                    otherwise
                        this.directionKeyPress(src.Key, src.Modifier);
                end
            else
                switch src.Key
                    case 'escape'
                        this.selectROIMode();
                    case 'delete'
                        this.deleteSelectedROIs();
                    case 'pagedown'
                        this.changeImage(1);
                    case 'pageup'
                        this.changeImage(-1);
                    otherwise
                        this.directionKeyPress(src.Key, src.Modifier);
                end
            end
        end
        
        %------------------------------------------------------------------
        
        function directionKeyPress(this, keyPressed, modifierPressed)

            directionKeys = {'uparrow', 'downarrow', 'rightarrow',...
                'leftarrow'};
            keyIndex = find(strcmp(keyPressed, directionKeys), 1);
            
            if ~isempty(keyIndex)
                hAxes = findobj(this.FigureHandles.MainImage,'Type',...
                    'axes');
                currentROIs = findall(hAxes, 'tag', 'imrect',...
                    'Selected','on');
                if isempty(currentROIs)
                    if keyIndex==1
                        this.changeImage(-1);
                    elseif keyIndex==2
                        this.changeImage(1);
                    end
                else
                    nudgeROI();
                end
            end
            
            %--------------------------------------------------------------
            function nudgeROI()
                
                hImage = findobj(hAxes, 'Type', 'image');
                [y_extent, x_extent, ~] = size(get(hImage,'CData'));
                constraint_fcn = makeConstrainToRectFcn('imrect',...
                    [1 x_extent+1], [1 y_extent+1]);

                roiObjects = arrayfun(@iptgetapi, currentROIs);
                roiPositions = cell2mat(arrayfun(@(x) x.getPosition(),...
                    roiObjects,'UniformOutput',false));
                
                % Get number of pixels to nudge (based on whether CTRL is
                % pressed), and the index of the ROI that is closest to the
                % image boundary
                [nudgePixels, index] = nudgeDirection();
                
                % If the ROI closest to the image boundary is within bounds
                % after nudging, then nudge all ROIs
                newPos = roiPositions(index,:) + nudgePixels + [0.5 0.5 0 0];
                
                this.InsideNudge = 1;
                if isequal(newPos, constraint_fcn(newPos))
                    newRoiPositions = cell2mat(arrayfun(@(x)...
                        roiPositions(x,:) + nudgePixels,...
                        (1:numel(currentROIs))','UniformOutput',false));
                    arrayfun(@(x,y) x.setPosition(newRoiPositions(y,:)),...
                        roiObjects,(1:numel(currentROIs))');
                end
                this.InsideNudge = 0;
                this.updateSessionObject();

                drawnow();

                %----------------------------------------------------------
                function [nudgePixels, index] = nudgeDirection()
                    
                    switch keyIndex
                        case 1
                            nudgePixels = [0 -5 0 0];
                            [~,index] = min(roiPositions(:,2));
                        case 2
                            nudgePixels = [0 5 0 0];
                            [~,index] = max(roiPositions(:,2)+...
                                roiPositions(:,4));
                        case 3
                            nudgePixels = [5 0 0 0];
                            [~,index] = max(roiPositions(:,1)+...
                                roiPositions(:,3));
                        case 4
                            nudgePixels = [-5 0 0 0];
                            [~,index] = min(roiPositions(:,1));
                    end
                    
                    if ~isempty(modifierPressed)
                        if any(strcmp(modifierPressed, {'control',...
                                'command'}))
                            nudgePixels = nudgePixels./5;
                        end
                    end
                    
                end    % end of nudgeDirection()
                
            end    % end of nudgeROI()
            
        end
        %--------------------------------------------------------------
        function changeImage(this, direction)

            currentIndex = this.getSelectedImageIndex();
            this.setSelectedImageIndex(currentIndex+direction);
            this.makeSelectionVisible(currentIndex+direction);
            
        end
        
        %------------------------------------------------------------------
        % Select all ROIs
        function selectAllROIs(this, varargin)
           
            hAxes = findobj(this.FigureHandles.MainImage, 'Type', 'axes');
            % Get handles to unselected ROIs
            roiUnSelected = findall(hAxes, 'tag', 'imrect','Selected',...
                'off');
            roiPatches = findall(roiUnSelected, 'type', 'patch');
            this.selectROI(roiUnSelected, roiPatches);

            this.updateSessionObject();
            
        end
        
        %------------------------------------------------------------------
        % Paste selected ROI co-ordinates
        function pasteSelectedROIs(this, varargin)
            
            hAxes = findobj(this.FigureHandles.MainImage, 'Type', 'axes');
            hImage = findobj(hAxes, 'Type', 'image');
            selectedROI = findall(hAxes, 'tag', 'imrect','Selected','on');
            
            [y_extent, x_extent, ~] = size(get(hImage,'CData'));
            constraint_fcn = makeConstrainToRectFcn('imrect',...
                    [1 x_extent+1], [1 y_extent+1]);
            
            % Offsets needed for pasting in case of overlap
            xOffset = round(x_extent/100 + 1);
            yOffset = round(y_extent/100 + 1);
            offset(1,:) = [ xOffset,  yOffset, 0, 0];
            offset(2,:) = [-xOffset, -yOffset, 0, 0];
            offset(3,:) = [ xOffset, -yOffset, 0, 0];
            offset(4,:) = [-xOffset,  yOffset, 0, 0];
            
            currentIndex = this.getSelectedImageIndex();
            
            numROIs = size(this.CopiedROIs,1);
            numPastedROIs = 0;
            for i = 1:numROIs
                boxPoints = this.CopiedROIs(i,:);
                currentROIs = this.Session.ImageSet.ImageStruct...
                    (currentIndex).objectBoundingBoxes;
                
                % Pasting between images of different sizes
                if (boxPoints(1) > x_extent) || (boxPoints(2) > y_extent)
                    continue;
                end
                
                boxPoints(3) = min(boxPoints(3), x_extent+1-boxPoints(1));
                boxPoints(4) = min(boxPoints(4), y_extent+1-boxPoints(2));
                
                % Offset code
                offsetIndex = 1;
                if ~isempty(currentROIs)
                    % Check if pasted ROI overlaps with existing ROIs
                    if ~isempty(intersect(currentROIs,boxPoints,'rows'))
                        lastToLastPoints = [NaN NaN NaN NaN];
                        lastPoints = boxPoints;
                        try
                            % Find a place to paste since there is overlap
                            findPlaceToPaste();
                        catch
                            % No place found, do not paste ROI
                            boxPoints = [];
                        end
                    end
                end
                
                if ~isempty(boxPoints)
                    % Paste the ROI, make it 'selected'
                    pastedRoi = iptui.imcropRect(...
                        hAxes, boxPoints-[0.5 0.5 0 0], hImage);
                    roiPatch = findobj(pastedRoi, 'type', 'patch');
                    this.selectROI(pastedRoi, roiPatch);
                    this.setROI(pastedRoi);
                    numPastedROIs = numPastedROIs + 1;
                end
            end

            % Unselect any selected ROIs if atleast one ROI is pasted
            if numPastedROIs > 0 && ~isempty(selectedROI)
                roiPatches = findall(selectedROI,'Type','Patch');
                this.unSelectROI(selectedROI, roiPatches);
                this.updateSessionObject();
            end
            
            % Notify user if all ROIs are not pasted
            if numROIs ~= numPastedROIs
                this.setStatusText('paste', [numROIs numPastedROIs]);
            end
            
            % Flush the event queue before new paste callback
            % This is required to ensure ROIs are pasted only as long as
            % CTRL+V is held down
            drawnow;
            
            %-------------------------------------------------------
            % Recursive function to look for a place to paste
            function findPlaceToPaste()
                
                % Add offset and check if within bounds
                newBoxPoints = boxPoints + offset(offsetIndex,:);
                if ~isequal(constraint_fcn(newBoxPoints), newBoxPoints)
                    
                    % Outside bounds, so change offset direction and keep
                    % looking for a place
                    offsetIndex = offsetIndex + 1;
                    if offsetIndex==5
                        offsetIndex = 1;
                    end
                    findPlaceToPaste();
                else
                    
                    % Check if we are have already been at the current
                    % location before (this check is needed to avoid 
                    % getting stuck in an infinite loop)
                    if ~isequal(lastToLastPoints,newBoxPoints)
                        
                        % If there is no overlap, then we have found a
                        % place to paste. This is the only point of return
                        % from this recursive function
                        if ~isempty(intersect(currentROIs,boxPoints,'rows'))
                            
                            % We still have overlap, update previous
                            % locations, and keep looking for a place
                            boxPoints = newBoxPoints;
                            lastToLastPoints = lastPoints;
                            lastPoints = boxPoints;
                            findPlaceToPaste();
                        end
                    else
                        
                        % We have been here before, so change direction 
                        % and keep looking for a place
                        offsetIndex = offsetIndex + 1;
                        if offsetIndex==5
                            offsetIndex = 1;
                        end
                        findPlaceToPaste();
                    end
                end
            end
            
        end
        %--------------------------------------------------------------
        % Copy selected ROIs
        function copySelectedROIs(this, varargin)

            currentIndex    = this.getSelectedImageIndex();
            selectedIndices = this.Session.ImageSet.IsROISelected...
                {currentIndex};
            
            if any(selectedIndices)
                if isempty(this.CopiedROIs)
                    this.enablePaste();
                end
                
                % Copy the selected ROIs
                this.CopiedROIs = this.Session.ImageSet.ImageStruct...
                    (currentIndex).objectBoundingBoxes(selectedIndices,:);
            end
            
        end
        
        %--------------------------------------------------------------
        % Cut selected ROIs
        function cutSelectedROIs(this, varargin)
            
            % Copy selected ROIs
            this.copySelectedROIs();
            
            % Delete selected ROIs
            this.deleteSelectedROIs();
            
        end
        
        %--------------------------------------------------------------
        % Delete selected ROIs
        function deleteSelectedROIs(this, varargin)
        
            % Delete selected ROIs and their respective 'Delete' icons
            hAxes = findobj(this.FigureHandles.MainImage, 'Type',...
                'axes');
            currentROIs = findall(hAxes, 'tag', 'imrect',...
                'Selected','on');
            delIcons = get(currentROIs, 'UserData');
            
            if iscell(delIcons)
                delete([delIcons{:}])
            else
                delete(delIcons)
            end
            delete(currentROIs);
            
            this.updateSessionObject();
            this.Session.CanExport = this.getExportStatus();
            this.updateButtonStates();
            
        end
        
        %--------------------------------------------------------------
        % Function to enable 'Paste' context menu at the first copy
        function enablePaste(this, varargin)
            
            hAxes = findobj(this.FigureHandles.MainImage, 'Type',...
                'axes');
            hImage     = findobj(hAxes, 'Type', 'image');
            foundPaste = findall(get(hImage,'UIContextMenu'),...
                'Label','Paste');
            set(foundPaste, 'Enable','on');
            
        end
        %--------------------------------------------------------------
    
   end
    
   %=======================================================================
            
    %----------------------------------------------------------------------
    % Static private methods
    %----------------------------------------------------------------------
    methods (Access = 'private', Static)

        %------------------------------------------------------------------
        function selection = askForSavingOfSession

            yes    = vision.getMessage('vision:uitools:Yes');
            no     = vision.getMessage('vision:uitools:No');
            cancel = vision.getMessage('vision:uitools:Cancel');            
           
            selection = questdlg(vision.getMessage...
                ('vision:uitools:SaveSessionQuestion'), ...
                vision.getMessage('vision:uitools:SaveSessionTitle'), ...
                yes, no, cancel, yes);
            
            if isempty(selection) % dialog was destroyed with a click
                selection = cancel;
            end
        end
                
        
    end % end of static private methods
    
end % end of classdef block

