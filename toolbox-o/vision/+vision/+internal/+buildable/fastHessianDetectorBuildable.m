classdef fastHessianDetectorBuildable < coder.ExternalDependency %#codegen
    %FASTHESSIANDETECTORBUILDABLE - encapsulate fastHessianDetector implementation library
    
    % Copyright 2013 The MathWorks, Inc.    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'fastHessianDetectorBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'fastHessianDetector', true); % needNonFreeLib = true                      
        end

        %------------------------------------------------------------------
        % write all supported data-type specific function calls       
        function [Location, Scale, Metric, SignOfLaplacian] = fastHessianDetector_uint8(Iu8, ...
                            nRows, nCols, numInDims, ...         
                            nOctaveLayers, nOctaves, hessianThreshold)
            
            coder.inline('always');
            coder.cinclude('cvstCG_fastHessianDetector.h');
            
            vision.internal.buildable.errorIfInSimulink('detectSURFFeatures');
            
            ptrKeypoint = coder.opaque('void *', 'NULL');
    
            % call function
            outNumRows = int32(0);
            outNumRows(1)=coder.ceval('fastHessianDetector_uint8',...
              coder.ref(Iu8), ...
              nRows, nCols, numInDims, ...   
              nOctaveLayers, nOctaves, hessianThreshold, ...
              coder.ref(ptrKeypoint));
            
            % copy output to mxArray
            % step-2: declare output as variable sized so that _mex file can return differet sized output.
            % allocate output
            coder.varsize('Location', [inf, 2]);
            coder.varsize('Scale', [inf, 1]);
            coder.varsize('Metric', [inf, 1]);
            coder.varsize('SignOfLaplacian', [inf, 1]);
            
            % create uninitialized memory
            Location = coder.nullcopy(zeros(double(outNumRows),2,'single'));
            Scale    = coder.nullcopy(zeros(double(outNumRows),1,'single'));
            Metric   = coder.nullcopy(zeros(double(outNumRows),1,'single'));
            SignOfLaplacian = coder.nullcopy(zeros(double(outNumRows),1,'int8'));
            
            
            coder.ceval('fastHessianDetector_keyPoints2field',...
              ptrKeypoint, ...
              coder.ref(Location), coder.ref(Scale), coder.ref(Metric), coder.ref(SignOfLaplacian));
            
            coder.ceval('fastHessianDetector_deleteKeypoint',...
              ptrKeypoint);
        end       
    end   
end
