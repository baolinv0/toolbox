%% Barcode Recognition
%
% This example shows how to create an image processing
% system which can recognize and interpret a GTIN-13 barcode. The GTIN-13
% barcode, formally known as EAN-13, is an international barcode standard.
% It is a superset of the widely used UPC standard.
%
% Copyright 2008 The MathWorks, Inc.

%% Example Model
% The following figure shows the Barcode Recognition model:
close;
open_system('vipbarcoderecognition');

%% The GTIN-13 Barcode
% GTIN is the acronym for Global Trade Item Number, a family of product
% identification numbers that encompasses the various versions of the EAN
% barcodes
% and provides a unified worldwide numbering system. The GTIN-13 (EAN/UCC-13)
% barcode encodes a 13-digit number.

%% Algorithm
% The barcode recognition example performs a search on selected rows of
% the input image, called scanlines. Prior to recognition, each pixel 
% of the scanline is preprocessed by transforming it into a feature value.
% The feature value of a pixel is set to a 1, if the pixel
% is considered black, -1 if it is considered white,
% and a value between -1 and 1 otherwise.
% Once all pixels are transformed, the scanline sequences
% are analyzed. 
% The example identifies the sequence and location of the 
% guard patterns [1] and symbols. The symbols are upsampled and compared with
% the codebook to determine the corresponding code.
%
% To compensate for various barcode orientations, the example analyzes from
% left-to-right and from right-to-left and chooses the better match. If the
% checksum is correct and a matching score against the codebook is higher
% than a set threshold, the code is considered valid and is displayed.
%
% You can change the number and location of the scanlines by changing the
% value of the "Row Positions Of Scanlines" parameter.

%% Results
% The scanlines that have been used to detect barcodes are displayed in
% red. When a GTIN-13 is correctly recognized and verified, the code is
% displayed at the top of the image.

close_system('vipbarcoderecognition');
sim('vipbarcoderecognition',[0 8.4666582]);

set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('vipbarcoderecognition/Display/Barcode');


%% Available Example Versions
%
% Example using stored video data: <matlab:vipbarcoderecognition
% vipbarcoderecognition.slx> (platform independent)
%
% Example using live video acquisition: <matlab:viplivebarcoderecognition_win
% viplivebarcoderecognition_win.slx> (Windows(R) only)

%% References
% [1] T. Pavlidis, J. Swartz, and Y.P. Wang, _Fundamentals of bar code
% information theory_, Computer, pp. 74-86, vol. 23, no. 4, Apr 1990.

%%
close_system('vipbarcoderecognition', 0);

