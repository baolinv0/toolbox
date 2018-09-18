function validateImage(I, varName, imageType)
% Image validation function. The input image I can be logical, uint8,
% int16, uint16, single, or double, and it must be real and nonsparse. By
% default, the validation function also validates that I is only 2D or 3D
%
% validateImage(I,varName, imageType) optionally checks that the image is
% grayscale when imageType is 'grayscale'.

%#codegen
%#ok<*EMTC>
%#ok<*EMCA>

if nargin < 2
    varName = 'Image';
end

if nargin == 3                  
    switch imageType
        case 'grayscale'    
            imageSizeAttribute = [NaN NaN];
        case 'rgb'
            imageSizeAttribute = [NaN NaN NaN];
        otherwise
            error('Unknown image type');
    end
else
    imageSizeAttribute = [NaN NaN NaN];
end    

if isempty(coder.target)
    % use try/catch to throw error from calling function. This produces an
    % error stack that is better associated with the calling function.
    try 
        localValidate(I, varName, imageSizeAttribute)
    catch E        
        throwAsCaller(E); % to produce nice error message from caller.
    end
else
    localValidate(I, varName, imageSizeAttribute);
end

%--------------------------------------------------------------------------
function localValidate(I, varName, imageSizeAttribute)
classAttributes = {'double','single','int16','uint16','uint8','logical'};

if isa(I, 'gpuArray')
    localValidateForGPU(I, varName, classAttributes, imageSizeAttribute);
else    
    validateattributes(I, classAttributes,...
        {'nonempty','real', 'nonsparse','size', imageSizeAttribute},...
        'validateImage', varName); 
end

sz = size(I);
coder.internal.errorIf(ndims(I)==3 && sz(3) ~= 3,...
    'vision:dims:imageNot2DorRGB');

%--------------------------------------------------------------------------
function localValidateForGPU(I, varName, classAttributes, imageSizeAttribute)
% use hValidateAttributes until gpuArray support for validateattributes
hValidateAttributes(I, classAttributes,...
    {'nonempty','real','nonsparse'},...
    'validateImage', varName);

% size attribute not supported by hValidateAttributes
n = ndims(I);
if numel(imageSizeAttribute) == 2
    % size must be 2D
    if n ~= 2
        error(message('vision:dims:imageNot2D'));
    end
else
    % size must be 2D or 3D
    if n < 2 || n > 3
        error(message('vision:dims:imageNot2DorRGB'));
    end
end