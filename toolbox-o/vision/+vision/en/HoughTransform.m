classdef HoughTransform
%HoughTransform Hough transform
%   HHOUGH = vision.HoughTransform returns a Hough transform System object,
%   HHOUGH, that implements the Hough transform to detect lines in images.
%
%   HHOUGH = vision.HoughTransform('PropertyName', PropertyValue, ...)
%   returns a Hough transform object, HHOUGH, with each specified property
%   set to the specified value.
%
%   HHOUGH = vision.HoughTransform(THETARES, RHORES, 'PropertyName', ...
%   PropertyValue, ...) returns a Hough transform object, HHOUGH, with the
%   ThetaResolution property set to THETARES, the RhoResolution property
%   set to RHORES, and other specified properties set to the specified
%   values.
%
%   The Hough transform maps points in the Cartesian image space to curves
%   in the Hough parameter space using the following equation:
%         rho = x*cos(theta) + y*sin(theta)  
%   Here, rho denotes the distance from the origin to the line along a 
%   vector perpendicular to the line, and theta denotes the angle between
%   the x-axis and this vector. This object computes the parameter space
%   matrix, whose rows and columns correspond to the rho and theta values
%   respectively. Peak values in this matrix represent potential straight
%   lines in the input image.
%
%   Step method syntax:
%
%   HT = step(HHOUGH, BW) outputs the parameter space matrix, HT, for the
%   binary input image matrix BW.
%
%   [HT, THETA, RHO] = step(HHOUGH, BW) also returns the theta and rho
%   values, in vectors THETA and RHO respectively, when the
%   ThetaRhoOutputPort property is true.
%
%   HoughTransform methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Hough transform object with same property values
%   isLocked - Locked status (logical)
%
%   HoughTransform properties:
%
%   ThetaResolution    - Theta resolution in radians
%   RhoResolution      - Rho resolution
%   ThetaRhoOutputPort - Enables theta and rho outputs
%   OutputDataType     - Data type of output
%
%   This System object supports fixed-point operations when the
%   OutputDataType property is 'Fixed point'. For more information, type
%   vision.HoughTransform.helpFixedPoint.
%
%   % EXAMPLE: Compute the hough transform of an image that can be used to
%   %           detect the longest line in the image.
%
%      I = imread('circuit.tif');
%
%      % Use the EdgeDetection System object to find edges in the intensity
%      % image. This step outputs a binary image required by the
%      % HoughTransform System object and improves the efficiency of the
%      % HoughLines System object.
%      hedge       = vision.EdgeDetector;
%      hhoughtrans = vision.HoughTransform(pi/360, ...
%                                         'ThetaRhoOutputPort', true);
%      hfindmax    = vision.LocalMaximaFinder(1, ...
%                                            'HoughMatrixInput', true);
%      hhoughlines = vision.HoughLines('SineComputation', ...
%                                     'Trigonometric function');
%
%      % Find the edges in the intensity image
%      BW = step(hedge, I);
%      % Run the edge output through the transform
%      [ht, theta, rho] =  step(hhoughtrans, BW);
%      % Find the location of the maximum value in the Hough matrix.
%      idx = step(hfindmax, ht);
%      % Find the longest line.
%      linepts = step(hhoughlines, theta(idx(1)), rho(idx(2)), I);
%
%      % View the image superimposed with the longest line.
%      imshow(I); hold on;
%      line(linepts([1 3]), linepts([2 4]));
%
%   See also vision.DCT, vision.HoughLines, vision.LocalMaximaFinder,
%            vision.EdgeDetector, vision.HoughTransform.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=HoughTransform
            %HoughTransform Hough transform
            %   HHOUGH = vision.HoughTransform returns a Hough transform System object,
            %   HHOUGH, that implements the Hough transform to detect lines in images.
            %
            %   HHOUGH = vision.HoughTransform('PropertyName', PropertyValue, ...)
            %   returns a Hough transform object, HHOUGH, with each specified property
            %   set to the specified value.
            %
            %   HHOUGH = vision.HoughTransform(THETARES, RHORES, 'PropertyName', ...
            %   PropertyValue, ...) returns a Hough transform object, HHOUGH, with the
            %   ThetaResolution property set to THETARES, the RhoResolution property
            %   set to RHORES, and other specified properties set to the specified
            %   values.
            %
            %   The Hough transform maps points in the Cartesian image space to curves
            %   in the Hough parameter space using the following equation:
            %         rho = x*cos(theta) + y*sin(theta)  
            %   Here, rho denotes the distance from the origin to the line along a 
            %   vector perpendicular to the line, and theta denotes the angle between
            %   the x-axis and this vector. This object computes the parameter space
            %   matrix, whose rows and columns correspond to the rho and theta values
            %   respectively. Peak values in this matrix represent potential straight
            %   lines in the input image.
            %
            %   Step method syntax:
            %
            %   HT = step(HHOUGH, BW) outputs the parameter space matrix, HT, for the
            %   binary input image matrix BW.
            %
            %   [HT, THETA, RHO] = step(HHOUGH, BW) also returns the theta and rho
            %   values, in vectors THETA and RHO respectively, when the
            %   ThetaRhoOutputPort property is true.
            %
            %   HoughTransform methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Hough transform object with same property values
            %   isLocked - Locked status (logical)
            %
            %   HoughTransform properties:
            %
            %   ThetaResolution    - Theta resolution in radians
            %   RhoResolution      - Rho resolution
            %   ThetaRhoOutputPort - Enables theta and rho outputs
            %   OutputDataType     - Data type of output
            %
            %   This System object supports fixed-point operations when the
            %   OutputDataType property is 'Fixed point'. For more information, type
            %   vision.HoughTransform.helpFixedPoint.
            %
            %   % EXAMPLE: Compute the hough transform of an image that can be used to
            %   %           detect the longest line in the image.
            %
            %      I = imread('circuit.tif');
            %
            %      % Use the EdgeDetection System object to find edges in the intensity
            %      % image. This step outputs a binary image required by the
            %      % HoughTransform System object and improves the efficiency of the
            %      % HoughLines System object.
            %      hedge       = vision.EdgeDetector;
            %      hhoughtrans = vision.HoughTransform(pi/360, ...
            %                                         'ThetaRhoOutputPort', true);
            %      hfindmax    = vision.LocalMaximaFinder(1, ...
            %                                            'HoughMatrixInput', true);
            %      hhoughlines = vision.HoughLines('SineComputation', ...
            %                                     'Trigonometric function');
            %
            %      % Find the edges in the intensity image
            %      BW = step(hedge, I);
            %      % Run the edge output through the transform
            %      [ht, theta, rho] =  step(hhoughtrans, BW);
            %      % Find the location of the maximum value in the Hough matrix.
            %      idx = step(hfindmax, ht);
            %      % Find the longest line.
            %      linepts = step(hhoughlines, theta(idx(1)), rho(idx(2)), I);
            %
            %      % View the image superimposed with the longest line.
            %      imshow(I); hold on;
            %      line(linepts([1 3]), linepts([2 4]));
            %
            %   See also vision.DCT, vision.HoughLines, vision.LocalMaximaFinder,
            %            vision.EdgeDetector, vision.HoughTransform.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.HoughTransform System object 
            %               fixed-point information
            %   vision.HoughTransform.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.HoughTransform
            %   System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
            % Can be removed if no hidden properties
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Same as
        %   product' | {'Custom'}]. This property is applicable when the
        %   OutputDataType property is 'Fixed point'.
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Fixed point'. The default value of this
        %   property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomHoughOutputDataType Hough output word and fraction lengths
        %   Specify the hough output fixed-point data type as an auto-signed,
        %   unscaled numerictype object. This property is applicable when the
        %   OutputDataType property is 'Fixed point'. The default value of this
        %   property is numerictype([],16).
        %
        %   See also numerictype.
        CustomHoughOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Fixed point'. The default value of this
        %   property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomRhoDataType Rho word and fraction lengths
        %   Specify the rho fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Fixed point'. The default value of this
        %   property is numerictype([],32,16).
        %
        %   See also numerictype.
        CustomRhoDataType;

        %CustomSineTableDataType Sine table word and fraction lengths
        %   Specify the sine table fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Fixed point'. The default value of this
        %   property is numerictype([],16,14).
        %
        %   See also numerictype.
        CustomSineTableDataType;

        %CustomThetaOutputDataType Theta output word and fraction lengths
        %   Specify the theta output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   OutputDataType property is 'Fixed point'. The default value of this
        %   property is numerictype([],32,16).
        %
        %   See also numerictype.
        CustomThetaOutputDataType;

        %HoughOutputDataType Hough output word- and fraction-length designations
        %   This property is constant and is set to 'Custom'. This property is
        %   applicable when the OutputDataType property is 'Fixed point'.
        HoughOutputDataType;

        %OutputDataType Data type of output
        %   Specify the data type of the output signal as one of [{'double'} |
        %   'single' | 'Fixed point'].
        OutputDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of ['Wrap' | {'Saturate'}]. This
        %   property is applicable when the OutputDataType property is 'Fixed
        %   point'.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   This property is constant and is set to 'Custom'. This property is
        %   applicable when the OutputDataType property is 'Fixed point'.
        ProductDataType;

        %RhoDataType Rho word- and fraction-length designations
        %   This property is constant and is set to 'Custom'. This property is
        %   applicable when the OutputDataType property is 'Fixed point'.
        RhoDataType;

        %RhoResolution Rho resolution 
        %   Specify the spacing of the Hough transform bins along the rho-axis as
        %   a scalar numeric value greater than 0. The default value of this
        %   property is 1.
        RhoResolution;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   'Floor' | {'Nearest'} | 'Round' | 'Simplest' | 'Zero']. This property
        %   is applicable when the OutputDataType property is 'Fixed point'.
        RoundingMethod;

        %SineTableDataType Sine table word- and fraction-length designations
        %   This property is constant and is set to 'Custom'. This property is
        %   applicable when the OutputDataType property is 'Fixed point'.
        SineTableDataType;

        %ThetaOutputDataType Theta output word- and fraction-length designations
        %   This property is constant and is set to 'Custom'. This property is
        %   applicable when the OutputDataType property is 'Fixed point'.
        ThetaOutputDataType;

        %ThetaResolution Theta resolution in radians
        %   Specify the spacing of the Hough transform bins along the theta-axis
        %   in radians, as a scalar numeric value between 0 and pi/2. The default
        %   value of this property is pi/180.
        ThetaResolution;

        %ThetaRhoOutputPort Enables theta and rho outputs
        %   Set this property to true for the object to output theta and rho
        %   values. The default value of this property is false.
        ThetaRhoOutputPort;

    end
end
