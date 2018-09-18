function [undistortedPoints, reprojectionErrors] = undistortPoints(points, cameraParams)
%undistortPoints Correct point coordinates for lens distortion.
%  undistortedPoints = undistortPoints(points, cameraParams) returns point
%  coordinates corrected for lens distortion. points and undistortedPoints 
%  are M-by-2 matrices of [x,y] coordinates. cameraParams is a 
%  cameraParameters object returned by the estimateCameraParameters function
%  or the cameraCalibrator app. 
%
%  [undistortedPoints, reprojectionErrors] = undistortPoints(...) 
%  additionally returns reprojectionErrors, an M-by-1 vector, used to 
%  evaluate the accuracy of undistorted points. The function computes the 
%  reprojection errors by applying distortion to the undistorted points, 
%  and taking the distances between the result and the corresponding input 
%  points. Reprojection errors are expressed in pixels.
%
%  Class Support
%  -------------
%  points must be a real and nonsparse numeric matrix. undistortedPoints is
%  of class double if points is a double. Otherwise undistortedPoints is of
%  class single. reprojectionErrors are the same class as
%  undistortedPoints.
%
%  Notes
%  -----
%  undistortPoints function uses numeric non-linear least-squares
%  optimization. If the number of points is large, it may be faster to
%  undistort the entire image using the undistortImage function.
%
%  Example - Undistort Checkerboard Points
%  ---------------------------------------
%  % Create an imageSet object containing calibration images
%  images = imageSet(fullfile(toolboxdir('vision'), 'visiondata', ...
%      'calibration', 'fishEye'));
%  imageFileNames = images.ImageLocation;
%
%  % Detect calibration pattern
%  [imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);
%
%  % Generate world coordinates of the corners of the squares
%  squareSize = 29; % in millimeters
%  worldPoints = generateCheckerboardPoints(boardSize, squareSize);
%
%  % Calibrate the camera
%  params = estimateCameraParameters(imagePoints, worldPoints);
%
%  % Load an image and detect the checkerboard points
%  I = images.read(10);
%  points = detectCheckerboardPoints(I);
%
%  % Undistort the points
%  undistortedPoints = undistortPoints(points, params);
%
%  % Undistort the image
%  [J, newOrigin] = undistortImage(I, params, 'OutputView', 'full');
%
%  % Translate undistorted points
%  undistortedPoints = [undistortedPoints(:,1) - newOrigin(1), ...
%                       undistortedPoints(:,2) - newOrigin(2)];
%
%  % Display the results
%  figure; 
%  imshow(I); 
%  hold on;
%  plot(points(:, 1), points(:, 2), 'r*-');
%  title('Detected Points'); 
%  hold off;
%
%  figure; 
%  imshow(J); 
%  hold on;
%  plot(undistortedPoints(:, 1), undistortedPoints(:, 2), 'g*-');
%  title('Undistorted Points'); 
%  hold off;
%
%  See also undistortImage, extrinsics, triangulate, estimateCameraParameters,
%    cameraCalibrator, cameraParameters, imageSet

%   Copyright 2014 The MathWorks, Inc.


validateInputs(points, cameraParams);

if isa(points, 'double')
    outputClass = 'double';
else
    outputClass = 'single';
end

pointsDouble = double(points);

undistortedPointsDouble = undistortPointsImpl(cameraParams, pointsDouble);
undistortedPoints = cast(undistortedPointsDouble, outputClass);

if nargout > 1
    redistortedPoints = distortPoints(cameraParams, undistortedPointsDouble);
    errorsDouble = sqrt(sum((pointsDouble - redistortedPoints).^ 2 , 2));
    reprojectionErrors = cast(errorsDouble, outputClass);
end

%--------------------------------------------------------------------------
function validateInputs(points, cameraParams)
validateattributes(points, {'numeric'}, ...
    {'2d', 'nonsparse', 'real', 'size', [NaN, 2]}, mfilename, 'points');

validateattributes(cameraParams, {'cameraParameters'}, {'scalar'}, ...
    mfilename, 'cameraParams');