%% Scene Change Detection
% This example shows how to segment video in time. The algorithm in this 
% example can be used to detect major changes in video streams, such as 
% when a commercial begins and ends. It can be useful when editing video 
% or when you want to skip ahead through certain content.

% Copyright 2004-2006 The MathWorks, Inc.

%% Example Model
% The following figure shows the Scene Change Detection example model:
oldpath = path;
addpath([getenv('LARGE_TEST_DATA_ROOT') filesep 'Computer_Vision_System_Toolbox' filesep 'v000']);

open_system('vipscenechange');
blkName=find_system('vipscenechange','blocktype','Scope');
close_system(blkName{1});

%% Scene Change Detection Results
% The model segments the video using the following steps. First, it finds the
% edges in two consecutive video frames, which makes the algorithm less sensitive
% to small changes. Based on these edges, the model uses the Block Processing
% block to compare sections of the video frames to one another. If the number of
% different sections exceeds a specified threshold, the example determines that the
% scene has changed.

close_system('vipscenechange');
sim('vipscenechange',[0 6]);

% get windows by their names
set(allchild(0), 'Visible','off');

% show the scope first
open_system('vipscenechange/Number of  Changed Block');

%%

captureVideoViewerFrame('vipscenechange/Video output/Key Frame Display/Sequence of the  start frames  of the video shot');
captureVideoViewerFrame('vipscenechange/Video output/Add Text/Original Video');

close_system('vipscenechange');
path(oldpath);
