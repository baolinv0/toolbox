classdef ImageDataTypeConverter
%ImageDataTypeConverter Convert and scale input image to specified output data type
%   HIDTYPECONV = vision.ImageDataTypeConverter returns a System
%   object, HIDTYPECONV, that converts and scales input image to specified
%   output data type. When converting between floating-point data types,
%   the object casts the input into the output data type and clips values
%   outside the range to 0 or 1. When converting between all other data
%   types, the object casts the input into the output data type and scales
%   the data type values into the dynamic range of the output data type.
%   For double- and single-precision floating-point data types, the dynamic
%   range is between 0 and 1. For fixed-point data types, the dynamic range
%   is between the minimum and maximum values that can be represented by
%   the data type.
%
%   HIDTYPECONV = vision.ImageDataTypeConverter('PropertyName',
%   PropertyValue, ...) returns an image data type conversion object,
%   HIDTYPECONV, with each specified property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HIDTYPECONV, X) converts the input image X to Y. The data type
%   of Y is specified by the OutputDataType property.
%
%   ImageDataTypeConverter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create image data type conversion object with same property
%              values
%   isLocked - Locked status (logical)
%
%   ImageDataTypeConverter properties:
%
%   OutputDataType - Data type of output
%
%   This System object supports fixed-point operations. For more
%   information, type vision.ImageDataTypeConverter.helpFixedPoint.
%
%   % EXAMPLE: Convert the image datatype from uint8 to single.
%       x = imread('pout.tif');
%       hidtypeconv = vision.ImageDataTypeConverter;
%       y = step(hidtypeconv, x);
%       imshow(y);
%       whos y % Image has been converted from uint8 to single.
%
%   See also vision.ColorSpaceConverter,
%            vision.ImageDataTypeConverter.helpFixedPoint.

 
%   Copyright 2008-2010 The MathWorks, Inc.

    methods
        function out=ImageDataTypeConverter
            %ImageDataTypeConverter Convert and scale input image to specified output data type
            %   HIDTYPECONV = vision.ImageDataTypeConverter returns a System
            %   object, HIDTYPECONV, that converts and scales input image to specified
            %   output data type. When converting between floating-point data types,
            %   the object casts the input into the output data type and clips values
            %   outside the range to 0 or 1. When converting between all other data
            %   types, the object casts the input into the output data type and scales
            %   the data type values into the dynamic range of the output data type.
            %   For double- and single-precision floating-point data types, the dynamic
            %   range is between 0 and 1. For fixed-point data types, the dynamic range
            %   is between the minimum and maximum values that can be represented by
            %   the data type.
            %
            %   HIDTYPECONV = vision.ImageDataTypeConverter('PropertyName',
            %   PropertyValue, ...) returns an image data type conversion object,
            %   HIDTYPECONV, with each specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HIDTYPECONV, X) converts the input image X to Y. The data type
            %   of Y is specified by the OutputDataType property.
            %
            %   ImageDataTypeConverter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create image data type conversion object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   ImageDataTypeConverter properties:
            %
            %   OutputDataType - Data type of output
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.ImageDataTypeConverter.helpFixedPoint.
            %
            %   % EXAMPLE: Convert the image datatype from uint8 to single.
            %       x = imread('pout.tif');
            %       hidtypeconv = vision.ImageDataTypeConverter;
            %       y = step(hidtypeconv, x);
            %       imshow(y);
            %       whos y % Image has been converted from uint8 to single.
            %
            %   See also vision.ColorSpaceConverter,
            %            vision.ImageDataTypeConverter.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.ImageDataTypeConverter System object
            %               fixed-point information
            %   vision.ImageDataTypeConverter.helpFixedPoint displays information
            %   about fixed-point properties and operations of the
            %   vision.ImageDataTypeConverter System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %CustomOutputDataType Output word and fraction lengths 
        %   Specify the output fixed-point type as a signed or unsigned scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Custom'. The default value of this
        %   property is numerictype(true,16,0).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %OutputDataType Data type of output
        %   Specify the data type of the output signal as one of ['double' |
        %   {'single'} | 'int8' | 'uint8' | 'int16' | 'uint16' | 'logical' |
        %   'Custom'].
        OutputDataType;

    end
end
