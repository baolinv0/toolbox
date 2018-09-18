%% Video Compression
% This example shows how to compress a video using motion compensation and discrete 
% cosine transform (DCT) techniques. 
% The example calculates motion vectors between successive frames and uses them to 
% reduce redundant information. Then it divides each frame into submatrices 
% and applies the discrete cosine transform to each submatrix. Finally, the 
% example applies a quantization technique to achieve further compression. The 
% Decoder subsystem performs the inverse process to recover the original
% video.

% Copyright 2004-2007 The MathWorks, Inc.


%% Example Model
% The following figure shows the Video Compression model:

open_system('vipcodec');

%% Encoder Subsystem
% The Block Processing block sends 16-by-16 submatrices of each video frame 
% to the Block Processing block's subsystem for processing. Within this 
% subsystem, the model applies a motion compensation technique and the DCT 
% to the video stream. By discarding many high-frequency coefficients in 
% the DCT output, the example reduces the bit rate of the input video. 

open_system('vipcodec/Encoder');

%% Video Compression Results
% The Decoded window shows the compressed video stream. You can see that the 
% compressed video is not as clear as the original video, shown in the Original 
% window, but it still contains many of its features. 

sim('vipcodec',[0 4]);

set(allchild(0), 'Visible', 'off');
captureVideoViewerFrame('vipcodec/Display/Original');
captureVideoViewerFrame('vipcodec/Display/Decoded');


%% Available Example Versions
%
% *Intensity version of this example:*
%
% <matlab:vipcodec vipcodec.slx> 
%
% *Color version of this example:* 
%
% <matlab:vipcodec_color vipcodec_color.slx> 

close_system('vipcodec');

