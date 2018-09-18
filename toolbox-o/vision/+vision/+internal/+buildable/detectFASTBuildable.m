classdef detectFASTBuildable < coder.ExternalDependency %#codegen
    % detectFASTBuildable - used by detectFASTFeatures
    
    % Copyright 2012 The MathWorks, Inc.
    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'detectFASTBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'detectFAST', false); % needNonFreeLib = false             
        end

        %------------------------------------------------------------------
        % write all supported data-type specific function calls      
        function [outLocation, outMetric] = detectFAST_uint8(Iu8, minContrast)        
            
            coder.inline('always');
            coder.cinclude('cvstCG_detectFAST.h');
            
            vision.internal.buildable.errorIfInSimulink('detectFASTFeatures');
                        
            ptrKeypoints = coder.opaque('void *', 'NULL');
    
            % call function
            out_numel = int32(0);
            nRows = int32(size(Iu8, 1));
            nCols = int32(size(Iu8, 2));
            isRGB = ~ismatrix(Iu8);
            out_numel(1)=coder.ceval('detectFAST_compute',...
              coder.ref(Iu8), ...
              nRows, nCols, isRGB, ... 
              minContrast, ...
              coder.ref(ptrKeypoints));
            
            % copy output to mxArray
            % declare output as variable sized so that _mex file can return differet sized output.
            % allocate output
            % coder.internal.prefer_const(featureWidth);
            coder.varsize('outLocation',        [inf, 2]);
            coder.varsize('outMetric',          [inf, 1]);
            
            % create uninitialized memory using coder.nullcopy
            outLocation = coder.nullcopy(zeros(out_numel,2,'single'));
            outMetric   = coder.nullcopy(zeros(out_numel,1,'single'));           
            
            coder.ceval('detectFAST_assignOutput',...
              ptrKeypoints, ...
              coder.ref(outLocation), ...
              coder.ref(outMetric));

        end       
    end   
end