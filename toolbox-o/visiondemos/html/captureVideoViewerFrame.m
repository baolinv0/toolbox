function i = captureVideoViewerFrame(blockName, multiplier)
%CAPTUREVIDEOVIEWERFRAME 

%   Copyright 2008 The MathWorks, Inc.

h = scopeextensions.ScopeBlock.getInstance(blockName);
f = figure;
data = get(h.Framework.Visual.Image, 'CData');
if islogical(data)
    i = imshow(data, 'border','tight');
else
    i = imshow(data, h.Framework.Visual.ColorMap.Map, 'border','tight');
end

if nargin < 2
    z = h.Framework.getExtInst('Tools', 'Image Navigation Tools');
    multiplier = z.findProp('Magnification').Value;
end

a = ancestor(i, 'axes');
pos = get(a, 'position');
set(a, 'position', [0 0 pos(3:4)*multiplier], 'units','pixels');
set(f, 'Units', 'Pixels');
pos = get(a, 'position');
figpos = get(f, 'position');
set(f, 'position', [figpos(1:2) pos(3:4)]);

% [EOF]
