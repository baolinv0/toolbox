classdef ColorSpaceConverter
%ColorSpaceConverter Image color space conversion
%   HCSC = vision.ColorSpaceConverter returns a System object, HCSC, that
%   converts color information between color spaces.
%
%   HCSC = vision.ColorSpaceConverter('PropertyName', PropertyValue, ...)
%   returns a color space conversion object, HCSC, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   C2 = step(HCSC, C1) converts a multidimensional input image C1 to a
%   multidimensional output image C2. C1 and C2 are images in different
%   color spaces.
%
%   ColorSpaceConverter methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create color space conversion object with same property values
%   isLocked - Locked status (logical)
%
%   ColorSpaceConverter properties:
%
%   Conversion         - Color space input/output conversion
%   WhitePoint         - Reference white point
%   ConversionStandard - Standard for RGB to YCbCr conversion
%   ScanningStandard   - Scanning standard for RGB to YCbCr conversion
%
%   % EXAMPLE: Convert an rgb image of pears to intensity.
%      i1 = imread('pears.png');
%      imshow(i1);
%      hcsc = vision.ColorSpaceConverter;
%      hcsc.Conversion = 'RGB to intensity';
%      i2 = step(hcsc, i1);
%      pause(2);
%      imshow(i2);
%
%   See also vision.Autothresholder. 

 
%   Copyright 2008-2010 The MathWorks, Inc.

    methods
        function out=ColorSpaceConverter
            %ColorSpaceConverter Image color space conversion
            %   HCSC = vision.ColorSpaceConverter returns a System object, HCSC, that
            %   converts color information between color spaces.
            %
            %   HCSC = vision.ColorSpaceConverter('PropertyName', PropertyValue, ...)
            %   returns a color space conversion object, HCSC, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   C2 = step(HCSC, C1) converts a multidimensional input image C1 to a
            %   multidimensional output image C2. C1 and C2 are images in different
            %   color spaces.
            %
            %   ColorSpaceConverter methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create color space conversion object with same property values
            %   isLocked - Locked status (logical)
            %
            %   ColorSpaceConverter properties:
            %
            %   Conversion         - Color space input/output conversion
            %   WhitePoint         - Reference white point
            %   ConversionStandard - Standard for RGB to YCbCr conversion
            %   ScanningStandard   - Scanning standard for RGB to YCbCr conversion
            %
            %   % EXAMPLE: Convert an rgb image of pears to intensity.
            %      i1 = imread('pears.png');
            %      imshow(i1);
            %      hcsc = vision.ColorSpaceConverter;
            %      hcsc.Conversion = 'RGB to intensity';
            %      i2 = step(hcsc, i1);
            %      pause(2);
            %      imshow(i2);
            %
            %   See also vision.Autothresholder. 
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %Conversion Color space input/output conversion
        %   Specify the color spaces to convert between as one of
        %   [{'RGB to YCbCr'}    |
        %     'YCbCr to RGB'     | 
        %     'RGB to intensity' | 
        %     'RGB to HSV'       |  
        %     'HSV to RGB'       | 
        %     'sRGB to XYZ'      | 
        %     'XYZ to sRGB'      | 
        %     'sRGB to L*a*b*'   | 
        %     'L*a*b* to sRGB']. 
        %   Note that the R, G, B and Y (luma) signal components in the above
        %   color space conversions are gamma corrected.
        Conversion;

        %ConversionStandard Standard for RGB to YCbCr conversion
        %   Specify the standard used to convert the values between the RGB and
        %   YCbCr color spaces as one of [{'Rec. 601 (SDTV)'} | 'Rec. 709
        %   (HDTV)']. This property is applicable when the Conversion property
        %   is 'RGB to YCbCr' or 'YCbCr to RGB'.
        ConversionStandard;

        %ScanningStandard Scanning standard for RGB to YCbCr conversion
        %   Specify the scanning standard used to convert the values between
        %   the RGB and YCbCr color spaces as one of [{'1125/60/2:1'} |
        %   '1250/50/2:1']. This property is applicable when the
        %   ConversionStandard property is 'Rec. 709 (HDTV)'.
        ScanningStandard;

        %WhitePoint Reference white point
        %   Specify the reference white point as one of ['D50' | 'D55' |
        %   {'D65'}]. This property is applicable when the Conversion property
        %   is 'sRGB to L*a*b*' or 'L*a*b* to sRGB'.
        WhitePoint;

    end
end
