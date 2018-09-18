% Adds cameratoolbar to figure for point cloud viewing.
function initializeCameraToolbar(hFigure, currentAxes, vertAxis, vertAxisDir, varargin)

% Equal axis is required for cameratoolbar
if numel(varargin) > 0 && varargin{1}
    axis(currentAxes, 'equal');
end

% Set up the cameratoolbar
cameratoolbar(hFigure);
vis = cameratoolbar('GetVisible');
if ~vis
    cameratoolbar('Show');
end

% Turn on the orbit mode of the cameratoolbar
mode = cameratoolbar('GetMode');
if ~strcmpi(mode, 'orbit')
    cameratoolbar('SetMode', 'orbit');
end

% Set up the camera
cameratoolbar('ResetCamera');

currentVertAxis = cameratoolbar('GetCoordsys');
if ~strcmpi(currentVertAxis, vertAxis)
    cameratoolbar('SetCoordSys',vertAxis);
end

vision.internal.pc.initializeVerticalAxis(currentAxes, vertAxis, vertAxisDir);

% Change the icon to indicate the rotation
SetData = setptr('rotate');
set(hFigure, SetData{:});

