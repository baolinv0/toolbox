%% Tracking Cars Using Optical Flow 
% This example shows how to detect and track cars in a video sequence 
% using optical flow estimation. 

% Copyright 2004-2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Tracking Cars Using Optical Flow
% model:
close
open_system('viptrafficof');

%% 

open_system('viptrafficof');

%% Tracking Cars Using Optical Flow Results
% The model uses an optical flow estimation technique to estimate the 
% motion vectors in each frame of the video sequence. By thresholding and 
% performing morphological closing on the motion vectors, the model produces 
% binary feature images. The model locates the cars in each binary feature 
% image using the Blob Analysis block. Then it uses the Draw Shapes block 
% to draw a green rectangle around the cars that pass beneath the white 
% line. The counter in the upper left corner of the Results window tracks the 
% number of cars in the region of interest. 

close_system('viptrafficof');
sim('viptrafficof',[0 5]);

set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('viptrafficof/Display Results/Original');
captureVideoViewerFrame('viptrafficof/Display Results/Motion Vector');
captureVideoViewerFrame('viptrafficof/Display Results/Threshold');
captureVideoViewerFrame('viptrafficof/Display Results/Results');

close_system('viptrafficof_all');


