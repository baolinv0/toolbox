%% Video Focus Assessment
% This example shows how to determine whether video frames are in focus 
% by using the ratio of the high spatial frequency 
% content to the low spatial frequency content within a region of interest 
% (ROI). When this ratio is high, the video is in focus. When this ratio is 
% low, the video is out of focus.

% Copyright 2004-2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Video Focus Assessment model:

open_system('vipfocus');


%% Video Focus Assessment Results
% This example shows a video sequence that is moving in and out of focus. The 
% model uses the Draw Shapes block to highlight an ROI on the video frames 
% and the Insert Text block to indicate whether or not the video is in focus. 
%
% The Relative Focus window displays a plot of the ratio of the high spatial 
% frequency content to the low spatial frequency content within the ROI. 
% This ratio is an indication of the relative focus adjustment of the video 
% camera. When this ratio is high, the video is in focus. When this ratio 
% is low, the video is out of focus. Although it is possible to judge the 
% relative focus of a camera with respect to the video using 2-D 
% filters, the approach used in this example enables you to see the relationship 
% between the high spatial frequency content of the video and its focus.
%
% The FFT Data window shows the 2-D FFT data within the ROI.

close_system('vipfocus');
sim('vipfocus',[0 35]);

set(allchild(0), 'Visible', 'Off');

%%

set(findall(0, 'Type', 'figure', 'Name', sprintf('vipfocus/Relative\nFocus')), 'visible','on');
captureVideoViewerFrame('vipfocus/Focus Metrics/FFT Data');
captureVideoViewerFrame('vipfocus/Original Video  with ROI & text');

close_system('vipfocus');


