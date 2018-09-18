classdef ImagePadder
%ImagePadder Pad or crop input image
%   HIMPAD = vision.ImagePadder returns an image padder System object,
%   HIMPAD, that performs two-dimensional padding and/or cropping of an
%   input image.
%
%   HIMPAD = vision.ImagePadder('PropertyName', PropertyValue, ...) returns
%   an image padder object, HIMPAD, with each specified property set to the
%   specified value.
%
%   Step method syntax:
%
%   Y = step(HIMPAD, X) performs two-dimensional padding or cropping of
%   input, X.
%
%   Y = step(HIMPAD, X, PAD) performs two-dimensional padding and/or
%   cropping of input, X, using the input PAD as the pad value, when the
%   Method property is 'Constant' and the PaddingValueSource property is
%   'Input port'.
%
%   ImagePadder methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create image padder object with same property values
%   isLocked - Locked status (logical)
%
%   ImagePadder properties:
%
%   Method                 - How to pad input image
%   PaddingValueSource     - How to specify padding value
%   PaddingValue           - Padding value
%   SizeMethod             - How to specify output image size
%   RowPaddingLocation     - Location at which to add rows
%   NumPaddingRows         - Number of rows to add
%   NumOutputRowsSource    - How to specify number of output rows
%   NumOutputRows          - Total number of rows in output
%   ColumnPaddingLocation  - Location at which to add columns
%   NumPaddingColumns      - Number of columns to add
%   NumOutputColumnsSource - How to specify number of output columns
%   NumOutputColumns       - Total number of columns in output
%
%   % EXAMPLE: Pad two rows to the bottom, and three columns to the right
%   % of a matrix, using the value of the last array element as the padding
%   % value.
%       himpad = vision.ImagePadder('Method', 'Replicate', ...
%                               'RowPaddingLocation', 'Bottom', ...
%                               'NumPaddingRows', 2, ...
%                               'ColumnPaddingLocation', 'Right', ...
%                               'NumPaddingColumns', 3);
%       x = [1 2;3 4];
%       y = step(himpad,x);
%
%   See also vision.GeometricScaler.

 
%   Copyright 2004-2011 The MathWorks, Inc.

    methods
        function out=ImagePadder
            %ImagePadder Pad or crop input image
            %   HIMPAD = vision.ImagePadder returns an image padder System object,
            %   HIMPAD, that performs two-dimensional padding and/or cropping of an
            %   input image.
            %
            %   HIMPAD = vision.ImagePadder('PropertyName', PropertyValue, ...) returns
            %   an image padder object, HIMPAD, with each specified property set to the
            %   specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HIMPAD, X) performs two-dimensional padding or cropping of
            %   input, X.
            %
            %   Y = step(HIMPAD, X, PAD) performs two-dimensional padding and/or
            %   cropping of input, X, using the input PAD as the pad value, when the
            %   Method property is 'Constant' and the PaddingValueSource property is
            %   'Input port'.
            %
            %   ImagePadder methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create image padder object with same property values
            %   isLocked - Locked status (logical)
            %
            %   ImagePadder properties:
            %
            %   Method                 - How to pad input image
            %   PaddingValueSource     - How to specify padding value
            %   PaddingValue           - Padding value
            %   SizeMethod             - How to specify output image size
            %   RowPaddingLocation     - Location at which to add rows
            %   NumPaddingRows         - Number of rows to add
            %   NumOutputRowsSource    - How to specify number of output rows
            %   NumOutputRows          - Total number of rows in output
            %   ColumnPaddingLocation  - Location at which to add columns
            %   NumPaddingColumns      - Number of columns to add
            %   NumOutputColumnsSource - How to specify number of output columns
            %   NumOutputColumns       - Total number of columns in output
            %
            %   % EXAMPLE: Pad two rows to the bottom, and three columns to the right
            %   % of a matrix, using the value of the last array element as the padding
            %   % value.
            %       himpad = vision.ImagePadder('Method', 'Replicate', ...
            %                               'RowPaddingLocation', 'Bottom', ...
            %                               'NumPaddingRows', 2, ...
            %                               'ColumnPaddingLocation', 'Right', ...
            %                               'NumPaddingColumns', 3);
            %       x = [1 2;3 4];
            %       y = step(himpad,x);
            %
            %   See also vision.GeometricScaler.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %ColumnPaddingLocation Location at which to add columns
        %   Specify the direction in which to add columns one of ['Left' |
        %   'Right' | {'Both left and right'} | 'None']. Set this property to
        %   'Left' to add additional columns on the left side of the image,
        %   'Right' to add additional columns on the right side of the image,
        %   'Both left and right' to add additional columns on the left and
        %   right side of the image, and 'None' to maintain the column length
        %   of the input image.
        ColumnPaddingLocation;

        %Method How to pad input image
        %   Specify how to pad the input image as one of [{'Constant'} |
        %   'Replicate' | 'Symmetric' | 'Circular'].
        Method;

        %NumOutputColumns Total number of columns in output
        %   Specify the total number of columns in the output as a scalar
        %   integer. If the specified number is smaller than the number of
        %   columns of the input image, then image is cropped. The default
        %   value of this property is 10. This property is applicable when the
        %   SizeMethod property is 'Output size' and the NumOutputColumnsSource
        %   property is 'Property'.
        NumOutputColumns;

        %NumOutputColumnsSource How to specify number of output columns
        %   Indicate how to specify the number of output columns as one of
        %   [{'Property'} | 'Next power of two']. If this property is set to
        %   'Next power of two', the System object adds columns to the input
        %   until the number of columns is equal to a power of two. This
        %   property is applicable when the SizeMethod property is 'Output
        %   size'.
        NumOutputColumnsSource;

        %NumOutputRows Total number of rows in output
        %   Specify the total number of rows in the output as a scalar integer.
        %   If the specified number is smaller than the number of rows of the
        %   input image, then image is cropped. The default value of this
        %   property is 12. This property is applicable when the SizeMethod
        %   property is 'Output size' and the NumOutputRowsSource property is
        %   'Property'.
        NumOutputRows;

        %NumOutputRowsSource How to specify number of output rows
        %   Indicate how to specify the number of output rows as one of
        %   [{'Property'} | 'Next power of two']. If this property is 'Next
        %   power of two', the System object adds rows to the input image until
        %   the number of rows is equal to a power of two. This property is
        %   applicable when the SizeMethod property is 'Output size'.
        NumOutputRowsSource;

        %NumPaddingColumns Number of columns to add
        %   Specify the number of columns to be added to the left, right, or
        %   both sides of the input image as a scalar value. When the
        %   ColumnPaddingLocation property is 'Both left and right', this
        %   property can also be set to a two element vector, where the first
        %   element controls the number of columns the System object adds to
        %   the left side of the image and the second element controls the
        %   number of columns the System object adds to the right side of the
        %   image. The default value of this property is 2. This property is
        %   applicable when the SizeMethod property is 'Pad size' and the
        %   NumPaddingColumns property is not 'None'.
        NumPaddingColumns;

        %NumPaddingRows Number of rows to add
        %   Specify the number of rows to be added to the top, bottom, or both
        %   sides of the input image as a scalar value. When the
        %   RowPaddingLocation property is 'Both top and bottom', this property
        %   can also be set to a two element vector, where the first element
        %   controls the number of rows the System object adds to the top of
        %   the image and the second element controls the number of rows the
        %   System object adds to the bottom of the image. The default value of
        %   this property is [2 3]. This property is applicable when the
        %   SizeMethod property is 'Pad size' and the RowPaddingLocation
        %   property is not 'None'.
        NumPaddingRows;

        %PaddingValue Pad value
        %   Specify the constant scalar value with which to pad the image. This
        %   property is applicable when the Method property is 'Constant' and
        %   the PaddingValueSource property is 'Property'. The default value of
        %   this property is 0. This property is tunable.
        PaddingValue;

        %PaddingValueSource How to specify pad value
        %   Indicate how to specify the pad value as one of [{'Property'} |
        %   'Input port']. This property is applicable when the Method property
        %   is 'Constant'.
        PaddingValueSource;

        %   RowPaddingLocation Location at which to add rows Specify the
        %   direction in which to add rows to as one of ['Top' | 'Bottom' |
        %   {'Both top and bottom'} | 'None']. Set this property to 'Top' to
        %   add additional rows to the top of the image, 'Bottom' to add
        %   additional rows to the bottom of the image, 'Both top and bottom'
        %   to add additional rows to the top and bottom of the image, and
        %   'None' to maintain the row size of the input image.
        RowPaddingLocation;

        %SizeMethod How to specify output image size
        %   Indicate how to pad the input image to obtain the output image by
        %   selecting one of [{'Pad size'} | 'Output size']. When this property
        %   is 'Pad size', the size of the padding in the vertical and
        %   horizontal directions are specified. When this property is 'Output
        %   size', the total number of output rows and output columns are
        %   specified.
        SizeMethod;

    end
end
