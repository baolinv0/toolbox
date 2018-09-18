%% Edge Detection Using Live Video Acquisition
% This example shows how to use the From Video Device block provided by Image Acquisition Toolbox(TM) 
% to acquire live image data from a Hamamatsu C8484 camera into 
% Simulink(R).  The Prewitt method is applied to find the edges of objects in 
% the input video stream. 
%
% Image Acquisition Toolbox provides functions for acquiring images
% and video directly into MATLAB(R) and Simulink from PC-compatible
% imaging hardware. You can detect hardware automatically, configure
% hardware properties, preview an acquisition, and acquire images and
% video. 
%
% This example requires Image Acquisition Toolbox and Hamamatsu image acquisition 
% device (C8484) to run the model. 

%%
%
% <matlab:playbackdemo('vipliveedgedetection_video','toolbox/vision/web/demos'); Watch
% edge detection using live video acquisition>. (4 seconds)
%
%

%%

% Copyright 2007 The MathWorks, Inc.


%% Example Model
% The following figure shows the example model using the From Video Device
% block.
%
open_system('vipliveedgedetection_win');

%%
%
close_system('vipliveedgedetection_win');

%% Live Video Input
% The example acquires the input video live from a Hamamatsu image acquisition device
% (C8484). In this example, the block acquires intensity data from the 
% camera and outputs it into the Simulink model at every simulation time 
% step. 

%% Edge Detection Analysis
% This example uses Computer Vision System Toolbox(TM) to find the edges 
% of objects in the video input. When you run the model, you can 
% double-click the Edge Detection block and adjust the threshold 
% parameter while the simulation is running. The higher you make the
% threshold, the smaller the amount of edges the example finds in the video
% stream.
%
% <<vipliveedgedetection_outputs.png>>
%

%%
% Even though a Hamamatsu camera was used for this example, you can update 
% this model to use other supported image acquisition devices. This 
% enables you to use the same Simulink model with different image 
% acquisition hardware.
