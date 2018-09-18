%% Rotation Correction
% This example shows how to use the Hough Transform and Polyfit blocks to horizontally align
% text rotating in a video sequence. The techniques illustrated by this example can 
% be used in video stabilization and optical character recognition (OCR).

% Copyright 2004-2006 The MathWorks, Inc.

%% Example Model
% The following figure shows the Rotation Correction example model:

open_system('viphough');

%% Text Alignment Using Hough Transform Subsystem
% The morphological operators in the Smudge text subsystem 
% blur the letters to create a binary image with two distinct lines. 
% You can see the result of this process in the Smudged Video window.
%
% By transforming the binary image into the Hough parameter space, the 
% example determines the theta and rho values of the lines created by the Smudge 
% text subsystem. Once the theta values of the text lines are known,
% the example uses the Rotate block to eliminate the large angular variations.

blk = sprintf('viphough/Text alignment \nusing Hough \ntransform');
open_system(blk);

%% Post-Processing: Text Alignment Using Polynomial Fit Subsystem
% The example uses the Polyfit block, in the slope correction subsystem, and 
% the Rotate block to eliminate small angular variations in the text. The Polyfit block fits a
% straight line to the smudged text. Then the slope correction subsystem calculates the slope of
% the line and its angle of inclination. The Rotate block uses this
% angle to correct for the small rotations.

open_system('viphough/Post-Processing: Text alignment using polynomial fit');

%% Rotation Correction Results
% The Input Video window shows the original video. The Smudged video window
% shows the result of blurring the letters to create a binary image with two 
% distinct lines. In the Hough Matrix window, the x- and y-coordinates of the 
% two dominant yellow dots correspond to the theta and rho values of the 
% text lines, respectively. The Corrected video window shows the result of
% the rotation correction process.

close_system('viphough');
sim('viphough',[0 0.5]);
set(allchild(0), 'Visible', 'off');

captureVideoViewerFrame('viphough/Corrected video/Corrected video');
captureVideoViewerFrame('viphough/Input Video');
captureVideoViewerFrame('viphough/Text alignment  using Hough  transform/Smudged video');
captureVideoViewerFrame('viphough/Text alignment  using Hough  transform/Detect angle  of rotation of the most dominant line/Hough Matrix');

close_system('viphough');
