classdef MedianFilter
%MedianFilter 2-D median filtering
%   HMEDIANFILT = vision.MedianFilter returns a System object, HMEDIANFILT,
%   that performs two-dimensional median filtering of an input matrix.
%
%   HMEDIANFILT = vision.MedianFilter('PropertyName', PropertyValue, ...)
%   returns a median filter System object, HMEDIANFILT, with each specified
%   property set to the specified value.
%
%   HMEDIANFILT = video.MedianFilter(SIZE, 'PropertyName', 
%   PropertyValue, ...) returns a median filter System object, HMEDIANFILT,
%   with the NeighborhoodSize property set to SIZE and other specified
%   properties set to the specified values.
%
%   Step method syntax:
%
%   I2 = step(HMEDIANFILT, I1) performs median filtering on input image I1
%   and returns the filtered image I2.
%
%   I2 = step(HMEDIANFILT, I1, PVAL) performs median filtering on input
%   image I1, using PVAL for the padding value. This option is available
%   when the OutputSize property is 'Same as input size', the PaddingChoice
%   property is 'Constant', and the PaddingValueSource property is 'Input
%   port'.
%
%   MedianFilter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create median filter object with same property values
%   isLocked - Locked status (logical)
%
%   MedianFilter properties:
%
%   NeighborhoodSize   - Size of neighborhood to compute the median
%   OutputSize         - Output size as valid or same as input image size
%   PaddingMethod      - How to pad boundary of input matrix
%   PaddingValueSource - How to specify constant boundary value
%   PaddingValue       - Constant value with which to pad matrix
%
%   This System object supports fixed-point properties when the
%   NeighborhoodSize property is of even size. For more information, type
%   vision.MedianFilter.helpFixedPoint.
%
%   EXAMPLE: Perform median filtering on an image of peppers.
%   ---------------------------------------------------------   
%   I = imread('pout.tif');
%   I = imnoise(I, 'salt & pepper'); % add noise
%    
%   medianFilter = vision.MedianFilter([5 5]);
%   I_filtered = step(medianFilter, I);
%
%   figure; imshowpair(I, I_filtered, 'montage'); 
%   title('Noisy image on the left and filtered image on the right');
%
%   See also vision.ImageFilter, vision.MedianFilter.helpFixedPoint,
%            medfilt2

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=MedianFilter
            %MedianFilter 2-D median filtering
            %   HMEDIANFILT = vision.MedianFilter returns a System object, HMEDIANFILT,
            %   that performs two-dimensional median filtering of an input matrix.
            %
            %   HMEDIANFILT = vision.MedianFilter('PropertyName', PropertyValue, ...)
            %   returns a median filter System object, HMEDIANFILT, with each specified
            %   property set to the specified value.
            %
            %   HMEDIANFILT = video.MedianFilter(SIZE, 'PropertyName', 
            %   PropertyValue, ...) returns a median filter System object, HMEDIANFILT,
            %   with the NeighborhoodSize property set to SIZE and other specified
            %   properties set to the specified values.
            %
            %   Step method syntax:
            %
            %   I2 = step(HMEDIANFILT, I1) performs median filtering on input image I1
            %   and returns the filtered image I2.
            %
            %   I2 = step(HMEDIANFILT, I1, PVAL) performs median filtering on input
            %   image I1, using PVAL for the padding value. This option is available
            %   when the OutputSize property is 'Same as input size', the PaddingChoice
            %   property is 'Constant', and the PaddingValueSource property is 'Input
            %   port'.
            %
            %   MedianFilter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create median filter object with same property values
            %   isLocked - Locked status (logical)
            %
            %   MedianFilter properties:
            %
            %   NeighborhoodSize   - Size of neighborhood to compute the median
            %   OutputSize         - Output size as valid or same as input image size
            %   PaddingMethod      - How to pad boundary of input matrix
            %   PaddingValueSource - How to specify constant boundary value
            %   PaddingValue       - Constant value with which to pad matrix
            %
            %   This System object supports fixed-point properties when the
            %   NeighborhoodSize property is of even size. For more information, type
            %   vision.MedianFilter.helpFixedPoint.
            %
            %   EXAMPLE: Perform median filtering on an image of peppers.
            %   ---------------------------------------------------------   
            %   I = imread('pout.tif');
            %   I = imnoise(I, 'salt & pepper'); % add noise
            %    
            %   medianFilter = vision.MedianFilter([5 5]);
            %   I_filtered = step(medianFilter, I);
            %
            %   figure; imshowpair(I, I_filtered, 'montage'); 
            %   title('Noisy image on the left and filtered image on the right');
            %
            %   See also vision.ImageFilter, vision.MedianFilter.helpFixedPoint,
            %            medfilt2
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.MedianFilter System object 
            %               fixed-point information
            %   vision.MedianFilter.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.MedianFilter
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
        %   input'} | 'Custom']. This property is applicable when the
        %   NeighborhoodSize property corresponds to even neighborhood options.
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom' and the NeighborhoodSize
        %   property corresponds to even neighborhood options. The default
        %   value of this property is numerictype([],32,30).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom' and the NeighborhoodSize
        %   property corresponds to even neighborhood options. The default
        %   value of this property is numerictype([],16,15).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %NeighborhoodSize Size of neighborhood to compute the median 
        %   Specify the size of the neighborhood over which the object computes
        %   the median. This property can be set to a scalar value that
        %   represents the number of rows and columns in a square matrix or a
        %   two-element vector that represents the number of rows and columns
        %   in a rectangular matrix. When both neighborhood dimensions are odd,
        %   fixed-point properties are not supported. The default value of this
        %   property is [3 3].
        NeighborhoodSize;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as one of [{'Same as
        %   input'} | 'Custom']. This property is applicable when the
        %   NeighborhoodSize property corresponds to even neighborhood options.
        OutputDataType;

        %OutputSize Output size as 'Valid' or 'Same as input size' 
        %   Specify how to control the size of the output as one of [{'Same as
        %   input size'} | 'Valid']. If this property is set to 'Valid', the
        %   object only computes the median where the neighborhood fits
        %   entirely within the input image, so no padding is required. In this
        %   case, the dimensions of the output image are as follows: 
        %      output rows    = input rows    - neighborhood rows    + 1 
        %      output columns = input columns - neighborhood columns + 1  
        %   Otherwise, the output has the same dimensions as the input image.
        OutputSize;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the NeighborhoodSize property
        %   corresponds to even neighborhood options.
        OverflowAction;

        %PaddingMethod How to pad boundary of input matrix
        %   Specify how to pad the boundary of the input matrix as one of
        %   [{'Constant'} | 'Replicate' | 'Symmetric' | 'Circular']. Set this
        %   property to:
        %   'Constant'  to pad the matrix with a constant value,
        %   'Replicate' to pad the input matrix by repeating its border values,
        %   'Symmetric' to pad the input matrix with its mirror image, and
        %   'Circular'  to pad the input matrix using a circular repetition of
        %               its elements. 
        %   This property is applicable when the OutputSize property is 'Same
        %   as input size'.
        PaddingMethod;

        %PaddingValue Constant value with which to pad matrix
        %   Specify a constant value with which to pad the input matrix. This
        %   property is applicable when the PaddingMethod property is
        %   'Constant' and the PaddingValueSource property is 'Property'. The
        %   default value of this property is 0. This property is tunable.
        PaddingValue;

        %PaddingValueSource How to specify constant boundary value
        %   Specify how to define the constant boundary value as one of
        %   [{'Property'} | 'Input port']. This property is applicable when the
        %   PaddingMethod property is 'Constant'.
        PaddingValueSource;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the NeighborhoodSize property
        %   corresponds to even neighborhood options.
        RoundingMethod;

    end
end
