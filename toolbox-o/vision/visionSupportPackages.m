function visionSupportPackages
% visionSupportPackages Launches the support package installer
%  This function launches the Support Package installer, where you will be
%  able to download, and install support packages for the Computer Vision
%  System Toolbox.

%   Copyright 2013 The MathWorks, Inc.

hwconnectinstaller.launchInstaller('baseproduct','Computer Vision System Toolbox',...
                                    'SupportCategory','software');

