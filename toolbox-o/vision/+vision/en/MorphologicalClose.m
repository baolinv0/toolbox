classdef MorphologicalClose
%MorphologicalClose Morphological closing
%   ----------------------------------------------------------------------------
%   The vision.MorphologicalClose will be removed in a future release. 
%   Use the imclose function with equivalent functionality instead.
%   ----------------------------------------------------------------------------
%
%   HCLOSING = vision.MorphologicalClose returns a System object,
%   HCLOSING, that performs morphological closing on an intensity or binary
%   image.
%
%   HCLOSING = vision.MorphologicalClose('PropertyName', PropertyValue,
%   ...) returns a morphological closing System object, HCLOSING, with each
%   specified property set to the specified value.
%
%   The MorphologicalClose System object performs a dilation operation
%   followed by an erosion operation using a predefined neighborhood or
%   structuring element. This System object uses flat structuring elements
%   only.
%
%   Step method syntax:
%
%   IC = step(HCLOSING, I) performs morphological closing on input image I.
%
%   IC = step(HCLOSING, I, NHOOD) uses input NHOOD as the neighborhood when
%   the NeighborhoodSource property is set to 'Input port'.
%
%   MorphologicalClose methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create morphological closing object with same property values
%   isLocked - Locked status (logical)
%
%   MorphologicalClose properties:
%
%   NeighborhoodSource - Source of neighborhood values
%   Neighborhood       - Neighborhood or structuring element values
%
%   % EXAMPLE: Perform closing on an image.
%      img = im2single(imread('blobs.png'));
%      hclosing = vision.MorphologicalClose;
%      hclosing.Neighborhood = strel('disk', 10);
%      closed = step(hclosing, img);
%      figure;
%      subplot(1,2,1),imshow(img); title('Original image');
%      subplot(1,2,2),imshow(closed); title('Closed image');
%
%   See also imclose

 
%   Copyright 2004-2013 The MathWorks, Inc.

    methods
        function out=MorphologicalClose
            %MorphologicalClose Morphological closing
            %   ----------------------------------------------------------------------------
            %   The vision.MorphologicalClose will be removed in a future release. 
            %   Use the imclose function with equivalent functionality instead.
            %   ----------------------------------------------------------------------------
            %
            %   HCLOSING = vision.MorphologicalClose returns a System object,
            %   HCLOSING, that performs morphological closing on an intensity or binary
            %   image.
            %
            %   HCLOSING = vision.MorphologicalClose('PropertyName', PropertyValue,
            %   ...) returns a morphological closing System object, HCLOSING, with each
            %   specified property set to the specified value.
            %
            %   The MorphologicalClose System object performs a dilation operation
            %   followed by an erosion operation using a predefined neighborhood or
            %   structuring element. This System object uses flat structuring elements
            %   only.
            %
            %   Step method syntax:
            %
            %   IC = step(HCLOSING, I) performs morphological closing on input image I.
            %
            %   IC = step(HCLOSING, I, NHOOD) uses input NHOOD as the neighborhood when
            %   the NeighborhoodSource property is set to 'Input port'.
            %
            %   MorphologicalClose methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create morphological closing object with same property values
            %   isLocked - Locked status (logical)
            %
            %   MorphologicalClose properties:
            %
            %   NeighborhoodSource - Source of neighborhood values
            %   Neighborhood       - Neighborhood or structuring element values
            %
            %   % EXAMPLE: Perform closing on an image.
            %      img = im2single(imread('blobs.png'));
            %      hclosing = vision.MorphologicalClose;
            %      hclosing.Neighborhood = strel('disk', 10);
            %      closed = step(hclosing, img);
            %      figure;
            %      subplot(1,2,1),imshow(img); title('Original image');
            %      subplot(1,2,2),imshow(closed); title('Closed image');
            %
            %   See also imclose
        end

    end
    methods (Abstract)
    end
    properties
        %Neighborhood Neighborhood or structuring element values
        %   This property is applicable when the NeighborhoodSource property is
        %   set to 'Property'. If you are specifying a neighborhood, this
        %   property must be a matrix or vector of 1s and 0s. If you are
        %   specifying a structuring element, use the strel function. The
        %   default value of this property is strel('line',5,45).
        %
        %   See also strel.
        Neighborhood;

    end
end
