classdef MorphologicalDilate
%MorphologicalDilate Morphological dilation
%   ----------------------------------------------------------------------------
%   The vision.MorphologicalDilate will be removed in a future release. 
%   Use the imdilate function with equivalent functionality instead.
%   ----------------------------------------------------------------------------
%
%   HDILATE = vision.MorphologicalDilate returns a System object, HDILATE,
%   that performs morphological dilation on an intensity or binary image.
%
%   HDILATE = vision.MorphologicalDilate('PropertyName', PropertyValue, ...)
%   returns a morphological dilation System object, HDILATE, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   ID = step(HDILATE, I) performs morphological dilation on input image I
%   and returns the dilated image IE.
%
%   ID = step(HDILATE, I, NHOOD) uses input NHOOD as the neighborhood when
%   the NeighborhoodSource property is set to 'Input port'.
%
%   MorphologicalDilate methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create morphological dilation object with same property
%              values
%   isLocked - Locked status (logical)
%
%   MorphologicalDilate properties:
%
%   NeighborhoodSource - Source of neighborhood values
%   Neighborhood       - Neighborhood or structuring element values
%
%   % EXAMPLE: Use MorphologicalDilate to fuse fine discontinuities on
%   % images
%       x = imread('peppers.png');
%       hcsc = vision.ColorSpaceConverter;
%       hcsc.Conversion = 'RGB to intensity';
%       hautothresh = vision.Autothresholder;
%       hdilate = vision.MorphologicalDilate('Neighborhood', ones(5,5));
%       x1 = step(hcsc, x);
%       x2 = step(hautothresh, x1);
%       y  = step(hdilate, x2);
%       figure;
%       subplot(3,1,1),imshow(x); title('Original image');
%       subplot(3,1,2),imshow(x2); title('Thresholded Image');
%       subplot(3,1,3),imshow(y); title('Dilated Image');
%
%   See also imdilate

 
%   Copyright 2004-2010 The MathWorks, Inc.

    methods
        function out=MorphologicalDilate
            %MorphologicalDilate Morphological dilation
            %   ----------------------------------------------------------------------------
            %   The vision.MorphologicalDilate will be removed in a future release. 
            %   Use the imdilate function with equivalent functionality instead.
            %   ----------------------------------------------------------------------------
            %
            %   HDILATE = vision.MorphologicalDilate returns a System object, HDILATE,
            %   that performs morphological dilation on an intensity or binary image.
            %
            %   HDILATE = vision.MorphologicalDilate('PropertyName', PropertyValue, ...)
            %   returns a morphological dilation System object, HDILATE, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   ID = step(HDILATE, I) performs morphological dilation on input image I
            %   and returns the dilated image IE.
            %
            %   ID = step(HDILATE, I, NHOOD) uses input NHOOD as the neighborhood when
            %   the NeighborhoodSource property is set to 'Input port'.
            %
            %   MorphologicalDilate methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create morphological dilation object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   MorphologicalDilate properties:
            %
            %   NeighborhoodSource - Source of neighborhood values
            %   Neighborhood       - Neighborhood or structuring element values
            %
            %   % EXAMPLE: Use MorphologicalDilate to fuse fine discontinuities on
            %   % images
            %       x = imread('peppers.png');
            %       hcsc = vision.ColorSpaceConverter;
            %       hcsc.Conversion = 'RGB to intensity';
            %       hautothresh = vision.Autothresholder;
            %       hdilate = vision.MorphologicalDilate('Neighborhood', ones(5,5));
            %       x1 = step(hcsc, x);
            %       x2 = step(hautothresh, x1);
            %       y  = step(hdilate, x2);
            %       figure;
            %       subplot(3,1,1),imshow(x); title('Original image');
            %       subplot(3,1,2),imshow(x2); title('Thresholded Image');
            %       subplot(3,1,3),imshow(y); title('Dilated Image');
            %
            %   See also imdilate
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
        %   default value of this property is [1 1; 1 1].
        %
        %   See also strel.
        Neighborhood;

    end
end
