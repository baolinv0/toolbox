classdef Autothresholder
%Autothresholder Convert intensity image to binary image
%   HAUTOTH = vision.Autothresholder returns a System object, HAUTOTH, that
%   automatically converts an intensity image to a binary image. The object
%   uses Otsu's method, which determines the threshold by splitting the
%   histogram of the input image such that the variance for each of the
%   pixel groups is minimized.
%
%   HAUTOTH = vision.Autothresholder('PropertyName', PropertyValue, ...)
%   returns an autothreshold object, HAUTOTH, with each specified property
%   set to the specified value.
%
%   Step method syntax:
%
%   BW = step(HAUTOTH, I) converts input intensity image, I, to a binary
%   image, BW.
%
%   [BW, TH] = step(HAUTOTH, I) also returns the threshold, TH, when the
%   ThresholdOutputPort property is true.
%
%   [..., EMETRIC] = step(HAUTOTH, I) also returns EMETRIC, a metric
%   indicating the effectiveness of thresholding the input image when the
%   EffectivenessOutputPort property is true. The lower bound of the metric
%   (zero) is attainable only by images having a single gray level, and the
%   upper bound (one) is attainable only by two-valued images.
%
%   Autothresholder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create autothreshold object with same property values
%   isLocked - Locked status (logical)
%
%   Autothresholder properties:
%
%   Operator                  - Threshold operator on input matrix values
%   ThresholdOutputPort       - Enables threshold output
%   EffectivenessOutputPort   - Enables threshold effectiveness output
%   InputRangeSource          - Source of input data range
%   InputRange                - Expected input data range
%   InputRangeViolationAction - Behavior when input values are out of range
%   ThresholdScaleFactor      - Threshold scale factor
%
%   This System object supports fixed-point operations. For more
%   information, type vision.Autothresholder.helpFixedPoint.
%
%   % EXAMPLE: Convert an image of peppers to binary.
%      img = im2single(rgb2gray(imread('peppers.png')));
%      imshow(img);
%      hautoth = vision.Autothresholder;
%      bin = step(hautoth, img);
%      pause(2);
%      figure;imshow(bin);
%
%   See also vision.ColorSpaceConverter, vision.Autothresholder.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=Autothresholder
            %Autothresholder Convert intensity image to binary image
            %   HAUTOTH = vision.Autothresholder returns a System object, HAUTOTH, that
            %   automatically converts an intensity image to a binary image. The object
            %   uses Otsu's method, which determines the threshold by splitting the
            %   histogram of the input image such that the variance for each of the
            %   pixel groups is minimized.
            %
            %   HAUTOTH = vision.Autothresholder('PropertyName', PropertyValue, ...)
            %   returns an autothreshold object, HAUTOTH, with each specified property
            %   set to the specified value.
            %
            %   Step method syntax:
            %
            %   BW = step(HAUTOTH, I) converts input intensity image, I, to a binary
            %   image, BW.
            %
            %   [BW, TH] = step(HAUTOTH, I) also returns the threshold, TH, when the
            %   ThresholdOutputPort property is true.
            %
            %   [..., EMETRIC] = step(HAUTOTH, I) also returns EMETRIC, a metric
            %   indicating the effectiveness of thresholding the input image when the
            %   EffectivenessOutputPort property is true. The lower bound of the metric
            %   (zero) is attainable only by images having a single gray level, and the
            %   upper bound (one) is attainable only by two-valued images.
            %
            %   Autothresholder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create autothreshold object with same property values
            %   isLocked - Locked status (logical)
            %
            %   Autothresholder properties:
            %
            %   Operator                  - Threshold operator on input matrix values
            %   ThresholdOutputPort       - Enables threshold output
            %   EffectivenessOutputPort   - Enables threshold effectiveness output
            %   InputRangeSource          - Source of input data range
            %   InputRange                - Expected input data range
            %   InputRangeViolationAction - Behavior when input values are out of range
            %   ThresholdScaleFactor      - Threshold scale factor
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.Autothresholder.helpFixedPoint.
            %
            %   % EXAMPLE: Convert an image of peppers to binary.
            %      img = im2single(rgb2gray(imread('peppers.png')));
            %      imshow(img);
            %      hautoth = vision.Autothresholder;
            %      bin = step(hautoth, img);
            %      pause(2);
            %      figure;imshow(bin);
            %
            %   See also vision.ColorSpaceConverter, vision.Autothresholder.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.Autothresholder System object fixed-point
            %information
            %   vision.Autothresholder.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.Autothresholder
            %   System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Accumulator1DataType Accumulator-1 word- and fraction-length designations
        %   Specify the accumulator-1 fixed-point data type as one of [{'Same as
        %   product 1'} | 'Custom'].
        Accumulator1DataType;

        %Accumulator2DataType Accumulator-2 word- and fraction-length designations
        %   Specify the accumulator-2 fixed-point data type as one of [{'Same as
        %   product 2'} | 'Custom'].
        Accumulator2DataType;

        %Accumulator3DataType Accumulator-3 word- and fraction-length designations
        %   Specify the accumulator-3 fixed-point data type as one of [{'Same as
        %   product 3'} | 'Custom']. This property is applicable when the
        %   EffectivenessOutputPort property is true.
        Accumulator3DataType;

        %Accumulator4DataType Accumulator-4 word- and fraction-length designations
        %   Specify the accumulator-4 fixed-point data type as one of [{'Same as
        %   product 4'} | 'Custom'].
        Accumulator4DataType;

        %CustomAccumulator1DataType Accumulator-1 word and fraction lengths
        %   Specify the accumulator-1 fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   Accumulator1DataType property is 'Custom'. The default value of this
        %   property is numerictype([],32).
        %
        %   See also numerictype.
        CustomAccumulator1DataType;

        %CustomAccumulator2DataType Accumulator-2 word and fraction lengths
        %   Specify the accumulator-2 fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   Accumulator2DataType property is 'Custom'. The default value of this
        %   property is numerictype([],32).
        %
        %   See also numerictype.
        CustomAccumulator2DataType;

        %CustomAccumulator3DataType Accumulator-3 word and fraction lengths
        %   Specify the accumulator-3 fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   EffectivenessOutputPort property is true and the Accumulator3DataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],32).
        %
        %   See also numerictype.
        CustomAccumulator3DataType;

        %CustomAccumulator4DataType Accumulator-4 word and fraction lengths
        %   Specify the accumulator-4 fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   Accumulator4DataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,4).
        %
        %   See also numerictype.
        CustomAccumulator4DataType;

        %CustomEffectivenessDataType Effectiveness metric word and fraction
        %lengths
        %   Specify the effectiveness metric fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the
        %   EffectivenessOutputPort property is true. The default value of this
        %   property is numerictype([],16).
        %
        %   See also numerictype.
        CustomEffectivenessDataType;

        %CustomProduct1DataType Product-1 word and fraction lengths      
        %   Specify the product-1 fixed-point type as an auto-signed numerictype
        %   object. The default value of this property is numerictype([],32).
        %
        %   See also numerictype.
        CustomProduct1DataType;

        %CustomProduct2DataType Product-2 word and fraction lengths
        %   Specify the product-2 fixed-point type as an auto-signed numerictype
        %   object. The default value of this property is numerictype([],32).
        %
        %   See also numerictype.
        CustomProduct2DataType;

        %CustomProduct3DataType Product-3 word and fraction lengths
        %   Specify the product-3 fixed-point type as an auto-signed numerictype
        %   object. The default value of this property is numerictype([],32).
        %
        %   See also numerictype.
        CustomProduct3DataType;

        %CustomProduct4DataType Product-4 word and fraction lengths
        %   Specify the product-4 fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   Product4DataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,15).
        %
        %   See also numerictype.
        CustomProduct4DataType;

        %CustomQuotientDataType - Quotient word and fraction lengths    
        %   Specify the quotient fixed-point type as an auto-signed numerictype
        %   object. This property is applicable when the QuotientDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],32).
        %
        %   See also numerictype.
        CustomQuotientDataType;

        %EffectivenessDataType Effectiveness metric word- and fraction-length
        %designations
        %   This is a constant property with value 'Custom'. This property is
        %   applicable when the EffectivenessOutputPort property is true.
        EffectivenessDataType;

        %EffectivenessOutputPort Enables threshold effectiveness output
        %   Set this property to true to enable the output of the effectiveness of
        %   the thresholding. This effectiveness metric ranges from 0 to 1. If
        %   every pixel has the same value, the effectiveness metric is 0. If the
        %   image has two pixel values or the histogram of the image pixels is
        %   symmetric, the effectiveness metric is 1. The default value of this
        %   property is false.
        EffectivenessOutputPort;

        %InputRange Input data range
        %   Specify the input data range as a two element numeric row vector.
        %   First element of the input data range vector represents the minimum
        %   input value while the second element represents the maximum value.
        %   This property is applicable when the InputRangeSource property is
        %   'Property'.
        InputRange;

        %InputRangeSource Source of input data range
        %   Specify the input data range as one of [{'Auto'} | 'Property'].  If
        %   this property is set to 'Auto', then the System object assumes that
        %   the input range is between 0 and 1, inclusive, for floating point data
        %   types. For all other data types, the input range is the full range of
        %   the data type.  To specify a different input data range, set this
        %   property to 'Property'.
        InputRangeSource;

        %InputRangeViolationAction Behavior when input values are out of range
        %   Specify the System object's behavior when the input values are
        %   outside the expected data range as one of ['Ignore' | {'Saturate'}].
        %   This property is applicable when InputRangeSource property is
        %   'Property'.
        InputRangeViolationAction;

        %Operator Threshold operator on input matrix values
        %   Specify the condition the System object places on the input matrix
        %   values as one of [{'>'} | '<='].  If this property is set to '>' and
        %   the input value is greater than the threshold value, the System object
        %   outputs 1; otherwise, it outputs 0. If this property is set to '<='
        %   and the input value is less than or equal to the threshold value, the
        %   System object outputs 1; otherwise, it outputs 0.   
        Operator;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %Product1DataType Product-1 word- and fraction-length designations
        %   This is a constant property with value 'Custom'.
        Product1DataType;

        %Product2DataType Product-2 word- and fraction-length designations
        %   This is a constant property with value 'Custom'.
        Product2DataType;

        %Product3DataType Product-3 word- and fraction-length designations
        %   This is a constant property with value 'Custom'.
        Product3DataType;

        %Product4DataType Product-4 word- and fraction-length designations
        %   Specify the product-4 fixed-point data type as one of ['Same as input'
        %   | {'Custom'}].
        Product4DataType;

        %QuotientDataType Quotient word- and fraction-length designations
        %   Specify the quotient fixed-point data type as 'Custom'.
        QuotientDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %ThresholdOutputPort Enables threshold output
        %   Set this property to true to enable the output of the calculated
        %   threshold values. The default value of this property is false.
        ThresholdOutputPort;

        %ThresholdScaleFactor Threshold scale factor
        %   Specify the threshold scale factor as a numeric scalar greater than 0.
        %   The System object multiplies this scalar value with the threshold
        %   value computed by Otsu's method and uses the result as the new
        %   threshold value. The default value of this property is 1, i.e. no
        %   threshold scaling. This property is tunable.
        ThresholdScaleFactor;

    end
end
