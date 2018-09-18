classdef detectMserBuildable < coder.ExternalDependency %#codegen
    % detectMserBuildable - used by detectMserFeatures
    
    % Copyright 2012 The MathWorks, Inc.
    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'detectMserBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'detectMser', false); % needNonFreeLib = false
        end
        
        %------------------------------------------------------------------
        % write all supported data-type specific function calls
        function [outPixelList, outLengts] = detectMser_uint8(Iu8, params)
            
            coder.inline('always');
            coder.cinclude('cvstCG_detectMser.h');
            
            vision.internal.buildable.errorIfInSimulink('detectMSERFeatures');
            
            ptrRegions = coder.opaque('void *', 'NULL');
            
            % call function
            numTotalPts = int32(0);
            numRegions = int32(0);
            nRows = int32(size(Iu8, 1));
            nCols = int32(size(Iu8, 2));
            isRGB = ~ismatrix(Iu8);
            
            if isempty(Iu8)                
                outPixelList = zeros(numTotalPts,2,'int32');
                outLengts    = zeros(numRegions,1,'int32');
            else
                coder.ceval('detectMser_compute',...
                    coder.ref(Iu8), ...
                    nRows, nCols, isRGB, ...
                    params.delta, ... % int
                    params.minArea, ... % int
                    params.maxArea, ... % int
                    params.maxVariation, ... % float
                    params.minDiversity, ... % float
                    params.maxEvolution, ... % int
                    params.areaThreshold, ... % double
                    params.minMargin, ... % double
                    params.edgeBlurSize, ... % int
                    coder.ref(numTotalPts), ...
                    coder.ref(numRegions), ...
                    coder.ref(ptrRegions));
                
                % copy output to mxArray
                % declare output as variable sized so that _mex file can return differet sized output.
                % allocate output
                % coder.internal.prefer_const(featureWidth);
                coder.varsize('outPixelList', [inf, 2]);
                coder.varsize('outLengts',    [inf, 1]);
                
                % create uninitialized memory using coder.nullcopy
                outPixelList = coder.nullcopy(zeros(numTotalPts,2,'int32'));
                outLengts    = coder.nullcopy(zeros(numRegions,1,'int32'));
                
                coder.ceval('detectMser_assignOutput',...
                    ptrRegions, ...
                    numTotalPts, ...
                    coder.ref(outPixelList), ...
                    coder.ref(outLengts));            
            end
            
        end
    end
end