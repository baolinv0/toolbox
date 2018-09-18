classdef matchFeaturesApproxNN < coder.ExternalDependency %#codegen
    
    % Copyright 2012 The MathWorks, Inc.
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'matchFeatures';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'matchFeatures', false); % needNonFreeLib = false
        end
        
        %------------------------------------------------------------------
        % write all supported data-type specific function calls
        function [indexPairs, matchMetric] = ...
                findApproximateNearestNeighbors(features1, features2, metric)                             
            
            coder.inline('always');
            coder.cinclude('cvstCG_matchFeatures.h');              
            
            M  = cast(size(features1,1),'int32');
            N1 = cast(size(features1,2),'int32');
            N2 = cast(size(features2,2),'int32');
                                         
            % When there is only 1 feature vector in features2 we cannot
            % find 2 nearest neighbors.
            if N2 > 1
                knn = int32(2);
            else
                knn = int32(1);
            end
            
            indexPairs  = coder.nullcopy(zeros(knn, N1, 'int32'));
            
            if strcmpi(metric, 'hamming');
                matchMetric = coder.nullcopy(zeros(knn, N1, 'int32'));
                coder.ceval('findApproximateNearestNeighbors_uint8',...
                    coder.ref(features1), ...
                    coder.ref(features2), ...
                    metric,...
                    N1, N2, M, knn, ...
                    coder.ref(indexPairs),...
                    coder.ref(matchMetric));
            else
                matchMetric = coder.nullcopy(zeros(knn, N1, 'single'));
                coder.ceval('findApproximateNearestNeighbors_real32',...
                    coder.ref(features1), ...
                    coder.ref(features2), ...
                    metric,...
                    N1, N2, M, knn, ...
                    coder.ref(indexPairs),...
                    coder.ref(matchMetric));
            end
        end
    end
end
