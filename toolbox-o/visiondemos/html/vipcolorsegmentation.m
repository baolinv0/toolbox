%% Tracking Based on Color
% This example shows how to track a person's face and hand using a color-based segmentation
% method.

% Copyright 2004-2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Color Segmentation example model:
close;
open_system('vipcolorsegmentation');

%% Color Segmentation Results
% To create an accurate color model for the example, many images containing
% skin color samples were processed to compute the mean (m) and covariance (C) of
% the Cb and Cr color channels. Using this color model, the Color
% Segmentation/Color Classifier subsystem classifies each pixel as either skin or
% nonskin by computing the square of the Mahalanobis distance and comparing it
% to a threshold. The equation for the Mahalanobis distance is shown below:
%
% SquaredDistance(Cb,Cr) = (x-m)'*inv(C)*(x-m), where x=[Cb; Cr]
%
% The result of this process is binary image, where pixel values equal to 1
% indicate potential skin color locations.
%
% The Color Segmentation/Filtering subsystem filters and performs
% morphological operations on each binary image, which creates the refined binary
% images shown in the Skin Region window.
%
% The Color Segmentation/Region Filtering subsystem uses the Blob Analysis
% block and the Extract Face and Hand subsystem to determine the location of the
% person's face and hand in each binary image. The Display Results/Mark Image
% subsystem uses this location information to draw bounding boxes around these
% regions.

close_system('vipcolorsegmentation');
sim('vipcolorsegmentation',[0 1]);
set(allchild(0), 'Visible', 'off');

captureVideoViewerFrame('vipcolorsegmentation/Display Results/Original Video');
captureVideoViewerFrame('vipcolorsegmentation/Display Results/Skin Region');
captureVideoViewerFrame('vipcolorsegmentation/Display Results/Marked Video');

%%
close_system('vipcolorsegmentation');
