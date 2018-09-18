% plotCamera Plot a camera in 3-D coordinates.
%   cam = plotCamera() returns a camera visualization object rendered
%   in the current axes. 
% 
%   cam = plotCamera(..., Name, Value) creates a camera visualization
%   object with the property values specified in the argument list.
%   The following properties are supported:
%
%   'Location'       Camera location specified as a 3-element vector of 
%                    [x, y, z] coordinates in the data units of the parent.
%
%                    Default: [0, 0, 0]
%
%   'Orientation'    A 3-by-3 3-D rotation matrix.
% 
%                    Default: eye(3)
%
%   'Size'           The width of camera's base specified as a scalar.
%
%                    Default: 1
%
%   'Label'          Camera label specified as a string.
%
%                    Default: ''
%
%   'Color'          The color of the camera specified as a string or a 
%                    3-element vector of RGB values with the range of [0, 1].
%
%                    Default: [1, 0, 0]   
%
%   'Opacity'        A scalar in the range of [0, 1] specifying the opacity
%                    of the camera.
%
%                    Default: 0.2
%
%   'Visible'        A logical scalar, specifying whether the camera is visible.
% 
%                    Default: true
%
%   'AxesVisible'    A logical scalar, specifying whether to display
%                    camera's axes.
%
%                    Default: false
%
%   'ButtonDownFcn'  Callback function that executes when you click the camera.
%
%                    Default: ''
%
%   'Parent'         Specify an output axes for displaying the visualization.
%
%                    Default: gca
%
%   Example 1 - Create an Animated Camera
%   -------------------------------------
%   % Plot a camera pointing along the Y-axis
%   R = [1     0     0;
%        0     0    -1;
%        0     1     0];
%
%   % Setting opacity of the camera to zero for faster animation.
%   cam = plotCamera('Location', [10 0 20], 'Orientation', R, 'Opacity', 0);
% 
%   % Set view properties
%   grid on
%   axis equal
%   axis manual
%
%   % Make the space large enough for the animation.
%   xlim([-15, 20]);
%   ylim([-15, 20]);
%   zlim([15, 25]);
% 
%   % Make the camera fly in a circle
%   for theta = 0:pi/64:10*pi
%       % Rotation about camera's y-axis
%       T = [cos(theta)  0  sin(theta);
%               0        1      0;
%            -sin(theta) 0  cos(theta)];
%       cam.Orientation = T * R;
%       cam.Location = [10 * cos(theta), 10 * sin(theta), 20];
%       drawnow();
%   end
%
%   Example 2 - Sparse 3-D Reconstruction From Two Views
%   ----------------------------------------------------
%   % This example shows you how ti perform sparse 3-D reconstruction from
%   % two views, and how to visualize the resulting 3-D point cloud
%   % together with the camera locations and orientations.
%   % <a href="matlab:web(fullfile(matlabroot,'toolbox','vision','visiondemos','html','SparseReconstructionExample.html'))">View example</a>
%
%   See also extrinsics, showExtrinsics

function cam = plotCamera(varargin)

params = parseInputs(varargin{:});

hCamera = vision.graphics.Camera.plotCameraImpl(params.Size, params.Location, ...
    params.Orientation, params.Parent);

hCamera.Visible = params.Visible;
hCamera.Label = params.Label;
hCamera.Color = params.Color;
hCamera.Opacity = params.Opacity;
hCamera.AxesVisible = params.AxesVisible;
hCamera.ButtonDownFcn = params.ButtonDownFcn;

if nargout > 0
    cam = hCamera;
end

%--------------------------------------------------------------------------
function params = parseInputs(varargin)
import vision.graphics.*;

parser = inputParser;
parser.addParameter('Location', [0,0,0], @Camera.checkLocation);
parser.addParameter('Orientation', eye(3), @Camera.checkOrientation);
parser.addParameter('Size', 1, @Camera.checkCameraSize);

parser.addParameter('Color', [1 0 0], @Camera.checkColor);
parser.addParameter('Label', '', @Camera.checkLabel);
parser.addParameter('Visible', true, @Camera.checkVisible);
parser.addParameter('AxesVisible', false, @Camera.checkAxesVisible);
parser.addParameter('Opacity', 0.2, @Camera.checkOpacity);
parser.addParameter('ButtonDownFcn', '', @Camera.checkCallback);

parser.addParameter('Parent', [], @checkParent);

parser.parse(varargin{:});
params = parser.Results;

% Set parent to gca if it is not specified.
% This must be done after parsing the parameters. Otherwise, a new axes may
% be created even if parameter validation fails.
if isempty(params.Parent)
    params.Parent = gca();
end

% Force location to be a row vector;
if ~isrow(params.Location)
    params.Location = params.Location';
end

%--------------------------------------------------------------------------
function tf = checkParent(parent)
tf = vision.internal.inputValidation.validateAxesHandle(parent);


