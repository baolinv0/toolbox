%% Traffic Warning Sign Recognition 
% This example shows how to recognize traffic warning signs, such as Stop, 
% Do Not Enter, and Yield, in a color video sequence.
%
% <matlab:playbackdemo('vipwarningsigns_video','toolbox/vision/web/demos'); Watch the Traffic Warning Sign Recognition example>.

% Copyright 2004-2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Traffic Warning Sign Recognition model:
oldpath = path;
addpath([getenv('LARGE_TEST_DATA_ROOT') filesep 'Computer_Vision_System_Toolbox' filesep 'v000']);
close
open_system('vipwarningsigns');

sim('vipwarningsigns',[0 9.4999905]);
set(allchild(0), 'Visible', 'off');

%% Traffic Warning Sign Templates
% The example uses two set of templates - one for detection and the other for
% recognition. 
% 
% To save computation, the detection templates are low resolution, and the
% example uses one detection template per sign. Also, because the red pixels
% are the distinguishing feature of the traffic warning signs, the example
% uses these pixels in the detection step. 
% 
% For the recognition step, accuracy is the highest priority. So, the example
% uses three high resolution templates for each sign. Each of these
% templates shows the sign in a slightly different orientation.  Also,
% because the white pixels are the key to recognizing each traffic warning
% sign, the example uses these pixels in the recognition step.

%%
% The Detection Templates window shows the traffic warning sign detection 
% templates.
captureVideoViewerFrame('vipwarningsigns/Display/Detection Templates', 3.6);

%%
% The Recognition Templates window shows the traffic warning sign 
% recognition templates.
captureVideoViewerFrame('vipwarningsigns/Display/Recognition Templates');

%%
% The templates were generated using vipwarningsigns_templates.m and were
% stored in vipwarningsigns_templates.mat.

%% Detection
% The example analyzes each video frame in the YCbCr color space. By
% thresholding and performing morphological operations on the Cr channel,
% the example extracts the portions of the video frame that contain blobs of
% red pixels. Using the Blob Analysis block, the example finds the pixels and
% bounding box for each blob. The example then compares the blob with each
% warning sign detection template. If a blob is similar to any of the
% traffic warning sign detection templates, it is a potential traffic
% warning sign.
open_system('vipwarningsigns/Detection');

%% Tracking and Recognition
% The example compares the bounding boxes of the potential traffic warning
% signs in the current video frame with those in the previous frame. Then
% the example counts the number of appearances of each potential traffic
% warning sign. 
% 
% If a potential sign is detected in 4 contiguous video frames, the example
% compares it to the traffic warning sign recognition templates. If the
% potential traffic warning sign is similar enough to a traffic warning
% sign recognition template in 3 contiguous frames, the example considers the
% potential traffic warning sign to be an actual traffic warning sign.
% 
% When the example has recognized a sign, it continues to track it. However,
% to save computation, it no longer continues to recognize it.

%% Display
% After a potential sign has been detected in 4 or more video frames, the
% example uses the Draw Shape block to draw a yellow rectangle around it. When
% a sign has been recognized, the example uses the Insert Text block to write
% the name of the sign on the video stream. The example uses the term 'Tag' to
% indicate the order in which the sign is detected.

%% Traffic Warning Sign Recognition Results
captureVideoViewerFrame('vipwarningsigns/Display/Results');

%%
close_system('vipwarningsigns');
path(oldpath);
