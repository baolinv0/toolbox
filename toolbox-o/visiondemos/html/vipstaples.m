%% Object Counting
% This example shows how to use basic morphological operators to extract 
% information from a video stream. In this case, the model counts the 
% number of staples in each video frame. Note that the focus and lighting
% change in each video frame. 

% Copyright 2004-2007 The MathWorks, Inc.


%% Example Model
% The following figure shows the Object Counting model. 

open_system('vipstaples');

%% Count Staples Subsystem
% The model uses the Top-hat block to remove uneven illumination and the 
% Opening block to widen the gaps between the staples. Due to changes in 
% overall lighting intensity, the model cannot apply a single threshold value 
% to all of the video frames. Instead, it uses the Autothreshold block 
% to compute a threshold for each frame. Once the model applies the threshold 
% to separate the staples, it uses the Blob Analysis block to count the 
% number of staples in each frame and to calculate the centroid of each staple. 
% The model passes the total number of staples in each frame to the Insert Text 
% block in the main model. This block embeds this information on each video frame.

open_system('vipstaples/Count Staples');

%% Mark Staples Subsystem
% The model passes the centroid information to a series of Draw Markers blocks, 
% which mark the centroids of each staple.

open_system('vipstaples/Mark Staples');

%% Object Counting Results
% The Counted window displays one frame of the original video and the 
% segmented staples in that frame. The number of staples is displayed in 
% the lower left corner. 

close_system('vipstaples');
sim('vipstaples',[0 0.1]);

set(allchild(0), 'Visible', 'off');

captureVideoViewerFrame('vipstaples/Counted');

close_system('vipstaples');

