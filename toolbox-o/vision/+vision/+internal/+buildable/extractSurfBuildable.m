classdef extractSurfBuildable < coder.ExternalDependency %#codegen
    %CVSTGETAVERAGEBUILDABLE - encapsulate getAverage implementation library
    
    % Copyright 2012 The MathWorks, Inc.
    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'extractSurfBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'extractSurf', false); % needNonFreeLib = false  
        end

        %------------------------------------------------------------------
        % write all supported data-type specific function calls      
        function [outLocation, outScale, outMetric, outSignOfLaplacian, ...
                  outOrientation, outFeatures] = ...
                 extractSurf_uint8(Iu8T, inLocation, inScale, inMetric, ...
                 inSignOfLaplacian, featureWidth, isExtended, isUpright)        
            
            coder.inline('always');
            coder.cinclude('cvstCG_extractSurf.h');
            
            vision.internal.buildable.errorIfInSimulink('extractFeatures with SURF Features');
            
            ptrKeypoints = coder.opaque('void *', 'NULL');
            ptrDescriptors = coder.opaque('void *', 'NULL');
    
            % call function
            out_numel = int32(0);
            numel = int32(size(inLocation, 1));
            nRows = int32(size(Iu8T, 2)); % original (before transpose)
            nCols = int32(size(Iu8T, 1)); % original (before transpose)
            numInDims = int32(ndims(Iu8T));
            out_numel(1)=coder.ceval('extractSurf_compute',...
              coder.ref(Iu8T), ...
              nRows, nCols, numInDims, ...   
              inLocation, inScale, inMetric, inSignOfLaplacian, ...
              numel, isExtended, isUpright, ...
              coder.ref(ptrKeypoints), coder.ref(ptrDescriptors));
            
            % copy output to mxArray
            % declare output as variable sized so that _mex file can return differet sized output.
            % allocate output
            coder.internal.prefer_const(featureWidth);
            coder.varsize('outLocation',        [inf, 2]);
            coder.varsize('outScale',           [inf, 1]);
            coder.varsize('outMetric',          [inf, 1]);
            coder.varsize('outSignOfLaplacian', [inf, 1]);
            coder.varsize('outOrientation',     [inf, 1]);
            coder.varsize('outFeatures',        [inf, 128],[1 1]);
            
            % create uninitialized memory using coder.nullcopy
            outLocation = coder.nullcopy(zeros(out_numel,2,'single'));
            outScale    = coder.nullcopy(zeros(out_numel,1,'single'));
            outMetric   = coder.nullcopy(zeros(out_numel,1,'single'));
            outSignOfLaplacian = coder.nullcopy(zeros(out_numel,1,'int8'));
            outOrientation = coder.nullcopy(zeros(out_numel,1,'single'));
            outFeatures = coder.nullcopy(zeros(out_numel,featureWidth,'single'));            
            
            coder.ceval('extractSurf_assignOutput',...
              ptrKeypoints, ptrDescriptors, ...
              coder.ref(outLocation), coder.ref(outScale), ...
              coder.ref(outMetric), coder.ref(outSignOfLaplacian), ...
              coder.ref(outOrientation), coder.ref(outFeatures));

        end       
    end   
end
