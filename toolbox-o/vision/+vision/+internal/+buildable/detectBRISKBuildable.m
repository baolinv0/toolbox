classdef detectBRISKBuildable < coder.ExternalDependency %#codegen
   
    % Copyright 2012 The MathWorks, Inc.
        
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'detectBRISKFeatures';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'detectBRISK', false); % needNonFreeLib = false
        end
        
        %------------------------------------------------------------------
        % write all supported data-type specific function calls        
        function points = detectBRISK(Iu8, threshold, numOctaves)
            
            coder.inline('always');
            coder.cinclude('cvstCG_detectBRISK.h');
                        
            vision.internal.buildable.errorIfInSimulink('detectBRISKFeatures');
            
            ptrKeypoints = coder.opaque('void *', 'NULL');
    
            % call function
            numOut = int32(0);
            
            nRows = int32(size(Iu8,1));
            nCols = int32(size(Iu8,2));

            %> Detect BRISK Features
            numOut(1) = coder.ceval('detectBRISK_detect',...
                coder.ref(Iu8), ...
                nRows, nCols,...
                threshold, numOctaves,...
                coder.ref(ptrKeypoints));            
            
            coder.varsize('location',[inf 2]);
            coder.varsize('metric',[inf 1]);
            coder.varsize('scale',[inf 1]);
            coder.varsize('orientation',[inf 1]);
            
            location = coder.nullcopy(zeros(numOut,2,'single'));
            metric   = coder.nullcopy(zeros(numOut,1,'single'));
            scale    = coder.nullcopy(zeros(numOut,1,'single'));
            orientation = coder.nullcopy(zeros(numOut,1,'single'));
            
            %> Copy detected BRISK Features to output
            coder.ceval('detectBRISK_assignOutputs', ptrKeypoints, ...
                coder.ref(location),...
                coder.ref(metric),...
                coder.ref(scale),...
                coder.ref(orientation));    
                                  
            points.Location = location;
            points.Metric   = metric;
            points.Scale    = scale;
            points.Orientation = orientation;                      

        end       
    end   
end