%% Abandoned Object Detection
% This example shows how to track objects at a train station and to determine which ones
% remain stationary. Abandoned objects in public areas concern 
% authorities since they might pose a security risk.  Algorithms,
% such as the one used in this example, can be used to assist security officers
% monitoring live surveillance video by directing their attention to a 
% potential area of interest.
%
% This example illustrates how to use the Blob Analysis and MATLAB(R) Function blocks
% to design a custom tracking algorithm. The example implements this algorithm 
% using the following steps: 1) Eliminate video areas that are unlikely 
% to contain abandoned objects by extracting a region of interest (ROI).
% 2) Perform video segmentation using background subtraction. 
% 3) Calculate object statistics using the Blob Analysis block. 4) Track 
% objects based on their area and centroid statistics.  5) Visualize the 
% results.
%
% <matlab:playbackdemo('vipabandonedobj_video','toolbox/vision/web/demos'); Watch the Abandoned Object Detection example>.

% Copyright 2004-2014 The MathWorks, Inc. 

%% Example Model
% The following figure shows the Abandoned Object Detection example model. 
oldpath = path;
addpath([getenv('LARGE_TEST_DATA_ROOT') filesep 'Computer_Vision_System_Toolbox' filesep 'v000']);
close;
open_system('vipabandonedobj');

%% Store Background Subsystem
% This example uses the first frame of the video as the background.
% To improve accuracy, the example uses both intensity and color information 
% for the background subtraction operation. During this operation, Cb and Cr 
% color channels are stored in a complex array.
%
% If you are designing a professional surveillance system, you should implement
% a more sophisticated segmentation algorithm.

open_system('vipabandonedobj/Store Background');

%% Detect Subsystem
% The Detect subsystem contains the main algorithm.  Inside this subsystem, 
% the Luminance Segmentation and Color Segmentation subsystems perform 
% background subtraction using the intensity and color data.  The example
% combines these two segmentation results using a binary OR operator.  
% The Blob Analysis block computes statistics of the objects present in
% the scene.

open_system('vipabandonedobj/Detect');

%% 
% Abandoned Object Tracker subsystem, shown below, uses the object statistics 
% to determine which objects are stationary. To view the contents of this
% subsystem, right-click the subsystem and select Look Under Mask.  To view the
% tracking algorithm details, double-click the Abandoned Object Tracker 
% block.  The MATLAB(R) code in this block is an example of how to 
% implement your custom code to augment Computer Vision System Toolbox(TM) 
% functionality.

open_system(sprintf('vipabandonedobj/Detect/Abandoned Object\nTracker'),...
            'force')

%% Abandoned Object Detection Results
% The All Objects window marks the region of interest (ROI) with a yellow box
% and all detected objects with green boxes. 

close_system('vipabandonedobj');
sim('vipabandonedobj',[0 4.5]);
f = allchild(0);

% get windows by their names
winNames = {'Threshold','All Objects','Abandoned Objects'};
[thIdx, allIdx, abaIdx] = deal(1,2,3);
h = ones(1,3);

for i = 1:3
    for j = 1:3
        if strncmp(f(i).Name,winNames{j},2)
            h(j) = f(i);
        end
    end
end

set(h(thIdx),'visible','off');
set(h(allIdx),'visible','off');
set(h(abaIdx),'visible','off');

%%

captureVideoViewerFrame('vipabandonedobj/Display Results/All Objects');

%%
% The Threshold window shows the result of the background 
% subtraction in the ROI.

captureVideoViewerFrame('vipabandonedobj/Display Results/Threshold');

%%
% The Abandoned Objects window highlights the abandoned objects with a red
% box.

captureVideoViewerFrame('vipabandonedobj/Display Results/Abandoned Objects');

%%

close_system('vipabandonedobj');

path(oldpath);


