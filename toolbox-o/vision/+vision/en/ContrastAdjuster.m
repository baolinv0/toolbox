classdef ContrastAdjuster
%ContrastAdjuster Adjust image contrast by linearly scaling pixel values
%   HCONTADJ = vision.ContrastAdjuster returns a System object, HCONTADJ,
%   that adjusts the contrast of an image by linearly scaling the pixel
%   values between upper and lower limits. Pixel values that are above or
%   below this range are saturated to the upper or lower limit values,
%   respectively.
%
%   HCONTADJ = vision.ContrastAdjuster('PropertyName', PropertyValue, ...)
%   returns a contrast adjustment System object, HCONTADJ, with each
%   specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HCONTADJ, X) performs contrast adjustment of input X and
%   returns the adjusted image Y.
%
%   ContrastAdjuster methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create contrast adjustment object with same property values
%   isLocked - Locked status (logical)
%
%   ContrastAdjuster properties:
%
%   InputRange                - How to specify lower and upper input limits
%   CustomInputRange          - Lower and upper input limits
%   PixelSaturationPercentage - Percentage of pixels to consider outliers
%   HistogramNumBins          - Number of histogram bins
%   OutputRangeSource         - How to specify lower and upper output
%                               limits
%   OutputRange               - Lower and upper output limits
%
%   This System object supports fixed-point operations. For more
%   information, type vision.ContrastAdjuster.helpFixedPoint.
%
%   % EXAMPLE: Use ContrastAdjuster System object to enhance image quality.
%      hcontadj = vision.ContrastAdjuster;
%      x = imread('pout.tif');
%      y = step(hcontadj, x);
%      subplot(1,2,1); imshow(x); title('Original Image');
%      subplot(1,2,2); imshow(y); title('Contrast-adjusted Image');
%
%   See also vision.HistogramEqualizer,
%            vision.ContrastAdjuster.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=ContrastAdjuster
            %ContrastAdjuster Adjust image contrast by linearly scaling pixel values
            %   HCONTADJ = vision.ContrastAdjuster returns a System object, HCONTADJ,
            %   that adjusts the contrast of an image by linearly scaling the pixel
            %   values between upper and lower limits. Pixel values that are above or
            %   below this range are saturated to the upper or lower limit values,
            %   respectively.
            %
            %   HCONTADJ = vision.ContrastAdjuster('PropertyName', PropertyValue, ...)
            %   returns a contrast adjustment System object, HCONTADJ, with each
            %   specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HCONTADJ, X) performs contrast adjustment of input X and
            %   returns the adjusted image Y.
            %
            %   ContrastAdjuster methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create contrast adjustment object with same property values
            %   isLocked - Locked status (logical)
            %
            %   ContrastAdjuster properties:
            %
            %   InputRange                - How to specify lower and upper input limits
            %   CustomInputRange          - Lower and upper input limits
            %   PixelSaturationPercentage - Percentage of pixels to consider outliers
            %   HistogramNumBins          - Number of histogram bins
            %   OutputRangeSource         - How to specify lower and upper output
            %                               limits
            %   OutputRange               - Lower and upper output limits
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.ContrastAdjuster.helpFixedPoint.
            %
            %   % EXAMPLE: Use ContrastAdjuster System object to enhance image quality.
            %      hcontadj = vision.ContrastAdjuster;
            %      x = imread('pout.tif');
            %      y = step(hcontadj, x);
            %      subplot(1,2,1); imshow(x); title('Original Image');
            %      subplot(1,2,2); imshow(y); title('Contrast-adjusted Image');
            %
            %   See also vision.HistogramEqualizer,
            %            vision.ContrastAdjuster.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.ContrastAdjuster System object 
            %               fixed-point information
            %   vision.ContrastAdjuster.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   vision.ContrastAdjuster System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CustomInputRange Lower and upper input limits
        %   Specify the lower and upper input limits as a two-element vector of
        %   scalar values, where the first element corresponds to the lower
        %   input limit, and the second element corresponds to the upper input
        %   limit. This property is applicable when the InputRange property is
        %   'Custom'. This property is tunable.
        CustomInputRange;

        %CustomProductHistogramDataType Product histogram word and fraction
        %                               lengths
        %   Specify the product histogram fixed-point type as an auto-signed
        %   scaled numerictype object. The default value of this property is
        %   numerictype([],32,16). This property is applicable when the
        %   InputRange property is 'Range determined by saturating outlier
        %   pixels'.
        %
        %   See also numerictype.
        CustomProductHistogramDataType;

        %CustomProductInputDataType Product input word and fraction lengths
        %   Specify the product input fixed-point type as an auto-signed scaled
        %   numerictype object. The default value of this property is
        %   numerictype([],32,16).
        %
        %   See also numerictype.
        CustomProductInputDataType;

        %HistogramNumBins Number of histogram bins
        %   Specify the number of histogram bins used to calculate the scaled
        %   input values. This property is applicable when the InputRange
        %   property is 'Range determined by saturating outlier pixels'. The
        %   default value of this property is 256.
        HistogramNumBins;

        %InputRange How to specify lower and upper input limits
        %   Specify how to determine the lower and upper input limits as one of
        %   [{'Full input data range [min max]'} | 'Custom' | 'Range determined
        %   by saturating outlier pixels'].
        InputRange;

        %OutputRange Lower and upper output limits
        %   Specify the lower and upper output limits as a two-element vector
        %   of scalar values, where the first element corresponds to the lower
        %   output limit and the second element corresponds to the upper output
        %   limit. This property is applicable when the OutputRangeSource
        %   property is 'Property'. This property is tunable.
        OutputRange;

        %OutputRangeSource How to specify lower and upper output limits
        %   Specify how to determine the lower and upper output limits as one
        %   of [{'Auto'} | 'Property']. If this property is set to 'Auto', the
        %   object uses the minimum value of the input data type as the lower
        %   output limit and the maximum value of the input data type as the
        %   upper output limit.
        OutputRangeSource;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %PixelSaturationPercentage Percentage of pixels to consider outliers
        %   Specify the percentage of pixels to consider outliers as a
        %   two-element vector. The object calculates the lower input limit
        %   such that the percentage of pixels with values smaller than the
        %   lower limit is at most the value of the first element. It
        %   calculates the upper input limit similarly. This property is
        %   applicable when the InputRange property is 'Range determined by
        %   saturating outlier pixels'. The default value of this property is
        %   [1 1].
        PixelSaturationPercentage;

        %ProductHistogramDataType Product histogram word- and fraction-length
        %                         designations
        %   Specify the product histogram fixed-point data type as one of 
        %   [{'Custom'} | 'Same as input']. This property is applicable when 
        %   the InputRange property is 'Range determined by saturating 
        %   outlier pixels'.
        ProductHistogramDataType;

        %ProductInputDataType Product input word- and fraction-length designations
        %   Specify the product input fixed-point data type as one of 
        %   [{'Custom'} | 'Same as input'].
        ProductInputDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

    end
end
