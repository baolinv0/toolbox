function scopext(ext)
%SCOPEXT Register scope extension for vision.VideoPlayer System object.

% Copyright 2004-2010 The MathWorks, Inc.

% Data handler for Video visual
uiscopes.addDataHandler(ext,'Streaming','Video','scopeextensions.VideoMLStreamingHandler');

% [EOF]
