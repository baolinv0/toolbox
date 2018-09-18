%% Video Stabilization
% This example shows how to remove the 
% effect of camera motion from a video stream. In the first video frame, 
% the model defines the target to track. In this case, it is the back of a 
% car and the license plate. It also establishes a dynamic search region, 
% whose position is determined by the last known target location. The model 
% only searches for the target within this search region, which reduces the 
% number of computations required to find the target. In each subsequent 
% video frame, the model determines how much the target has moved relative 
% to the previous frame. It uses this information to remove unwanted 
% translational camera motions and generate a stabilized video.


% Copyright 2004-2007 The MathWorks, Inc.


%% Example Model
% The following figure shows the Video Stabilization model:

open_system('vipstabilize');


%% Estimate Motion Subsystem
% The model uses the Template Matching block to move the target over the
% search region and compute the Sum of Absolute Differences (SAD) at each 
% location. The location with the lowest SAD value corresponds to the location 
% of the target in the video frame. Based on the location information, the 
% model computes the displacement vector between the target and its original location.  
% The Translate block in the Stabilization subsystem uses this vector to shift 
% each frame so that the camera motion is removed from the video stream.


open_system('vipstabilize/Stabilization/Estimate Motion');

%% Display Results Subsystem
% The model uses the Resize, Compositing, and Insert Text blocks to embed the 
% enlarged target and its displacement vector on the original video.

open_system('vipstabilize/Display Results');

%% Video Stabilization Results
% The figure on the left shows the original video. The figure 
% on the right shows the stabilized video. 

close_system('vipstabilize');
sim('vipstabilize',[0 1/30]);
set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('vipstabilize/Display Results/Results');


%% Available Example Versions
%
% Floating-point version of this example: <matlab:vipstabilize vipstabilize.slx> 
%
% Fixed-point version of this example: <matlab:vipstabilize_fixpt vipstabilize_fixpt.slx> 
%
% Fixed-point version of this example that simulates row major data organization: <matlab:vipstabilize_fixpt_rowmajor vipstabilize_fixpt_rowmajor.slx> 

close_system('vipstabilize_all');

