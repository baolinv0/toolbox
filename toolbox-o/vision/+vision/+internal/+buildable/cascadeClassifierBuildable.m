classdef cascadeClassifierBuildable < coder.ExternalDependency %#codegen
    %CASCADECLASSIFIERBUILDABLE - encapsulate cascadeClassifier implementation library
    
    % Copyright 2013 The MathWorks, Inc.    
    
    methods (Static)
        
        function name = getDescriptiveName(~)
            name = 'vision.CascadeObjectDetector';
        end
        
        function b = isSupportedContext(context)
            b = context.isMatlabHostTarget();
        end
        
        function updateBuildInfo(buildInfo, context)
            vision.internal.buildable.opencvBuildInfo(buildInfo, context, ...
                'cascadeClassifier', false); % needNonFreeLib = false              
        end

        %------------------------------------------------------------------
        % write all supported data-type specific function calls       
        function ptrObj = cascadeClassifier_construct()
            
            coder.inline('always');
            coder.cinclude('cvstCG_cascadeClassifier.h');
            
            vision.internal.buildable.errorIfInSimulink('vision.CascadeObjectDetector');

            ptrObj = coder.opaque('void *', 'NULL');
    
            % call function from shared library
            coder.ceval('cascadeClassifier_construct', coder.ref(ptrObj));
        end    
        
        %------------------------------------------------------------------
        % write all supported data-type specific function calls       
        function cascadeClassifier_load(ptrObj, ClassificationModel)
            coder.inline('always');
            % call function from shared library
            coder.ceval('cascadeClassifier_load', ptrObj, coder.ref(ClassificationModel));
        end 
        
        %------------------------------------------------------------------
        % write all supported data-type specific function calls       
        function [originalWindowSize, featureTypeID] = cascadeClassifier_getClassifierInfo(ptrObj)
            coder.inline('always');
            
            originalWindowSize = zeros(1,2,'uint32');
            featureTypeID = uint32(0);
            
            % call function from shared library
            coder.ceval('cascadeClassifier_getClassifierInfo', ptrObj, ...
                coder.ref(originalWindowSize), coder.ref(featureTypeID));
        end 
        
        %------------------------------------------------------------------
        % write all supported data-type specific function calls       
        function bboxes = cascadeClassifier_detectMultiScale(ptrObj, I, ScaleFactor, ...
                MergeThreshold, MinSize, MaxSize)
            
            coder.inline('always');
            coder.varsize('bboxes_', [inf, 4]);
            if isempty(I)
                % no-op
                bboxes = zeros(0,4);
            else
                % call function
                nRows = int32(size(I, 2));
                nCols = int32(size(I, 1));
                ScaleFactor_ = double(ScaleFactor);
                MergeThreshold_ = uint32(MergeThreshold);
                MinSize_ = int32(MinSize);
                MaxSize_ = int32(MaxSize);
                
                ptrDetectedObj = coder.opaque('void *', 'NULL');
                
                num_bboxes = int32(0);
                num_bboxes(:) = coder.ceval('cascadeClassifier_detectMultiScale', ...
                    ptrObj, coder.ref(ptrDetectedObj), ...
                    I, nRows, nCols, ScaleFactor_, ...
                    MergeThreshold_, coder.ref(MinSize_), coder.ref(MaxSize_));
                
                vision.internal.buildable.errorIfInSimulink('vision.CascadeObjectDetector');
                
                coder.varsize('bboxes_', [inf, 4]);
                bboxes_ = coder.nullcopy(zeros(double(num_bboxes),4,'int32'));
                
                % call function from shared library
                coder.ceval('cascadeClassifier_assignOutputDeleteBbox', ...
                    ptrDetectedObj, coder.ref(bboxes_));   
                
                bboxes = double(bboxes_);            
            end
            
        end 

        %------------------------------------------------------------------
        % write all supported data-type specific function calls       
        function cascadeClassifier_deleteObj(ptrObj)
            
            coder.inline('always');
    
            % call function from shared library
            coder.ceval('cascadeClassifier_deleteObj', ptrObj);
        end         
        
    end   
end
