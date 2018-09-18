classdef EdgeDetector
%EdgeDetector Find edges of objects in images
%   HEDGE = vision.EdgeDetector returns an edge detection System object,
%   HEDGE, that finds edges in an input image using Sobel, Prewitt,
%   Roberts, or Canny algorithm.
%
%   HEDGE = vision.EdgeDetector('PropertyName', PropertyValue, ...) returns
%   an edge detection object, HEDGE, with each specified property set to
%   the specified value.
%
%   For Sobel, Prewitt and Roberts algorithms, the object finds edges in an
%   input image by approximating the gradient magnitude of the image. The
%   gradient is obtained as a result of convolving the image with the
%   Sobel, Prewitt or Roberts kernel. For Canny algorithm, the object finds
%   edges by looking for the local maxima of the gradient of the input
%   image. It calculates the gradient using the derivative of a Gaussian
%   filter. This algorithm is more robust to noise and more likely to
%   detect true weak edges.
%
%   Step method syntax:
%
%   EDGES = step(HEDGE, IMG) finds the edges, EDGES, in input IMG using the
%   specified algorithm when the BinaryImageOutputPort property is true.
%   EDGES is a logical matrix with non-zero elements representing edge
%   pixels and zero elements representing background pixels.
%
%   [GV, GH] = step(HEDGE, IMG) finds the two gradient components, GV and
%   GH, of the input IMG when the Method property is 'Sobel', 'Prewitt' or
%   'Roberts' and the GradientComponentOutputPorts property is true and the
%   BinaryImageOutputPort property is false. If the Method property is
%   'Sobel' or 'Prewitt', GV is a matrix of gradient values in the vertical
%   direction and GH is a matrix of gradient values in the horizontal
%   direction. If the Method property is 'Roberts', GV represents the
%   gradient component at 45 degree edge response and GH represents the
%   gradient component at 135 degree edge response.
%
%   [EDGES, GV, GH] = step(HEDGE, IMG) finds the edges, EDGES, and the two
%   gradient components, GV and GH, of the input IMG when the Method
%   property is 'Sobel', 'Prewitt' or 'Roberts' and both the
%   BinaryImageOutputPort and GradientComponentOutputPorts properties are
%   true.
%
%   EdgeDetector methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create edge detection object with same property values
%   isLocked - Locked status (logical)
%
%   EdgeDetector properties:
%
%   Method                          - Edge detection algorithm
%   BinaryImageOutputPort           - Output the binary image
%   GradientComponentOutputPorts    - Output the gradient components
%   ThresholdSource                 - Source of threshold value(s)
%   Threshold                       - Threshold value(s)
%   ThresholdScaleFactor            - Multiplier to adjust value of
%                                     automatic threshold
%   EdgeThinning                    - Enables performing edge thinning
%   NonEdgePixelsPercentage         - Approximate percentage of weak and
%                                     nonedge pixels
%   GaussianFilterStandardDeviation - Standard deviation of Gaussian filter
%
%   This System object supports fixed-point operations. For more
%   information, type vision.EdgeDetector.helpFixedPoint.
%
%   % EXAMPLE: Find the edges in peppers.png
%      hedge = vision.EdgeDetector;
%      hcsc = vision.ColorSpaceConverter(...
%       'Conversion', 'RGB to intensity');
%      hidtypeconv = vision.ImageDataTypeConverter('OutputDataType', 'single');
%      img = step(hcsc, imread('peppers.png'));
%      img1 = step(hidtypeconv, img);
%      edges = step(hedge, img1);
%      imshow(edges);
%
%   See also vision.TemplateMatcher, vision.EdgeDetector.helpFixedPoint.

 
%   Copyright 2004-2013 The MathWorks, Inc.

    methods
        function out=EdgeDetector
            %EdgeDetector Find edges of objects in images
            %   HEDGE = vision.EdgeDetector returns an edge detection System object,
            %   HEDGE, that finds edges in an input image using Sobel, Prewitt,
            %   Roberts, or Canny algorithm.
            %
            %   HEDGE = vision.EdgeDetector('PropertyName', PropertyValue, ...) returns
            %   an edge detection object, HEDGE, with each specified property set to
            %   the specified value.
            %
            %   For Sobel, Prewitt and Roberts algorithms, the object finds edges in an
            %   input image by approximating the gradient magnitude of the image. The
            %   gradient is obtained as a result of convolving the image with the
            %   Sobel, Prewitt or Roberts kernel. For Canny algorithm, the object finds
            %   edges by looking for the local maxima of the gradient of the input
            %   image. It calculates the gradient using the derivative of a Gaussian
            %   filter. This algorithm is more robust to noise and more likely to
            %   detect true weak edges.
            %
            %   Step method syntax:
            %
            %   EDGES = step(HEDGE, IMG) finds the edges, EDGES, in input IMG using the
            %   specified algorithm when the BinaryImageOutputPort property is true.
            %   EDGES is a logical matrix with non-zero elements representing edge
            %   pixels and zero elements representing background pixels.
            %
            %   [GV, GH] = step(HEDGE, IMG) finds the two gradient components, GV and
            %   GH, of the input IMG when the Method property is 'Sobel', 'Prewitt' or
            %   'Roberts' and the GradientComponentOutputPorts property is true and the
            %   BinaryImageOutputPort property is false. If the Method property is
            %   'Sobel' or 'Prewitt', GV is a matrix of gradient values in the vertical
            %   direction and GH is a matrix of gradient values in the horizontal
            %   direction. If the Method property is 'Roberts', GV represents the
            %   gradient component at 45 degree edge response and GH represents the
            %   gradient component at 135 degree edge response.
            %
            %   [EDGES, GV, GH] = step(HEDGE, IMG) finds the edges, EDGES, and the two
            %   gradient components, GV and GH, of the input IMG when the Method
            %   property is 'Sobel', 'Prewitt' or 'Roberts' and both the
            %   BinaryImageOutputPort and GradientComponentOutputPorts properties are
            %   true.
            %
            %   EdgeDetector methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create edge detection object with same property values
            %   isLocked - Locked status (logical)
            %
            %   EdgeDetector properties:
            %
            %   Method                          - Edge detection algorithm
            %   BinaryImageOutputPort           - Output the binary image
            %   GradientComponentOutputPorts    - Output the gradient components
            %   ThresholdSource                 - Source of threshold value(s)
            %   Threshold                       - Threshold value(s)
            %   ThresholdScaleFactor            - Multiplier to adjust value of
            %                                     automatic threshold
            %   EdgeThinning                    - Enables performing edge thinning
            %   NonEdgePixelsPercentage         - Approximate percentage of weak and
            %                                     nonedge pixels
            %   GaussianFilterStandardDeviation - Standard deviation of Gaussian filter
            %
            %   This System object supports fixed-point operations. For more
            %   information, type vision.EdgeDetector.helpFixedPoint.
            %
            %   % EXAMPLE: Find the edges in peppers.png
            %      hedge = vision.EdgeDetector;
            %      hcsc = vision.ColorSpaceConverter(...
            %       'Conversion', 'RGB to intensity');
            %      hidtypeconv = vision.ImageDataTypeConverter('OutputDataType', 'single');
            %      img = step(hcsc, imread('peppers.png'));
            %      img1 = step(hidtypeconv, img);
            %      edges = step(hedge, img1);
            %      imshow(edges);
            %
            %   See also vision.TemplateMatcher, vision.EdgeDetector.helpFixedPoint.
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.EdgeDetector System object
            %               fixed-point information
            %   vision.EdgeDetector.helpFixedPoint displays information about
            %   fixed-point properties and operations of the
            %   vision.EdgeDetector System object.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function loadObjectImpl(in) %#ok<MANU>
        end

        function saveObjectImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length
        %                      designations
        %   Specify the accumulator fixed-point data type as one of ['Same as
        %   first input' | {'Same as product'} | 'Custom']. This property is
        %   accessible when the Method property is not 'Canny'.
        AccumulatorDataType;

        %BinaryImageOutputPort Output the binary image
        %   Set this property to true to output the binary image after edge
        %   detection. When this property is set to true, the object will
        %   output a logical matrix. The nonzero elements of this matrix
        %   correspond to the edge pixels and the zero elements correspond to
        %   the background pixels. This property is accessible when the Method
        %   property is 'Sobel', 'Prewitt' or 'Roberts'. The default value for
        %   this property is true.
        BinaryImageOutputPort;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is accessible when the Method
        %   property is not 'Canny' and the AccumulatorDataType property is
        %   'Custom'. The default value of this property is
        %   numerictype([],32,8).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomGradientDataType Gradient word and fraction lengths
        %   Specify the gradient components fixed-point type as an auto-signed,
        %   scaled numerictype object. This property is accessible when the
        %   Method property is not 'Canny', the GradientComponentOutputPorts
        %   property is true and the GradientDataType property is 'Custom'. The
        %   default value of this property is numerictype([],16,4).
        %
        %   See also numerictype.
        CustomGradientDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is accessible when the Method
        %   property is not 'Canny' and the ProductDataType property is 
        %   'Custom'. The default value of this property is
        %   numerictype([],32,8).
        %
        %   See also numerictype.
        CustomProductDataType;

        %EdgeThinning Enables performing edge thinning
        %   Indicate whether edge thinning should be performed. Choosing to
        %   perform edge thinning requires additional processing time and
        %   resources. This property is accessible when the Method property is
        %   'Sobel', 'Prewitt' or 'Roberts' and the BinaryImageOutputPort
        %   property is true. The default value of this property is false.
        EdgeThinning;

        %GaussianFilterStandardDeviation  Standard deviation of Gaussian
        %                                 filter
        %   Specify the standard deviation of the Gaussian filter whose
        %   derivative is convolved with the input image. This property can be
        %   set to any positive scalar and the default value is 1. This
        %   property is accessible when the Method property is 'Canny'.
        GaussianFilterStandardDeviation;

        %GradientComponentOutputPorts Output the gradient components
        %   Set this property to true to output the gradient components after
        %   edge detection. When this property is set to true, and the Method
        %   property is set to 'Sobel' or 'Prewitt', this System object outputs
        %   the gradient components that correspond to the horizontal and
        %   vertical edge responses. When the Method property is set to
        %   'Roberts', the System object outputs the gradient components that
        %   correspond to the 45 and 135 degree edge responses. Both
        %   BinaryImageOutputPort and GradientComponentOutputPorts properties
        %   cannot be false at the same time. The default value for this
        %   property is false.
        GradientComponentOutputPorts;

        %GradientDataType Gradient word- and fraction-length designations
        %   Specify the gradient components fixed-point data type as one of
        %   ['Same as accumulator' | {'Same as first input'} | 'Same as
        %   product' | 'Custom']. This property is accessible when the Method
        %   property is not 'Canny' and the GradientComponentOutputPorts
        %   property is true.
        GradientDataType;

        %Method Edge detection algorithm
        %   Specify the edge detection algorithm as one of [{'Sobel'} |
        %   'Prewitt' | 'Roberts' | 'Canny'].
        Method;

        %NonEdgePixelsPercentage Approximate percentage of weak and nonedge
        %                        pixels
        %   Specify the approximate percentage of weak edge and nonedge image
        %   pixels as a scalar between 0 and 100. The default value is 70. This
        %   property is applicable when the Method property is 'Canny' and the
        %   ThresholdSource is 'Auto'. This property is tunable.
        NonEdgePixelsPercentage;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of [{'Wrap'} | 'Saturate']. This
        %   property is accessible when the Method property is not 'Canny'.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as one of ['Same as first
        %   input' | {'Custom'}]. This property is accessible when the Method
        %   property is not 'Canny'.
        ProductDataType;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   {'Floor'} | 'Nearest' |'Round' | 'Simplest' | 'Zero']. This
        %   property is accessible when the Method property is not 'Canny'.
        RoundingMethod;

        %Threshold Threshold value(s)
        %   Specify the threshold value as a scalar of MATLAB built-in numeric
        %   data type that is within the range of the input data when the
        %   Method property is 'Sobel', 'Prewitt' or 'Roberts'. Specify the
        %   threshold as two-element vector of low and high values that define
        %   the weak and strong edges when the Method property is 'Canny'. The
        %   default value is [0.25 0.6] when the Method property is 'Canny' or
        %   20 otherwise. This property is accessible when the ThresholdSource
        %   property is 'Property'. This property is tunable. 
        Threshold;

        %ThresholdScaleFactor Multiplier to adjust value of automatic
        %                     threshold
        %   Specify multiplier that is used to adjust calculation of automatic
        %   threshold as a scalar MATLAB built-in numeric data type. The
        %   default value is 4. This property is accessible when the Method
        %   property is 'Sobel', 'Prewitt' or 'Roberts' and the ThresholdSource
        %   property is 'Auto'. This property is tunable.
        ThresholdScaleFactor;

        %ThresholdSource Source of threshold value
        %   Specify how to determine threshold as one of [{'Auto'} | 'Property'
        %   | 'Input port']. This property is accessible when the Method
        %   property is 'Canny'. This property is also accessible when the
        %   Method property is 'Sobel', 'Prewitt' or 'Roberts' and the
        %   BinaryImageOutputPort property is true.
        ThresholdSource;

    end
end
