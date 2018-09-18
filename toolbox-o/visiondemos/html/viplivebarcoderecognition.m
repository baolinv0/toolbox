%% Barcode Recognition Using Live Video Acquisition
%
% This example shows how to use the From Video Device block provided by 
% Image Acquisition Toolbox(TM) to acquire live image data from a 
% Point Grey Flea(R) 2 camera into Simulink(R). The example uses
% the Computer Vision System Toolbox(TM) to create an image processing
% system which can recognize and interpret a GTIN-13 barcode. The GTIN-13
% barcode, formally known as EAN-13, is an international barcode standard.
% It is a superset of the widely used UPC standard.
%
% Image Acquisition Toolbox(TM) provides functions for acquiring images
% and video directly into MATLAB(R) and Simulink from PC-compatible
% imaging hardware. You can detect hardware automatically, configure
% hardware properties, preview an acquisition, and acquire images and
% video. 
%
% This example requires Image Acquisition Toolbox and a Point Grey Flea(R) 2
% camera to run the model. 
%
% <matlab:playbackdemo('viplivebarcoderecognition_video','toolbox/vision/web/demos'); Watch
% barcode recognition on live video stream>. (11 seconds)
%
% Copyright 2008 The MathWorks, Inc.

%% Example Model
% The following figure shows the example model using 
% the From Video Device block.
%
warn_status = warning('query', 'Simulink:blocks:RefBlockUnknownParameter');
warning('off', warn_status.identifier);
close;
open_system('viplivebarcoderecognition_win');

%%
close_system('viplivebarcoderecognition_win');

%% Example Description
% This example uses the same algorithm as the Barcode Recognition example.
% Refer to the <matlab:showdemo('vipbarcoderecognition') Barcode
% Recognition example> for detailed information.

%% Results
% The scan lines that have been used to detect barcodes are displayed in
% red. When a GTIN-13 is correctly recognized and verified, the code is
% displayed at the top of the image.
%
sim('vipbarcoderecognition',[0 8.4666582]);

set(allchild(0), 'visible','off');
captureVideoViewerFrame('vipbarcoderecognition/Display/Barcode');


%%
% Even though a Point Grey Flea(R) 2 camera was used for this example, you
% can update this model to use other supported image acquisition devices,
% for example, webcams.
% This enables you to use the same Simulink model with different image
% acquisition hardware. Before using this example, please adjust the focus
% of your imaging device such that the barcodes are legible.

%% Available Example Versions
%
% Example using live video acquisition: <matlab:viplivebarcoderecognition_win
% viplivebarcoderecognition_win.slx> (Windows(R) only)
%
% Example using stored video data: <matlab:vipbarcoderecognition
% vipbarcoderecognition.slx> (platform independent)

%%
close_system('vipbarcoderecognition');
warning(warn_status.state, warn_status.identifier);
