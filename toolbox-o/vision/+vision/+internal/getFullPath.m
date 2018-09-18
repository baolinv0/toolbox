% getFullPath Full path to a file or directory
%  fullPath = getFullPath(file) returns the full path to file. file is a
%  file or folder name specified as a string.

%   Copyright 2014 The MathWorks, Inc.
function fullPath = getFullPath(file)
[~, attr] = fileattrib(file);
fullPath = attr.Name;