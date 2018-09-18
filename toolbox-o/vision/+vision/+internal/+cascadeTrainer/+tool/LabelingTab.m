
% LabelingTab Defines key UI elements of the Ground Truth Labeling App
% used by trainCascadeObjectDetector algorithm
%    This class defines all key UI elements and sets up callbacks that
%    point to methods inside the TrainingDataLabeler class.

% Copyright 2012-2013 The MathWorks, Inc.


classdef LabelingTab < vision.internal.uitools.AbstractTab
    
    properties(Access = private)
        FilePanel;
        
        % mode section
        ZoomInButton
        ZoomOutButton
        PanButton
        AddROIButton
        ModeButtonGroup
        
        ExportPanel;
    end
    
    %----------------------------------------------------------------------
    % Public methods
    %----------------------------------------------------------------------
    methods (Access=public)
        %------------------------------------------------------------------
        % Constructor
        %------------------------------------------------------------------
        function this = LabelingTab(tool)
            this = this@vision.internal.uitools.AbstractTab(tool, ...
                tool.getGroupName(), ...
                vision.getMessage('vision:trainingtool:LabelingTab'));
            this.createWidgets();
            this.installListeners();
        end
        
        % -----------------------------------------------------------------
        function testers = getTesters(~)
            testers = [];
        end
                
        %------------------------------------------------------------------
        function updateButtonStates(this, session)
            
            hasAnyImages = session.hasAnyImages();
            this.updateModeButtons(hasAnyImages);
            this.ExportPanel.IsButtonEnabled = session.CanExport;
            
            if this.ExportPanel.IsButtonEnabled
                setToolTip(this.ExportPanel, ...
                    'vision:trainingtool:EnabledExportToolTip');
            else
                setToolTip(this.ExportPanel, ...
                    'vision:trainingtool:DisabledExportToolTip');
            end
            
        end
        
        %------------------------------------------------------------------
        % returns a string with the type of mode, so that we can customize
        % cmenu according to the selection
        %------------------------------------------------------------------
        function mode = getSelectedMode(this)
            if this.AddROIButton.Selected 
                mode = 'ROI';
            elseif this.ZoomInButton.Selected
                mode = 'zoomin';
            elseif this.ZoomOutButton.Selected
                mode = 'zoomout';
            elseif this.PanButton.Selected
                mode = 'pan';
            end
        end
        
        %------------------------------------------------------------------
        function selectZoomInMode(this)
            this.ZoomInButton.Selected = true;
        end
        
        %------------------------------------------------------------------
        function selectZoomOutMode(this)
            this.ZoomOutButton.Selected = true;
        end
        
        %------------------------------------------------------------------
        function selectPanMode(this)
            this.PanButton.Selected = true;
        end
        
        %------------------------------------------------------------------
        function selectROIMode(this)
            this.AddROIButton.Selected = true;
        end
        
        %------------------------------------------------------------------
    end % end of public methods
    
    %----------------------------------------------------------------------
    % Private methods
    %----------------------------------------------------------------------
    methods (Access=private)
        
        %------------------------------------------------------------------
        function updateModeButtons(this, hasAnyImages)
            
            if hasAnyImages
                
                this.ZoomInButton.Enabled  = true;
                this.ZoomOutButton.Enabled = true;
                this.PanButton.Enabled     = true;
                this.AddROIButton.Enabled  = true;

                this.AddROIButton.Selected = true;
                
            else

                % Clear out any selections when there are no images
                this.ZoomInButton.Selected  = false;
                this.ZoomOutButton.Selected = false;
                this.PanButton.Selected     = false;
                this.AddROIButton.Selected  = true;

                drawnow();
                
                % Now disable them
                this.ZoomInButton.Enabled   = false;
                this.ZoomOutButton.Enabled  = false;
                this.PanButton.Enabled      = false;
                this.AddROIButton.Enabled   = false;
                
            end
        end
        
        %------------------------------------------------------------------
        function createWidgets(this)
            
            % Tool-strip sections
            %%%%%%%%%%%%%%%%%%%%%
            fileSection = this.createSection(...
                'vision:uitools:FileSection', 'secFile');
            
            modeSection = this.createSection(...
                'vision:trainingtool:ModeSection', 'secZoom');
            
            exportSection = this.createSection(...
                'vision:uitools:ExportSection', 'secExport');
                        
            helpSection = this.createSection(...
                'vision:uitools:ResourcesSection', 'secResources');
                        
            % Creating Components for each section
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            this.createFileSection();
            
            this.createModeSection();
            
            this.createModeButtonGroup();
            
            this.createExportSection();
                        
            % Tool-strip layout
            %%%%%%%%%%%%%%%%%%%
            
            this.addFileSection(fileSection);
            
            this.addModeSection(modeSection);
            
            this.addExportSection(exportSection);
                       
            this.addHelpSection(helpSection);
            
            % Place sections
            %%%%%%%%%%%%%%%%
            tab = this.getToolTab();
            add(tab,fileSection);
            add(tab,modeSection);
            add(tab,exportSection);
            add(tab, helpSection);
            
        end
        
        %------------------------------------------------------------------
        function installListeners(this)            
            this.installListenersFileSection();
            this.installListenersModeSection();
        end
        
        %------------------------------------------------------------------
        function createFileSection(this)
            this.FilePanel = vision.internal.cascadeTrainer.tool.LabelerFilePanel();            
        end
        
        %------------------------------------------------------------------
        function createModeSection(this)
            
            this.createZoomInButton();
            this.createZoomOutButton();
            this.createPanButton();
            this.createAddROIButton();
            
        end
        
        %------------------------------------------------------------------
        function createExportSection(this)
            this.ExportPanel = vision.internal.uitools.OneButtonPanel();
            
            exportIcon = toolpack.component.Icon.CONFIRM_24;
            nameId = 'vision:trainingtool:ExportButton';
            this.ExportPanel.createTheButton(exportIcon, nameId, 'btnExport');
                        
            this.ExportPanel.setToolTip(...
                'vision:trainingtool:DisabledExportToolTip');
            
            fun = @(es,ed)export(getParent(this));
            this.ExportPanel.addButtonCallback(fun);
        end                  
        
        %------------------------------------------------------------------
        function createZoomInButton(this)
            zoomInIcon = toolpack.component.Icon.ZOOM_IN_16;
            this.ZoomInButton = this.createToggleButton(zoomInIcon, ...
                'vision:uitools:ZoomInButton', ...
                'btnZoomIn', 'horizontal');
            this.setToolTipText(this.ZoomInButton,...
                'vision:uitools:ZoomInToolTip');
        end
        
        %------------------------------------------------------------------
        function createZoomOutButton(this)
            zoomOutIcon = toolpack.component.Icon.ZOOM_OUT_16;
            this.ZoomOutButton = this.createToggleButton(zoomOutIcon, ...
                'vision:uitools:ZoomOutButton', ...
                'btnZoomOut', 'horizontal');
            this.setToolTipText(this.ZoomOutButton,...
                'vision:uitools:ZoomOutToolTip');
        end
        
        %------------------------------------------------------------------
        function createPanButton(this)
            panIcon = toolpack.component.Icon.PAN_16;
            this.PanButton = this.createToggleButton(panIcon, ...
                'vision:uitools:PanButton', ...
                'btnPan', 'horizontal');
            this.setToolTipText(this.PanButton,...
                'vision:uitools:PanToolTip');
        end
        
        %------------------------------------------------------------------
        function createAddROIButton(this)
            addROIIcon = toolpack.component.Icon(...
                fullfile(matlabroot,'toolbox','vision','vision',...
                '+vision','+internal','+cascadeTrainer','+tool','ROI_24.png'));
            this.AddROIButton = this.createToggleButton(addROIIcon, ...
                'vision:trainingtool:AddROIButton', ...
                'btnAddROI', 'vertical');
            this.setToolTipText(this.AddROIButton,...
                'vision:trainingtool:AddROIsToolTip');
        end
        
        %------------------------------------------------------------------
        function createModeButtonGroup(this)
            this.ModeButtonGroup = toolpack.component.ButtonGroup;
            this.ModeButtonGroup.add(this.ZoomInButton);
            this.ModeButtonGroup.add(this.ZoomOutButton);
            this.ModeButtonGroup.add(this.PanButton);
            this.ModeButtonGroup.add(this.AddROIButton);
        end
                
        %------------------------------------------------------------------
        function addFileSection(this, fileSection)
            add(fileSection, this.FilePanel.Panel);
        end
        
        %------------------------------------------------------------------
        function addModeSection(this, modeSection)
            panel = toolpack.component.TSPanel('f:p,3dlu,p:g', 'p:g,p:g,p:g');
            add(panel, this.ZoomInButton, 'xy(3,1)');
            add(panel, this.ZoomOutButton, 'xy(3,2)');
            add(panel, this.PanButton, 'xy(3,3)');
            add(panel, this.AddROIButton, 'xywh(1,1,1,3)');
            add(modeSection, panel);
        end
        
        %------------------------------------------------------------------
        function addExportSection(this, exportSection)
            add(exportSection, this.ExportPanel.Panel);
        end
        
        %------------------------------------------------------------------
        function addHelpSection(this, helpSection)
            helpFun = @(es,ed)help(getParent(this));
            toolTipId = 'vision:trainingtool:HelpToolTip';
            panel = vision.internal.uitools.HelpPanel(helpFun, toolTipId);
            add(helpSection, panel.Panel);
        end
        
        %------------------------------------------------------------------
        function installListenersFileSection(this)
            this.FilePanel.addNewSessionCallback(...
                @(es,ed)newSession(getParent(this)));
            
            this.FilePanel.addOpenSessionCallbacks(...
                @(es,ed)openSession(getParent(this)), @this.doOpen);
            
            this.FilePanel.addSaveSessionCallbacks(...
                @(es,ed)saveSession(getParent(this)), @this.doSave);

            this.FilePanel.addAddImagesCallback(...
                @(es,ed)addImages(getParent(this)));
        end
        
        %------------------------------------------------------------------
        function installListenersModeSection(this)
            addlistener(this.ZoomInButton, 'ItemStateChanged',...
                @this.doSelectMode);
            addlistener(this.ZoomOutButton, 'ItemStateChanged',...
                @this.doSelectMode);
            addlistener(this.PanButton, 'ItemStateChanged',...
                @this.doSelectMode);
            addlistener(this.AddROIButton, 'ItemStateChanged',...
                @this.doSelectMode);
        end
                        
        %------------------------------------------------------------------
        function items = getSaveOptions(~)
            % defining the option entries appearing on the popup of the
            % Save Split Button.
            
            saveIcon = com.mathworks.common.icons.CommonIcon.SAVE;
            saveAsIcon = com.mathworks.common.icons.CommonIcon.SAVE_AS;
            
            items(1) = struct(...
                'Title', vision.getMessage('vision:uitools:SaveSessionOption'), ...
                'Description', '', ...
                'Icon', toolpack.component.Icon(saveIcon.getIcon), ...
                'Help', [], ...
                'Header', false);
            items(2) = struct(...
                'Title', vision.getMessage('vision:uitools:SaveSessionAsOption'), ...
                'Description', '', ...
                'Icon', toolpack.component.Icon(saveAsIcon.getIcon), ...
                'Help', [], ...
                'Header', false);
        end
        
        %------------------------------------------------------------------
        % Handle the save button options
        %------------------------------------------------------------------
        function doSave(this, src, ~)
            
            % from save options popup
            if src.SelectedIndex == 1         % Save
                saveSession(getParent(this));
            elseif src.SelectedIndex == 2     % SaveAs
                saveSessionAs(getParent(this));
            end
        end
        
        %------------------------------------------------------------------
        % Handle the open button options
        %------------------------------------------------------------------
        function doOpen(this, src, ~)
            
            % from save options popup
            if src.SelectedIndex == 1         % Save
                openSession(getParent(this));
            elseif src.SelectedIndex == 2     % SaveAs
                addToCurrentSession(getParent(this));
            end
        end
        
        %------------------------------------------------------------------
        % Handle Mode options
        %------------------------------------------------------------------
        
        % Check if there is a way to handle just toggle on
        function doSelectMode(this, src, ~)
            drawnow();
            if src.Selected
                switch (src.Name)
                    case 'btnZoomIn'
                        doZoomIn(getParent(this));                                            
                    case 'btnZoomOut'
                        doZoomOut(getParent(this));                    
                    case 'btnPan'
                        doPan(getParent(this));
                    case 'btnAddROI'
                        doAddROI(getParent(this));                    
                end
            end
            
        end % doSelectMode
        
        %------------------------------------------------------------------
 
    end % end of private methods

end % end of class definition
