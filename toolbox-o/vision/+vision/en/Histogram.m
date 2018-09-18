classdef Histogram
%Histogram Generate histogram of each input matrix
%   HHIST = vision.Histogram returns a histogram System object, HHIST,
%   that computes the frequency distribution of the elements in each input
%   matrix.
%
%   HHIST = vision.Histogram('PropertyName', PropertyValue, ...) returns
%   a histogram object, HHIST, with each specified property set to the
%   specified value.
%
%   HHIST = vision.Histogram(MIN, MAX, NUMBINS, 'PropertyName',
%   PropertyValue, ...) returns a histogram System object, HHIST, with
%   the LowerLimit property set to MIN, UpperLimit property set to MAX,
%   NumBins property set to NUMBINS and other specified properties set to
%   the specified values.
%
%   Step method syntax:
%
%   Y = step(HHIST, X) returns a histogram Y for the input data X. When
%   the RunningHistogram property is true, Y corresponds to the histogram
%   of the input elements over successive calls to the step method.
%
%   Y = step(HHIST, X, R) computes the histogram of the input elements
%   over successive calls to the step method. The object optionally resets
%   its state based on the value of reset input signal, R, and the
%   ResetCondition property. This is possible when you set both the
%   RunningHistogram and ResetInputPort properties to true.
%
%   Histogram methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create histogram object with same property values
%   isLocked - Locked status (logical)
%   reset    - Reset the states of running histogram
%
%   Histogram properties:
%
%   LowerLimit       - Lower boundary
%   UpperLimit       - Upper boundary
%   NumBins          - Number of bins in the histogram
%   Normalize        - Enables output vector normalization
%   RunningHistogram - Calculation over successive calls to step method
%   ResetInputPort   - Enables resetting in running histogram mode
%   ResetCondition   - Reset condition for running histogram mode
%
%   This System object supports fixed-point operations when the property
%   Normalize is set to false. For more information, type
%   vision.Histogram.helpFixedPoint.
%
%   % EXAMPLE: Compute histogram of a grayscale image.
%       img = im2single(rgb2gray(imread('peppers.png')));
%       hhist = vision.Histogram;
%       y = step(hhist, img);
%       bar((0:255)/256, y);
%
%   See also vision.Histogram.helpFixedPoint.

 
%   Copyright 2004-2010 The MathWorks, Inc.

    methods
        function out=Histogram
            %Histogram Generate histogram of each input matrix
            %   HHIST = vision.Histogram returns a histogram System object, HHIST,
            %   that computes the frequency distribution of the elements in each input
            %   matrix.
            %
            %   HHIST = vision.Histogram('PropertyName', PropertyValue, ...) returns
            %   a histogram object, HHIST, with each specified property set to the
            %   specified value.
            %
            %   HHIST = vision.Histogram(MIN, MAX, NUMBINS, 'PropertyName',
            %   PropertyValue, ...) returns a histogram System object, HHIST, with
            %   the LowerLimit property set to MIN, UpperLimit property set to MAX,
            %   NumBins property set to NUMBINS and other specified properties set to
            %   the specified values.
            %
            %   Step method syntax:
            %
            %   Y = step(HHIST, X) returns a histogram Y for the input data X. When
            %   the RunningHistogram property is true, Y corresponds to the histogram
            %   of the input elements over successive calls to the step method.
            %
            %   Y = step(HHIST, X, R) computes the histogram of the input elements
            %   over successive calls to the step method. The object optionally resets
            %   its state based on the value of reset input signal, R, and the
            %   ResetCondition property. This is possible when you set both the
            %   RunningHistogram and ResetInputPort properties to true.
            %
            %   Histogram methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create histogram object with same property values
            %   isLocked - Locked status (logical)
            %   reset    - Reset the states of running histogram
            %
            %   Histogram properties:
            %
            %   LowerLimit       - Lower boundary
            %   UpperLimit       - Upper boundary
            %   NumBins          - Number of bins in the histogram
            %   Normalize        - Enables output vector normalization
            %   RunningHistogram - Calculation over successive calls to step method
            %   ResetInputPort   - Enables resetting in running histogram mode
            %   ResetCondition   - Reset condition for running histogram mode
            %
            %   This System object supports fixed-point operations when the property
            %   Normalize is set to false. For more information, type
            %   vision.Histogram.helpFixedPoint.
            %
            %   % EXAMPLE: Compute histogram of a grayscale image.
            %       img = im2single(rgb2gray(imread('peppers.png')));
            %       hhist = vision.Histogram;
            %       y = step(hhist, img);
            %       bar((0:255)/256, y);
            %
            %   See also vision.Histogram.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.Histogram System object fixed-point 
            %               information
            %   vision.Histogram.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.Histogram
            %   System object.
        end

    end
    methods (Abstract)
    end
    properties
        %NumBins Number of bins in the histogram
        %   Specify the number of bins in the histogram. The default value of
        %   this property is 256.
        NumBins;

        %UpperLimit Upper boundary
        %   Specify the upper boundary of the highest-valued bin as a
        %   real-valued scalar value. NaN and Inf are not valid values for this
        %   property. The default value of this property is 1. This property is
        %   tunable.
        UpperLimit;

    end
end
