%% Evaluating the Accuracy of Single Camera Calibration
% This example shows how to evaluate the accuracy of camera parameters
% estimated using the |cameraCalibrator| app or the
% |estimateCameraParameters| function.
%
%   Copyright 2014 The MathWorks, Inc.

%% Overview
% Camera calibration is the process of estimating parameters of the camera
% using images of a special calibration pattern. The parameters include
% camera intrinsics, distortion coefficients, and camera extrinsics. Once
% you calibrate a camera, there are several ways to evaluate the accuracy
% of the estimated parameters:
%
% * Plot the relative locations of the camera and the calibration pattern
%
% * Calculate the reprojection errors
%
% * Calculate the parameter estimation errors

%% Calibrate the Camera
% Estimate camera parameters using a set of images of a checkerboard
% calibration pattern.

% Create a set of calibration images.
images = imageSet(fullfile(toolboxdir('vision'), 'visiondata', ...
    'calibration', 'fishEye'));
imageFileNames = images.ImageLocation;

% Detect calibration pattern.
[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);

% Generate world coordinates of the corners of the squares.
squareSize = 29; % millimeters
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera.
[params, ~, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints);

%% Extrinsics
% You can quickly discover obvious errors in your calibration by plotting
% relative locations of the camera and the calibration pattern. Use the
% |showExtrinsics| function to either plot the locations of the calibration
% pattern in the camera's coordinate system, or the locations of the camera
% in the pattern's coordinate system. Look for obvious problems, such as
% the pattern being behind the camera, or the camera being behind the
% pattern. Also check if a pattern is too far or too close to the camera.

figure; 
showExtrinsics(params, 'CameraCentric');
figure; 
showExtrinsics(params, 'PatternCentric');

%% Reprojection Errors
% Reprojection errors provide a qualitative measure of accuracy. A
% reprojection error is the distance between a pattern keypoint detected in
% a calibration image, and a corresponding world point projected into the
% same image. The |showReprojectionErrors| function provides a useful
% visualization of the average reprojection error in each calibration
% image. If the overall mean reprojection error is too high, consider excluding
% the images with the highest error and recalibrating.

figure; 
showReprojectionErrors(params);

%% Estimation Errors
% Estimation errors represent the uncertainty of each estimated parameter.
% The |estimateCameraParameters| function optionally returns
% |estimationErrors| output, containing the standard error corresponding to
% each estimated camera parameter.  The returned standard error $\sigma$ 
% (in the same units as the corresponding parameter) can be used to
% calculate confidence intervals.  For example +/- $1.96 \sigma$
% corresponds to the 95% confidence interval. In other words, the
% probability that the actual value of a given parameter is within 
% $1.96 \sigma$ of its estimate is 95%.
displayErrors(estimationErrors, params);

%% Interpreting Principal Point Estimation Error
% The principal point is the optical center of the camera, the point where 
% the optical axis intersects the image plane. You can easily visualize and
% interpret the standard error of the estimated principal point. Plot an 
% ellipse around the estimated principal point $(cx,cy)$, whose radii are 
% equal to 1.96 times the corresponding estimation errors. The ellipse 
% represents the uncertainty region, which contains the actual principal 
% point with 95% probability.

principalPoint = params.PrincipalPoint;
principalPointError = estimationErrors.IntrinsicsErrors.PrincipalPointError;

fig = figure; 
ax = axes('Parent', fig);
imshow(imageFileNames{1}, 'InitialMagnification', 60, 'Parent', ax);
hold(ax, 'on');

% Plot the principal point.
plot(principalPoint(1), principalPoint(2), 'g+', 'Parent', ax);

% Plot the ellipse representing the 95% confidence region.
halfRectSize = 1.96 * principalPointError;
rectangle('Position', [principalPoint-halfRectSize, 2 * halfRectSize], ...
    'Curvature', [1,1], 'EdgeColor', 'green', 'Parent', ax);

legend('Estimated principal point');
title('Principal Point Uncertainty');
hold(ax, 'off');

%% Interpreting Translation Vectors Estimation Errors
% You can also visualize the standard errors of the translation vectors.
% Each translation vector represents the translation from the pattern's
% coordinate system into the camera's coordinate system. Equivalently, each
% translation vector represents the location of the pattern's origin in the
% camera's coordinate system. You can plot the estimation errors of the
% translation vectors as ellipsoids representing uncertainty volumes for
% each pattern's location at 95% confidence level.

% Get translation vectors and corresponding errors.
vectors = params.TranslationVectors;
errors = 1.96 * estimationErrors.ExtrinsicsErrors.TranslationVectorsError;

% Set up the figure.
fig = figure;  
ax = axes('Parent', fig, 'CameraViewAngle', 5, 'CameraUpVector', [0, -1, 0], ...
    'CameraPosition', [-1500, -1000, -6000]);
hold on

% Plot camera location.
plotCamera('Size', 40, 'AxesVisible', true);

% Plot an ellipsoid showing 95% confidence volume of uncertainty of 
% location of each checkerboard origin.
labelOffset = 10; 
for i = 1:params.NumPatterns    
    ellipsoid(vectors(i,1), vectors(i,2), vectors(i,3), ...
        errors(i,1), errors(i,2), errors(i,3), 5)
    
    text(vectors(i,1) + labelOffset, vectors(i,2) + labelOffset, ...
        vectors(i,3) + labelOffset, num2str(i), ...
        'fontsize', 12, 'Color', 'r');
end
colormap('hot');
hold off

% Set view properties.
xlim([-400, 200]); 
zlim([-100, 1100]);

xlabel('X (mm)'); 
ylabel('Y (mm)'); 
zlabel('Z (mm)');

grid on
axis 'equal'
cameratoolbar('Show');
cameratoolbar('SetMode', 'orbit');
cameratoolbar('SetCoordSys', 'Y');
title('Translation Vectors Uncertainty');

%% How to Improve Calibration Accuracy
% Whether or not a particular reprojection or estimation error is
% acceptable depends on the precision requirements of your particular
% application. However, if you have determined that your calibration
% accuracy is unacceptable, there are several ways to improve it:
%
% * Modify calibration settings. Try using 3 radial distortion
%   coefficients, estimating tangential distortion, or the skew.
%
% * Take more calibration images. The pattern in the images must be in
%   different 3D orientations, and it should be positioned such that you have
%   keypoints in all parts of the field of view. In particular, it is very
%   important to have keypoints close to the edges and the corners of the
%   image in order to get a better estimate of the distortion coefficients.
%
% * Exclude images that have high reprojection errors and re-calibrate.

%% Summary
% This example showed how to interpret camera calibration errors.

%% References
% [1] Z. Zhang. A flexible new technique for camera calibration. 
% IEEE Transactions on Pattern Analysis and Machine Intelligence, 
% 22(11):1330-1334, 2000.

displayEndOfDemoMessage(mfilename)
