%% Color-based Road Tracking
% 
% This example shows how to use color information to detect and track road edges set in
% primarily residential settings where lane markings may not be present.
% The Color-based Tracking example illustrates how to use the Color Space
% Conversion block, the Hough Transform block, and the Kalman Filter block
% to detect and track information using hue and saturation.
%
% Copyright 2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Color-based Tracking model:
close;
open_system('vipunmarkedroad');

%% Algorithm
% The example algorithm performs a search to define the left and right edges
% of a road by analyzing video images for change in color behavior. First a
% search for edge pixels, or a line passing through enough number of color
% pixels, whichever comes first, is initiated from the bottom center of the
% image. The search moves to both the upper left and right corners of the
% image. 
%
hfig = figure;
imshow('vipunmarkedroad_schema.png', 'Border', 'tight');
%
%%
% To process low quality video sequences, where road sides might be
% difficult to see, or are obstructed, the algorithm will wait for multiple
% frames of valid edge information. The example uses the same process to
% decide when to begin to ignore a side.

%% Tracking Results
% The Detection window shows the road sides detected in the current video
% frame.
close(hfig);
close_system('vipunmarkedroad', 0);
sim('vipunmarkedroad',[0 2.6]);

set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('vipunmarkedroad/Display/Detection');

%%
% When no road sides are visible, the Tracking window displays an error
% symbol.
close_system('vipunmarkedroad');
sim('vipunmarkedroad',[0 1.8]);

set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('vipunmarkedroad/Display/Tracking');

%%
% When only one side of the road is visible, the example displays an arrow
% parallel to the road side. The direction of the arrow is toward the upper
% point of intersection between the road side and image boundary.
close_system('vipunmarkedroad');
sim('vipunmarkedroad',[0 2.033333333333333]);

set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('vipunmarkedroad/Display/Tracking');

%%
% When both of the road sides are visible, the example shows an arrow in the
% center of the road in the direction calculated by averaging the
% directions of the left and right sides.
close_system('vipunmarkedroad');
sim('vipunmarkedroad',[0 2.6]);
set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('vipunmarkedroad/Display/Tracking');


%%
close_system('vipunmarkedroad');
