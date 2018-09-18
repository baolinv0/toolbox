%% Pattern Matching
% This example shows how to use the 2-D normalized cross-correlation for pattern
% matching and target tracking. 
%
% Double-click the Edit Parameters block to select the number of similar 
% targets to detect. You can also change the pyramiding factor. By 
% increasing it, you can match the target template to each video frame more
% quickly. Changing the pyramiding factor might require you to change
% the Threshold value.
% 
% Additionally, you can double-click the Correlation Method switch to specify
% the domain in which to perform the cross-correlation.  The relative size
% of the target to the input video frame and the pyramiding factor determine 
% which domain computation is faster.

% Copyright 2004-2007 The MathWorks, Inc.


%% Example Model
% The following figure shows the Pattern Matching model:

open_system('vippattern');
blkName=find_system('vippattern','blocktype','Scope');
close_system(blkName{1});


%% Pattern Matching Results
% The Match metric window shows the variation of the target match metrics.
% The model determines that the target template is present in a video 
% frame when the match metric exceeds a threshold (cyan line).

close_system('vippattern');
sim('vippattern',[0 4]);

% get windows by their names
set(allchild(0), 'Visible', 'Off');

% show the scope first
open_system('vippattern/Match metric');

%%
% The Cross-correlation window shows the result of cross-correlating the 
% target template with a video frame. Large values in this window correspond
% to the locations of the targets in the input image.

set(findall(0, 'type','figure','name', 'vippattern/Cross-correlation'), 'visible','on');

%%
% The Overlay window shows the locations of the targets by highlighting them
% with rectangular regions of interest (ROIs). These ROIs are present only 
% when the targets are detected in the video frame.

captureVideoViewerFrame('vippattern/Highlight the target/Overlay the ROI on the target');

%%

close_system('vippattern');

