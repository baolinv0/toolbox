classdef HoughLines
%HoughLines Find Cartesian coordinates of lines described by rho and theta pairs
%   HHoughLines = vision.HoughLines returns a Hough lines System object,
%   HHoughLines, that finds Cartesian coordinates of lines that are
%   described by rho and theta pairs. The object inputs are the theta and
%   rho values of lines and a reference image. The object outputs the [x y]
%   coordinates of the intersections between the lines and two of the
%   reference image boundary lines. The boundary lines are the left and
%   right vertical boundaries and the top and bottom horizontal boundaries
%   of the reference image.
%
%   HHoughLines = vision.HoughLines('PropertyName', PropertyValue, ...)
%   returns a Hough lines object, HHoughLines, with each specified property
%   set to the specified value.
%
%   Step method syntax:
%
%   PTS = step(HHoughLines, THETA, RHO, REFIMG) outputs the [x y]
%   coordinates of the intersections between the lines described by THETA
%   and RHO and two of the reference image boundary lines.
%
%   HoughLines methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create Hough lines object with same property values
%   isLocked - Locked status (logical)
%
%   HoughLines properties:
%
%   SineComputation - How to calculate sine values used to find
%                     intersections of lines
%   ThetaResolution - Spacing of the theta-axis
%
%   This System object supports fixed-point operations when the
%   SineComputation property is 'Table lookup'. For more information, type
%   vision.HoughLines.helpFixedPoint.
%
%   % EXAMPLE: Use hough lines to detect the longest line in an image.
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
%      linepts = step(hhoughlines, theta(idx(1)-1), rho(idx(2)-1), I);
%
%      % View the image superimposed with the longest line.
%      imshow(I); hold on;
%      line(linepts([1 3])-1, linepts([2 4])-1,'color',[1 1 0]);
%
%   See also vision.HoughTransform, vision.LocalMaximaFinder,  
%            vision.EdgeDetector, vision.HoughLines.helpFixedPoint.

 
%   Copyright 2008-2013 The MathWorks, Inc.

    methods
        function out=HoughLines
            %HoughLines Find Cartesian coordinates of lines described by rho and theta pairs
            %   HHoughLines = vision.HoughLines returns a Hough lines System object,
            %   HHoughLines, that finds Cartesian coordinates of lines that are
            %   described by rho and theta pairs. The object inputs are the theta and
            %   rho values of lines and a reference image. The object outputs the [x y]
            %   coordinates of the intersections between the lines and two of the
            %   reference image boundary lines. The boundary lines are the left and
            %   right vertical boundaries and the top and bottom horizontal boundaries
            %   of the reference image.
            %
            %   HHoughLines = vision.HoughLines('PropertyName', PropertyValue, ...)
            %   returns a Hough lines object, HHoughLines, with each specified property
            %   set to the specified value.
            %
            %   Step method syntax:
            %
            %   PTS = step(HHoughLines, THETA, RHO, REFIMG) outputs the [x y]
            %   coordinates of the intersections between the lines described by THETA
            %   and RHO and two of the reference image boundary lines.
            %
            %   HoughLines methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create Hough lines object with same property values
            %   isLocked - Locked status (logical)
            %
            %   HoughLines properties:
            %
            %   SineComputation - How to calculate sine values used to find
            %                     intersections of lines
            %   ThetaResolution - Spacing of the theta-axis
            %
            %   This System object supports fixed-point operations when the
            %   SineComputation property is 'Table lookup'. For more information, type
            %   vision.HoughLines.helpFixedPoint.
            %
            %   % EXAMPLE: Use hough lines to detect the longest line in an image.
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
            %      linepts = step(hhoughlines, theta(idx(1)-1), rho(idx(2)-1), I);
            %
            %      % View the image superimposed with the longest line.
            %      imshow(I); hold on;
            %      line(linepts([1 3])-1, linepts([2 4])-1,'color',[1 1 0]);
            %
            %   See also vision.HoughTransform, vision.LocalMaximaFinder,  
            %            vision.EdgeDetector, vision.HoughLines.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.HoughLines System object fixed-point 
            %               information
            %   vision.HoughLines.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.HoughLines
            %   System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Same as
        %   product'} | 'Custom']. This property is applicable when the
        %   SineComputation property is 'Table lookup'.
        AccumulatorDataType;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   SineComputation property is 'Table lookup', and the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,16).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed scaled
        %   numerictype object. This property is applicable when the
        %   SineComputation property is 'Table lookup', and the ProductDataType
        %   property is 'Custom'. The default value of this property is
        %   numerictype([],32,16).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomSineTableDataType Sine table word and fraction lengths
        %   Specify the sine table fixed-point type as an auto-signed unscaled
        %   numerictype object. This property is applicable when the
        %   SineComputation property is 'Table lookup', and the
        %   SineTableDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16).
        %
        %   See also numerictype.
        CustomSineTableDataType;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is applicable when the SineComputation property is 'Table
        %   lookup'.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as first
        %   input' | {'Custom'}]. This property is applicable when the
        %   SineComputation property is 'Table lookup'.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero']. This
        %   property is applicable when the SineComputation property is 'Table
        %   lookup'.
        RoundingMethod;

        %SineComputation How to calculate sine values used to find
        %                intersections of lines
        %   Specify how to calculate sine values which is used to find
        %   intersection of lines as one of ['Trigonometric function' | {'Table
        %   lookup'}]. If this property is set to 'Trigonometric function', the
        %   object computes sine and cosine values it needs to calculate the
        %   intersections of the lines. If it is set to 'Table lookup', the
        %   object computes and stores the trigonometric values it needs to
        %   calculate the intersections of the lines in a table and uses the
        %   table for each step call. In this case, the object requires extra
        %   memory. For floating-point inputs, this property must be set to
        %   'Trigonometric function'. For fixed-point inputs, the property must
        %   be set to 'Table lookup'.
        SineComputation;

        %SineTableDataType Sine table word- and fraction-length designations
        %   Specify the sine table fixed-point data type as a constant property
        %   always set to 'Custom'. This property is applicable when the
        %   SineComputation property is 'Table lookup'.
        SineTableDataType;

        %ThetaResolution Spacing of the theta-axis
        %   Specify the spacing of the theta-axis. This property is applicable
        %   when the SineComputation property is 'Table lookup'.
        ThetaResolution;

    end
end
