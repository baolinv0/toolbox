%% Periodic Noise Reduction
% This example shows how to remove periodic noise from a video.
% In a video stream, periodic noise is typically caused by the presence of
% electrical or electromechanical interference during video acquisition or
% transmission. This type of noise is most effectively reduced with frequency
% domain filtering, which isolates the frequencies occupied by the noise and
% suppresses them using a band-reject filter.

% Copyright 2004-2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Periodic Noise Reduction example model:
close
open_system('vipstripes');

%% Periodic Noise Reduction Results
% This example creates periodic noise by adding two 2-D sinusoids
% with varying frequency and phase to the video frames. Then it removes
% this noise using a frequency-domain or spatial-domain filter. You can
% specify which filter the example uses by double-clicking the Filtering 
% Method switch. 
%
% For the frequency-domain filter, the model uses a binary mask, which it 
% creates using Draw Shapes blocks, to eliminate a band of frequencies from 
% the frequency domain representation of the image.  For the spatial-domain
% filter, the model uses the 2-D FIR Filter block and precomputed band-reject 
% filter coefficients that were derived using the Filter Design and Analysis 
% Tool (FDATool) and the ftrans2 function.

close_system('vipstripes');
sim('vipstripes',[0 0.2]);
set(allchild(0), 'Visible', 'off');

captureVideoViewerFrame('vipstripes/Original Video');
captureVideoViewerFrame('vipstripes/Video + Periodic Noise');
captureVideoViewerFrame('vipstripes/Restored');

close_system('vipstripes');
