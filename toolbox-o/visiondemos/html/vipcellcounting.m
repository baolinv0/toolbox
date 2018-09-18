%% Cell Counting
% This example shows how to use a combination of basic morphological 
% operators and blob analysis to extract information from a video stream. 
% In this case, the example counts the number of E. Coli bacteria in each 
% video frame. Note that the cells are of varying brightness, which
% makes the task of segmentation more challenging.

% Copyright 2004-2007 The MathWorks, Inc.

%% Example Model
% The following figure shows the Cell Counting example model. 
close;
open_system('vipcellcounting');
blkName=find_system('vipcellcounting/Display Results','blocktype','Scope');
close_system(blkName{1});

%% Segment Cells Subsystem
% Inside the Isolate Cells subsystem, the example uses a combination 
% of morphological dilation
% and image arithmetic operations to remove uneven illumination and 
% to emphasize the boundaries between the cells.  Due to changes in overall 
% lighting intensity, the example cannot apply a single threshold value to all 
% of the video frames. The example uses the Autothreshold block to compute 
% a threshold for each frame.

open_system('vipcellcounting/Segment Cells');

%%
% Isolate Cells subsystem:

open_system('vipcellcounting/Segment Cells/Isolate Cells');

%% Cell Counting Results
% After the example applies the threshold and separates the cells, it uses 
% the Blob Analysis block to count the number of cells in each frame and to 
% calculate the centroid of each cell. The example passes the total 
% number of cells in each frame to the Insert Text block, which is in the 
% Display Results subsystem.  This block embeds this information on each 
% video frame.

close_system('vipcellcounting');
sim('vipcellcounting',[0 0.7]);
blkName=find_system('vipcellcounting/Display Results','blocktype','Scope');

f = allchild(0);
set(f(1),'visible','off');

%%
% The Cell division rate window shows the exponential growth of the
% bacteria.

open_system(blkName{1});

%%
% The Results window displays one frame of the original video and 
% green markers indicating centroid locations of the found cells. The frame 
% number and the number of cells are displayed in the upper left corner.

captureVideoViewerFrame('vipcellcounting/Display Results/Results');

%% Data Set Credits
% The data set for this example was provided by Jonathan Young 
% and Michael Elowitz from California Institute of Technology(R). It is used
% with permission. For additional information about this data, see
%
% N. Rosenfeld, J. Young, U. Alon, P. Swain, and M.B. Elowitz,
% "Gene Regulation at the Single-Cell Level, " Science 2005, 
% Vol. 307, pp. 1962-1965.

close_system('vipcellcounting');

