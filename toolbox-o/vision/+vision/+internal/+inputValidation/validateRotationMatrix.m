function validateRotationMatrix(M, fileName, varName)
%#codegen
validateattributes(M, {'numeric'}, ...
    {'finite', '2d', 'real', 'nonsparse', 'size', [3,3]}, fileName, varName); %#ok<EMCA>