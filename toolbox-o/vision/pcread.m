function ptCloud = pcread(filename)
% pcread Read a 3-D point cloud from PLY file.
%   ptCloud = pcread(filename) reads a point cloud from the PLY file
%   specified by the string filename. The return value ptCloud is a
%   pointCloud object.
%
%   Notes
%   -----
%   PLY files can contain numerous data entries. pcread loads the following
%   fields: 'vertex' with location property 'x', 'y', 'z', color property
%   'red'(or 'r'), 'green'(or 'g'), 'blue'(or 'b'), and normal property
%   'nx', 'ny', 'nz'. All other fields are not read.
% 
%   Example : Read a point cloud from a PLY file
%   --------------------------------------------
%   ptCloud = pcread('teapot.ply');
%   pcshow(ptCloud);
%
%   See also pointCloud, pcwrite, pcshow
 
%  Copyright 2014 The MathWorks, Inc.

% Validate the input
if ~ischar(filename)
    error(message('vision:pointcloud:badFileName'));
end

% Verify that the file exists.
fid = fopen(filename, 'r');
if (fid == -1)
    if ~isempty(dir(filename))
        error(message('MATLAB:imagesci:imread:fileReadPermission', filename));
    else
        error(message('MATLAB:imagesci:imread:fileDoesNotExist', filename));
    end
else
    % File exists.  Get full filename.
    filename = fopen(fid);
    fclose(fid);
end

% Read properties of 'Vertex'
elementName = 'vertex';
requiredProperties = {'x','y','z'};
% Alternative names are specified in a cell array within the main cell array.
optionalProperties = {{'r','red'},{'g','green'},{'b','blue'},'nx','ny','nz'};
properties = visionPlyRead(filename,elementName,requiredProperties,optionalProperties);

% Get location property
x = properties{1};
y = properties{2};
z = properties{3};
if isa(x,'double') || isa(y,'double') || isa(z,'double')
	loc = [double(x), double(y), double(z)];
else
	loc = [single(x), single(y), single(z)];
end

% Get color property
r = properties{4};
g = properties{5};
b = properties{6};
color = [im2uint8(r), im2uint8(g), im2uint8(b)];

% Get normal property
nx = properties{7};
ny = properties{8};
nz = properties{9};
if isa(nx,'double') || isa(ny,'double') || isa(nz,'double')
	normal = [double(nx), double(ny), double(nz)];
else
	normal = [single(nx), single(ny), single(nz)];
end

ptCloud = pointCloud(loc, 'Color', color, 'Normal', normal);