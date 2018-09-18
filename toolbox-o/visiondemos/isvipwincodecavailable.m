function A = isvipwincodecavailable
% ISVIPWINCODECAVAILABLE Checks for availability of a video codec.
% A = ISVIPWINCODECAVAILABLE returns TRUE on a Windows platform if a video 
% codec used to compress multimedia files for the Computer Vision
% System Toolbox demos is available on the system. Otherwise, it returns
% FALSE.

% Copyright 1995-2005 The MathWorks, Inc.

if ispc
    A = true;
    if strcmp(computer,'PCWIN64')
        try
            % all demo files are encoded with the same codec, try one
            dspmmfileinfo('vipfly.avi');
        catch
            A = false;
        end
    end
else
    A = false;
end
