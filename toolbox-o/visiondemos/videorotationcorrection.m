%% Text Rotation Correction
% This example shows how to use HoughTransform and polyfit function 
% to horizontally align text rotating in a video sequence. 
% The techniques illustrated by this example can be used in video 
% stabilization and optical character recognition (OCR) applications.

%   Copyright 2004-2014 The MathWorks, Inc.

%% Introduction
% This example illustrates how to use the HoughTransform and
% polyfit function to correct rotated text. This is often a preprocessing
% step needed before applying OCR.

%% Initialization
NumTimes = 100;         % Number of times the streaming loop should be run. 
x = imread('text.png');
I = single(x(5:60,5:end-40));

%%
% Create three Rotate System objects to rotate the image matrices by
% desired angles.
hrotate1 = vision.GeometricRotator( ...
    'AngleSource', 'Input port', ...
    'MaximumAngle', single(pi));

hrotate2 = vision.GeometricRotator( ...
    'AngleSource', 'Input port', ...
    'MaximumAngle', single(pi), ...
    'OutputSize', 'Same as input image');

hrotate3 = vision.GeometricRotator( ...
    'AngleSource', 'Input port', ...
    'MaximumAngle', single(pi), ...
    'OutputSize', 'Same as input image');

%%
% Create a HoughTransform System object(TM) to find theta and rho values of the
% lines in the binary image.
hhough = vision.HoughTransform( ...
    'ThetaRhoOutputPort', true, ...
    'OutputDataType', 'single');
%%
% Create a FindLocalMaxima System object to find the most dominant line from
% the hough matrix. 
hfindmax = vision.LocalMaximaFinder( ...
    'MaximumNumLocalMaxima', 5, ...
    'NeighborhoodSize', [21 11], ...
    'Threshold', 6, ...
    'HoughMatrixInput', true, ...
    'IndexDataType',  'single');

%%
% Create two Maximum System objects.
hmax1 = vision.Maximum('ValueOutputPort', true,  'IndexOutputPort', false);
hmax2 = vision.Maximum('ValueOutputPort', false, 'IndexOutputPort', true, ...
    'Dimension', 'Column');

%%
% Create a video player to display the original video, smudge video and
% corrected video.
hVideo1 = vision.VideoPlayer('Name', 'Input Video');
hVideo1.Position(1) = round(hVideo1.Position(1)*0.2);
hVideo1.Position(2) = round(hVideo1.Position(2)*1.5);
hVideo1.Position([4 3]) = [250 250]; 

hVideo2 = vision.VideoPlayer('Name', 'Smudge Video');
hVideo2.Position(1) = hVideo1.Position(1) + 260;
hVideo2.Position(2) = round(hVideo2.Position(2)*1.5);
hVideo2.Position([4 3]) = [250 250]; 

hVideo3 = vision.VideoPlayer('Name', 'Corrected Video');
hVideo3.Position(1) = hVideo2.Position(1) + 260;
hVideo3.Position(2) = round(hVideo3.Position(2)*1.5);
hVideo3.Position([4 3]) = [250 250]; 

hVideo4 = vision.VideoPlayer('Name', 'Hough Matrix');
hVideo4.Position(1) = hVideo3.Position(1) + 260;
hVideo4.Position(2) = round(hVideo1.Position(2)*0.7);
hVideo4.Position([4 3]) = [450 280]; 

%% Stream Processing Loop
% Create a processing loop to correct the rotation of the text in the
% input video. This loop uses the System objects you instantiated above.
for ii= 1: NumTimes
    % Read input video and generate random angle values between
    % -pi/6 to pi/6 which is used to rotate the input text image.
    image = step(hrotate1, I, ...  
        single(-pi/6)+(single(pi/6)-single(-pi/6))*single(rand));    

    y1 = imclose(logical(image), strel('disk',4));  % smudge text    
    % Detect angle of rotation of most dominant line using the
    % HoughTransform System object.
    [yHough, yTheta] = step(hhough, y1);
    Idx = step(hfindmax, yHough);
    y2 = yTheta(:,Idx(2,1));
    if y2 >= 0
        Theta = y2 - single(pi/2);
    else
        Theta = y2 + single(pi/2);
    end
    % Rotate the image with the angle of the most dominant line.
    image_rot = step(hrotate2, image, Theta);
    
    % Slope correction
    y5        = imclose(logical(image_rot), strel('disk',4)); % smudge text
    yIdx      = step(hmax2, single(y5));
    y6        = polyfit(0:219, single(yIdx), 1);
    Angle     = atan(y6(1));
    image_out = step(hrotate3, image_rot, Angle);
    
    % Display videos
    step(hVideo1, image); %Original text
    step(hVideo2, y1);
    step(hVideo3, image_out); 

    % Display hough matrix
    y3 = yHough(120:end - 70,:);
    Hough_Mtx = y3./step(hmax1,y3);
    step(hVideo4, Hough_Mtx);
end

%% Summary
% The Input Video window shows the original video. The Smudged Video window
% shows the result of blurring the letters to create a binary image with
% two distinct lines. The Corrected video window shows the result of the
% rotation correction run.


displayEndOfDemoMessage(mfilename)
