classdef disparitySGBMBuildable < coder.ExternalDependency %#codegen
    % disparitySGBMBuildable - encapsulate semi-global block matching
    % algorithm
    
    % Copyright 2012 The MathWorks, Inc.
    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'disparitySGBMBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'disparitySGBM', false); % needNonFreeLib = false              
        end

        %------------------------------------------------------------------
        % write all supported data-type specific function calls      
        function outDisparity = disparitySGBM_compute(image1_u8, image2_u8, opt)        
            
            coder.inline('always');
            coder.cinclude('cvstCG_disparitySGBM.h');
            
            nRows = int32(size(image1_u8, 1)); % original (before transpose)
            nCols = int32(size(image1_u8, 2)); % original (before transpose)
            outSize = [nRows nCols];
            outDisparity = coder.nullcopy(zeros(outSize,'single'));
            
            paramStruct = struct( ...
                'preFilterCap', int32(opt.preFilterCap), ...
                'SADWindowSize', int32(opt.SADWindowSize), ...
                'minDisparity', int32(opt.minDisparity), ...
                'numberOfDisparities', int32(opt.numberOfDisparities), ...
                'uniquenessRatio', int32(opt.uniquenessRatio), ...
                'disp12MaxDiff', int32(opt.disp12MaxDiff), ...
                'speckleWindowSize', int32(opt.speckleWindowSize), ...
                'speckleRange', int32(opt.speckleRange), ...                
                'P1',int32(opt.P1),...
                'P2',int32(opt.P2),...
                'fullDP',int32(opt.fullDP)...
                );   
            
            coder.cstructname(paramStruct,'cvstDSGBMStruct_T');
            
            coder.ceval('disparitySGBM_compute',...
                    coder.ref(image1_u8), ...
                    coder.ref(image2_u8), ...
                    nRows, nCols, ... 
                    coder.ref(outDisparity), ...
                    coder.ref(paramStruct));
            
        end       
    end   
end
