classdef GeometricRotator
%GeometricRotator Rotate image by specified angle
%   HROTATE = vision.GeometricRotator returns a geometric rotator System
%   object, HROTATE, that rotates an image by an angle specified in
%   radians.
%
%   HROTATE = vision.GeometricRotator('PropertyName', PropertyValue, ...)
%   returns a geometric rotator object, HROTATE, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HROTATE, IMG) returns a rotated image Y, with the rotation
%   angle specified by the Angle property.
%
%   Y = step(HROTATE, IMG, ANGLE) uses input ANGLE as the angle to rotate
%   the input IMG when the AngleSource property is 'Input port'.
%
%   GeometricRotator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create geometric rotator object with same property values
%   isLocked - Locked status (logical)
%
%   GeometricRotator properties:
%
%   OutputSize           - Output size as full or same as input image size
%   AngleSource          - Source of angle
%   Angle                - Rotation angle value (radians)
%   MaximumAngle         - Maximum angle by which to rotate image
%   RotatedImageLocation - How the image is rotated
%   SineComputation      - How to calculate the rotation
%   BackgroundFillValue  - Value of pixels outside image
%   InterpolationMethod  - Interpolation method used to rotate image
%
%   This System object supports fixed-point operations when the
%   SineComputation property is 'Table lookup'. For more information, type
%   vision.GeometricRotator.helpFixedPoint.
%
%   % EXAMPLE #1: Rotate peppers.png 90 degrees (pi/2 radians).
%       hrotate1 = vision.GeometricRotator;
%       hrotate1.Angle = pi / 2;
%       img1 = im2double(rgb2gray(imread('peppers.png')));
%       rotimg1 = step(hrotate1, img1); % rotimg1 contains img1 rotated
%       imshow(rotimg1);
%
%   % By setting the AngleSource property to 'Input port', the
%   % rotation angle is passed as input.
%
%   % EXAMPLE #2: Rotate onion.png, giving the rotation angle as an input
%       hrotate2 = vision.GeometricRotator;
%       hrotate2.AngleSource = 'Input port';
%       img2 = im2double(rgb2gray(imread('onion.png')));
%       rotimg2 = step(hrotate2, img2, pi/4);% rotimg2 contains img2 rotated
%       imshow(rotimg2);
%
%   See also vision.GeometricTranslator, vision.GeometricScaler,
%            vision.GeometricRotator.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=GeometricRotator
            %GeometricRotator Rotate image by specified angle
            %   HROTATE = vision.GeometricRotator returns a geometric rotator System
            %   object, HROTATE, that rotates an image by an angle specified in
            %   radians.
            %
            %   HROTATE = vision.GeometricRotator('PropertyName', PropertyValue, ...)
            %   returns a geometric rotator object, HROTATE, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HROTATE, IMG) returns a rotated image Y, with the rotation
            %   angle specified by the Angle property.
            %
            %   Y = step(HROTATE, IMG, ANGLE) uses input ANGLE as the angle to rotate
            %   the input IMG when the AngleSource property is 'Input port'.
            %
            %   GeometricRotator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create geometric rotator object with same property values
            %   isLocked - Locked status (logical)
            %
            %   GeometricRotator properties:
            %
            %   OutputSize           - Output size as full or same as input image size
            %   AngleSource          - Source of angle
            %   Angle                - Rotation angle value (radians)
            %   MaximumAngle         - Maximum angle by which to rotate image
            %   RotatedImageLocation - How the image is rotated
            %   SineComputation      - How to calculate the rotation
            %   BackgroundFillValue  - Value of pixels outside image
            %   InterpolationMethod  - Interpolation method used to rotate image
            %
            %   This System object supports fixed-point operations when the
            %   SineComputation property is 'Table lookup'. For more information, type
            %   vision.GeometricRotator.helpFixedPoint.
            %
            %   % EXAMPLE #1: Rotate peppers.png 90 degrees (pi/2 radians).
            %       hrotate1 = vision.GeometricRotator;
            %       hrotate1.Angle = pi / 2;
            %       img1 = im2double(rgb2gray(imread('peppers.png')));
            %       rotimg1 = step(hrotate1, img1); % rotimg1 contains img1 rotated
            %       imshow(rotimg1);
            %
            %   % By setting the AngleSource property to 'Input port', the
            %   % rotation angle is passed as input.
            %
            %   % EXAMPLE #2: Rotate onion.png, giving the rotation angle as an input
            %       hrotate2 = vision.GeometricRotator;
            %       hrotate2.AngleSource = 'Input port';
            %       img2 = im2double(rgb2gray(imread('onion.png')));
            %       rotimg2 = step(hrotate2, img2, pi/4);% rotimg2 contains img2 rotated
            %       imshow(rotimg2);
            %
            %   See also vision.GeometricTranslator, vision.GeometricScaler,
            %            vision.GeometricRotator.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.GeometricRotator System object
            %               fixed-point information
            %   vision.GeometricRotator.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   vision.GeometricRotator System object.
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
        %   applicable when the SineComputation property is 'Table lookup'.
        AccumulatorDataType;

        %Angle Rotation angle value (radians)
        %   Set this property to a real, scalar value for the rotation angle
        %   (radians). This property is applicable when AngleSource property is
        %   'Property'. The default value of this property is pi/6.
        Angle;

        %AngleDataType Angle word- and fraction-length designations
        %   Specify the angle fixed-point data type as one of [{'Same word
        %   length as input'} | 'Custom']. This property is applicable when the
        %   SineComputation property is 'Table lookup', and the AngleSource
        %   property is 'Property'.
        AngleDataType;

        %AngleSource Source of angle
        %   Specify how to specify the rotation angle as one of [{'Property'} |
        %   'Input port'].
        AngleSource;

        %BackgroundFillValue Value of pixels outside image
        %   Specify the value of pixels that are outside the image as a numeric
        %   scalar value or a numeric vector of same length as the third
        %   dimension of input image. The default value of this property is 0.
        %   This property is tunable.
        BackgroundFillValue;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   SineComputation property is 'Table lookup', and the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomAngleDataType Angle word and fraction lengths
        %   Specify the angle fixed-point type as an auto-signed numerictype
        %   object. This property is applicable when the SineComputation
        %   property is 'Table lookup', the AngleSource property is 'Property'
        %   and the AngleDataType property is 'Custom'. The default value of
        %   this property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomAngleDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   SineComputation property is 'Table lookup', and the OutputDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],32,10).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   SineComputation property is 'Table lookup', and the ProductDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],32,10).
        %
        %   See also numerictype.
        CustomProductDataType;

        %InterpolationMethod Interpolation method used to rotate image
        %   Specify the interpolation method used to rotate the image as one of
        %   ['Nearest neighbor' | {'Bilinear'} | 'Bicubic']. If this property
        %   is set to 'Nearest neighbor', the object uses the value of one
        %   nearby pixel for the new pixel value. If it is set to 'Bilinear',
        %   the new pixel value is the weighted average of the four nearest
        %   pixel values. If it is set to 'Bicubic', the new pixel value is the
        %   weighted average of the sixteen nearest pixel values.
        InterpolationMethod;

        %MaximumAngle Maximum angle by which to rotate image
        %   Specify the maximum angle by which to rotate the input image as a
        %   numeric scalar value greater than 0. This property is applicable
        %   when AngleSource property is 'Input port'. The default value of
        %   this property is pi.
        MaximumAngle;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as first
        %   input'} | 'Custom']. This property is applicable when the
        %   SineComputation property is 'Table lookup'.
        OutputDataType;

        %OutputSize Output size as full or same as input image size
        %   Specify the size of output image as one of [{'Expanded to fit
        %   rotated input image'} | 'Same as input image']. If this property is
        %   set to 'Expanded to fit rotated input image', the object outputs a
        %   matrix that contains all the rotated image values. If it is set to
        %   'Same as input image', the object outputs a matrix that contains
        %   the middle part of the rotated image.
        OutputSize;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of ['Wrap' | {'Saturate'}]. This
        %   property is applicable when the SineComputation property is 'Table
        %   lookup'.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as first
        %   input' | {'Custom'}]. This property is applicable when the
        %   SineComputation property is 'Table lookup'.
        ProductDataType;

        %RotatedImageLocation How the image is rotated
        %   Specify how the image is rotated as one of ['Top-left corner' |
        %   {'Center'}]. If this property is set to 'Center', the image is
        %   rotated about its center point. If it is set to 'Top-left corner',
        %   the object rotates the image so that two corners of the input image
        %   are always in contact with the top and left side of the output
        %   image. This property is applicable when the OutputSize property is
        %   'Expanded to fit rotated input image', and, the 'AngleSource'
        %   property is 'Input port'.
        RotatedImageLocation;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   'Floor' | {'Nearest'} | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the SineComputation property is 'Table
        %   lookup'.
        RoundingMethod;

        %SineComputation How to calculate the rotation
        %   Specify how to calculate the rotation as one of ['Trigonometric
        %   function' | {'Table lookup'}]. If this property is set to
        %   'Trigonometric function', the object computes sine and cosine
        %   values it needs to calculate the rotation of the input image. If it
        %   is set to 'Table lookup', the object computes and stores the
        %   trigonometric values it needs to calculate the rotation of the
        %   input image in a table and uses the table for each step call. In
        %   this case, the object requires extra memory.
        SineComputation;

    end
end
