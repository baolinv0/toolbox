classdef OpticalFlow
%OpticalFlow Estimate object velocities
%   Use vision.OpticalFlow when you need to process fixed-point data with
%   Lucas-Kanade (Difference filter) method. For all other applications,
%   use the opticalFlowHS, opticalFlowLK, or opticalFlowLKDoG function.
%
%   HOF = vision.OpticalFlow returns an optical flow System object, HOF,
%   that estimates the direction and speed of object motion from one image
%   to another, or from one video frame to another.
%
%   HOF = vision.OpticalFlow('PropertyName', PropertyValue, ...) returns an
%   optical flow System object, HOF, with each specified property set to
%   the specified value.
%
%   Step method syntax:
%
%   VSQ = step(HOF, I) computes the optical flow of input image I from one
%   video frame to another, and returns VSQ as a matrix of velocity
%   magnitudes.
%
%   V = step(HOF, I) computes the optical flow of input image I from one
%   video frame to another, and returns V as a complex matrix of horizontal
%   and vertical components, when the OutputValue property is 'Horizontal
%   and vertical components in complex form'.
%
%   [...] = step(HOF, I1, I2) computes the optical flow of the input image
%   I1, using I2 as a reference frame, when the ReferenceFrameSource
%   property is 'Input port'.
%
%   [..., IMV] = step(HOF, I) outputs the delayed input image, IMV. The
%   delay is equal to the latency introduced by the computation of the
%   motion vectors. This property is visible when the Method property is
%   'Lucas-Kanade', the TemporalGradientFilter property is 'Derivative of
%   Gaussian', and the MotionVectorImageOutputPort property is true.
%
%   OpticalFlow methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create optical flow object with same property values
%   isLocked - Locked status (logical)
%
%   OpticalFlow properties:
%
%   Method                                   - Algorithm used to compute
%                                              optical flow
%   ReferenceFrameSource                     - Source of the reference
%                                              frame used for the optical
%                                              flow calculation
%   ReferenceFrameDelay                      - Number of frames between
%                                              reference and current frame
%   Smoothness                               - Term expressing expected
%                                              smoothness of optical flow
%   IterationTerminationCondition            - Condition to stop iterative
%                                              solution computation
%   MaximumIterationCount                    - Maximum number of iterations
%                                              to perform
%   VelocityDifferenceThreshold              - Velocity difference
%                                              threshold to stop
%                                              computation
%   OutputValue                              - Form of velocity output
%   TemporalGradientFilter                   - Type of temporal gradient
%                                              filter
%   BufferedFramesCount                      - Number of frames to buffer
%                                              for temporal smoothing
%   ImageSmoothingFilterStandardDeviation    - Standard deviation for image
%                                              smoothing filter
%   GradientSmoothingFilterStandardDeviation - Standard deviation for
%                                              gradient smoothing filter
%   DiscardIllConditionedEstimates           - Discard normal flow
%                                              estimates when constraint
%                                              equation is ill-conditioned
%   MotionVectorImageOutputPort              - Return image corresponding
%                                              to motion vectors
%   NoiseReductionThreshold                  - Threshold for noise
%                                              reduction
%
%   This System object supports fixed-point operations when the Method
%   property is 'Lucas-Kanade' and the TemporalGradientFilter property is
%   'Difference filter [-1 1]'. For more information, type
%   vision.OpticalFlow.helpFixedPoint.
%
%   % EXAMPLE: Track cars using optical flow.  
%       hvfr = vision.VideoFileReader('viptraffic.avi', ...
%                                     'ImageColorSpace', 'Intensity', ...
%                                     'VideoOutputDataType', 'uint8');
%       hidtc = vision.ImageDataTypeConverter; 
%       hof = vision.OpticalFlow('ReferenceFrameDelay', 1);
%       hof.OutputValue = 'Horizontal and vertical components in complex form';
%       hvp = vision.VideoPlayer('Name', 'Motion Vector');
%       while ~isDone(hvfr)
%         frame = step(hvfr);
%         im = step(hidtc, frame); % convert the image to 'single' precision
%         of = step(hof, im);      % compute optical flow for the video
%         lines = videooptflowlines(of, 20); % generate coordinate points 
%         out = insertShape(im, 'Line', lines, ...
%                    'Color', 'white'); % draw lines to indicate flow
%         step(hvp, out);               % view in video player
%       end
%       release(hvp);
%       release(hvfr);
%
%   See also insertShape, vision.Pyramid, vision.OpticalFlow.helpFixedPoint,
%     opticalFlowHS, opticalFlowLK, opticalFlowLKDoG.

 
%   Copyright 2004-2013 The MathWorks, Inc.

    methods
        function out=OpticalFlow
            %OpticalFlow Estimate object velocities
            %   Use vision.OpticalFlow when you need to process fixed-point data with
            %   Lucas-Kanade (Difference filter) method. For all other applications,
            %   use the opticalFlowHS, opticalFlowLK, or opticalFlowLKDoG function.
            %
            %   HOF = vision.OpticalFlow returns an optical flow System object, HOF,
            %   that estimates the direction and speed of object motion from one image
            %   to another, or from one video frame to another.
            %
            %   HOF = vision.OpticalFlow('PropertyName', PropertyValue, ...) returns an
            %   optical flow System object, HOF, with each specified property set to
            %   the specified value.
            %
            %   Step method syntax:
            %
            %   VSQ = step(HOF, I) computes the optical flow of input image I from one
            %   video frame to another, and returns VSQ as a matrix of velocity
            %   magnitudes.
            %
            %   V = step(HOF, I) computes the optical flow of input image I from one
            %   video frame to another, and returns V as a complex matrix of horizontal
            %   and vertical components, when the OutputValue property is 'Horizontal
            %   and vertical components in complex form'.
            %
            %   [...] = step(HOF, I1, I2) computes the optical flow of the input image
            %   I1, using I2 as a reference frame, when the ReferenceFrameSource
            %   property is 'Input port'.
            %
            %   [..., IMV] = step(HOF, I) outputs the delayed input image, IMV. The
            %   delay is equal to the latency introduced by the computation of the
            %   motion vectors. This property is visible when the Method property is
            %   'Lucas-Kanade', the TemporalGradientFilter property is 'Derivative of
            %   Gaussian', and the MotionVectorImageOutputPort property is true.
            %
            %   OpticalFlow methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create optical flow object with same property values
            %   isLocked - Locked status (logical)
            %
            %   OpticalFlow properties:
            %
            %   Method                                   - Algorithm used to compute
            %                                              optical flow
            %   ReferenceFrameSource                     - Source of the reference
            %                                              frame used for the optical
            %                                              flow calculation
            %   ReferenceFrameDelay                      - Number of frames between
            %                                              reference and current frame
            %   Smoothness                               - Term expressing expected
            %                                              smoothness of optical flow
            %   IterationTerminationCondition            - Condition to stop iterative
            %                                              solution computation
            %   MaximumIterationCount                    - Maximum number of iterations
            %                                              to perform
            %   VelocityDifferenceThreshold              - Velocity difference
            %                                              threshold to stop
            %                                              computation
            %   OutputValue                              - Form of velocity output
            %   TemporalGradientFilter                   - Type of temporal gradient
            %                                              filter
            %   BufferedFramesCount                      - Number of frames to buffer
            %                                              for temporal smoothing
            %   ImageSmoothingFilterStandardDeviation    - Standard deviation for image
            %                                              smoothing filter
            %   GradientSmoothingFilterStandardDeviation - Standard deviation for
            %                                              gradient smoothing filter
            %   DiscardIllConditionedEstimates           - Discard normal flow
            %                                              estimates when constraint
            %                                              equation is ill-conditioned
            %   MotionVectorImageOutputPort              - Return image corresponding
            %                                              to motion vectors
            %   NoiseReductionThreshold                  - Threshold for noise
            %                                              reduction
            %
            %   This System object supports fixed-point operations when the Method
            %   property is 'Lucas-Kanade' and the TemporalGradientFilter property is
            %   'Difference filter [-1 1]'. For more information, type
            %   vision.OpticalFlow.helpFixedPoint.
            %
            %   % EXAMPLE: Track cars using optical flow.  
            %       hvfr = vision.VideoFileReader('viptraffic.avi', ...
            %                                     'ImageColorSpace', 'Intensity', ...
            %                                     'VideoOutputDataType', 'uint8');
            %       hidtc = vision.ImageDataTypeConverter; 
            %       hof = vision.OpticalFlow('ReferenceFrameDelay', 1);
            %       hof.OutputValue = 'Horizontal and vertical components in complex form';
            %       hvp = vision.VideoPlayer('Name', 'Motion Vector');
            %       while ~isDone(hvfr)
            %         frame = step(hvfr);
            %         im = step(hidtc, frame); % convert the image to 'single' precision
            %         of = step(hof, im);      % compute optical flow for the video
            %         lines = videooptflowlines(of, 20); % generate coordinate points 
            %         out = insertShape(im, 'Line', lines, ...
            %                    'Color', 'white'); % draw lines to indicate flow
            %         step(hvp, out);               % view in video player
            %       end
            %       release(hvp);
            %       release(hvfr);
            %
            %   See also insertShape, vision.Pyramid, vision.OpticalFlow.helpFixedPoint,
            %     opticalFlowHS, opticalFlowLK, opticalFlowLKDoG.
        end

        function getNumInputsImpl(in) %#ok<MANU>
        end

        function getNumOutputsImpl(in) %#ok<MANU>
        end

        function helpFixedPoint(in) %#ok<MANU>
            %helpFixedPoint Display vision.OpticalFlow System object fixed-point ...
            %               information
            %   vision.OpticalFlow.helpFixedPoint displays information about
            %   fixed-point properties and operations of the vision.OpticalFlow
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
            % cache state in private property for efficiency
        end

        function stepImpl(in) %#ok<MANU>
        end

        function validateInputsImpl(in) %#ok<MANU>
            % Input validation
        end

    end
    methods (Abstract)
    end
    properties
        %AccumulatorDataType Accumulator word- and fraction-length designations
        %   Specify the accumulator fixed-point data type as one of [{'Same as
        %   product'} | 'Custom']. This property is accessible when the Method
        %   property is 'Lucas-Kanade' and the TemporalGradientFilter is
        %   'Difference filter [-1 1]'.
        AccumulatorDataType;

        %BufferedFramesCount Number of frames to buffer for temporal smoothing
        %   Specify the number of frames to buffer for temporal smoothing as an
        %   odd integer between 3 and 31, both inclusive. The default value of
        %   this property is 3. This property determines characteristics such
        %   as the standard deviation and the number of filter coefficients of
        %   the Gaussian filter used to perform temporal filtering. This
        %   property is accessible when the Method property is
        %   'Lucas-Kanade' and the TemporalGradientFilter is 'Derivative of
        %   Gaussian'.
        BufferedFramesCount;

        %CustomAccumulatorDataType Accumulator word and fraction lengths
        %   Specify the accumulator fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is accessible when the Method
        %   property is 'Lucas-Kanade' and the TemporalGradientFilter is
        %   'Difference filter [-1 1]'. This property is applicable when the
        %   AccumulatorDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomAccumulatorDataType;

        %CustomGradientDataType Gradient word and fraction lengths
        %   Specify the gradient fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is accessible when the Method
        %   property is 'Lucas-Kanade' and the TemporalGradientFilter is
        %   'Difference filter [-1 1]'. This property is applicable when the
        %   GradientDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomGradientDataType;

        %CustomOutputDataType Output word and fraction lengths
        %   Specify the output fixed-point type as an auto-signed scaled
        %   numerictype object. This property is accessible when the Method
        %   property is 'Lucas-Kanade', the TemporalGradientFilter is
        %   'Difference filter [-1 1]' and the OutputDataType property is
        %   'Custom'. The default value of this property is
        %   numerictype([],32,20).
        %
        %   See also numerictype.
        CustomOutputDataType;

        %CustomProductDataType Product word and fraction lengths
        %   Specify the product fixed-point type as an auto-signed, scaled
        %   numerictype object. This property is accessible when the Method
        %   property is 'Lucas-Kanade' and the TemporalGradientFilter is
        %   'Difference filter [-1 1]'. This property is applicable when the
        %   ProductDataType property is 'Custom'. The default value of this
        %   property is numerictype([],32,20).
        %
        %   See also numerictype.
        CustomProductDataType;

        %CustomThresholdDataType Threshold word and fraction lengths
        %   Specify the threshold fixed-point type as an auto-signed
        %   numerictype object. This property is accessible when the Method
        %   property is 'Lucas-Kanade' and the TemporalGradientFilter is
        %   'Difference filter [-1 1]'. This property is applicable when the
        %   ThresholdDataType property is 'Custom'. The default value of this
        %   property is numerictype([],16,12).
        %
        %   See also numerictype.
        CustomThresholdDataType;

        %DiscardIllConditionedEstimates Discard normal flow estimates when
        %                               constraint equation is ill-conditioned
        %   Set this property to true if the motion vector should be set to 0
        %   when the optical flow constraint equation is ill-conditioned. The
        %   default value of this property is false. This property is
        %   accessible when the Method property is 'Lucas-Kanade' and the
        %   TemporalGradientFilter is 'Derivative of Gaussian'. This property
        %   is tunable.
        DiscardIllConditionedEstimates;

        %GradientDataType Gradient word- and fraction-length designations
        %   Specify the gradient fixed-point data type as one of [{'Same as
        %   accumulator'} | 'Same as product' | 'Custom']. This property is
        %   accessible when the Method property is 'Lucas-Kanade' and the
        %   TemporalGradientFilter is 'Difference filter [-1 1]'.
        GradientDataType;

        %GradientSmoothingFilterStandardDeviation Standard deviation for
        %                                         gradient smoothing filter
        %   Specify the standard deviation for the filter used to smooth the
        %   spatiotemporal image gradient components as a scalar number greater
        %   than 0. The default value of this property is 1. This property is
        %   accessible when the Method property is 'Lucas-Kanade' and the
        %   TemporalGradientFilter is 'Derivative of Gaussian'.
        GradientSmoothingFilterStandardDeviation;

        %ImageSmoothingFilterStandardDeviation Standard deviation for image
        %                                      smoothing filter
        %   Specify the standard deviation for the Gaussian filter used to
        %   smooth the image using spatial filtering as a scalar number greater
        %   than 0. The default value of this property is 1.5. This property is
        %   accessible when the Method property is 'Lucas-Kanade' and the
        %   TemporalGradientFilter is 'Derivative of Gaussian'.
        ImageSmoothingFilterStandardDeviation;

        %IterationTerminationCondition Condition to stop iterative solution
        %                              computation 
        %   Specify when the optical flow iterative solution should stop as one
        %   of [{'Maximum iteration count'} | 'Velocity difference threshold' 
        %   | 'Either']. This property is accessible when the Method property 
        %   is 'Horn-Schunck'.
        IterationTerminationCondition;

        %MaximumIterationCount Maximum number of iterations to perform
        %   Specify the maximum number of iterations to perform in the optical
        %   flow iterative solution computation as a scalar integer value
        %   greater than 0. The default value of this property is 10. This
        %   property is accessible when the Method property is 'Horn-Schunck'
        %   and the IterationTerminationCondition property is either 'Maximum 
        %   iteration count' or 'Either'. This property is tunable.
        MaximumIterationCount;

        %Method Algorithm used to compute optical flow
        %   Specify the algorithm to compute the optical flow as one of
        %   [ {'Horn-Schunck'} | 'Lucas-Kanade' ].
        Method;

        %MotionVectorImageOutputPort Return image corresponding to motion
        %                            vectors
        %   Set this property to true to output the image that corresponds to
        %   the motion vector being output by the object. The default value of
        %   this property is false. This property is accessible when the Method
        %   property is 'Lucas-Kanade' and the TemporalGradientFilter is
        %   'Derivative of Gaussian'.
        MotionVectorImageOutputPort;

        %NoiseReductionThreshold Threshold for noise reduction
        %   Specify the motion threshold between each image or video frame as a
        %   scalar number greater than 0. The higher the number, the less small
        %   movements impact the optical flow calculation. The default value of
        %   this property is 0.0039. This property is accessible when the
        %   Method property is 'Lucas-Kanade'. This property is tunable.
        NoiseReductionThreshold;

        %OutputDataType Output word- and fraction-length designations
        %   Specify the output fixed-point data type as 'Custom'. This property
        %   is accessible when the Method property is 'Lucas-Kanade' and the
        %   TemporalGradientFilter is 'Difference filter [-1 1]'.
        OutputDataType;

        %OutputValue Form of velocity output 
        %   Specify the velocity output as one of [ {'Magnitude-squared'} |
        %   'Horizontal and vertical components in complex form' ].
        OutputValue;

        %OverflowAction Overflow action for fixed-point operations
        %   Specify the overflow action as one of ['Wrap' | {'Saturate'}]. This
        %   property is accessible when the Method property is 'Lucas-Kanade'
        %   and the TemporalGradientFilter is 'Difference filter [-1 1]'.
        OverflowAction;

        %ProductDataType Product word- and fraction-length designations
        %   Specify the product fixed-point data type as 'Custom'. This
        %   property is accessible when the Method property is 'Lucas-Kanade'
        %   and the TemporalGradientFilter is 'Difference filter [-1 1]'.
        ProductDataType;

        %ReferenceFrameDelay Number of frames between reference frame and
        %                    current frame
        %   Specify the number of frames between the reference and current
        %   frame as a scalar integer value greater than 0. The default value
        %   of this property is 1. This property is accessible when the
        %   ReferenceFrameSource property is 'Property'.
        ReferenceFrameDelay;

        %ReferenceFrameSource Source of the reference frame used for the
        %                     optical flow calculation
        %   Specify computing optical flow between one of [ {'Property'} |
        %   'Input port' ].  When this property is set to 'Property', the
        %   ReferenceFrameDelay property is used to determine a previous frame
        %   with which to compare.  When this property is set to 'Input Port',
        %   an input image should be supplied for comparison. This property is
        %   accessible when the Method property is 'Horn-Schunck'. This
        %   property is also accessible when the Method property is
        %   'Lucas-Kanade' and the TemporalGradientFilter is 'Difference filter
        %   [-1 1]'.
        ReferenceFrameSource;

        %RoundingMethod Rounding method for fixed-point operations
        %   Specify the rounding method as one of ['Ceiling' | 'Convergent' |
        %   'Floor' | {'Nearest'} | 'Round' | 'Simplest' | 'Zero']. This
        %   property is accessible when the Method property is 'Lucas-Kanade'
        %   and the TemporalGradientFilter is 'Difference filter [-1 1]'.
        RoundingMethod;

        %Smoothness Term expressing expected smoothness of optical flow
        %   Specify the smoothness factor as a positive scalar number. If the
        %   relative motion between the two images or video frames is large,
        %   specify a large positive scalar value. If the relative motion is
        %   small, specify a small positive scalar value. The default value of
        %   this property is 1. This property is accessible when the Method
        %   property is 'Horn-Schunck'. This property is tunable.
        Smoothness;

        %TemporalGradientFilter Temporal gradient filter used by Lucas-Kanade
        %                       algorithm
        %   Specify the temporal gradient filter used by the Lucas-Kanade
        %   algorithm as one of [{'Difference filter [-1 1]'} | 'Derivative of
        %   Gaussian']. This property is accessible when the Method property
        %   is 'Lucas-Kanade'.
        TemporalGradientFilter;

        %ThresholdDataType Threshold word- and fraction-length designations
        %   Specify the threshold fixed-point data type as one of [{'Same word
        %   length as first input'} | 'Custom']. This property is accessible
        %   when the Method property is 'Lucas-Kanade' and the
        %   TemporalGradientFilter is 'Difference filter [-1 1]'.
        ThresholdDataType;

        %VelocityDifferenceThreshold Velocity difference threshold to stop
        %                            computation 
        %   Specify the velocity difference threshold to stop the optical flow
        %   iterative solution computation as a scalar number greater than 0.
        %   The default value of this property is eps. This property is
        %   accessible when the Method property is 'Horn-Schunck' and the
        %   IterationTerminationCondition property is either 'Maximum iteration
        %   count' or 'Either'. This property is tunable.
        VelocityDifferenceThreshold;

    end
end
