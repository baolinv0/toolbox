classdef (Hidden) VideoPlayerScopeCfg < matlabshared.scopes.SystemObjectScopeSpecification & scopeextensions.MPlayScopeCfg
    %VideoPlayerScopeCfg   Define the VideoPlayerScopeCfg class.
    
    %   Copyright 2009-2011 The MathWorks, Inc.
    
    methods      
      function this = VideoPlayerScopeCfg(varargin)
         % Prevent clear classes warnings
         mlock;
         this@matlabshared.scopes.SystemObjectScopeSpecification(varargin{:});
      end
      
      function appName = getScopeTag(~)
        appName = 'Video Player';
      end
      
      function configurationFile = getConfigurationFile(~)
        configurationFile = 'videoplayer.cfg';
      end
      
      function hiddenExts = getHiddenExtensions(~)
        hiddenExts = {'Tools:Instrumentation Sets', 'Tools:Measurements', ...
          'Tools:Plot Navigation', 'Visuals:Time Domain'};
      end
            
      function helpMenus = getHelpMenus(this, hUI) %#ok
        mapFileLocation = fullfile(docroot,'toolbox','vision','vision.map');
        
        mVideoPlayer = uimgr.uimenu('vision.VideoPlayer', 'vision.VideoPlayer &Help');
        mVideoPlayer.Placement = -inf;
        mVideoPlayer.setWidgetPropertyDefault(...
          'Callback', @(hco,ev) helpview(mapFileLocation, 'scvideoplayer'));
        
        mVIPBlks = uimgr.uimenu('VIPBlks', ...
          '&Computer Vision System Toolbox Help');
        mVIPBlks.setWidgetPropertyDefault(...
          'Callback', @(hco,ev) helpview(mapFileLocation, 'visioninfo'));
        
        mDemo = uimgr.uimenu('VIPBlks Demos', ...
          'Computer Vision System Toolbox &Demos');
        mDemo.setWidgetPropertyDefault(...
            'Callback', @(hco,ev) visiondemos);
        
        % Want the "About" option separated, so we group everything above
        % into a menugroup and leave "About" as a singleton menu
        mAbout = uimgr.uimenu('About', ...
          '&About Computer Vision System Toolbox');
        mAbout.setWidgetPropertyDefault(...
          'Callback', @(hco,ev)aboutvipblks);
        
        helpMenus = uimgr.Installer( { ...
          mVideoPlayer 'Base/Menus/Help/Application'; ...
          mVIPBlks 'Base/Menus/Help/Application'; ...
          mDemo 'Base/Menus/Help/Demo'; ...
          mAbout 'Base/Menus/Help/About'});
      end
      
      function [mApp, mExample, mAbout] = createHelpMenuItems(~, mHelp)
        mapFileLocation = fullfile(docroot,'toolbox','vision','vision.map');
        
        mApp(1) = uimenu(mHelp, ...
          'Tag', 'uimgr.uimenu_vision.VideoPlayer', ...
          'Label', 'vision.VideoPlayer &Help', ...
          'Callback', @(hco,ev) helpview(mapFileLocation, 'scvideoplayer'));
        
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
          'Callback', @(hco,ev)aboutvipblks);
      end
      function b = shouldShowControls(this, id)
          if strcmp(id, 'Snapshot')
              % Default setting is to hide the snapshot action on the
              % system object scope.
              b = true;
          else
              b = shouldShowControls@matlabshared.scopes.SystemObjectScopeSpecification(this, id);
          end
      end
    end
end

% [EOF]
