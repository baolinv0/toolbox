classdef VideoViewerScopeCfg < Simulink.scopes.ScopeBlockSpecification
    %VideoViewerScopeCfg   Define the VideoViewerScopeCfg class.
    
    %   Copyright 2008-2011 The MathWorks, Inc.
    
    methods
        
        function this = VideoViewerScopeCfg(varargin)
            %VideoViewerScopeCfg   Construct the VideoViewerScopeCfg class.
            
            % Prevent clear classes warnings
            mlock;
            
            this@Simulink.scopes.ScopeBlockSpecification(varargin{:});
        end
    end
    
    methods
        
        function appName = getScopeTag(~)
            %getAppName Returns the simple application name.
            appName = 'Video Viewer';
        end
        
        function setScopeParams(this)
            
            hBlock = this.Block;
            hScope = this.Scope;
            
            if strcmpi(hBlock.useColorMap, 'on')
                mapExpression = hBlock.ColormapValue;
            else
                mapExpression = 'gray(256)';
            end
            
            setScopeParam(hScope, 'Visuals', 'Video', ...
                'ColorMapExpression', mapExpression);
            setScopeParam(hScope, 'Visuals', 'Video', ...
                'UseDataRange', strcmp(hBlock.specRange, 'on'));
            setScopeParam(hScope, 'Visuals', 'Video', ...
                'DataRangeMin', evalin('base', hBlock.minInputVal));
            setScopeParam(hScope, 'Visuals', 'Video', ...
                'DataRangeMax', evalin('base', hBlock.maxInputVal));
            
            set(this.Scope.getWidget('Base/Menus/File/Sources/OpenAtMdlStart').WidgetHandle, ...
                'Checked', hBlock.OpenAtMdlStart);
            
            if strcmp(hBlock.imagePorts, 'One multidimensional signal')
                set(this.Scope.getWidget('Base/Menus/File/Sources/ImageSignal/OneImagePort').WidgetHandle, 'Checked', 'on');
            else
                set(this.Scope.getWidget('Base/Menus/File/Sources/ImageSignal/MultiImagePort').WidgetHandle, 'Checked', 'on');
            end
        end
        
        function setBlockParams(this)
            
            hScope = this.Scope;
            
            colorMap = getScopeParam(hScope, 'Visuals', 'Video', 'ColorMapExpression');
            if strncmp(colorMap, 'gray(256)', 9)
                useColorMap = 'off';
            else
                useColorMap = 'on';
            end
            setBlockParam(hScope, 'useColorMap', useColorMap);
            setBlockParam(hScope, 'colorMapValue', colorMap);
            setBlockParam(hScope, 'minInputVal', mat2str(getScopeParam(hScope, 'Visuals', 'Video', 'DataRangeMin')));
            setBlockParam(hScope, 'maxInputVal', mat2str(getScopeParam(hScope, 'Visuals', 'Video', 'DataRangeMax')));
            if getScopeParam(hScope, 'Visuals', 'Video', 'UseDataRange')
                specRange = 'on';
            else
                specRange = 'off';
            end
            setBlockParam(hScope, 'specRange', specRange);
        end
        
        function mdlStart(this)
            set(this.Scope.getWidget('Base/Menus/File/Sources/ImageSignal'), ...
                'Enable', 'off');
            set(this.Scope.getWidget('Base/Menus/File/Sources/OpenAtMdlStart'), ...
                'Enable', 'off');
        end
        
        function mdlTerminate(this)
            set(this.Scope.getWidget('Base/Menus/File/Sources/ImageSignal'), ...
                'Enable', 'on');
            set(this.Scope.getWidget('Base/Menus/File/Sources/OpenAtMdlStart'), ...
                'Enable', 'on');
        end
        
        function b = getOpenAtMdlStart(this)
            b = strcmp(this.Block.OpenAtMdlStart, 'on');
        end
        
        function uiInstaller = createGUI(this, ~)
            
            if strcmp(this.Block.imagePorts, 'One multidimensional signal')
                MultiChecked = 'on';
                SeparateChecked = 'off';
            else
                MultiChecked = 'off';
                SeparateChecked = 'on';
            end
            
            if strcmp(get(bdroot(this.Block.Handle), 'SimulationStatus'), 'stopped')
                enabState = 'on';
            else
                enabState = 'off';
            end
            
            hIS = uimgr.uimenugroup('ImageSignal', 1, 'Image Signal');
            hMulti = uimgr.spctogglemenu('OneImagePort', 0, 'One Multi-Dimensional Signal');
            hMulti.setWidgetPropertyDefault(...
                'Checked', MultiChecked, ...
                'Callback', @(h, ev) setBlockParam(this.Scope, 'imagePorts', 'One multidimensional signal'));
            
            hSep = uimgr.spctogglemenu('MultiImagePort', 1, 'Separate Color Signals');
            hSep.setWidgetPropertyDefault(...
                'Checked', SeparateChecked, ...
                'Callback', @(h, ev) setBlockParam(this.Scope, 'imagePorts', 'Separate color signals'));
            
            hIS.add(hMulti);
            hIS.add(hSep);
            hIS.SelectionConstraint = 'SelectOne';
            hIS.Enable = enabState;
            
            hOpen = uimgr.spctogglemenu('OpenAtMdlStart', 0, 'Open at Start of Simulation');
            hOpen.setWidgetPropertyDefault(...
                'Checked', this.Block.OpenAtMdlStart, ...
                'Callback', @(h, ev) toggleOpenAtMdlStart(this));
            hOpen.Enable = enabState;
            
            mapFileLocation = fullfile(docroot, 'toolbox', 'vision', 'vision.map');
            
            mVV = uimgr.uimenu('VideoViewerHelp', 'Video Viewer &Help');
            mVV.Placement = -inf;
            mVV.setWidgetPropertyDefault(...
                'Callback', @(hco,ev) helpview(mapFileLocation, 'vipvideoviewer'));
            
            mVIPBlks = uimgr.uimenu('VIPBlks', '&Computer Vision System Toolbox Help');
            mVIPBlks.setWidgetPropertyDefault(...
                'Callback', @(hco,ev) helpview(mapFileLocation, 'visioninfo'));
            
            mDemo = uimgr.uimenu('VIPBlks Demos', 'Computer Vision System Toolbox &Demos');
            mDemo.setWidgetPropertyDefault(...
                'Callback', @(hco,ev) visiondemos);
            
            % Want the "About" option separated, so we group everything above
            % into a menugroup and leave "About" as a singleton menu
            mAbout = uimgr.uimenu('About', '&About Computer Vision System Toolbox');
            mAbout.setWidgetPropertyDefault(...
                'Callback', @(hco,ev) aboutvipblks);
            
            uiInstaller = uimgr.Installer( { ...
                hIS,     'Base/Menus/File/Sources'; ...
                hOpen,   'Base/Menus/File/Sources'; ...
                mVV      'Base/Menus/Help/Application'; ...
                mVIPBlks 'Base/Menus/Help/Application'; ...
                mDemo    'Base/Menus/Help/Demo'; ...
                mAbout   'Base/Menus/Help/About'});
            
        end
        
        function [mApp, mExample, mAbout] = createHelpMenuItems(~, mHelp)
            mApp(1) = uimenu(mHelp, ...
                'Tag', 'uimgr.uimenu_VideoViewerHelp', ...
                'Label', 'Video Viewer &Help', ...
                'Callback', @(hco,ev) helpview(mapFileLocation, 'vipvideoviewer'));
            
            mApp(2) = uimenu(mHelp, ...
                'Tag', 'uimgr.uimenu_VIPBlks', ...
                'Label', '&Computer Vision System Toolbox Help', ...
                'Callback', @(hco,ev) helpview(mapFileLocation, 'visioninfo'));
            
            mExample = uimenu(mHelp, ...
                'Tag', 'uimgr.uimenu_VIPBlks Demos', ...
                'Label', 'Computer Vision System Toolbox &Demos', ...
                'Callback', @(hco,ev) visiondemos);
            
            % Want the "About" option separated, so we group everything above
            % into a menugroup and leave "About" as a singleton menu
            mAbout = uimenu(mHelp, ...
                'Tag', 'uimgr.uimenu_About', ...
                'Label', '&About Computer Vision System Toolbox', ...
            	'Callback', @(hco,ev) aboutvipblks);
        end
        
        function cfgFile = getConfigurationFile(~)
            cfgFile = 'videoviewer.cfg';
        end
        
        function helpArgs = getHelpArgs(~, key)
            if nargin < 2
                helpArgs = {'vipvideoviewer'};
            else
                
                mapFileLocation = fullfile('$DOCROOT$', 'toolbox', 'vision', 'vision.map');
                
                switch lower(key)
                    case 'colormap'
                        helpArgs = {'uiservices.helpview', mapFileLocation, 'video_viewer_colormap'};
                    case 'overall'
                        helpArgs = {'vipvideoviewer'};
                    otherwise
                        helpArgs = {};
                end
            end
        end
        
        function setScopePosition(this)
            %setScopePosition Set the scope position into the figure.
            
            % If there is no framework, then we cannot set the scope
            % position, simply return.  If we are docked, a warning will
            % occur when we try to set the scope position.
            hFramework = this.Scope.Framework;
            if isempty(hFramework) || ...
                    strcmp(get(hFramework.Parent, 'WindowStyle'), 'docked')
                return;
            end
            
            hBlock = this.Block;
            
            figPosHG = evalin('base', hBlock.FigPos);

            % If we are loading in an old block (pre7b), it will be in HG
            % format already.
            if strcmp(get(hBlock, 'inputType'), 'Obsolete7b')
                figPosHG = togglePositionFormat(figPosHG);
            end
            set(hFramework.Parent, 'Position', figPosHG);
        end
        
        function saveScopePosition(this, figPosHG)
            %saveScopePosition Save the position of the scope into the
            %block.
            
            hBlock = this.Block;
            
            % Set the Figure Position. Convert from FigPos, which is from
            % the northwest corner, to HG position, which is from the
            % southwest corner.
            hBlock.FigPos = mat2str(togglePositionFormat(figPosHG));
        end
        
        function hiddenExts = getHiddenExtensions(~)
            hiddenExts = {'Tools:Measurements', 'Tools:Plot Navigation', 'Visuals:Time Domain'};
        end
        
        function numInputs = getNumInputs(this)
            type = get(this.Block.Handle, 'imagePorts');
            if strcmp(type, 'One multidimensional signal')
                numInputs = 1;
            else
                numInputs = 3;
            end
        end
        
    end
    
    methods(Access = protected)
        
        % cache config params so they are not need to be repeatedly loaded
        function retVal = getDefaultConfigParams(this)
            
            persistent defaultConfigParams;
            
            if isempty(defaultConfigParams) 
                defaultConfigParams = extmgr.ConfigurationSet.createAndLoad(this.getConfigurationFile);
            end
            
            retVal = defaultConfigParams;
        end
    end
    
    methods (Static, Hidden)
        
        function this = loadobj(s)
            this = loadobj@ Simulink.scopes.ScopeBlockSpecification(s);
            if isempty(this.CurrentConfiguration)
                return;
            end
            cfg = this.CurrentConfiguration.findConfig('Core', 'Source UI');
            if isempty(cfg) || isempty(cfg.PropertyDb)
                return;
            end
            prop = cfg.PropertyDb.findProp('ShowPlaybackCmdMode');
            if isempty(prop)
                return;
            end
            prop.Value = false;
        end
    end
end

% -------------------------------------------------------------------------
function toggleOpenAtMdlStart(this)

if strcmp(get(this.Block, 'OpenAtMdlStart'), 'on')
    newValue = 'off';
else
    newValue = 'on';
end

setBlockParam(this.Scope, 'OpenAtMdlStart', newValue);
end

% -------------------------------------------------------------------------
function figPos = togglePositionFormat(figPos)
% Convert between windows and HG positioning.  The same calculation
% reverses itself.

origUnits = get(0, 'units');
set(0, 'units', 'pix');
screenSize = get(0, 'screenSize'); % [left bottom width height] in pixels
set(0,'units', origUnits);   % restore the resolution settings

figPos(2) = screenSize(4) - figPos(2) - 1;
end

% [EOF]
