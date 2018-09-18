% Session holds the state of the Training Data Labeler App
%
%   This class holds the entire state of the training data labeler UI.
%   It is used to save and load the labeling session. It is also
%   used to pass data amongst other classes.

% Copyright 2012-2013 The MathWorks, Inc.


classdef Session < handle
    
    properties
        
        IsChanged;             % true when session may need saving

        FileName;              % filename of the stored session
        ExportVariableName;    % default export variable name
        CanExport;             % check whether session is ready to export            
        
        ImageSet;              % Property that will hold a class describing the entire image set        
    end
    
    properties(Access=private, Hidden)
        
        Version = ver('vision');
        
    end
    
    methods
        
        %------------------------------------------------------------------
        % Constructor
        %----------------------------------------------------------------
        
        function this = Session()                        
            this.ImageSet = vision.internal.cascadeTrainer.tool.ImageSet;
            this.reset();
        end
        
        
        %------------------------------------------------------------------
        % Returns true if the session already has images else returns false
        %------------------------------------------------------------------
        
        function ret = hasAnyImages(this)
            
            ret = ~isempty(this.ImageSet.ImageStruct);
            
        end
        
        
        %------------------------------------------------------------------
        function reset(this)
            
            this.IsChanged          = false;
            this.FileName           = '';
            this.ExportVariableName = 'positiveInstances';
            this.CanExport          = false;

            this.ImageSet.reset();            
        end
        
        %------------------------------------------------------------------
        function checkImagePaths(this, pathname, filename)
            this.ImageSet.checkImagePaths(pathname, filename);
        end
        
    end
    
    %----------------------------------------------------------------------
    % saveobj and loadobj are implemented to ensure compatibility across
    % releases even if architecture of Session class changes
    %----------------------------------------------------------------------
    methods (Hidden)
        
        function thisOut = saveobj(this)
            thisOut = this;
        end
        
    end
    %======================================================================
    
    methods (Static, Hidden)
        
        function thisOut = loadobj(this)
            thisOut = this;
        end
        
    end
    %======================================================================
    
end
