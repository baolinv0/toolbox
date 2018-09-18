function [xyzPoints, flippedDepthImage] = depthToPointCloud(depthImage, depthDevice)
%depthToPointCloud Convert Kinect depth image to a 3-D point cloud.
%   -----------------------------------------------------------------------
%   The depthToPointCloud will be removed in a future release. 
%   Use the pcfromkinect function with equivalent functionality instead.
%   -----------------------------------------------------------------------
%
%   [xyzPoints, flippedDepthImage] = depthToPointCloud(depthImage, depthDevice) 
%   returns an M-by-N-by-3 matrix of 3-D points in meters and an M-by-N
%   depth image flippedDepthImage, which is equivalent to fliplr(depthImage). 
%   depthDevice is a videoinput object or an imaq.VideoDevice object
%   configured for Kinect for Windows. depthImage is an M-by-N depth image
%   returned by Kinect.
%
%   Notes
%   -----
%   - This function requires Image Acquisition Toolbox that supports Kinect
%     for Windows.
%
%   - The origin of a right-handed world coordinate system is at the center
%     of the depth camera. The X axis of the coordinate system is pointing 
%     to the right, Y axis is pointing downward, and the Z axis is pointing
%     away from the camera. 
%
%   - Since Kinect depth camera has limited range, some pixels in depth
%     image do not have corresponding 3-D coordinates. The values for those
%     pixels are set to NaN in xyzPoints.
%
%   - Since Kinect was designed for gaming, the original image, depthImage,
%     from Kinect is a mirror image of the scene. The returned image, 
%     flippedDepthImage, is corrected to match the actual scene.
%
%   Class Support 
%   ------------- 
%   depthDevice must be a videoinput object or an imaq.VideoDevice object for
%   Kinect's depth device. depthImage must be uint16. xyzPoints is single.
%
%   Example: Plot point cloud from Kinect for Windows
%   ------- 
%   % Create system object for the Kinect device
%   depthDevice = imaq.VideoDevice('kinect',2)
%
%   % Warm up the cameras
%   step(depthDevice);
%
%   % Grab one frame from the devices. It takes a longer time to execute for
%   % the first time in order to wake up the devices
%   depthImage = step(depthDevice);
% 
%   % Convert to the point cloud from the depth image
%   xyzPoints = depthToPointCloud(depthImage, depthDevice);
%     
%   % Render the point cloud with false color. The axis is set to better
%   % visualize the point cloud
%   pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
%   xlabel('X (m)');
%   ylabel('Y (m)');
%   zlabel('Z (m)');
%
%   % Release the system objects
%   release(depthDevice);
%
% See also pcfromkinect
 
%  Copyright 2013-2015 The MathWorks, Inc.

% validate the class of input
validateattributes(depthImage, {'uint16'}, {'real','nonsparse','2d',...
    'nonempty'}, mfilename, 'depthImage', 1);

if ~isa(depthDevice, 'videoinput') && ~isa(depthDevice, 'imaq.VideoDevice')
    error(message('vision:pointcloud:invalidDepthDevice'));
end

xyzPoints = vision.internal.visionKinectDepthToSkeleton(depthDevice, depthImage);
invalidIndex = find(depthImage(:)==0);
szImg = numel(depthImage);
xyzPoints(invalidIndex) = NaN;
xyzPoints(invalidIndex+szImg) = NaN;
xyzPoints(invalidIndex+szImg*2) = NaN;

% flip along X and Y axis
xyzPoints = fliplr(xyzPoints);
xyzPoints(:,:,1) = -xyzPoints(:,:,1);
xyzPoints(:,:,2) = -xyzPoints(:,:,2);

if nargout > 1
    flippedDepthImage = fliplr(depthImage);
end