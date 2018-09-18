function camMatrix = cameraMatrix(cameraParams, rotationMatrix, translationVector)
%cameraMatrix Compute camera projection matrix.
%  camMatrix = cameraMatrix(cameraParams, rotationMatrix, translationVector)
%  returns a 4-by-3 camera projection matrix, which projects a 3-D world point
%  in homogeneous coordinates into the image. cameraParams is a
%  cameraParameters object. rotationMatrix is a 3-by-3 rotation matrix and 
%  translationVector is a 3-element translation vector describing the
%  transformation from the world coordinates to the camera coordinates. 
%  You can obtain rotationMatrix and translationVector using the extrinsics
%  function.
%
%  Notes
%  -----
%  The camera matrix is computed as follows:
%  camMatrix = [rotationMatrix; translationVector] * K
%  where K is the intrinsic matrix.
%
%  Class Support
%  -------------
%  cameraParams must be a cameraParameters object. rotationMatrix and
%  translationVector must be numeric arrays of the same class, and must be
%  real and nonsparse. camMatrix is of class double if rotationMatrix and
%  translationVector are double. Otherwise camMatrix is of class single.
%
%  Example
%  -------
%
%  % Load precomputed camera parameters
%  load('sparseReconstructionCameraParameters.mat');
%
%  % Read a pair of images
%  imageDir = fullfile(toolboxdir('vision'), 'visiondata','sparseReconstructionImages');
%  I = imread(fullfile(imageDir, 'Globe01.jpg'));
%
%  % Calculate camera extrinsics
%  squareSize = 22; %millimeters
%  [refPoints, boardSize] = detectCheckerboardPoints(I);
%  worldPoints = generateCheckerboardPoints(boardSize, squareSize);
%  [R, t] = extrinsics(refPoints, worldPoints, cameraParams);
%
%  % Calculate camera matrix
%  P = cameraMatrix(cameraParams, R, t)
%
%  See also extrinsics, triangulate, cameraCalibrator, estimateCameraParameters
%    cameraPose

%#codegen

[K, R, t] = parseInputs(cameraParams, rotationMatrix, translationVector);
camMatrix = [R; t] * K;

%--------------------------------------------------------------------------
function [K, R, t] = parseInputs(cameraParams, rotationMatrix, translationVector)

validateInputs(cameraParams, rotationMatrix, translationVector)

if isa(rotationMatrix, 'double')
    outputClass = 'double';
else
    outputClass = 'single';
end

K = cast(cameraParams.IntrinsicMatrix, outputClass);
R = cast(rotationMatrix, outputClass);
if isrow(translationVector)
    t = cast(translationVector, outputClass);
else
    t = cast(translationVector', outputClass);
end

%--------------------------------------------------------------------------
function validateInputs(cameraParams, rotationMatrix, translationVector)
validateattributes(cameraParams, {'cameraParameters'}, {}, ...
        mfilename, 'cameraParams');
vision.internal.inputValidation.validateRotationMatrix(...
    rotationMatrix, mfilename, 'rotationMatrix');
vision.internal.inputValidation.validateTranslationVector(...
    translationVector, mfilename, 'translationVector');

coder.internal.errorIf(~isequal(class(rotationMatrix), class(translationVector)),...
    'vision:calibrate:RandTClassMismatch');
