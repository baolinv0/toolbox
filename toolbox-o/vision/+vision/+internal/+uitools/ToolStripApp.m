% ToolStripApp the base class for the toolstrip-based apps
%
%  This is a base class for toolstrip apps. It contains the toolgroup
%  object and the session information.
%
%  ToolStripApp properties:
%    ToolGroup      - the toolpack.desktop.ToolGroup object
%    Session        - the session object, containing the App's data
%    SessionManager - the object that should handle loading and saving of the session
%
%  ToolStripApp methods:
%    removeViewTab - remove the View tab, which is enabled by default
%    addFigure     - add a figure to the app (protected)
%

% Copyright 2014 The MathWorks, Inc.

classdef ToolStripApp < handle
    properties(Access = protected)
        % ToolGroup the toolpack.desktop.ToolGroup object.
        %  This object must be instantiated in the derived class 
        ToolGroup;
        
        % SessionManager object that handles saving/loading of the session
        %  This object must be instantiated in the derived class
        SessionManager;
        
        % Session the object containing the App's data
        %  This object must be instantiated in the derived class
        Session         
    end
    
    methods
        %------------------------------------------------------------------
        function removeViewTab(this)
        % removeViewTab Remove the view tab
        %   removeViewTab(app) removes the view tab from the app. If you do
        %   not call this method, the view tab will be on by default. app
        %   is the ToolStripApp object.
            group = this.ToolGroup.Peer.getWrappedComponent;
            % Group without a View tab (needs to be called before t.open)
            group.putGroupProperty(...
                com.mathworks.widgets.desk.DTGroupProperty.ACCEPT_DEFAULT_VIEW_TAB, ...
                false);
        end
    end
        
    methods(Access=protected)
        %------------------------------------------------------------------
        function addFigure(this, fig)
        % addFigure Add a figure to the app and disable drag-and-drop into it.   
        %  addFigure(app, fig) adds a figure to the app. app is the
        %  ToolStrip app object. fig is the figure handle.
            this.ToolGroup.addFigure(fig);
            this.ToolGroup.getFiguresDropTargetHandler().unregisterInterest(...
                fig);
        end
    end
end