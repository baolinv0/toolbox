classdef MorphologicalTopHat
%MorphologicalTopHat Top-hat filtering
%   ----------------------------------------------------------------------------
%   The vision.MorphologicalTopHat will be removed in a future release. 
%   Use the imtophat function with equivalent functionality instead.
%   ----------------------------------------------------------------------------
% 
%   HTOP = vision.MorphologicalTopHat returns a System object, HTOP,
%   that performs top-hat filtering on an intensity or binary image using a
%   predefined neighborhood or structuring element.
%
%   HTOP = vision.MorphologicalTopHat('PropertyName', PropertyValue, ...)
%   returns a top-hat filtering System object, HTOP, with each specified
%   property set to the specified value.
%
%   Top-hat filtering is the equivalent of subtracting the result of
%   performing a morphological opening operation on the input image from
%   the input image itself. This System object uses flat structuring
%   elements only.
%
%   Step method syntax:
%
%   Y = step(HTOP, I) filters the input image, I, and returns the output Y.
%
%   Y = step(HTOP, I, NHOOD) uses input NHOOD as the neighborhood when the
%   NeighborhoodSource property is 'Input port'.
%
%   MorphologicalTopHat methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create top-hat filtering object with same property values
%   isLocked - Locked status (logical)
%
%   MorphologicalTopHat properties:
%
%   ImageType          - Type of input image or video stream
%   NeighborhoodSource - Source of neighborhood values
%   Neighborhood       - Neighborhood or structuring element values
%
%   % EXAMPLE: Perform top-hat filtering to correct uneven illumination
%      I = im2single(imread('rice.png'));
%      htop = vision.MorphologicalTopHat('Neighborhood', strel('disk', 12));
%      hc = vision.ContrastAdjuster; % To improve contrast of output image
%      J = step(htop,I);
%      J = step(hc,J);
%      figure;
%      subplot(1,2,1),imshow(I); title('Original image');
%      subplot(1,2,2),imshow(J); title('Top-hat filtered image');
%
%   See also imtophat

 
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=MorphologicalTopHat
            %MorphologicalTopHat Top-hat filtering
            %   ----------------------------------------------------------------------------
            %   The vision.MorphologicalTopHat will be removed in a future release. 
            %   Use the imtophat function with equivalent functionality instead.
            %   ----------------------------------------------------------------------------
            % 
            %   HTOP = vision.MorphologicalTopHat returns a System object, HTOP,
            %   that performs top-hat filtering on an intensity or binary image using a
            %   predefined neighborhood or structuring element.
            %
            %   HTOP = vision.MorphologicalTopHat('PropertyName', PropertyValue, ...)
            %   returns a top-hat filtering System object, HTOP, with each specified
            %   property set to the specified value.
            %
            %   Top-hat filtering is the equivalent of subtracting the result of
            %   performing a morphological opening operation on the input image from
            %   the input image itself. This System object uses flat structuring
            %   elements only.
            %
            %   Step method syntax:
            %
            %   Y = step(HTOP, I) filters the input image, I, and returns the output Y.
            %
            %   Y = step(HTOP, I, NHOOD) uses input NHOOD as the neighborhood when the
            %   NeighborhoodSource property is 'Input port'.
            %
            %   MorphologicalTopHat methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create top-hat filtering object with same property values
            %   isLocked - Locked status (logical)
            %
            %   MorphologicalTopHat properties:
            %
            %   ImageType          - Type of input image or video stream
            %   NeighborhoodSource - Source of neighborhood values
            %   Neighborhood       - Neighborhood or structuring element values
            %
            %   % EXAMPLE: Perform top-hat filtering to correct uneven illumination
            %      I = im2single(imread('rice.png'));
            %      htop = vision.MorphologicalTopHat('Neighborhood', strel('disk', 12));
            %      hc = vision.ContrastAdjuster; % To improve contrast of output image
            %      J = step(htop,I);
            %      J = step(hc,J);
            %      figure;
            %      subplot(1,2,1),imshow(I); title('Original image');
            %      subplot(1,2,2),imshow(J); title('Top-hat filtered image');
            %
            %   See also imtophat
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
        %   Specify the type of the input image or video stream as one of
        %   [{'Intensity'} | 'Binary'].
        ImageType;

        %Neighborhood Neighborhood or structuring element values
        %   This property is applicable when the NeighborhoodSource property is
        %   'Property'. If specifying a neighborhood, this property must be a
        %   matrix or vector of 1s and 0s. If specifying a structuring element,
        %   use the strel function. The default value of this property is
        %   strel('square',4).
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
