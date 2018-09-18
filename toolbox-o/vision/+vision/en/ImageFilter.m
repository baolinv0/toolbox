classdef ImageFilter
%ImageFilter 2-D FIR filtering
%   HIMGFILT = vision.ImageFilter returns a System object, HIMGFILT, that
%   performs two-dimensional FIR filtering of input matrix using the
%   specified filter coefficient matrix.
%
%   HIMGFILT = vision.ImageFilter('PropertyName', PropertyValue, ...)
%   returns an ImageFilter System object, HIMGFILT, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HIMGFILT, I) filters the input image I and returns the
%   filtered image in Y.
%
%   Y = step(HIMGFILT, I, COEFFS) uses filter coefficients, COEFFS, to
%   filter the input image when the CoefficientsSource property is 'Input
%   port' and the SeparableCoefficients property is false.
%
%   Y = step(HIMGFILT, I, HV, HH) uses vertical filter coefficients, HV,
%   and horizontal coefficients, HH, to filter the input image when the
%   CoefficientsSource property is 'Input port' and the
%   SeparableCoefficients property is true.
%
%   Y = step(HIMGFILT, ..., PVAL) uses PVAL for the pad value when the
%   OutputSize property is either 'Full' or 'Same as first input', the
%   PaddingMethod property is 'Constant', and the PaddingValueSource
%   property is 'Input port'.
%
%   ImageFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create image filter object with same property values
%   isLocked - Locked status (logical)
%
%   ImageFilter properties:
%
%   SeparableCoefficients  - Set to true if filter coefficients are separable
%   CoefficientsSource     - Source of filter coefficients
%   Coefficients           - Filter coefficients
%   VerticalCoefficients   - Vertical filter coefficients for separable filter
%   HorizontalCoefficients - Horizontal filter coefficients for separable
%                            filter
%   OutputSize             - Output size as full, valid or same as input size
%   PaddingMethod          - How to pad boundary of input matrix
%   PaddingValueSource     - Source of padding value
%   PaddingValue           - Constant value with which to pad matrix
%   Method                 - Method for filtering input matrix
%
%   This System object supports fixed-point operations. For more
%   information, type vision.ImageFilter.helpFixedPoint.
%
%   % EXAMPLE: Filter an image to enhance the edges of 45 degree and show 
%   %          the before/after.
%      img = im2single(rgb2gray(imread('peppers.png')));
%      hfir2d = vision.ImageFilter;
%      hfir2d.Coefficients = [1 0; 0 -.5];
%      fImg = step(hfir2d, img);
%      subplot(2,1,1);imshow(img);title('Original image')
%      subplot(2,1,2);imshow(fImg);title('Filtered image')
%
%   See also vision.MedianFilter, vision.ImageFilter.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=ImageFilter
            %ImageFilter 2-D FIR filtering
            %   HIMGFILT = vision.ImageFilter returns a System object, HIMGFILT, that
            %   performs two-dimensional FIR filtering of input matrix using the
            %   specified filter coefficient matrix.
            %
            %   HIMGFILT = vision.ImageFilter('PropertyName', PropertyValue, ...)
            %   returns an ImageFilter System object, HIMGFILT, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HIMGFILT, I) filters the input image I and returns the
            %   filtered image in Y.
            %
            %   Y = step(HIMGFILT, I, COEFFS) uses filter coefficients, COEFFS, to
            %   filter the input image when the CoefficientsSource property is 'Input
            %   port' and the SeparableCoefficients property is false.
            %
            %   Y = step(HIMGFILT, I, HV, HH) uses vertical filter coefficients, HV,
            %   and horizontal coefficients, HH, to filter the input image when the
            %   CoefficientsSource property is 'Input port' and the
            %   SeparableCoefficients property is true.
            %
            %   Y = step(HIMGFILT, ..., PVAL) uses PVAL for the pad value when the
            %   OutputSize property is either 'Full' or 'Same as first input', the
            %   PaddingMethod property is 'Constant', and the PaddingValueSource
            %   property is 'Input port'.
            %
            %   ImageFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create image filter object with same property values
            %   isLocked - Locked status (logical)
            %
            %   ImageFilter properties:
            %
            %   SeparableCoefficients  - Set to true if filter coefficients are separable
            %   CoefficientsSource     - Source of filter coefficients
            %   Coefficients           - Filter coefficients
            %   VerticalCoefficients   - Vertical filter coefficients for separable filter
            %   HorizontalCoefficients - Horizontal filter coefficients for separable
            %                            filter
            %   OutputSize             - Output size as full, valid or same as input size
            %   PaddingMethod          - How to pad boundary of input matrix
            %   PaddingValueSource     - Source of padding value
            %   PaddingValue           - Constant value with which to pad matrix
            %   Method                 - Method for filtering input matrix
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.ImageFilter.helpFixedPoint.
            %
            %   % EXAMPLE: Filter an image to enhance the edges of 45 degree and show 
            %   %          the before/after.
            %      img = im2single(rgb2gray(imread('peppers.png')));
            %      hfir2d = vision.ImageFilter;
            %      hfir2d.Coefficients = [1 0; 0 -.5];
            %      fImg = step(hfir2d, img);
            %      subplot(2,1,1);imshow(img);title('Original image')
            %      subplot(2,1,2);imshow(fImg);title('Filtered image')
            %
            %   See also vision.MedianFilter, vision.ImageFilter.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.ImageFilter System object fixed-point 
            %               information
            %   vision.ImageFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.ImageFilter
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
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Same as
        %   product'} | 'Same as input' | 'Custom'].
        AccumulatorDataType;

        %Coefficients Filter coefficients
        %   Specify the filter coefficients as a real or complex-valued matrix.
        %   This property is applicable when the SeparableCoefficients property
        %   is false and the CoefficientsSource property is 'Property'. The
        %   default value of this property is [1 0; 0 -1].  This property is
        %   tunable.
        Coefficients;

        %CoefficientsDataType Coefficients word- and fraction-length designations
        %   Specify the coefficients fixed-point data type as one of ['Same
        %   word length as input' | {'Custom'}]. This property is applicable
        %   when the CoefficientsSource property is 'Property'.
        CoefficientsDataType;

        %CoefficientsSource Source of filter coefficients
        %   Indicate how to specify the filter coefficients as one of
        %   [{'Property'} | 'Input port'].
        CoefficientsSource;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomCoefficientsDataType Coefficients word and fraction lengths
        %   Specify the coefficients fixed-point type as a signed or unsigned
        %   numerictype object. This property is applicable when the
        %   CoefficientsSource property is 'Property' and the
        %   CoefficientsDataType property is 'Custom'. The default value of
        %   this property is numerictype(true,16).
        %
        %   See also numerictype.
        CustomCoefficientsDataType;

        %CustomOutputDataType Output word and fraction lengths        
        %   Specify the output fixed-point type as a scaled numerictype object.
        %   This property is applicable when the OutputDataType property is
        %   'Custom'. The default value of this property is
        %   numerictype([],32,12).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,10).
        %
        %   See also numerictype.
        CustomProductDataType;

        %HorizontalCoefficients Horizontal filter coefficients for the separable
        %                       filter
        %   Specify the horizontal filter coefficients for the separable filter
        %   as a vector. This property is applicable when the
        %   SeparableCoefficients property is true and the CoefficientsSource
        %   property is 'Property'. The default value of this property is [4
        %   0]. This property is tunable.
        HorizontalCoefficients;

        %Method Method for filtering input matrix
        %   Specify the method by which the object filters the input matrix as
        %   one of [{'Convolution'} | 'Correlation'].
        Method;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   input'} | 'Custom'].
        OutputDataType;

        %OutputSize Output size as full, valid or same as input image size
        %   Specify how to control the size of the output as one of [{'Full'} |
        %   'Same as first input' | 'Valid']. If this property is set to
        %   'Full', the dimensions of the output image are as follows:
        %      output rows    = input rows    + filter coefficient rows    - 1 
        %      output columns = input columns + filter coefficient columns - 1 
        %   If this property is set to 'Same as first input', the output has
        %   the same dimensions as the input image. If this property is set to
        %   'Valid', the object filters the input image only where the
        %   coefficient matrix fits entirely within it, so no padding is
        %   required. In this case, the dimensions of the output image are as
        %   follows:
        %      output rows    = input rows    - filter coefficient rows    - 1 
        %      output columns = input columns - filter coefficient columns - 1 
        OutputSize;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %PaddingMethod How to pad boundary of input matrix
        %   Specify how to pad the boundary of input matrix as one of
        %   [{'Constant'} | 'Replicate' | 'Symmetric' | 'Circular']. Set this
        %   property to 
        %     * 'Constant' to pad the input matrix with a constant value;
        %     * 'Replicate' to pad the input matrix by repeating its border 
        %        values;
        %     * 'Symmetric' to pad the input matrix with its mirror image;
        %     * 'Circular' to pad the input matrix using a circular repetition 
        %        of its elements. 
        %   This property is applicable when the OutputSize property is 'Full'
        %   or 'Same as first input'.
        PaddingMethod;

        %PaddingValue Constant value with which to pad matrix
        %   Specify a constant value with which to pad the input matrix. This
        %   property is applicable when the PaddingMethod property is
        %   'Constant' and the PaddingValueSource property is 'Property'. The
        %   default value of this property is 0. This property is tunable.
        PaddingValue;

        %PaddingValueSource Source of padding value
        %   Specify how to define the constant boundary value as one of
        %   [{'Property'} | 'Input port']. This property is applicable when the
        %   PaddingMethod property is 'Constant'.
        PaddingValueSource;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as
        %   input' | {'Custom'}].
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %SeparableCoefficients Set to true if filter coefficients are separable
        %   Using separable filter coefficients reduces the amount of
        %   calculations the object must perform to compute the output. The
        %   function isfilterseparable can be used to check filter
        %   separability. The default value of this property is false.
        %
        %   See also isfilterseparable.
        SeparableCoefficients;

        %VerticalCoefficients Vertical filter coefficients for the separable filter
        %   Specify the vertical filter coefficients for the separable filter
        %   as a vector. This property is applicable when the
        %   SeparableCoefficients property is true and the CoefficientsSource
        %   property is 'Property'. The default value of this property is 
        %   [4 0]. This property is tunable.
        VerticalCoefficients;

    end
end
