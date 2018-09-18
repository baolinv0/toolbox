classdef MorphologicalOpen
%MorphologicalOpen Morphological opening
%   ----------------------------------------------------------------------------
%   The vision.MorphologicalOpen will be removed in a future release. 
%   Use the imopen function with equivalent functionality instead.
%   ---------------------------------------------------------------------------- 
%
%   HOPENING = vision.MorphologicalOpen returns a System object,
%   HOPENING, that performs morphological opening on an intensity or binary
%   image.
%
%   HOPENING = vision.MorphologicalOpen('PropertyName', PropertyValue, ...)
%   returns a morphological opening System object, HOPENING, with each
%   specified property set to the specified value.
%
%   The MorphologicalOpen System object performs an erosion operation
%   followed by a dilation operation using a predefined neighborhood or
%   structuring element. This System object uses flat structuring elements
%   only.
%
%   Step method syntax:
%
%   IO = step(HOPENING, I) performs morphological opening on input image I.
%
%   IO = step(HOPENING, I, NHOOD) uses input NHOOD as the neighborhood when
%   the NeighborhoodSource property is set to 'Input port'.
%
%   MorphologicalOpen methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create morphological open object with same property values
%   isLocked - Locked status (logical)
%
%   MorphologicalOpen properties:
%
%   NeighborhoodSource - Source of neighborhood values
%   Neighborhood       - Neighborhood or structuring element values
%
%   % EXAMPLE: Perform opening on an image.
%      img = im2single(imread('blobs.png'));
%      hopening = vision.MorphologicalOpen;
%      hopening.Neighborhood = strel('disk', 5);
%      opened = step(hopening, img);
%      figure;
%      subplot(1,2,1),imshow(img); title('Original image');
%      subplot(1,2,2),imshow(opened); title('Opened image');
%
%   See also imopen

 
%   Copyright 2004-2013 The MathWorks, Inc.

    methods
        function out=MorphologicalOpen
            %MorphologicalOpen Morphological opening
            %   ----------------------------------------------------------------------------
            %   The vision.MorphologicalOpen will be removed in a future release. 
            %   Use the imopen function with equivalent functionality instead.
            %   ---------------------------------------------------------------------------- 
            %
            %   HOPENING = vision.MorphologicalOpen returns a System object,
            %   HOPENING, that performs morphological opening on an intensity or binary
            %   image.
            %
            %   HOPENING = vision.MorphologicalOpen('PropertyName', PropertyValue, ...)
            %   returns a morphological opening System object, HOPENING, with each
            %   specified property set to the specified value.
            %
            %   The MorphologicalOpen System object performs an erosion operation
            %   followed by a dilation operation using a predefined neighborhood or
            %   structuring element. This System object uses flat structuring elements
            %   only.
            %
            %   Step method syntax:
            %
            %   IO = step(HOPENING, I) performs morphological opening on input image I.
            %
            %   IO = step(HOPENING, I, NHOOD) uses input NHOOD as the neighborhood when
            %   the NeighborhoodSource property is set to 'Input port'.
            %
            %   MorphologicalOpen methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create morphological open object with same property values
            %   isLocked - Locked status (logical)
            %
            %   MorphologicalOpen properties:
            %
            %   NeighborhoodSource - Source of neighborhood values
            %   Neighborhood       - Neighborhood or structuring element values
            %
            %   % EXAMPLE: Perform opening on an image.
            %      img = im2single(imread('blobs.png'));
            %      hopening = vision.MorphologicalOpen;
            %      hopening.Neighborhood = strel('disk', 5);
            %      opened = step(hopening, img);
            %      figure;
            %      subplot(1,2,1),imshow(img); title('Original image');
            %      subplot(1,2,2),imshow(opened); title('Opened image');
            %
            %   See also imopen
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
        %   default value of this property is strel('disk',5).
        %
        %   See also strel.
        Neighborhood;

    end
end
