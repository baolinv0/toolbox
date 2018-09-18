classdef OpticalFlowEstimation
%OpticalFlowEstimation Optical Flow Estimation

   
%   Copyright 1995-2013 The MathWorks, Inc.

    methods
        function out=OpticalFlowEstimation
            %OpticalFlowEstimation Optical Flow Estimation
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        AccumulatorDataType;

        BufferedFramesCount;

        CustomAccumulatorDataType;

        CustomGradientDataType;

        CustomOutputDataType;

        CustomProductDataType;

        CustomThresholdDataType;

        DiscardIllConditionedEstimates;

        GradientDataType;

        GradientSmoothingFilterStandardDeviation;

        ImageSmoothingFilterStandardDeviation;

        IterationTerminationCondition;

        MaximumIterationCount;

        Method;

        MotionVectorImageOutputPort;

        NoiseReductionThreshold;

        OutputDataType;

        OutputValue;

        OverflowAction;

        ProductDataType;

        ReferenceFrameDelay;

        ReferenceFrameSource;

        RoundingMethod;

        Smoothness;

        TemporalGradientFilter;

        ThresholdDataType;

        VelocityDifferenceThreshold;

    end
end
