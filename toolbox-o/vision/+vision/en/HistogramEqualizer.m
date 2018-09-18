classdef HistogramEqualizer
%HistogramEqualizer Enhance contrast of images using histogram equalization
%   HHISTEQ = vision.HistogramEqualizer returns a System object, HHISTEQ,
%   that enhances the contrast of input image using histogram equalization.
%
%   HHISTEQ = vision.HistogramEqualizer('PropertyName', PropertyValue, ...)
%   returns a histogram equalization object, HHISTEQ, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   Y = step(HHISTEQ, X) performs histogram equalization on input image, X,
%   and returns the enhanced image, Y.
%
%   Y = step(HHISTEQ, X, HIST) performs histogram equalization on input
%   image, X, using input histogram, HIST, and returns the enhanced image,
%   Y when the Histogram property is 'Input port'.
%
%   HistogramEqualizer methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create histogram equalization object with same property
%              values
%   isLocked - Locked status (logical)
%
%   HistogramEqualizer properties:
%
%   Histogram       - How to specify histogram
%   CustomHistogram - Desired histogram of output image
%   BinCount        - Number of bins for uniform histogram
%
%   % EXAMPLE: Use HistogramEqualizer System object to enhance image quality.
%       hhisteq = vision.HistogramEqualizer;
%       x = imread('tire.tif');
%       y = step(hhisteq, x);
%       imshow(x); title('Original Image');
%       figure, imshow(y); title('Enhanced Image after histogram equalization');
%
%   See also vision.Histogram. 

 
%   Copyright 2008-2010 The MathWorks, Inc.

    methods
        function out=HistogramEqualizer
            %HistogramEqualizer Enhance contrast of images using histogram equalization
            %   HHISTEQ = vision.HistogramEqualizer returns a System object, HHISTEQ,
            %   that enhances the contrast of input image using histogram equalization.
            %
            %   HHISTEQ = vision.HistogramEqualizer('PropertyName', PropertyValue, ...)
            %   returns a histogram equalization object, HHISTEQ, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   Y = step(HHISTEQ, X) performs histogram equalization on input image, X,
            %   and returns the enhanced image, Y.
            %
            %   Y = step(HHISTEQ, X, HIST) performs histogram equalization on input
            %   image, X, using input histogram, HIST, and returns the enhanced image,
            %   Y when the Histogram property is 'Input port'.
            %
            %   HistogramEqualizer methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create histogram equalization object with same property
            %              values
            %   isLocked - Locked status (logical)
            %
            %   HistogramEqualizer properties:
            %
            %   Histogram       - How to specify histogram
            %   CustomHistogram - Desired histogram of output image
            %   BinCount        - Number of bins for uniform histogram
            %
            %   % EXAMPLE: Use HistogramEqualizer System object to enhance image quality.
            %       hhisteq = vision.HistogramEqualizer;
            %       x = imread('tire.tif');
            %       y = step(hhisteq, x);
            %       imshow(x); title('Original Image');
            %       figure, imshow(y); title('Enhanced Image after histogram equalization');
            %
            %   See also vision.Histogram. 
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %BinCount Number of bins for uniform histogram to have
        %   Specify the number of equally spaced bins the uniform histogram has
        %   as an integer scalar value greater than 1. This property is
        %   applicable when the Histogram property is 'Uniform'. The default
        %   value of this property is 64.
        BinCount;

        %CustomHistogram Desired histogram of output image
        %   Specify the desired histogram of output image as a numeric vector.
        %   This property is applicable when the Histogram property is 'Custom'.
        %   The default value of this property is ones(1,64).
        CustomHistogram;

        %Histogram How to specify histogram
        %   Specify the desired histogram of the output image as one of
        %   [{'Uniform'} | 'Input port' | 'Custom'].
        Histogram;

    end
end
