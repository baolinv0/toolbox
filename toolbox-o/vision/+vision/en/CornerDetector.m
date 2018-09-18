classdef CornerDetector
%CornerDetector Find corner features
%   ----------------------------------------------------------------------------    
%   Use the vision.CornerDetector for fixed-point support. Otherwise, it is 
%   recommended to use one of the new detectHarrisFeatures, 
%   detectMinEigenFeatures, or detectFastFeatures functions in place of 
%   vision.CornerDetector.
%   ----------------------------------------------------------------------------    
%
%   The CornerDetector object finds corners in a grayscale image. It
%   returns corner locations as a matrix of [x y] coordinates. The object
%   provides Harris, Minimum Eigenvalue and FAST corner detectors.
%    
%   cornerDetector = vision.CornerDetector returns a corner detector System
%   object, cornerDetector, that finds corners in an image using Harris corner
%   detector.
%
%   cornerDetector = vision.CornerDetector(..., 'Name', 'Value') configures 
%   the corner detector properties, specified as one or more name-value 
%   pair arguments. Unspecified properties have default values.
%
%   Step method syntax:
%
%   LOC = step(cornerDetector, I) finds corners in grayscale image I.
%   LOC is an M-by-2 matrix of [x y] corner coordinates, where M is the 
%   number of detected corners. M can be less than or equal to a value
%   set in MaximumCornerCount property.
%
%   METRIC = step(cornerDetector, I) returns a matrix with corner metric values,
%   METRIC, when the MetricMatrixOutputPort property is true. METRIC
%   represents corner strength and has the same size as I.    
%
%   [LOC, METRIC] = step(cornerDetector, I) returns the locations of the
%   corners in LOC and the corner metric matrix in METRIC, when both the 
%   CornerLocationOutputPort and MetricMatrixOutputPort properties are true.
%
%   CornerDetector methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create corner detector object with same property values
%   isLocked - Locked status (logical)
%
%   CornerDetector properties:
%
%   Method                      - Method to find corner values
%   Sensitivity                 - Sensitivity factor to detect sharp corners
%   SmoothingFilterCoefficients - Coefficients of smoothing filter
%   IntensityThreshold          - Intensity comparison threshold
%   MaximumAngleThreshold       - Maximum angle in degrees to be considered
%                                 corner
%   CornerLocationOutputPort    - Enables output of the corner location
%   MetricMatrixOutputPort      - Enables output of the metric matrix
%   MaximumCornerCount          - Maximum number of corners to detect
%   CornerThreshold             - Minimum metric value that indicates a corner
%   NeighborhoodSize            - Size of suppressed region around detected
%                                 corner
%
%   This System object supports fixed-point operations. For more
%   information, type vision.CornerDetector.helpFixedPoint.
%
%   Example
%   -------
%   % Detect corners in an input image.
%   I = im2single(imread('circuit.tif'));
%   % select FAST algorithm by Rosten & Drummond
%   cornerDetector = vision.CornerDetector( ... 
%            'Method', 'Local intensity comparison (Rosten & Drummond)');
% 
%   pts = step(cornerDetector, I); 
%   % note that color data range must match the data range of image I
%   color = [1 0 0]; % [red, green, blue]
%   % insert color marker
%   J = insertMarker(I, pts, 'Color', 'red');
%   imshow(J); title ('Corners detected in a grayscale image'); 
%
%   See also detectHarrisFeatures, detectMinEigenFeatures,
%       detectFASTFeatures, detectSURFFeatures, detectMSERFeatures,
%       extractFeatures, matchFeatures, vision.LocalMaximaFinder,
%       insertMarker

 
%   Copyright 2003-2013 The MathWorks, Inc.

    methods
        function out=CornerDetector
            %CornerDetector Find corner features
            %   ----------------------------------------------------------------------------    
            %   Use the vision.CornerDetector for fixed-point support. Otherwise, it is 
            %   recommended to use one of the new detectHarrisFeatures, 
            %   detectMinEigenFeatures, or detectFastFeatures functions in place of 
            %   vision.CornerDetector.
            %   ----------------------------------------------------------------------------    
            %
            %   The CornerDetector object finds corners in a grayscale image. It
            %   returns corner locations as a matrix of [x y] coordinates. The object
            %   provides Harris, Minimum Eigenvalue and FAST corner detectors.
            %    
            %   cornerDetector = vision.CornerDetector returns a corner detector System
            %   object, cornerDetector, that finds corners in an image using Harris corner
            %   detector.
            %
            %   cornerDetector = vision.CornerDetector(..., 'Name', 'Value') configures 
            %   the corner detector properties, specified as one or more name-value 
            %   pair arguments. Unspecified properties have default values.
            %
            %   Step method syntax:
            %
            %   LOC = step(cornerDetector, I) finds corners in grayscale image I.
            %   LOC is an M-by-2 matrix of [x y] corner coordinates, where M is the 
            %   number of detected corners. M can be less than or equal to a value
            %   set in MaximumCornerCount property.
            %
            %   METRIC = step(cornerDetector, I) returns a matrix with corner metric values,
            %   METRIC, when the MetricMatrixOutputPort property is true. METRIC
            %   represents corner strength and has the same size as I.    
            %
            %   [LOC, METRIC] = step(cornerDetector, I) returns the locations of the
            %   corners in LOC and the corner metric matrix in METRIC, when both the 
            %   CornerLocationOutputPort and MetricMatrixOutputPort properties are true.
            %
            %   CornerDetector methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create corner detector object with same property values
            %   isLocked - Locked status (logical)
            %
            %   CornerDetector properties:
            %
            %   Method                      - Method to find corner values
            %   Sensitivity                 - Sensitivity factor to detect sharp corners
            %   SmoothingFilterCoefficients - Coefficients of smoothing filter
            %   IntensityThreshold          - Intensity comparison threshold
            %   MaximumAngleThreshold       - Maximum angle in degrees to be considered
            %                                 corner
            %   CornerLocationOutputPort    - Enables output of the corner location
            %   MetricMatrixOutputPort      - Enables output of the metric matrix
            %   MaximumCornerCount          - Maximum number of corners to detect
            %   CornerThreshold             - Minimum metric value that indicates a corner
            %   NeighborhoodSize            - Size of suppressed region around detected
            %                                 corner
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.CornerDetector.helpFixedPoint.
            %
            %   Example
            %   -------
            %   % Detect corners in an input image.
            %   I = im2single(imread('circuit.tif'));
            %   % select FAST algorithm by Rosten & Drummond
            %   cornerDetector = vision.CornerDetector( ... 
            %            'Method', 'Local intensity comparison (Rosten & Drummond)');
            % 
            %   pts = step(cornerDetector, I); 
            %   % note that color data range must match the data range of image I
            %   color = [1 0 0]; % [red, green, blue]
            %   % insert color marker
            %   J = insertMarker(I, pts, 'Color', 'red');
            %   imshow(J); title ('Corners detected in a grayscale image'); 
            %
            %   See also detectHarrisFeatures, detectMinEigenFeatures,
            %       detectFASTFeatures, detectSURFFeatures, detectMSERFeatures,
            %       extractFeatures, matchFeatures, vision.LocalMaximaFinder,
            %       insertMarker
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.CornerDetector System object fixed-point information
            %   vision.CornerDetector.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.CornerDetector
            %   System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function isInputComplexityLockedImpl(in) %#ok<MANU>
        end

        function isInputSizeLockedImpl(in) %#ok<MANU>
        end

        function isOutputComplexityLockedImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function processTunedPropertiesImpl(in) %#ok<MANU>
        end

        function resetImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setupImpl(in) %#ok<MANU>
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
        end

        function validatePropertiesImpl(in) %#ok<MANU>
            % Check that at least one of the outputs is enabled
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of ['Same as
        %   input' | {'Custom'}].
        AccumulatorDataType;

        %CoefficientsDataType Coefficients word- and fraction-length designations
        %   Specify the coefficients fixed-point data type as one of ['Same word
        %   length as input' | {'Custom'}]. This property is applicable when the
        %   Method property is not 'Local intensity comparison (Rosten &
        %   Drummond)'.
        CoefficientsDataType;

        %CornerLocationOutputPort Enables output of the corner location
        %   Set this property to true to output the corner location after corner
        %   detection. Both this property and MetricMatrixOutputPort property
        %   cannot be false at the same time. The default value for this property
        %   is true.
        CornerLocationOutputPort;

        %CornerThreshold Minimum metric value that indicates a corner
        %   Specify the minimum metric value that indicates a corner as a
        %   positive scalar number. The default value of this property is 0.0005.
        %   This property is applicable when the CornerLocationOutputPort
        %   property is true. This property is tunable.
        CornerThreshold;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,0).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomCoefficientsDataType Coefficients word and fraction lengths 
        %   Specify the coefficients fixed-point type as an auto-signed
        %   numerictype object. This property is applicable when the Method
        %   property is not 'Local intensity comparison (Rosten & Drummond)' and
        %   the CoefficientsDataType property is 'Custom'. The default value of
        %   this property is numerictype([],16).
        %
        %   See also numerictype.
        CustomCoefficientsDataType;

        %CustomMemoryDataType Memory word and fraction lengths
        %   Specify the memory fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is not 'Local intensity comparison (Rosten & Drummond)' and
        %   the MemoryDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,0).
        %
        %   See also numerictype.
        CustomMemoryDataType;

        %CustomMetricOutputDataType Metric output word and fraction lengths
        %   Specify the metric output fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the
        %   MetricOutputDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,0).
        %
        %   See also numerictype.
        CustomMetricOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is applicable when the Method
        %   property is not 'Local intensity comparison (Rosten & Drummond)' and
        %   the ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,0).
        %
        %   See also numerictype.
        CustomProductDataType;

        %IntensityThreshold Intensity comparison threshold
        %   Specify the intensity threshold value used to find valid bright or
        %   dark surrounding pixels, as a positive scalar. The default value of
        %   this property is 0.1. This property is applicable when the Method
        %   property is 'Local intensity comparison (Rosten & Drummond)'. This
        %   property is tunable.
        IntensityThreshold;

        %MaximumAngleThreshold Maximum angle in degrees to be considered corner
        %   Specify the maximum angle in degrees to indicate a corner as one of
        %   ['22.5' | '45.0' | '67.5' | '90.0' | '112.5' | '135.0' | {'157.5'}].
        %   This property is applicable when the Method property is 'Local
        %   intensity comparison (Rosten & Drummond)'.
        MaximumAngleThreshold;

        %MaximumCornerCount Maximum number of corners to detect
        %   Specify the maximum number of corners to detect as a positive scalar
        %   integer value. The default value of this property is 200. This
        %   property is applicable when the CornerLocationOutputPort property is
        %   true.
        MaximumCornerCount;

        %MemoryDataType Memory word- and fraction-length designations
        %   Specify the memory fixed-point data type as one of ['Same as input' |
        %   {'Custom'}]. This property is applicable when the Method property
        %   is not 'Local intensity comparison (Rosten & Drummond)'.
        MemoryDataType;

        %Method Method to find corner values
        %   Specify the method to find the corner values as one of [{'Harris
        %   corner detection (Harris & Stephens)'} | 'Minimum eigenvalue (Shi &
        %   Tomasi)' | 'Local intensity comparison (Rosten & Drummond)'].
        Method;

        %MetricMatrixOutputPort Enables output of the metric matrix
        %   Set this property to true to output the metric matrix after corner
        %   detection. Both this property and CornerLocationOutputPort property
        %   cannot be false at the same time. The default value for this property
        %   is false.
        MetricMatrixOutputPort;

        %MetricOutputDataType Metric output word- and fraction-length designations
        %   Specify the metric output fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as input' | 'Custom'].
        MetricOutputDataType;

        %NeighborhoodSize Size of suppressed region around detected corner
        %   Specify the size of the neighborhood around the corner metric value
        %   over which the object zeros out the values, as a two element vector
        %   of positive odd integers, [r c]. Here, r is the number of rows in the
        %   neighborhood and c is the number of columns. The default value of
        %   this property is [11 11]. This property is applicable when the
        %   CornerLocationOutputPort property is true.
        NeighborhoodSize;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate'].
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as input'
        %   | {'Custom'}]. This property is applicable when the Method property
        %   is not 'Local intensity comparison (Rosten & Drummond)'.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' | 'Round' | 'Simplest' | 'Zero'].
        RoundingMethod;

        %Sensitivity Sensitivity factor to detect sharp corners
        %   Specify the sensitivity factor, k, used in the Harris corner
        %   detection algorithm as a scalar numeric value, such that 0 < k < 0.25.
        %   The smaller the value of k, the more likely it is that the algorithm
        %   will detect sharp corners. The default value of this property is
        %   0.04. This property is applicable when the Method property is 'Harris
        %   corner detection (Harris & Stephens)'. This property is tunable.
        Sensitivity;

        %SmoothingFilterCoefficients Coefficients of smoothing filter
        %   Specify the filter coefficients for the separable smoothing filter as
        %   a real-valued numeric vector. The vector must have an odd number of
        %   elements and a length of at least 3. The default value of this
        %   property is the output of fspecial('gaussian', [1 5], 1.5). For more
        %   information, type help fspecial. This property is applicable when the
        %   Method property is either 'Harris corner detection (Harris &
        %   Stephens)' or 'Minimum eigenvalue (Shi & Tomasi)'.
        %
        %   See also help fspecial.
        SmoothingFilterCoefficients;

    end
end
