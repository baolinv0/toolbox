function [alignedFlippedImage, flippedDepthImage] = alignColorToDepth(depthImage, colorImage, depthDevice)
%alignColorToDepth Align Kinect color image to depth image.
%   -----------------------------------------------------------------------
%   The alignColorToDepth will be removed in a future release. 
%   Use the pcfromkinect function with equivalent functionality instead.
%   -----------------------------------------------------------------------
%
%   [alignedFlippedImage, flippedDepthImage] = alignColorToDepth(depthImage, colorImage, depthDevice) 
%   returns an M-by-N-by-3 RGB truecolor image aligned with the M-by-N
%   flippedDepthImage, which is equivalent to fliplr(depthImage).
%   colorImage is an M-by-N-by-3 RGB truecolor image. depthDevice is a
%   videoinput object or an imaq.VideoDevice object.
%     
%   Notes
%   -----
%   - This function requires Image Acquisition Toolbox that supports Kinect
%     for Windows.
%
%   - Since Kinect was designed for gaming, the original images, colorImage
%     and depthImage, from Kinect are mirror images of the scene. 
%     The returned images, alignedFlippedImage and flippedDepthImage, are 
%     corrected to match the actual scene.
%
%   Class Support 
%   ------------- 
%   depthDevice must be a videoinput object or an imaq.VideoDevice object
%   for Kinect's depth device. depthImage must be uint16. colorImage and
%   alignedColorImage are uint8.
%
%   Example: Plot colored point cloud from Kinect for Windows
%   ------- 
%   % Create system objects for the Kinect device
%   colorDevice = imaq.VideoDevice('kinect',1)
%   % Change the returned type of color image from single to uint8
%   colorDevice.ReturnedDataType = 'uint8';
%
%   depthDevice = imaq.VideoDevice('kinect',2)
% 
%   % Warm up the cameras
%   step(colorDevice);
%   step(depthDevice);
%
%   % Grab one frame from the devices. It takes a longer time to execute for
%   % the first time in order to wake up the devices
%   colorImage = step(colorDevice);
%   depthImage = step(depthDevice);
% 
%   % Convert to the point cloud from the depth image
%   xyzPoints = depthToPointCloud(depthImage, depthDevice);
%     
%   % Align the color image with the depth image 
%   alignedFlippedImage = alignColorToDepth(depthImage, colorImage, depthDevice);
%   
%   % Initialize a player to visualize 3-D point cloud data
%   ptCloud = pointCloud(xyzPoints);
%   player = pcplayer(ptCloud.XLimits, ptCloud.YLimits, ptCloud.ZLimits,...
%               'VerticalAxis', 'y', 'VerticalAxisDir', 'down');
%
%   xlabel(player.Axes, 'X (m)');
%   ylabel(player.Axes, 'Y (m)');
%   zlabel(player.Axes, 'Z (m)');
%
%   % Acquire and view 500 frames of live Kinect point cloud data
%   for i = 1:500    
%      colorImage = step(colorDevice);  
%      depthImage = step(depthDevice);
%
%      xyzPoints = depthToPointCloud(depthImage, depthDevice);        
%      alignedFlippedImage = alignColorToDepth(depthImage, colorImage, depthDevice);
%
%      view(player, xyzPoints, alignedFlippedImage);
%   end
%
%   % Release the system objects
%   release(colorDevice);
%   release(depthDevice);
%
% See also pcfromkinect
 
%  Copyright 2013-2015 The MathWorks, Inc.

% validate the class of input
validateattributes(depthImage, {'uint16'}, {'real','nonsparse','2d',...
                                'nonempty'}, mfilename, 'depthImage', 1);

validateattributes(colorImage, {'uint8'}, {'real','nonsparse','nonempty',...
                                'size', [NaN,NaN,3]}, mfilename, 'colorImage', 2);

% validate the resolution of the input
if size(depthImage,1)~=size(colorImage,1)||size(depthImage,2)~=size(colorImage,2)
    error(message('vision:pointcloud:mismatchDepthToColor'));
end

% validate the object class of the video device
if ~isa(depthDevice, 'videoinput') && ~isa(depthDevice, 'imaq.VideoDevice')
    error(message('vision:pointcloud:invalidDepthDevice'));
end

% alignment map contains the corresponding pixel location in color image
% for each pixel in the depth image
alignmentMap = vision.internal.visionKinectDepthToColorMap(depthDevice, depthImage);

X = alignmentMap(:,:,1);
Y = alignmentMap(:,:,2);

% get the valid pixel locations
validIndex = find(X>=1&X<=size(depthImage,2)&Y>=1&Y<=size(depthImage,1));

newIndex = sub2ind(size(depthImage), Y(validIndex), X(validIndex));

% fill in the values for the valid pixel locations
alignedFlippedImage = zeros(size(colorImage), 'like', colorImage);
szImg = numel(depthImage);
alignedFlippedImage(validIndex) = colorImage(newIndex);
alignedFlippedImage(validIndex+szImg) = colorImage(newIndex+szImg);
alignedFlippedImage(validIndex+szImg*2) = colorImage(newIndex+szImg*2);
alignedFlippedImage = fliplr(alignedFlippedImage);

if nargout > 1
    flippedDepthImage = fliplr(depthImage);
end
