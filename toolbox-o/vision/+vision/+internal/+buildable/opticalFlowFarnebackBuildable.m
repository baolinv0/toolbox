classdef opticalFlowFarnebackBuildable < coder.ExternalDependency %#codegen
    % opticalFlowFarnebackBuildable - encapsulate opticalFlowFarneback
    % implementation library
    
    % Copyright 2012 The MathWorks, Inc.
    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'opticalFlowFarnebackBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.cvstBuildInfo(buildInfo, context, ...
                                          'opticalFlowFarneback', ...
                                          {'NONE'}); %#ok<EMCA>
        end

        %------------------------------------------------------------------
        function outFlowXY = opticalFlowFarneback_compute( ...
         			ImagePrev, ImageCurr, inFlowXY, params)        
            
            coder.inline('always');
            coder.cinclude('cvstCG_opticalFlowFarneback.h');
    
            % allocate output    
            nRows = size(ImagePrev, 2);
            nCols = size(ImagePrev, 1);
            
            outSize = [nRows nCols*2];
            outFlowXY = coder.nullcopy(zeros(outSize,'single'));
            
            paramStruct = struct( ...
                'pyr_scale', double(params.pyr_scale), ...
                'poly_sigma',double(params.poly_sigma), ...
                'levels',    int32(params.levels), ...
                'winsize',   int32(params.winsize), ...
                'iterations',int32(params.iterations), ...
                'poly_n',    int32(params.poly_n), ...
                'flags',     int32(params.flags));   
            
            coder.cstructname(paramStruct,'cvstFarnebackStruct_T');
            
            fcnName = 'opticalFlowFarneback_compute';
            coder.ceval(fcnName,...
              coder.ref(ImagePrev), ...
              coder.ref(ImageCurr), ...
              coder.ref(inFlowXY), ...
              coder.ref(outFlowXY), ...
              coder.ref(paramStruct), ...
                    int32(nRows), ...
                    int32(nCols) ...
                  );
        end       
    end   
end