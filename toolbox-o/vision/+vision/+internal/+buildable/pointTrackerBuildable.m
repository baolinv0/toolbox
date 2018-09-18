classdef pointTrackerBuildable < coder.ExternalDependency %#codegen
    %pointTrackerBuildable - encapsulate pointTracker implementation library
    
    % Copyright 2013 The MathWorks, Inc.    
    %#ok<*EMCA>
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'pointTrackerBuildable';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'pointTracker', false); % needNonFreeLib = false     
        end

        %------------------------------------------------------------------
        % call shared library function      
        function ptrObj = pointTracker_construct()
            
            coder.inline('always');
            coder.cinclude('cvstCG_pointTracker.h');
            
            ptrObj = coder.opaque('void *', 'NULL');
    
            % call function from shared library
            coder.ceval('pointTracker_construct', coder.ref(ptrObj));
        end    
        
        %------------------------------------------------------------------
        % call shared library function      
        function pointTracker_initialize(ptrObj, params, Iu8_gray, points)
            
            coder.inline('always');            
            
            % call function
            nRows = int32(size(Iu8_gray, 2));
            nCols = int32(size(Iu8_gray, 1)); 
            numPoints = int32(size(points, 1));
            
            % do not use cCast on vector; use ccast only for scalar
            blockH = cCast('int32_T',params.BlockSize(1));
            blockW = cCast('int32_T',params.BlockSize(2));
            blockSize = [blockH blockW];
            paramStruct = struct( ...
                'blockSize', blockSize, ...
                'numPyramidLevels', cCast('int32_T',params.NumPyramidLevels), ...
                'maxIterations', cCast('double',params.MaxIterations), ...
                'epsilon', double(params.Epsilon), ...
                'maxBidirectionalError', double(params.MaxBidirectionalError));   
            
            coder.cstructname(paramStruct,'cvstPTStruct_T');
            
            % call function from shared library
            coder.ceval('pointTracker_initialize', ...
                ptrObj, ...
                coder.ref(Iu8_gray), nRows, nCols, ...
                coder.ref(points), numPoints, ...
                coder.ref(paramStruct)); % pass struct by reference
        end 

        %------------------------------------------------------------------
        % call shared library function      
        function pointTracker_setPoints(ptrObj, points, pointValidity)
            
            coder.inline('always');            
             
            numPoints = int32(size(points, 1));
            
            % call function from shared library
            coder.ceval('pointTracker_setPoints', ...
                ptrObj, ...
                coder.ref(points), numPoints, coder.ref(pointValidity));
        end
        
        %------------------------------------------------------------------
        % call shared library function      
        function [points, pointValidity, scores] = ...
                pointTracker_step(ptrObj, Iu8_gray, num_points)
            
            coder.inline('always');            
            
            % call function
            nRows = int32(size(Iu8_gray, 2));
            nCols = int32(size(Iu8_gray, 1));            
            
            numPoints = int32(num_points);
            
            vision.internal.buildable.errorIfInSimulink('vision.PointTracker');
            
            coder.varsize('points', [inf, 2]);
            coder.varsize('pointValidity', [inf, 1]);
            coder.varsize('scores', [inf, 1]);
            
            points = coder.nullcopy(zeros(double(numPoints),2,'single'));
            pointValidity = coder.nullcopy(false(double(numPoints),1));
            scores = coder.nullcopy(zeros(double(numPoints),1));
            
            % call function from shared library
            % no need to pass numPoints (retrieved from class member)            
            coder.ceval('pointTracker_step', ...
             ptrObj, coder.ref(Iu8_gray), nRows, nCols, ...
             coder.ref(points),coder.ref(pointValidity),coder.ref(scores));
        end 
        
        %------------------------------------------------------------------
        % call shared library function      
        function outFrame = pointTracker_getPreviousFrame(ptrObj, frameSize)
            
            coder.inline('always');            
            
            outFrame = coder.nullcopy(zeros(double(frameSize),'uint8'));
            % call function from shared library
            % no need to pass frameSize (retrieved from class member)
            coder.ceval('pointTracker_getPreviousFrame', ...
                ptrObj, coder.ref(outFrame));
        end
        
        %------------------------------------------------------------------
        % call shared library function      
        function [points, pointValidity] = ...
                pointTracker_getPointsAndValidity(ptrObj, num_points)
            
            coder.inline('always');            
            
            vision.internal.buildable.errorIfInSimulink('vision.PointTracker');
            
            coder.varsize('points', [inf, 1]);
            coder.varsize('pointValidity', [inf, 1]);
            
            numPoints = int32(num_points);
            
            points = coder.nullcopy(zeros(double(numPoints),1,'single'));
            pointValidity = coder.nullcopy(false(double(numPoints),1));
            
            % call function from shared library
            % no need to pass numPoints (retrieved from class member)
            coder.ceval('pointTracker_getPointsAndValidity', ...
                ptrObj, ...
                coder.ref(points), coder.ref(pointValidity));
        end
        
        %------------------------------------------------------------------
        % call shared library function      
        function pointTracker_deleteObj(ptrObj)
            
            coder.inline('always');            
    
            % call function from shared library
            coder.ceval('pointTracker_deleteObj', ptrObj);
        end         
        
    end   
end

function outVal = cCast(outClass, inVal)
outVal = coder.nullcopy(zeros(1,1,outClass));
outVal = coder.ceval(['('   outClass  ')'], inVal);
end
