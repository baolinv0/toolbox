% ABSTRACTTAB  Ancestor of all tabs available in Camera Calibrator
%
%    This class is simply a part of the tool-strip infrastructure.

% Copyright 2011 The MathWorks, Inc.

classdef AbstractTab < handle
    
    properties(Access = private)
        Parent
        ToolTab
    end
    
    %----------------------------------------------------------------------
    methods
        % Constructor
        function this = AbstractTab(tool,tabname,title)
            this.Parent = tool;
            this.ToolTab = toolpack.desktop.ToolTab(tabname,title);
        end
        % getToolTab
        function tooltab = getToolTab(this)
            tooltab = this.ToolTab;
        end
    end
    
    %----------------------------------------------------------------------
    % Abstract methods that each subclass should implement
    methods (Abstract = true)
        testers = getTesters(this) % Get the testers for the tab
    end
    
    %----------------------------------------------------------------------
    methods (Access = protected)
        % getParent
        function parent = getParent(this)
            parent = this.Parent;
        end
    end
    
    methods(Static)
        %--------------------------------------------------------------------------
        function section = createSection(nameId, tag)
            section = toolpack.desktop.ToolSection(tag, getString(message(nameId)));
        end
        
        %--------------------------------------------------------------------------
        % Sets tool tip text for labels, buttons, and other components
        %--------------------------------------------------------------------------
        function setToolTipText(component, toolTipID)
            component.Peer.setToolTipText(...
                vision.getMessage(toolTipID));
        end
            
        %--------------------------------------------------------------------------
        function toggleButton = createToggleButton( icon, titleID, name, orientation)
            toggleButton = toolpack.component.TSToggleButton(...
                vision.getMessage(titleID), icon);
            toggleButton.Name = name;
            switch orientation
                case 'horizontal'
                    toggleButton.Orientation = toolpack.component.ButtonOrientation.HORIZONTAL;
                case 'vertical'
                    toggleButton.Orientation = toolpack.component.ButtonOrientation.VERTICAL;
            end
        end
    end
    
end
