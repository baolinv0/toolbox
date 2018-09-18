classdef MorphologicalErode
%MorphologicalErode Morphological erosion
%   ----------------------------------------------------------------------------
%   The vision.MorphologicalErode will be removed in a future release. 
%   Use the imerode function with equivalent functionality instead.
%   ----------------------------------------------------------------------------
%
%   HERODE = vision.MorphologicalErode returns a System object,
%   HERODE, that performs morphological erosion on an intensity or binary
%   image.
%
%   HERODE = vision.MorphologicalErode('PropertyName', PropertyValue, ...)
%   returns a morphological erosion System object, HERODE, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   IE = step(HERODE, I) performs morphological erosion on input image I
%   and returns the eroded image IE.
%
%   IE = step(HERODE, I, NHOOD) uses input NHOOD as the neighborhood when
%   the NeighborhoodSource property is set to 'Input port'.
%
%   MorphologicalErode methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create morphological erosion object with same property values
%   isLocked - Locked status (logical)
%
%   MorphologicalErode properties:
%
%   NeighborhoodSource - Source of neighborhood values
%   Neighborhood       - Neighborhood or structuring element values
%
%   % EXAMPLE: Erode an input image.
%      x = imread('peppers.png');
%      hcsc = vision.ColorSpaceConverter;
%      hcsc.Conversion = 'RGB to intensity';
%      hautothresh = vision.Autothresholder;
%      herode = vision.MorphologicalErode('Neighborhood', ones(5,5));
%      x1 = step(hcsc, x);          % convert input to intensity
%      x2 = step(hautothresh, x1);  % convert input to binary
%      y  = step(herode, x2);       % Perform erosion on input
%      figure;
%      subplot(3,1,1),imshow(x); title('Original image');
%      subplot(3,1,2),imshow(x2); title('Thresholded Image');
%      subplot(3,1,3),imshow(y); title('Eroded Image');
%
%   See also imerode

 
%   Copyright 2004-2013 The MathWorks, Inc.

    methods
        function out=MorphologicalErode
            %MorphologicalErode Morphological erosion
            %   ----------------------------------------------------------------------------
            %   The vision.MorphologicalErode will be removed in a future release. 
            %   Use the imerode function with equivalent functionality instead.
            %   ----------------------------------------------------------------------------
            %
            %   HERODE = vision.MorphologicalErode returns a System object,
            %   HERODE, that performs morphological erosion on an intensity or binary
            %   image.
            %
            %   HERODE = vision.MorphologicalErode('PropertyName', PropertyValue, ...)
            %   returns a morphological erosion System object, HERODE, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   IE = step(HERODE, I) performs morphological erosion on input image I
            %   and returns the eroded image IE.
            %
            %   IE = step(HERODE, I, NHOOD) uses input NHOOD as the neighborhood when
            %   the NeighborhoodSource property is set to 'Input port'.
            %
            %   MorphologicalErode methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create morphological erosion object with same property values
            %   isLocked - Locked status (logical)
            %
            %   MorphologicalErode properties:
            %
            %   NeighborhoodSource - Source of neighborhood values
            %   Neighborhood       - Neighborhood or structuring element values
            %
            %   % EXAMPLE: Erode an input image.
            %      x = imread('peppers.png');
            %      hcsc = vision.ColorSpaceConverter;
            %      hcsc.Conversion = 'RGB to intensity';
            %      hautothresh = vision.Autothresholder;
            %      herode = vision.MorphologicalErode('Neighborhood', ones(5,5));
            %      x1 = step(hcsc, x);          % convert input to intensity
            %      x2 = step(hautothresh, x1);  % convert input to binary
            %      y  = step(herode, x2);       % Perform erosion on input
            %      figure;
            %      subplot(3,1,1),imshow(x); title('Original image');
            %      subplot(3,1,2),imshow(x2); title('Thresholded Image');
            %      subplot(3,1,3),imshow(y); title('Eroded Image');
            %
            %   See also imerode
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
        %   default value of this property is strel('square',4).
        %
        %   See also strel.
        Neighborhood;

    end
end
