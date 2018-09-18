function [template_detection, template_detection_display, ...
    template_recognition, template_recognition_display, ...
    template_ids, template_names] ...
    = vipwarningsigns_templates()

% This function creates two sets of templates for the Traffic Warning Sign
% Recognition demo.
%
% Detection templates:
%    1. Each traffic sign has a template;
%    2. Red pixels have value of 1, white pixels have value of -1, pixels
%       out of the range of sign have value of 0.
%
% Recognition templates:
%    1. Each traffic sign has several templates, each of which corresponding
%       to an orientation.
%    2. White pixels have value of 1, red pixels have value of -1, pixels
%       out of the range of sign have value of 0.

% Sign names and images
names = {'Stop', 'Do Not Enter', 'Yield'};
files = {...
    'vipwarningsigns_stop_template.png', ...
    'vipwarningsigns_donotenter_template.png', ...
    'vipwarningsigns_yield_template.png'};

% Size of the detection templates
sizeDetection = [12, 12];
% Size of the recognition templates
sizeRecognition = [18, 18];
% Anngles for the recognition templates
angles = [0, 7.5, -7.5];

numFiles = length(files);
numAngles = length(angles);

% Detection templates
template_detection = ...
    single(zeros(sizeDetection(1), sizeDetection(2), numFiles));

% Recognition templates
template_recognition = single(zeros(sizeRecognition(1), ...
    sizeRecognition(2), numFiles*numAngles));

% Template IDs, each of which corresponding to a recognition template
template_ids = single(zeros(1, numFiles*numAngles));

% Template names, each of which corresponding to a sign
maxNameLen = length(names{1});
for iFile = 2: numFiles
    if maxNameLen < length(names{iFile})
        maxNameLen = length(names{iFile});
    end
end
template_names = uint8(zeros(numFiles, maxNameLen));
for iFile = 1: numFiles
    template_names(iFile, 1:length(names{iFile})) = uint8(names{iFile});
end

for iFile = 1: numFiles
    I = imread(files{iFile});
    feature = calFeature(I, 0, sizeDetection, true);
    template_detection(:,:,iFile) = feature;
end
% Reshape the templates to a 2-D matrix and rescale to [0, 1] for display
template_detection_display = reshape(template_detection, ...
    [sizeDetection(1), sizeDetection(2)*numFiles]) * 0.5 + 0.5;

iTemp = 1;
for iFile = 1: numFiles
    I = imread(files{iFile});
    for iAng = 1: numAngles
        feature = calFeature(I, angles(iAng), sizeRecognition, false);
        template_recognition(:, :, iTemp) = feature;
        template_ids(iTemp) = iFile;
        iTemp = iTemp + 1;
    end
end
% Reshape the templates to a 2-D matrix and rescale to [0, 1] for display
template_recognition_display = reshape(template_recognition, ...
    [sizeRecognition(1), sizeRecognition(2)*numFiles*numAngles]) * 0.5 + 0.5;

end

%--------------------------------------------------------------------------
function feature = calFeature(I, angle, sizeTemplate, isRed)
data = imrotate(I, angle, 'bicubic');
red = data(:,:,1)>0.5 & data(:,:,2)<0.5 & data(:,:,3)<0.5;
white = data(:,:,1)>0.5 & data(:,:,2)>0.5 & data(:,:,3)>0.5;
boundary = findBoundary(red);
redData = red(boundary(1):boundary(3), boundary(2):boundary(4));
whiteData = white(boundary(1):boundary(3), boundary(2):boundary(4));
if isRed
    contrast = redData - whiteData;
else
    contrast = whiteData - redData;
end
feature = imresize(contrast, sizeTemplate);
end

%--------------------------------------------------------------------------
function boundary = findBoundary(I)
boundary = zeros(1, 4);
%
% Horizontal direction
maxLines = max(I, [], 2);
validLines = find(maxLines == 1);
boundary(1) = validLines(1);
boundary(3) = validLines(end);
%
% Vertical direction
maxLines = max(I, [], 1);
validLines = find(maxLines == 1);
boundary(2) = validLines(1);
boundary(4) = validLines(end);
end