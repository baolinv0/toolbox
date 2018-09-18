classdef opticalFlowLKDoGBuildable < coder.ExternalDependency %#codegen
    % opticalFlowLKDoGBuildable - encapsulate opticalFlowLKDoG implementation library
    
    % Copyright 2012 The MathWorks, Inc.
    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'opticalFlowLKDoGBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.cvstBuildInfo(buildInfo, context, ...
                                          'opticalFlowLKDoGCore', ...
                                          {'NONE'}); %#ok<EMCA>
        end

        %------------------------------------------------------------------
        % write all supported data-type specific function calls      
        function [outVelReal, outVelImag] = ...
                 opticalFlowLKDoG_compute( ...
         			tmpImageA, pDelayBuffer, allIdx, ...
					pGradCC, pGradRC, pGradRR, pGradCT, pGradRT, ...
					NoiseThreshold, ...
					tGradKernel, sGradKernel, tKernel, sKernel, wKernel, ...
                    discardIllConditionedEstimates)
            
            coder.inline('always');
            coder.cinclude('cvstCG_opticalFlowLKDoGCore.h');
    
            % call function
            outVelReal = zeros(size(tmpImageA), 'like', pGradCC);
            outVelImag = zeros(size(tmpImageA), 'like', pGradCC);
            
            pInRows = int32(size(tmpImageA,1));
            pInCols = int32(size(tmpImageA,2));
            numFramesInBuffer = int32(size(pDelayBuffer,3));
            tGradKernelLen = int32(length(tGradKernel));
            sGradKernelLen = int32(length(sGradKernel));
            tKernelLen = int32(length(tKernel));
            sKernelLen = int32(length(sKernel));
            wKernelLen = int32(length(wKernel));
            includeNormalFlow = ~discardIllConditionedEstimates;
            
            fcnName = ['MWCV_OpticalFlow_LKDoG_' class(tmpImageA)];
            coder.ceval(fcnName,...
              coder.ref(tmpImageA), ...
              coder.ref(pDelayBuffer), ...
              coder.ref(allIdx), ...
              numFramesInBuffer, ...
              coder.ref(outVelReal), ...
              coder.ref(outVelImag), ...
			  coder.ref(pGradCC), coder.ref(pGradRC), coder.ref(pGradRR), coder.ref(pGradCT), coder.ref(pGradRT), ...
			  coder.ref(NoiseThreshold), ... %eigTh
              coder.ref(tGradKernel),coder.ref(sGradKernel),coder.ref(tKernel),coder.ref(sKernel), coder.ref(wKernel), ...
              pInRows, pInCols, ...
			  tGradKernelLen, sGradKernelLen, tKernelLen, sKernelLen, wKernelLen, ...
              includeNormalFlow);

        end       
    end   
end
