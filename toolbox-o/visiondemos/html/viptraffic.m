%% Tracking Cars Using Foreground Detection
% This example shows how to detect and count cars in a video sequence using
% Gaussian mixture models (GMMs).

% Copyright 2004-2014 The MathWorks, Inc.

%% Example Model
% The following figure shows the Tracking Cars Using Foreground Detection
% model:
close
open_system('viptraffic');

%% 

open_system('viptraffic');

%% Detection and Tracking Results
% Detecting and counting cars can be used to analyze traffic patterns.
% Detection is also a first step prior to performing more sophisticated
% tasks such as tracking or categorization of vehicles by their type.
%
% This example uses the |vision.ForegroundDetector| to estimate the
% foreground pixels of the video sequence captured from a stationary
% camera. The |vision.ForegroundDetector| estimates the background using
% Gaussian Mixture Models and produces a foreground mask highlighting
% foreground objects; in this case, moving cars.
%
% The foreground mask is then analyzed using the Blob Analysis block, which
% produces bounding boxes around the cars. Finally, the number of cars and
% the bounding boxes are drawn into the original video to display the final
% results.

%% Tracking Results

close_system('viptraffic');
sim('viptraffic',[0 5]);
set(allchild(0), 'Visible', 'off');

captureVideoViewerFrame('viptraffic/Display Results/Detected Foreground');
captureVideoViewerFrame('viptraffic/Display Results/Results');

close_system('viptraffic');


