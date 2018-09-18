function vel_Lines=videooptflowlines(vel_Values, scaleFactor) 
% VIDEOOPTFLOWLINES Helper function to generate the coordinate points of
% optical flow lines. 

%   Copyright 2007-2010 The MathWorks, Inc.
%   Date: 2011/04/28 14:38:26 $

% This is used in the help example for the System object vision.OpticalFlow

persistent first_time;
persistent X;
persistent Y;
persistent RV;
persistent CV;
if isempty(first_time)
    first_time     = 1;
    %% user may change the following three parameters
    borderOffset   = 5;
    decimFactorRow = 5;
    decimFactorCol = 5;    
    %%
    [R C] = size(vel_Values);
    RV = borderOffset:decimFactorRow:(R-borderOffset);   
    CV = borderOffset:decimFactorCol:(C-borderOffset);
    [Y X] = meshgrid(CV,RV);
end

tmp = vel_Values(RV,CV);
tmp = tmp.*scaleFactor;
vel_Lines = [Y(:)   X(:)   Y(:)+real(tmp(:))   X(:)+imag(tmp(:))];