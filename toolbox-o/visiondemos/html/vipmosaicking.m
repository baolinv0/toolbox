%% Video Mosaicking
% 
% This example shows how to create a mosaic from a video sequence.
% Video mosaicking is the process of stitching video frames together to
% form a comprehensive view of the scene. The resulting mosaic image is a
% compact representation of the video data. The Video Mosaicking block is
% often used in video compression and surveillance applications.
% 
% This example illustrates how to use the Corner Detection block, the Estimate
% Geometric Transformation block, the Projective Transform block, and the
% Compositing block to create a mosaic image from a video sequence. 
%
% Copyright 2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Video Mosaicking model:
close;
open_system('vipmosaicking');

%%
% The Input subsystem loads a video sequence from either a file, or
% generates a synthetic video sequence. The choice is user defined. First,
% the Corner Detection block finds points that are matched between
% successive frames by the Corner Matching subsystem. Then the Estimate
% Geometric Transformation block computes an accurate estimate of the
% transformation matrix. This block uses the RANSAC algorithm to eliminate
% outlier input points, reducing error along the seams of the output mosaic
% image. Finally, the Mosaicking subsystem overlays the current video frame
% onto the output image to generate a mosaic. 

%% Input Subsystem
% The Input subsystem can be configured to load a video sequence from a
% file, or to generate a synthetic video sequence.
%
open_system('vipmosaicking/Input');

%%
% If you choose to use a video sequence from a file, you can reduce
% computation time by processing only some of the video frames.  This is
% done by setting the downsampling rate in the Frame Rate Downsampling
% subsystem.
% 
% If you choose a synthetic video sequence, you can set the speed of
% translation and rotation, output image size and origin, and the level of
% noise. The output of the synthetic video sequence generator mimics the
% images captured by a perspective camera with arbitrary motion over a
% planar surface. 

%% Corner Matching Subsystem
% The subsystem finds corner features in the current video frame in one of
% three methods. The example uses Local intensity comparison (Rosen &
% Drummond), which is the fastest method. The other methods available are
% the Harris corner detection (Harris & Stephens) and the Minimum
% Eigenvalue (Shi & Tomasi).
% 
open_system('vipmosaicking/Corner Matching', 'force');

%%
% The Corner Matching Subsystem finds the number of corners, location, and
% their metric values.  The subsystem then calculates the distances between
% all features in the current frame with those in the previous frame. By
% searching for the minimum distances, the subsystem finds the best
% matching features. 

%% Mosaicking Subsystem
% By accumulating transformation matrices between consecutive video frames,
% the subsystem calculates the transformation matrix between the current
% and the first video frame. The subsystem then overlays the current video
% frame on to the output image. By repeating this process, the subsystem
% generates a mosaic image. 
%
open_system('vipmosaicking/Mosaicking', 'force');

%%
% The subsystem is reset when the video sequence rewinds or when the
% Estimate Geometric Transformation block does not find enough inliers.

%% Video Mosaicking Using Synthetic Video

close_system('vipmosaicking');
open_system('vipmosaicking');
set_param('vipmosaicking/Switch', 'sw', '0');
sim('vipmosaicking',[0 30]);
set(allchild(0), 'visible', 'off');

%%
% The Corners window shows the corner locations in the current video frame.
captureVideoViewerFrame('vipmosaicking/Display/Corners');

%%
% The Mosaic window shows the resulting mosaic image.
captureVideoViewerFrame('vipmosaicking/Display/Mosaic ');

%% Video Mosaicking Using Captured Video

close_system('vipmosaicking', 0);
sim('vipmosaicking',[0 4.666666666666667]);
set(allchild(0), 'Visible','off');

%%
% The Corners window shows the corner locations in the current video frame.
captureVideoViewerFrame('vipmosaicking/Display/Corners');

%%
% The Mosaic window shows the resulting mosaic image.
captureVideoViewerFrame('vipmosaicking/Display/Mosaic ');

%%

close_system('vipmosaicking', 0);
