function validateImagePair(I1, I2, varName1, varName2, imageType)
% validateImagePair Validate a pair of images. 
% Verifies that I1 and I2 are valid grayscale or RGB images, and that they 
% are same size and class

%#codegen
%#ok<*EMTC>

if nargin < 5
    imageType = 'rgb';
end    

if isempty(coder.target)
    % use try/catch to throw error from calling function. This produces an
    % error stack that is better associated with the calling function.
    try 
        localValidate(I1, I2, varName1, varName2, imageType)
    catch E        
        throwAsCaller(E); % to produce nice error message from caller.
    end
else
    localValidate(I1, I2, varName1, varName2, imageType);
end

%--------------------------------------------------------------------------
function localValidate(I1, I2, varName1, varName2, imageType)

vision.internal.inputValidation.validateImage(I1, varName1, imageType);
vision.internal.inputValidation.validateImage(I2, varName2, imageType);

coder.internal.errorIf(~isequal(size(I1), size(I2)), ...
    'vision:dims:inputsMismatch');
    
coder.internal.errorIf(~isequal(class(I1), class(I2)), ...
    'vision:dims:inputsMismatch');