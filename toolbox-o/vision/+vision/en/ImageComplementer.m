classdef ImageComplementer
%ImageComplementer Complement image
%   HIMGCOMP = vision.ImageComplementer returns an image
%   complement System object, HIMGCOMP, that computes the complement of a
%   binary or intensity image. For binary images, the object replaces
%   pixel values equal to 0 with 1 and pixel values equal to 1 with 0. For
%   an intensity image, the object subtracts each pixel value from
%   the maximum value that can be represented by the input data type and
%   outputs the difference.
%
%   Step method syntax:
%
%   Y = step(HIMGCOMP, X) computes the complement of an input image X.
%
%   ImageComplementer methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create image complement object with same property values
%   isLocked - Locked status (logical)
%
%   % EXAMPLE: Use the ImageComplementer System object to compute the 
%   %          complement of an input image.
%      % Create System objects
%      himgcomp = vision.ImageComplementer;
%      hautoth = vision.Autothresholder; 
%      % Read in image
%      I = imread('coins.png');
%      % Convert the image to binary
%      bw = step(hautoth, I); 
%      % Take the image complement
%      Ic = step(himgcomp, bw);
%      % Display the results
%      figure;
%      subplot(2,1,1), imshow(bw), title('Original Binary image')
%      subplot(2,1,2), imshow(Ic), title('Complemented image')
%
%   See also vision.Autothresholder. 

 
%   Copyright 2007-2010 The MathWorks, Inc.

    methods
        function out=ImageComplementer
            %ImageComplementer Complement image
            %   HIMGCOMP = vision.ImageComplementer returns an image
            %   complement System object, HIMGCOMP, that computes the complement of a
            %   binary or intensity image. For binary images, the object replaces
            %   pixel values equal to 0 with 1 and pixel values equal to 1 with 0. For
            %   an intensity image, the object subtracts each pixel value from
            %   the maximum value that can be represented by the input data type and
            %   outputs the difference.
            %
            %   Step method syntax:
            %
            %   Y = step(HIMGCOMP, X) computes the complement of an input image X.
            %
            %   ImageComplementer methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create image complement object with same property values
            %   isLocked - Locked status (logical)
            %
            %   % EXAMPLE: Use the ImageComplementer System object to compute the 
            %   %          complement of an input image.
            %      % Create System objects
            %      himgcomp = vision.ImageComplementer;
            %      hautoth = vision.Autothresholder; 
            %      % Read in image
            %      I = imread('coins.png');
            %      % Convert the image to binary
            %      bw = step(hautoth, I); 
            %      % Take the image complement
            %      Ic = step(himgcomp, bw);
            %      % Display the results
            %      figure;
            %      subplot(2,1,1), imshow(bw), title('Original Binary image')
            %      subplot(2,1,2), imshow(Ic), title('Complemented image')
            %
            %   See also vision.Autothresholder. 
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
end
