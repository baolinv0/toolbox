classdef GeometricTranslator
%GeometricTranslator 2-D translation
%   HTRANSLATE = vision.GeometricTranslator returns a
%   System object, HTRANSLATE, that moves an image up or down and/or left
%   or right.
%
%   HTRANSLATE = vision.GeometricTranslator('PropertyName', PropertyValue,
%   ...) returns a geometric translator System object, HTRANSLATE, with
%   each specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HTRANSLATE, I) returns a translated image Y, with the offset
%   specified by the Offset property.
%
%   Y = step(HTRANSLATE, I, O) uses input O as the offset to translate the
%   image I when the OffsetSource property is 'Input port'. O is a
%   two-element offset vector that represents the number of pixels to
%   translate the image. The first element of the vector represents a shift
%   in the vertical direction and a positive value moves the image
%   downward. The second element of the vector represents a shift in the
%   horizontal direction and a positive value moves the image to the right.
%
%   GeometricTranslator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create geometric translator object with same property values
%   isLocked - Locked status (logical)
%
%   GeometricTranslator properties:
%
%   OutputSize          - Output size as full or same as input image size
%   OffsetSource        - Source of specifying offset values
%   Offset              - Translation values
%   MaximumOffset       - Maximum number of pixels by which to translate
%                         image
%   BackgroundFillValue - Value of pixels outside the image
%   InterpolationMethod - Interpolation method used to translate image
%
%   This System object supports fixed-point operations. For more
%   information, type vision.GeometricTranslator.helpFixedPoint.
%
%   % EXAMPLE: Translate an image to the right and bottom.
%      htranslate = vision.GeometricTranslator;
%      htranslate.OutputSize = 'Same as input image';
%      htranslate.Offset = [30 30];
%      I = im2single(imread('cameraman.tif'));
%      Y = step(htranslate, I);
%      imshow(Y);
%
%   See also vision.GeometricRotator, vision.GeometricTranslator.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=GeometricTranslator
            %GeometricTranslator 2-D translation
            %   HTRANSLATE = vision.GeometricTranslator returns a
            %   System object, HTRANSLATE, that moves an image up or down and/or left
            %   or right.
            %
            %   HTRANSLATE = vision.GeometricTranslator('PropertyName', PropertyValue,
            %   ...) returns a geometric translator System object, HTRANSLATE, with
            %   each specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HTRANSLATE, I) returns a translated image Y, with the offset
            %   specified by the Offset property.
            %
            %   Y = step(HTRANSLATE, I, O) uses input O as the offset to translate the
            %   image I when the OffsetSource property is 'Input port'. O is a
            %   two-element offset vector that represents the number of pixels to
            %   translate the image. The first element of the vector represents a shift
            %   in the vertical direction and a positive value moves the image
            %   downward. The second element of the vector represents a shift in the
            %   horizontal direction and a positive value moves the image to the right.
            %
            %   GeometricTranslator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create geometric translator object with same property values
            %   isLocked - Locked status (logical)
            %
            %   GeometricTranslator properties:
            %
            %   OutputSize          - Output size as full or same as input image size
            %   OffsetSource        - Source of specifying offset values
            %   Offset              - Translation values
            %   MaximumOffset       - Maximum number of pixels by which to translate
            %                         image
            %   BackgroundFillValue - Value of pixels outside the image
            %   InterpolationMethod - Interpolation method used to translate image
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.GeometricTranslator.helpFixedPoint.
            %
            %   % EXAMPLE: Translate an image to the right and bottom.
            %      htranslate = vision.GeometricTranslator;
            %      htranslate.OutputSize = 'Same as input image';
            %      htranslate.Offset = [30 30];
            %      I = im2single(imread('cameraman.tif'));
            %      Y = step(htranslate, I);
            %      imshow(Y);
            %
            %   See also vision.GeometricRotator, vision.GeometricTranslator.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.GeometricTranslator System object 
            %               fixed-point information
            %   vision.GeometricTranslator.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   vision.GeometricTranslator System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Same as
        %   product'} | 'Same as first input' | 'Custom']. This property is
        %   applicable when the InterpolationMethod property is either
        %   'Bilinear' or 'Bicubic'.
        AccumulatorDataType;

        %BackgroundFillValue Value of pixels outside image
        %   Specify the value of pixels that are outside the image as a numeric
        %   scalar value or a numeric vector of same length as the third
        %   dimension of input image. The default value of this property is 0.
        %   This property is tunable.
        BackgroundFillValue;

        %CustomAccumulatorDataType Accumulator  word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   InterpolationMethod property is either 'Bilinear' or 'Bicubic', and
        %   the AccumulatorDataType property is 'Custom'. The default value of
        %   this property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOffsetValuesDataType Offset word and fraction lengths
        %   Specify the offset fixed-point type as an auto-signed numerictype
        %   object. This property is applicable when the OffsetValuesDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],16,6).
        %
        %   See also numerictype.
        CustomOffsetValuesDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   InterpolationMethod property is either 'Bilinear' or 'Bicubic', and
        %   the ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomProductDataType;

        %InterpolationMethod Interpolation method used to translate image
        %   Specify the interpolation method used to translate the image as one
        %   of ['Nearest neighbor' | {'Bilinear'} | 'Bicubic']. If this
        %   property is set to 'Nearest neighbor', the object uses the value of
        %   one nearby pixel for the new pixel value. If it is set to
        %   'Bilinear', the new pixel value is the weighted average of the four
        %   nearest pixel values. If it is set to 'Bicubic', the new pixel
        %   value is the weighted average of the sixteen nearest pixel values.
        InterpolationMethod;

        %MaximumOffset Maximum number of pixels by which to translate image
        %   Specify the maximum number of pixels by which to translate the
        %   input image as a two-element real vector with elements greater than
        %   0. This property must have the same data type as the Offset input.
        %   This property is applicable when OutputSize property is 'Full' and
        %   OffsetSource property is 'Input port'. The System object uses this
        %   property to determine the size of the output matrix. If the Offset
        %   input is greater than this property value, the object saturates to
        %   the maximum value. The default value of this property is [8 10].
        MaximumOffset;

        %Offset Translation values
        %   Specify the number of pixels to translate the image as a
        %   two-element offset vector. The first element of the vector
        %   represents a shift in the vertical direction and a positive value
        %   moves the image downward. The second element of the vector
        %   represents a shift in the horizontal direction and a positive value
        %   moves the image to the right. The default value of this property is
        %   [1.5 2.3]. This property is applicable when OffsetSource is set to
        %   'Property'.
        Offset;

        %OffsetSource Source of specifying offset values
        %   Specify how the translation parameters are provided as one of
        %   ['Input port' | {'Property'}]. When the OffsetSource property is
        %   set to 'Input port' a two-element offset vector must be provided to
        %   the System object's step method.
        OffsetSource;

        %OffsetValuesDataType Offset word- and fraction-length designations
        %   Specify the offset fixed-point data type as one of [{'Same word
        %   length as input'} | 'Custom'].
        OffsetValuesDataType;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as first
        %   input'} | 'Custom'].
        OutputDataType;

        %OutputSize Output size as full or same as input image size
        %   Specify the size of output image as one of [{'Full'} | 'Same as
        %   input image']. If this property is set to 'Full', the object
        %   outputs a matrix that contains the translated image values. If it
        %   is set to 'Same as input image', the object outputs a matrix that
        %   is the same size as the input image and contains a portion of the
        %   translated image.
        OutputSize;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of ['Wrap' | {'Saturate'}].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as first
        %   input' | {'Custom'}]. This property is applicable when the
        %   InterpolationMethod property is either 'Bilinear' or 'Bicubic'.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   'Floor' | {'Nearest'} | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

    end
end
