function flag = vipsimdelay(u)
%VIPSIMDELAY Slow down the simulation speed.
%   VIPSIMDELAY function is used in Computer Vision System Toolbox demos
%   to slow down the simulation speed.
%
%   VIPSIMDELAY(U) slows down the simulation by U seconds.

%   Copyright 1993-2006 The MathWorks, Inc.

pause(u);
flag=1;