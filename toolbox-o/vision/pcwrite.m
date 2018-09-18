function pcwrite(varargin)
% pcwrite Write a 3-D point cloud to PLY file.
%   pcwrite(ptCloud, filename) writes a pointCloud object, ptCloud, to a
%   PLY file specified by the filename.
%
%   pcwrite(ptCloud, filename, 'PLYFormat', format) writes a pointCloud
%   object, ptCloud, to a PLY file with a specified format. Valid strings
%   for format are 'ascii', 'binary'. The default format is 'ascii'.
%
%   See also pointCloud, pcread, pcshow
 
%  Copyright 2014 The MathWorks, Inc.

[ptCloud, filename, format] = validateAndParseInputs(varargin{:});

% Little endian is the default setting for binary format
if strcmpi(format, 'binary')
    format = 'binary_little_endian';
end
% PLY file does not recognize invalid points.
pc = removeInvalidPoints(ptCloud);

% Append 'ply' extension if it is not provided in the filename.
ext = getExtFromFilename(filename);
if (isempty(ext) || ~strcmpi(ext, 'ply'))
    filename = [filename, '.ply'];
end

% Verify that the file can be written.
fid = fopen(filename, 'a');
if (fid == -1)
    error(message('MATLAB:imagesci:imwrite:fileOpen', filename));
else
    % File can be created.  Get full filename.
    filename = fopen(fid);
    fclose(fid);
end

% Write 'vertex' with existing properties
elementName = 'vertex';
propertyNames = {'x','y','z'};
propertyValues = {pc.Location(:,1), pc.Location(:,2), pc.Location(:,3)};
if ~isempty(pc.Color)
    propertyNames = [propertyNames, {'red','green','blue'}];
    propertyValues = [propertyValues, {pc.Color(:,1),...
                        pc.Color(:,2), pc.Color(:,3)}];
end
if ~isempty(pc.Normal)
    propertyNames = [propertyNames, {'nx','ny','nz'}];
    propertyValues = [propertyValues, {pc.Normal(:,1),...
                        pc.Normal(:,2), pc.Normal(:,3)}];
end

visionPlyWrite(filename, format, elementName, propertyNames, propertyValues);
end

%========================================================================== 
function [ptCloud, filename, format] = validateAndParseInputs(varargin)
% Validate and parse inputs

parser = inputParser;
parser.FunctionName  = mfilename;

parser.addRequired('ptCloud', @(x)validateattributes(x, {'pointCloud'},{}));
parser.addRequired('filename', @(x)validateattributes(x, {'char'},{'nonempty'}));
parser.addParameter('PLYFormat', 'ascii');

parser.parse(varargin{:});

ptCloud = parser.Results.ptCloud;
filename = parser.Results.filename;
format = checkFormatSring(parser.Results.PLYFormat);
end   

%==========================================================================
function format = checkFormatSring(value)
% Validate format string
list = {'ascii', 'binary'};
format = validatestring(value, list, mfilename, 'PLYFormat');
end

%==========================================================================
function ext = getExtFromFilename(filename)
% Get file extension from string
ext = '';

idx = find(filename == '.');

if (~isempty(idx))  
    ext = filename((idx(end) + 1):end);    
end
end