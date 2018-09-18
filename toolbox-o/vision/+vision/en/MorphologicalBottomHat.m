classdef MorphologicalBottomHat
%MorphologicalBottomHat Bottom-hat filtering
%   ----------------------------------------------------------------------------
%   The vision.MorphologicalBottomHat will be removed in a future release. 
%   Use the imbothat function with equivalent functionality instead.
%   ----------------------------------------------------------------------------
%
%   HBOT = vision.MorphologicalBottomHat returns a System object,
%   HBOT, that performs bottom-hat filtering on an intensity or binary
%   image using a predefined neighborhood or structuring element.
%
%   HBOT = vision.MorphologicalBottomHat('PropertyName', PropertyValue,
%   ...) returns a bottom-hat filtering System object, HBOT, with each
%   specified property set to the specified value.
%
%   Bottom-hat filtering is the equivalent of subtracting the input image
%   from the result of performing a morphological closing operation on the
%   input image. This System object uses flat structuring elements only.
%
%   Step method syntax:
%
%   Y = step(HBOT, I) filters the input image, I, and returns the output Y.
%
%   Y = step(HBOT, I, NHOOD) uses input NHOOD as the neighborhood when the
%   NeighborhoodSource property is 'Input port'.
%
%   MorphologicalBottomHat methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create bottom-hat filtering object with same property values
%   isLocked - Locked status (logical)
%
%   MorphologicalBottomHat properties:
%
%   ImageType          - Type of input image or video stream
%   NeighborhoodSource - Source of neighborhood values
%   Neighborhood       - Neighborhood or structuring element values
%
%   % EXAMPLE: Perform bottom-hat filtering on an image.
%      I = im2single(imread('blobs.png'));
%      hbot = vision.MorphologicalBottomHat('Neighborhood', strel('disk', 5));
%      J = step(hbot,I);
%      figure;
%      subplot(1,2,1),imshow(I); title('Original image');
%      subplot(1,2,2),imshow(J); title('Bottom-hat filtered image');
%
%   See also imbothat

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=MorphologicalBottomHat
            %MorphologicalBottomHat Bottom-hat filtering
            %   ----------------------------------------------------------------------------
            %   The vision.MorphologicalBottomHat will be removed in a future release. 
            %   Use the imbothat function with equivalent functionality instead.
            %   ----------------------------------------------------------------------------
            %
            %   HBOT = vision.MorphologicalBottomHat returns a System object,
            %   HBOT, that performs bottom-hat filtering on an intensity or binary
            %   image using a predefined neighborhood or structuring element.
            %
            %   HBOT = vision.MorphologicalBottomHat('PropertyName', PropertyValue,
            %   ...) returns a bottom-hat filtering System object, HBOT, with each
            %   specified property set to the specified value.
            %
            %   Bottom-hat filtering is the equivalent of subtracting the input image
            %   from the result of performing a morphological closing operation on the
            %   input image. This System object uses flat structuring elements only.
            %
            %   Step method syntax:
            %
            %   Y = step(HBOT, I) filters the input image, I, and returns the output Y.
            %
            %   Y = step(HBOT, I, NHOOD) uses input NHOOD as the neighborhood when the
            %   NeighborhoodSource property is 'Input port'.
            %
            %   MorphologicalBottomHat methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create bottom-hat filtering object with same property values
            %   isLocked - Locked status (logical)
            %
            %   MorphologicalBottomHat properties:
            %
            %   ImageType          - Type of input image or video stream
            %   NeighborhoodSource - Source of neighborhood values
            %   Neighborhood       - Neighborhood or structuring element values
            %
            %   % EXAMPLE: Perform bottom-hat filtering on an image.
            %      I = im2single(imread('blobs.png'));
            %      hbot = vision.MorphologicalBottomHat('Neighborhood', strel('disk', 5));
            %      J = step(hbot,I);
            %      figure;
            %      subplot(1,2,1),imshow(I); title('Original image');
            %      subplot(1,2,2),imshow(J); title('Bottom-hat filtered image');
            %
            %   See also imbothat
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %ImageType Specify type of input image or video stream
        %   Specify the type of the input image as one of [{'Intensity'} |
        %   'Binary'].
        ImageType;

        %Neighborhood Neighborhood or structuring element values
        %   This property is applicable when the NeighborhoodSource property is
        %   set to 'Property'. If specifying a neighborhood, this property must
        %   be a matrix or vector of 1s and 0s. If specifying a structuring
        %   element, use the strel function. The default value of this property
        %   is strel('octagon',15).
        %
        %   See also strel.
        Neighborhood;

        %NeighborhoodSource Source of neighborhood values
        %   Specify how to enter neighborhood or structuring element values as
        %   one of [{'Property'} | 'Input port']. If set to 'Property', use the
        %   Neighborhood property to specify the neighborhood or structuring
        %   element values. Otherwise, specify the neighborhood using an input
        %   to the step method. Note that structuring elements can only be
        %   specified using Neighborhood property and they cannot be used as
        %   input to the step method.
        NeighborhoodSource;

    end
end
