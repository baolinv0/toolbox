%% Lane Departure Warning System
% This example shows how to detect and track road lane markers in a video sequence and
% notifies the driver if they are moving across a lane. The example
% illustrates how to use the Hough Transform, Hough Lines and Kalman Filter
% blocks to create a line detection and tracking algorithm. The example
% implements this algorithm using the following steps: 1) Detect lane
% markers in the current video frame. 2) Match the current lane markers
% with those detected in the previous video frame. 3) Find the left and
% right lane markers. 4) Issue a warning message if the vehicle moves
% across either of the lane markers.
% 
% To process low quality video sequences, where lane markers might be
% difficult to see or are hidden behind objects, the example waits for a lane
% marker to appear in multiple frames before it considers the marker to be
% valid. The example uses the same process to decide when to begin to ignore a
% lane marker. 
% 
% Note: The example parameters are defined in the model workspace. To access
% the parameters, click View > Model Explorer. Then navigate to 
% Model Workspace under model's name.
%
% <matlab:playbackdemo('vipldws_video','toolbox/vision/web/demos'); Watch the Lane Departure Warning System example>.

% Copyright 2004-2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Lane Departure Warning System example model:

open_system('vipldws');
blkName=find_system('vipldws','blocktype','Scope');
close_system(blkName{1});

%% Lane Detection Subsystem 
% This subsystem uses the 2-D FIR Filter and Autothreshold blocks to detect
% the left boundaries of the lane markers in the current video frame. The
% boundaries of the lane markers resemble straight lines and correspond to
% peak values in the Hough transform matrix. This subsystem uses the Find
% Local Maxima block to determine the Polar coordinate location of the lane
% markers.

open_system('vipldws/Lane Detection');

%% Lane Tracking Subsystem 
% The example saves the previously-detected lanes in a repository and counts
% the number of times each lane is detected. This subsystem matches the
% lanes found in the current video frame with those in the repository. If a
% current lane is similar enough to another lane in the repository, the
% example updates the repository with the lanes' current location. The Kalman
% Filter block predicts the location of each lane in the repository, which
% improves the accuracy of the lane tracking.

open_system('vipldws/Lane Tracking');

%% Departure Warning Subsystem
% This subsystem uses the Hough Lines block to convert the Polar
% coordinates of a line to Cartesian coordinates. The subsystem uses these
% Cartesian coordinates to calculate the distance between the lane markers
% and the center of the video bottom boundary. If this distance is less
% than the threshold value, the example issues a warning. This subsystem also
% determines if the line is yellow or white and whether it is solid or 
% broken.

open_system('vipldws/Departure Warning');

%% Lane Departure Warning System Results 
% The Safety Margin Signals window shows a plot of a safety margin metric. 
% The safety margin metric is determined by the distance between the car 
% and the closest lane marker. When the safety margin metric, shown in 
% yellow, drops below 0, shown in magenta, the car is in lane departure 
% mode otherwise the car is in normal driving mode.

close_system('vipldws', 0);
sim('vipldws',[0 3.233333333333333]);
f = allchild(0);
set(f(1),'visible','off');

blkName=find_system('vipldws','blocktype','Scope');
open_system(blkName{1});

%%
% The Results window shows the left and right lane markers and a warning
% message. The warning message indicates that the vehicle is moving across 
% the right lane marker. The type and color of the lane markers are also 
% shown in this window. In addition to the text message, the Windows(R) 
% version of the example issues an audio warning.

captureVideoViewerFrame('vipldws/Output/Results');

%% Available Example Versions
%
% Floating-point version of this example: <matlab:vipldws vipldws.slx> 
%
% Fixed-point version of this example: <matlab:vipldws_fixpt vipldws_fixpt.slx>  

close_system('vipldws_all', 0);

