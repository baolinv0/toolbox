classdef GeometricScaler
%GeometricScaler Enlarge or shrink image sizes
%   HGS = vision.GeometricScaler returns a System object, HGS, that changes
%   the size of an image or a region of interest within an image.
%
%   HGS = vision.GeometricScaler('PropertyName', PropertyValue, ...)
%   returns a geometric scaler object, HGS, with each specified property
%   set to the specified value.
%
%   Step method syntax:
%
%   J = step(HGS, I) returns a resized image, J, of input image I.
%
%   J = step(HGS, I, ROI) resizes a particular region of the image I
%   defined by the ROI specified as [x y width height], where [x y] is
%   the upper left corner of the ROI. This option is possible when 
%   the SizeMethod property is 'Number of output rows and columns', 
%   the Antialiasing property is false, the InterpolationMethod property 
%   is one of 'Bilinear', 'Bicubic' or 'Nearest neighbor', and 
%   the ROIProcessing property is true.
%
%   [J, FLAG] = step(HGS, I, ROI) also returns FLAG which indicates whether
%   the given region of interest is within the image bounds. This is
%   possible when the SizeMethod property is 'Number of output rows and
%   columns', the Antialiasing property is false, the InterpolationMethod
%   property is one of 'Bilinear', 'Bicubic' or 'Nearest neighbor' and, the
%   ROIProcessing and the ROIValidityOutputPort properties are both true.
%
%   GeometricScaler methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create geometric scaler object with same property values
%   isLocked - Locked status (logical)
%
%   GeometricScaler properties:
%
%   SizeMethod            - Aspects of image to resize
%   ResizeFactor          - Percentage by which to resize rows and columns
%   NumOutputColumns      - Number of columns in output image
%   NumOutputRows         - Number of rows in output image
%   Size                  - Dimensions of output image
%   InterpolationMethod   - Interpolation method used to resize image
%   Antialiasing          - Enables low-pass filtering when shrinking image
%   ROIProcessing         - Enables region-of-interest processing
%   ROIValidityOutputPort - Enables indication that ROI is outside input
%                           image
%
%   This System object supports fixed-point operations. For more
%   information, type vision.GeometricScaler.helpFixedPoint.
%
%   % EXAMPLE: Use the GeometricScaler object to enlarge an image.
%       I = imread('cameraman.tif');
%       hgs = vision.GeometricScaler('ResizeFactor',135);
%       J = step(hgs, I);
%       imshow(I); title(' Original Image');
%       figure, imshow(J); title('Resized Image');
%
%   See also vision.Pyramid, vision.GeometricRotator, 
%            vision.GeometricTranslator.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=GeometricScaler
            %GeometricScaler Enlarge or shrink image sizes
            %   HGS = vision.GeometricScaler returns a System object, HGS, that changes
            %   the size of an image or a region of interest within an image.
            %
            %   HGS = vision.GeometricScaler('PropertyName', PropertyValue, ...)
            %   returns a geometric scaler object, HGS, with each specified property
            %   set to the specified value.
            %
            %   Step method syntax:
            %
            %   J = step(HGS, I) returns a resized image, J, of input image I.
            %
            %   J = step(HGS, I, ROI) resizes a particular region of the image I
            %   defined by the ROI specified as [x y width height], where [x y] is
            %   the upper left corner of the ROI. This option is possible when 
            %   the SizeMethod property is 'Number of output rows and columns', 
            %   the Antialiasing property is false, the InterpolationMethod property 
            %   is one of 'Bilinear', 'Bicubic' or 'Nearest neighbor', and 
            %   the ROIProcessing property is true.
            %
            %   [J, FLAG] = step(HGS, I, ROI) also returns FLAG which indicates whether
            %   the given region of interest is within the image bounds. This is
            %   possible when the SizeMethod property is 'Number of output rows and
            %   columns', the Antialiasing property is false, the InterpolationMethod
            %   property is one of 'Bilinear', 'Bicubic' or 'Nearest neighbor' and, the
            %   ROIProcessing and the ROIValidityOutputPort properties are both true.
            %
            %   GeometricScaler methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create geometric scaler object with same property values
            %   isLocked - Locked status (logical)
            %
            %   GeometricScaler properties:
            %
            %   SizeMethod            - Aspects of image to resize
            %   ResizeFactor          - Percentage by which to resize rows and columns
            %   NumOutputColumns      - Number of columns in output image
            %   NumOutputRows         - Number of rows in output image
            %   Size                  - Dimensions of output image
            %   InterpolationMethod   - Interpolation method used to resize image
            %   Antialiasing          - Enables low-pass filtering when shrinking image
            %   ROIProcessing         - Enables region-of-interest processing
            %   ROIValidityOutputPort - Enables indication that ROI is outside input
            %                           image
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.GeometricScaler.helpFixedPoint.
            %
            %   % EXAMPLE: Use the GeometricScaler object to enlarge an image.
            %       I = imread('cameraman.tif');
            %       hgs = vision.GeometricScaler('ResizeFactor',135);
            %       J = step(hgs, I);
            %       imshow(I); title(' Original Image');
            %       figure, imshow(J); title('Resized Image');
            %
            %   See also vision.Pyramid, vision.GeometricRotator, 
            %            vision.GeometricTranslator.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.GeometricScaler System object
            %               fixed-point information
            %   vision.GeometricScaler.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   vision.GeometricScaler System object.
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
        %   product'} | 'Same as input' | 'Custom'].
        AccumulatorDataType;

        %Antialiasing Enables low-pass filtering when shrinking image
        %   Set this property to true to perform low-pass filtering on the
        %   input image before shrinking it, to prevent aliasing when
        %   ResizeFactor is between 0 and 100 percent.
        Antialiasing;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomInterpolationWeightsDataType Interpolation weights word and
        %                                   fraction lengths
        %   Specify the interpolation weights fixed-point type as an auto-signed
        %   unscaled numerictype object. This property is applicable when the
        %   InterpolationWeightsDataType property is 'Custom'. The default
        %   value of this property is numerictype([],32).
        %
        %   See also numerictype.
        CustomInterpolationWeightsDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomProductDataType;

        %InterpolationMethod Interpolation method used to resize the image
        %   Specify the interpolation method to resize the image as one of
        %   ['Nearest neighbor' | {'Bilinear'} | 'Bicubic' | 'Lanczos2' |
        %   'Lanczos3']. If this property is set to 'Nearest neighbor', the
        %   object uses one nearby pixel to interpolate the pixel value. If it
        %   is set to 'Bilinear', the object uses four nearby pixels to
        %   interpolate the pixel value. If it is set to 'Bicubic' or
        %   'Lanczos2', the object uses sixteen nearby pixels to interpolate
        %   the pixel value. If it is set to 'Lanczos3', the object uses thirty
        %   six surrounding pixels to interpolate the pixel value.
        InterpolationMethod;

        %InterpolationWeightsDataType Interpolation weights word- and
        %                             fraction-length designations
        %   Specify the interpolation weights fixed-point data type as one of
        %   [{'Same word length as input'} | 'Custom']. 
        %   This property is applicable under any of the following conditions:
        %   *  If the InterpolationMethod property is set to any one of
        %   'Bicubic', 'Lanczos2' and 'Lanczos3'. 
        %   * If the SizeMethod property is set to any value other than 'Output
        %   size as a percentage of input size'.
        %   * If the SizeMethod property is 'Output size as a percentage of
        %   input size' and if the InterpolationMethod property is 'Bilinear'
        %   or 'Nearest neighbor' and if any of the elements of the
        %   ResizeFactor is less than 100, implying shrinking the input image,
        %   and if the Antialiasing property is true.
        InterpolationWeightsDataType;

        %NumOutputColumns Number of columns in output image
        %   Specify the number of columns of the output image as a positive
        %   integer scalar value. This property is applicable when the
        %   SizeMethod property is 'Number of output columns and preserve
        %   aspect ratio'. The default value of this property is 25.
        NumOutputColumns;

        %NumOutputRows Number of rows in output image
        %   Specify the number of rows of the output image as a positive
        %   integer scalar value. This property is applicable when the
        %   SizeMethod property is 'Number of output rows and preserve aspect
        %   ratio'. The default value of this property is 25.
        NumOutputRows;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   input'} | 'Custom'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of ['Wrap' | {'Saturate'}].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as
        %   input' | {'Custom'}].
        ProductDataType;

        %ROIProcessing Enables region-of-interest processing
        %   Indicate whether to resize a particular region of each input image.
        %   This property is applicable when the SizeMethod property is 'Number
        %   of output rows and columns', the InterpolationMethod property is
        %   'Nearest neighbor', 'Bilinear', or 'Bicubic', and the Antialiasing
        %   property is false. The default value is false.
        ROIProcessing;

        %ROIValidityOutputPort Enables indication that ROI is outside input
        %                      image
        %   Indicate whether to return the validity of the specified ROI being
        %   completely inside image. This property is applicable when the
        %   ROIProcessing property is true. The default value is false.
        ROIValidityOutputPort;

        %ResizeFactor Percentage by which to resize rows and columns
        %   Set this property to a scalar percentage value that is applied to
        %   both rows and columns or a two-element vector, where the first
        %   element is the percentage by which to resize the rows and the
        %   second element is the percentage by which to resize the columns.
        %   This property is applicable when the SizeMethod property is 'Output
        %   size as a percentage of input size'. The default value of this
        %   property is [200 150].
        ResizeFactor;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   'Floor' | {'Nearest'} | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %Size Dimensions of output image
        %   Set this property to a two-element vector, where the first element
        %   is the number of rows in the output image and the second element is
        %   the number of columns. This property is applicable when the
        %   SizeMethod property is 'Number of output rows and columns'. The
        %   default value of this property is [25 35].
        Size;

        %SizeMethod Aspects of image to resize
        %   Specify which aspects of the input image to resize as one of
        %   [{'Output size as a percentage of input size'} | 'Number of output
        %   columns and preserve aspect ratio' | 'Number of output rows and
        %   preserve aspect ratio' | 'Number of output rows and columns'].
        SizeMethod;

    end
end
