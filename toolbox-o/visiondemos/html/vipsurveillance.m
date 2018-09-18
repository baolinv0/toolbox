%% Surveillance Recording
% This example shows how to process surveillance video to select frames that contain motion.
% Security concerns mandate continuous monitoring of important locations 
% using video cameras. To efficiently record, review, and archive this massive 
% amount of data, you can either reduce the video frame size or reduce the 
% total number of video frames you record. This example illustrates the latter approach. 
% In it, motion in the camera's field of view triggers the capture of "interesting" video frames. 
%
% <matlab:playbackdemo('vipsurveillance_video','toolbox/vision/web/demos'); Watch the Surveillance Recording example>.

% Copyright 2004-2007 The MathWorks, Inc.


%% Example Model
% The following figure shows the Surveillance Recording model:

open_system('vipsurveillance');
blkName=find_system('vipsurveillance','blocktype','Scope');
close_system(blkName{1});

%% Motion Energy Subsystem
% The example uses the Template Matching block to detect motion in the 
% video sequence. When the Sum of Absolute Differences (SAD) value of a 
% particular frame exceeds a threshold, the example records this video frame 
% and displays it in the Motion Frames window.

open_system('vipsurveillance/Motion Energy');

%% Surveillance Recording Results
% The Motion Threshold window displays the threshold value in magenta, and 
% plots the SAD values for each frame in yellow. Any time the SAD value 
% exceeds the threshold, the model records the video frame.

close_system('vipsurveillance');
sim('vipsurveillance',[0 8]);

set(allchild(0), 'visible', 'off');

% turn on the scope
blkName=find_system('vipsurveillance','blocktype','Scope');
open_system(blkName{1});

%%
% The Original frames window shows a frame of the original video.

captureVideoViewerFrame('vipsurveillance/Original Frames');

%%
% The Motion frames window shows the last recorded video frame. In this 
% window, the Source frame value steadily increases as the video runs and 
% the Captured frame value indicates the total number of frames recorded 
% by the model.

captureVideoViewerFrame('vipsurveillance/Display results/Motion Frames');

%% Available Example Versions
%
% Floating-point: <matlab:vipsurveillance vipsurveillance.slx> 
%
% Fixed-point: <matlab:vipsurveillance_fixpt vipsurveillance_fixpt.slx>

close_system('vipsurveillance');

