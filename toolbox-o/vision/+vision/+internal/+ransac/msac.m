function [isFound, bestModelParams] = msac(allPoints, maxNumTrials, ...
                        confidence, maxDistance, sampleSize, fitFunc, ...
                        evalFunc, checkFunc, varargin)
% MSAC M-estimator SAmple Consensus (MSAC) algorithm that is used for point
% cloud model fitting. allPoints must be an M-by-N matrix, where each point
% is a row vector.

% Copyright 2015 The MathWorks, Inc.
%
% References:
% ----------
%   P. H. S. Torr and A. Zisserman, "MLESAC: A New Robust Estimator with
%   Application to Estimating Image Geometry," Computer Vision and Image
%   Understanding, 2000.

threshold = cast(maxDistance, 'like', allPoints);
numPts    = size(allPoints,1);
idxTrial  = 1;
numTrials = int32(maxNumTrials);
maxDis    = cast(threshold * numPts, 'like', allPoints);
bestDis   = maxDis;
bestModelParams = [];

% Create a random stream. It uses a fixed seed for the testing mode and a
% random seed for other mode.
if vision.internal.testEstimateGeometricTransform
    rng('default');
end

maxSkipTrials = maxNumTrials * 10;
skipTrials = 0;
while idxTrial <= numTrials && skipTrials < maxSkipTrials
    % Random selection without replacement
    indices = randperm(numPts, sampleSize);
    
    % Compute a model from samples
    samplePoints = allPoints(indices, :);
    modelParams = fitFunc(samplePoints);
    
    % Validate the model 
    isValidModel = checkFunc(modelParams, varargin{:});
    
    if isValidModel
        % Evaluate model with truncated loss
        dis = evalFunc(modelParams, allPoints);
        dis(dis > threshold) = threshold;
        accDis = sum(dis);

        % Update the best model found so far
        if accDis < bestDis
            bestDis = accDis;
            bestModelParams = modelParams;
            inlierNum = sum(dis < threshold);
            num = vision.internal.ransac.computeLoopNumber(sampleSize, ...
                    confidence, numPts, inlierNum);
            numTrials = min(numTrials, num);
        end
        
        idxTrial = idxTrial + 1;
    else
        skipTrials = skipTrials + 1;
    end   
end

isFound = checkFunc(bestModelParams, varargin{:});

