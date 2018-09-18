classdef GeometricTransformEstimator
%GeometricTransformEstimator Estimate geometric transformation from matching point pairs
%   ----------------------------------------------------------------------------
%   It is recommended to use the new estimateGeometricTransform function 
%   in place of vision.GeometricTransformEstimator.
%   ----------------------------------------------------------------------------   
%
%   The GeometricTransformEstimator object estimates the geometric 
%   transformation from the matching point pairs and returns it as a 
%   matrix. It offers robust statistical approaches such as RANSAC or 
%   Least Median of Squares to compute projective, affine or nonreflective 
%   similarity transformations.
%
%   HGEOTFORMEST = vision.GeometricTransformEstimator returns a geometric 
%   transform estimation System object, HGEOTFORMEST. 
%
%   HGEOTFORMEST = vision.GeometricTransformEstimator('PropertyName',
%   PropertyValue, ...) returns a geometric transform estimation object,
%   HGEOTFORMEST, with each specified property set to the specified value.
%
%   Step method syntax:
%
%   TFORM = step(HGEOTFORMEST, MATCHEDPOINTS1, MATCHEDPOINTS2)
%   calculates the transformation matrix, TFORM, given a set of matching 
%   points in MATCHEDPOINTS1 and MATCHEDPOINTS2 arrays. MATCHEDPOINTS1 
%   and MATCHEDPOINTS2, specify the locations of matching points in two 
%   images. The points in the arrays are stored as a set of [x1 y1;
%   x2 y2; ...; xN yN] coordinates, where N is the number of points.
%   TFORM is 3-by-3 when the Transform property is 'Projective', and 3-by-2
%   otherwise.
%
%   [TFORM, INLIER_INDEX] = step(HGEOTFORMEST, ...) additionally outputs the 
%   logical vector, INLIER_INDEX, indicating which points are the inliers.
%
%   GeometricTransformEstimator methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create geometric transform estimation object with same
%              property values
%   isLocked - Locked status (logical)
%
%   GeometricTransformEstimator properties:
%
%   Transform                  - Transformation type
%   ExcludeOutliers            - Whether to exclude outliers from input
%                                points
%   Method                     - Method to find outliers
%   AlgebraicDistanceThreshold - Algebraic distance threshold for
%                                determining inliers
%   PixelDistanceThreshold     - Distance threshold for determining inliers
%                                in pixels
%   NumRandomSamplingsMethod   - How to specify number of random samplings
%   NumRandomSamplings         - Number of random samplings
%   DesiredConfidence          - Probability to find largest group of points
%   MaximumRandomSamples       - Maximum number of random samplings
%   InlierPercentageSource     - Source of inlier percentage
%   InlierPercentage           - Percentage of point pairs to be found to
%                                stop random sampling
%   RefineTransformMatrix      - Whether to refine transformation matrix
%   TransformMatrixDataType    - Data type of the transformation matrix
%
%   % EXAMPLE 1: Recover a transformed image using SURF feature points
%     Iin  = imread('cameraman.tif'); imshow(Iin); title('Base image');
%     Iout = imresize(Iin, 0.7); Iout = imrotate(Iout, 31);
%     figure; imshow(Iout); title('Transformed image');
%
%     % Detect and extract features from both images
%     ptsIn  = detectSURFFeatures(Iin);
%     ptsOut = detectSURFFeatures(Iout);
%     [featuresIn, validPtsIn]  = extractFeatures(Iin,  ptsIn);
%     [featuresOut, validPtsOut]  = extractFeatures(Iout, ptsOut);
%
%     % Match feature vectors
%     indexPairs = matchFeatures(featuresIn, featuresOut);
%     % get matching points
%     matchedPtsIn  = validPtsIn(indexPairs(:,1));
%     matchedPtsOut = validPtsOut(indexPairs(:,2));
%     figure; showMatchedFeatures(Iin,Iout,matchedPtsIn,matchedPtsOut);
%     title('Matched SURF points, including outliers');
%
%     % Compute the transformation matrix using RANSAC
%     gte = vision.GeometricTransformEstimator;
%     gte.Transform = 'Nonreflective similarity';
%     [tform, inlierIdx] = step(gte, matchedPtsOut.Location, ...
%                         matchedPtsIn.Location);
%     figure; showMatchedFeatures(Iin,Iout,matchedPtsIn(inlierIdx),...
%                     matchedPtsOut(inlierIdx));
%     title('Matching inliers'); legend('inliersIn', 'inliersOut');
%
%     % Recover the original image Iin from Iout
%     agt = vision.GeometricTransformer;
%     Ir = step(agt, im2single(Iout), tform);
%     figure; imshow(Ir); title('Recovered image');
%
%   % EXAMPLE 2: Transform an image according to the specified points.
%     input = checkerboard;
%     [h, w] = size(input);
%     inImageCorners = [1 1; w 1; w h; 1 h];
%     outImageCorners = [4 21; 21 121; 79 51; 26 6]; 
%     hgte1 = vision.GeometricTransformEstimator('ExcludeOutliers', false);
%     tform = step(hgte1, inImageCorners, outImageCorners);
%
%     % Use tform to transform the image
%     hgt = vision.GeometricTransformer;
%     output = step(hgt, input, tform);
%     figure; imshow(input); title('Original image');
%     figure; imshow(output); title('Transformed image'); 
%
%   See also estimateGeometricTransform, imwarp, extractFeatures.

     
%   Copyright 2008-2011 The MathWorks, Inc.

    methods
        function out=GeometricTransformEstimator
            %GeometricTransformEstimator Estimate geometric transformation from matching point pairs
            %   ----------------------------------------------------------------------------
            %   It is recommended to use the new estimateGeometricTransform function 
            %   in place of vision.GeometricTransformEstimator.
            %   ----------------------------------------------------------------------------   
            %
            %   The GeometricTransformEstimator object estimates the geometric 
            %   transformation from the matching point pairs and returns it as a 
            %   matrix. It offers robust statistical approaches such as RANSAC or 
            %   Least Median of Squares to compute projective, affine or nonreflective 
            %   similarity transformations.
            %
            %   HGEOTFORMEST = vision.GeometricTransformEstimator returns a geometric 
            %   transform estimation System object, HGEOTFORMEST. 
            %
            %   HGEOTFORMEST = vision.GeometricTransformEstimator('PropertyName',
            %   PropertyValue, ...) returns a geometric transform estimation object,
            %   HGEOTFORMEST, with each specified property set to the specified value.
            %
            %   Step method syntax:
            %
            %   TFORM = step(HGEOTFORMEST, MATCHEDPOINTS1, MATCHEDPOINTS2)
            %   calculates the transformation matrix, TFORM, given a set of matching 
            %   points in MATCHEDPOINTS1 and MATCHEDPOINTS2 arrays. MATCHEDPOINTS1 
            %   and MATCHEDPOINTS2, specify the locations of matching points in two 
            %   images. The points in the arrays are stored as a set of [x1 y1;
            %   x2 y2; ...; xN yN] coordinates, where N is the number of points.
            %   TFORM is 3-by-3 when the Transform property is 'Projective', and 3-by-2
            %   otherwise.
            %
            %   [TFORM, INLIER_INDEX] = step(HGEOTFORMEST, ...) additionally outputs the 
            %   logical vector, INLIER_INDEX, indicating which points are the inliers.
            %
            %   GeometricTransformEstimator methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create geometric transform estimation object with same
            %              property values
            %   isLocked - Locked status (logical)
            %
            %   GeometricTransformEstimator properties:
            %
            %   Transform                  - Transformation type
            %   ExcludeOutliers            - Whether to exclude outliers from input
            %                                points
            %   Method                     - Method to find outliers
            %   AlgebraicDistanceThreshold - Algebraic distance threshold for
            %                                determining inliers
            %   PixelDistanceThreshold     - Distance threshold for determining inliers
            %                                in pixels
            %   NumRandomSamplingsMethod   - How to specify number of random samplings
            %   NumRandomSamplings         - Number of random samplings
            %   DesiredConfidence          - Probability to find largest group of points
            %   MaximumRandomSamples       - Maximum number of random samplings
            %   InlierPercentageSource     - Source of inlier percentage
            %   InlierPercentage           - Percentage of point pairs to be found to
            %                                stop random sampling
            %   RefineTransformMatrix      - Whether to refine transformation matrix
            %   TransformMatrixDataType    - Data type of the transformation matrix
            %
            %   % EXAMPLE 1: Recover a transformed image using SURF feature points
            %     Iin  = imread('cameraman.tif'); imshow(Iin); title('Base image');
            %     Iout = imresize(Iin, 0.7); Iout = imrotate(Iout, 31);
            %     figure; imshow(Iout); title('Transformed image');
            %
            %     % Detect and extract features from both images
            %     ptsIn  = detectSURFFeatures(Iin);
            %     ptsOut = detectSURFFeatures(Iout);
            %     [featuresIn, validPtsIn]  = extractFeatures(Iin,  ptsIn);
            %     [featuresOut, validPtsOut]  = extractFeatures(Iout, ptsOut);
            %
            %     % Match feature vectors
            %     indexPairs = matchFeatures(featuresIn, featuresOut);
            %     % get matching points
            %     matchedPtsIn  = validPtsIn(indexPairs(:,1));
            %     matchedPtsOut = validPtsOut(indexPairs(:,2));
            %     figure; showMatchedFeatures(Iin,Iout,matchedPtsIn,matchedPtsOut);
            %     title('Matched SURF points, including outliers');
            %
            %     % Compute the transformation matrix using RANSAC
            %     gte = vision.GeometricTransformEstimator;
            %     gte.Transform = 'Nonreflective similarity';
            %     [tform, inlierIdx] = step(gte, matchedPtsOut.Location, ...
            %                         matchedPtsIn.Location);
            %     figure; showMatchedFeatures(Iin,Iout,matchedPtsIn(inlierIdx),...
            %                     matchedPtsOut(inlierIdx));
            %     title('Matching inliers'); legend('inliersIn', 'inliersOut');
            %
            %     % Recover the original image Iin from Iout
            %     agt = vision.GeometricTransformer;
            %     Ir = step(agt, im2single(Iout), tform);
            %     figure; imshow(Ir); title('Recovered image');
            %
            %   % EXAMPLE 2: Transform an image according to the specified points.
            %     input = checkerboard;
            %     [h, w] = size(input);
            %     inImageCorners = [1 1; w 1; w h; 1 h];
            %     outImageCorners = [4 21; 21 121; 79 51; 26 6]; 
            %     hgte1 = vision.GeometricTransformEstimator('ExcludeOutliers', false);
            %     tform = step(hgte1, inImageCorners, outImageCorners);
            %
            %     % Use tform to transform the image
            %     hgt = vision.GeometricTransformer;
            %     output = step(hgt, input, tform);
            %     figure; imshow(input); title('Original image');
            %     figure; imshow(output); title('Transformed image'); 
            %
            %   See also estimateGeometricTransform, imwarp, extractFeatures.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %AlgebraicDistanceThreshold Algebraic distance threshold for
        %                           determining inliers
        %   Specify a scalar threshold value for determining inliers as a
        %   positive scalar value. The threshold controls the upper limit used
        %   to find the algebraic distance in the RANSAC Method. This property
        %   is applicable when the Transform property is 'Projective' and the
        %   Method property is 'Random Sample Consensus (RANSAC)'. The default
        %   value of this property is 2.5. This property is tunable.
        AlgebraicDistanceThreshold;

        %DesiredConfidence Probability to find largest group of points
        %   Specify the probability to find the largest group of points that
        %   can be mapped by a transformation matrix as a percentage. This
        %   property is applicable when the NumRandomSamplingsMethod property
        %   is 'Desired confidence'. The default value of this property is 99.
        %   This property is tunable.
        DesiredConfidence;

        %ExcludeOutliers Whether to exclude outliers from input points
        %   Set this property to true to find and exclude outliers from the
        %   input points and use only the inlier points to calculate the
        %   transformation matrix. When this property is false, all input
        %   points are used to calculate the transformation matrix. The default
        %   value of this property is true.
        ExcludeOutliers;

        %InlierOutputPort Enables output of the inlier point pairs 
        %   Set this property to true to output the inlier point pairs that
        %   were used to calculate the transformation matrix. This property is
        %   applicable when the ExcludeOutliers property is true. The default 
        %   value of this property is true.
        InlierOutputPort;

        %InlierPercentage Percentage of point pairs to be found to stop random 
        %                 sampling
        %   Specify the percentage of point pairs that need to be determined as
        %   inliers to stop random sampling. This property is applicable when
        %   the InlierPercentageSource property is 'Property'. The
        %   default value of this property is 75. This property is tunable.
        InlierPercentage;

        %InlierPercentageSource Source of inlier percentage
        %   Indicate how to specify the threshold to stop random sampling when
        %   a percentage of input point pairs have been found as inliers. This
        %   property can be set to one of [{'Auto'} | 'Property']. If set to 'Auto'
        %   then inlier threshold is disabled. This property is applicable when
        %   the Method property is 'Random Sample Consensus (RANSAC)'.
        InlierPercentageSource;

        %MaximumRandomSamples Maximum number of random samplings
        %   Specify the maximum number of random samplings as a positive
        %   integer value. This property is applicable when the
        %   NumRandomSamplingsMethod property is 'Desired confidence'. The
        %   default value of this property is 1000. This property is tunable.
        MaximumRandomSamples;

        %Method Method to find outliers
        %   Specify the Method to find outliers as one of [{'Random Sample
        %   Consensus (RANSAC)'} | 'Least Median of Squares'].
        Method;

        %NumRandomSamplings Number of random samplings 
        %  Specify the number of random samplings for the Method to perform
        %  as a positive integer value. This property is applicable when the
        %  NumRandomSamplingsMethod property is 'Specified value'. The default
        %  value of this property is 500. This property is tunable.
        NumRandomSamplings;

        %NumRandomSamplingsMethod How to specify number of random samplings
        %   Indicate how to specify number of random samplings as one of
        %   [{'Specified value'} | 'Desired confidence']. Set this property to
        %   'Desired confidence' to specify the number of random samplings as a
        %   percentage and a maximum number. This property is applicable when
        %   the ExcludeOutliers property is true and the Method property is
        %   'Random Sample Consensus (RANSAC)'.
        NumRandomSamplingsMethod;

        %PixelDistanceThreshold Distance threshold for determining inliers in 
        %                       pixels
        %   Specify the upper limit distance a point can differ from the
        %   projection location of its associating point as a positive scalar
        %   value. This property is applicable when the Transform property is
        %   'Nonreflective similarity' or 'Affine', and the Method property is
        %   'Random Sample Consensus (RANSAC)'. The default value of this
        %   property is 2.5. This property is tunable.
        PixelDistanceThreshold;

        %RefineTransformMatrix Whether to refine transformation matrix
        %   Set this property to true to perform additional iterative
        %   refinement on the transformation matrix. This property is
        %   applicable when the ExcludeOutliers property is true. The default
        %   value of this property is false.
        RefineTransformMatrix;

        %Transform Transformation type
        %   Specify transformation type as one of ['Nonreflective similarity' |
        %   {'Affine'} | 'Projective'].
        Transform;

        %TransformMatrixDataType Data type of the transformation matrix
        %   Specify transformation matrix data type as one of [{'single'} |
        %   'double'] when the input points are built-in integers. This
        %   property is not used when the data type of points is single or
        %   double.
        TransformMatrixDataType;

    end
end
