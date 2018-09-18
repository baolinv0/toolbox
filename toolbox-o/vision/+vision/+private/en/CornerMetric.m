classdef CornerMetric
%   Copyright 2003-2013 The MathWorks, Inc.

 
%   Copyright 2003-2013 The MathWorks, Inc.

    methods
        function out=CornerMetric
            %   Copyright 2003-2013 The MathWorks, Inc.
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
            % Corner Detector has variable outputs - but this sub-object only has
            % one, and it is always the 'data' output
        end

    end
    methods (Abstract)
    end
    properties
        AccumulatorDataType;

        CoefficientsDataType;

        CornerLocationOutputPort;

        CornerThreshold;

        CustomAccumulatorDataType;

        CustomCoefficientsDataType;

        CustomMemoryDataType;

        CustomMetricOutputDataType;

        CustomProductDataType;

        IntensityThreshold;

        MaximumAngleThreshold;

        MaximumCornerCount;

        MemoryDataType;

        Method;

        MetricMatrixOutputPort;

        MetricOutputDataType;

        NeighborhoodSize;

        OverflowAction;

        ProductDataType;

        RoundingMethod;

        Sensitivity;

        SmoothingFilterCoefficients;

    end
end
