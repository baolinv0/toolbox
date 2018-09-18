classdef GeometricTransformer
%GeometricTransformer Apply 2-D spatial transformation
%   HTRANS = vision.GeometricTransformer returns a geometric transformation
%   System object, HTRANS, which applies projective or affine
%   transformation to an image.
%
%   HTRANS = vision.GeometricTransformer('PropertyName',PropertyValue,...)
%   returns a geometric transformation object, HTRANS, with each specified
%   property set to the specified value.
%
%   Step method syntax:
%
%   J = step(HTRANS, I ,TFORM) outputs the transformed image, J, of the
%   input image, I. I is either an M-by-N or an M-by-N-by-P matrix, where M
%   is the number of rows, N is the number of columns, and P is the number
%   of color planes in the image. TFORM is the applied transformation
%   matrix. TFORM can be a 3-by-2 or Q-by-6 affine transformation matrix,
%   or a 3-by-3 or Q-by-9 projective transformation matrix, where Q is the
%   number of transformations.
%
%   J = step(HTRANS, I) outputs the transformed image, J, of the input
%   image, I, when the TransformMatrixSource property is 'Property'.
%
%   J = step(HTRANS, I, ROI) outputs the transformed image of the input
%   image within the region of interest, ROI. When specifying a rectangular
%   region of interest, ROI must be a 4-element vector or an R-by-4 matrix.
%   When specifying a polygonal region of interest, ROI must be a
%   2L-element vector or an R-by-2L matrix. R is the number of regions of
%   interest, and L is the number of vertices in a polygon region of
%   interest.
%
%   [J, ROIFLAG] = (HTRANS, I, ...) returns a logical flag, ROIFLAG,
%   indicating if any part of the region of interest is outside the input
%   image, when the ROIValidityOutputPort property is true.
%
%   [J, CLIPFLAG] = (HTRANS, I, ...) returns a logical flag, CLIPFLAG,
%   indicating if any transformed pixels were clipped, when the
%   ClippingStatusOutputPort property is true.
%
%   The above operations can be used simultaneously, provided the System
%   object properties are set appropriately. One example of providing all
%   possible inputs is shown below: [J, ROIFLAG, CLIPFLAG] = step(HTRANS,
%   I, TFORM, ROI) outputs the transformed image, J, of the input image, I,
%   within the region of interest, ROI, and using the transformation
%   matrix, TFORM. ROIFLAG, indicating if any part of the region of
%   interest is outside the input image, and CLIPFLAG, indicating if any
%   transformed pixels were clipped, are also returned.
%
%   GeometricTransformer methods:
%
%   step     - See above description for use of this method
%   release  - Allow property value and input characteristics changes
%   clone    - Create geometric transformation object with same property values
%   isLocked - Locked status (logical)
%
%   GeometricTransformer properties:
%
%   TransformMatrixSource     - Source of transformation matrix
%   TransformMatrix           - Transformation matrix
%   InterpolationMethod       - Interpolation method
%   BackgroundFillValue       - Background fill value
%   OutputImagePositionSource - How to specify output image location and
%                               size
%   OutputImagePosition       - Output image position vector [x y width 
%                               height]
%   ROIInputPort              - Enables the region of interest input port
%   ROIShape                  - Shape of the region of interest
%   ROIValidityOutputPort     - Output flag indicating if any part of ROI is
%                               outside input image
%   ProjectiveTransformMethod - Projective transformation method
%   ErrorTolerance            - Error tolerance (in pixels)
%   ClippingStatusOutputPort  - Enables clipping status flag output
%
%   % EXAMPLE #1: Apply a horizontal shear to an intensity image.
%      htrans1 = vision.GeometricTransformer(...
%                 'TransformMatrixSource', 'Property', ...
%                 'TransformMatrix',[1 0 0; .5 1 0; 0 0 1],...
%                 'OutputImagePositionSource', 'Property',...
%                 'OutputImagePosition', [0 0 750 400]);
%      img1 = im2single(rgb2gray(imread('peppers.png')));
%      transimg1 = step(htrans1,img1);
%      figure; imshow(transimg1);
%
%   % EXAMPLE #2: Apply a transform with multiple polygon ROI's.
%      htrans2 = vision.GeometricTransformer;
%      img2 = checker_board(20,10);
%
%      tformMat = [     1        0       30        0       1      -30; ...
%                  1.0204  -0.4082       70        0  0.4082       30; ...
%                  0.4082        0  89.1836  -0.4082       1  10.8164];
%                
%      polyROI = [  1   101    99   101    99   199     1   199; ...
%                   1     1    99     1    99    99     1    99; ...
%                 101   101   199   101   199   199   101   199];
%
%      htrans2.BackgroundFillValue = [0.5 0.5 0.75];
%      htrans2.ROIInputPort = true;
%      htrans2.ROIShape = 'Polygon ROI';
%      transimg2 = step(htrans2,img2,tformMat,polyROI);
%      figure; imshow(img2);
%      figure; imshow(transimg2);
%
%   See also vision.GeometricTransformEstimator.

 
%   Copyright 2004-2010 The MathWorks, Inc.

    methods
        function out=GeometricTransformer
            %GeometricTransformer Apply 2-D spatial transformation
            %   HTRANS = vision.GeometricTransformer returns a geometric transformation
            %   System object, HTRANS, which applies projective or affine
            %   transformation to an image.
            %
            %   HTRANS = vision.GeometricTransformer('PropertyName',PropertyValue,...)
            %   returns a geometric transformation object, HTRANS, with each specified
            %   property set to the specified value.
            %
            %   Step method syntax:
            %
            %   J = step(HTRANS, I ,TFORM) outputs the transformed image, J, of the
            %   input image, I. I is either an M-by-N or an M-by-N-by-P matrix, where M
            %   is the number of rows, N is the number of columns, and P is the number
            %   of color planes in the image. TFORM is the applied transformation
            %   matrix. TFORM can be a 3-by-2 or Q-by-6 affine transformation matrix,
            %   or a 3-by-3 or Q-by-9 projective transformation matrix, where Q is the
            %   number of transformations.
            %
            %   J = step(HTRANS, I) outputs the transformed image, J, of the input
            %   image, I, when the TransformMatrixSource property is 'Property'.
            %
            %   J = step(HTRANS, I, ROI) outputs the transformed image of the input
            %   image within the region of interest, ROI. When specifying a rectangular
            %   region of interest, ROI must be a 4-element vector or an R-by-4 matrix.
            %   When specifying a polygonal region of interest, ROI must be a
            %   2L-element vector or an R-by-2L matrix. R is the number of regions of
            %   interest, and L is the number of vertices in a polygon region of
            %   interest.
            %
            %   [J, ROIFLAG] = (HTRANS, I, ...) returns a logical flag, ROIFLAG,
            %   indicating if any part of the region of interest is outside the input
            %   image, when the ROIValidityOutputPort property is true.
            %
            %   [J, CLIPFLAG] = (HTRANS, I, ...) returns a logical flag, CLIPFLAG,
            %   indicating if any transformed pixels were clipped, when the
            %   ClippingStatusOutputPort property is true.
            %
            %   The above operations can be used simultaneously, provided the System
            %   object properties are set appropriately. One example of providing all
            %   possible inputs is shown below: [J, ROIFLAG, CLIPFLAG] = step(HTRANS,
            %   I, TFORM, ROI) outputs the transformed image, J, of the input image, I,
            %   within the region of interest, ROI, and using the transformation
            %   matrix, TFORM. ROIFLAG, indicating if any part of the region of
            %   interest is outside the input image, and CLIPFLAG, indicating if any
            %   transformed pixels were clipped, are also returned.
            %
            %   GeometricTransformer methods:
            %
            %   step     - See above description for use of this method
            %   release  - Allow property value and input characteristics changes
            %   clone    - Create geometric transformation object with same property values
            %   isLocked - Locked status (logical)
            %
            %   GeometricTransformer properties:
            %
            %   TransformMatrixSource     - Source of transformation matrix
            %   TransformMatrix           - Transformation matrix
            %   InterpolationMethod       - Interpolation method
            %   BackgroundFillValue       - Background fill value
            %   OutputImagePositionSource - How to specify output image location and
            %                               size
            %   OutputImagePosition       - Output image position vector [x y width 
            %                               height]
            %   ROIInputPort              - Enables the region of interest input port
            %   ROIShape                  - Shape of the region of interest
            %   ROIValidityOutputPort     - Output flag indicating if any part of ROI is
            %                               outside input image
            %   ProjectiveTransformMethod - Projective transformation method
            %   ErrorTolerance            - Error tolerance (in pixels)
            %   ClippingStatusOutputPort  - Enables clipping status flag output
            %
            %   % EXAMPLE #1: Apply a horizontal shear to an intensity image.
            %      htrans1 = vision.GeometricTransformer(...
            %                 'TransformMatrixSource', 'Property', ...
            %                 'TransformMatrix',[1 0 0; .5 1 0; 0 0 1],...
            %                 'OutputImagePositionSource', 'Property',...
            %                 'OutputImagePosition', [0 0 750 400]);
            %      img1 = im2single(rgb2gray(imread('peppers.png')));
            %      transimg1 = step(htrans1,img1);
            %      figure; imshow(transimg1);
            %
            %   % EXAMPLE #2: Apply a transform with multiple polygon ROI's.
            %      htrans2 = vision.GeometricTransformer;
            %      img2 = checker_board(20,10);
            %
            %      tformMat = [     1        0       30        0       1      -30; ...
            %                  1.0204  -0.4082       70        0  0.4082       30; ...
            %                  0.4082        0  89.1836  -0.4082       1  10.8164];
            %                
            %      polyROI = [  1   101    99   101    99   199     1   199; ...
            %                   1     1    99     1    99    99     1    99; ...
            %                 101   101   199   101   199   199   101   199];
            %
            %      htrans2.BackgroundFillValue = [0.5 0.5 0.75];
            %      htrans2.ROIInputPort = true;
            %      htrans2.ROIShape = 'Polygon ROI';
            %      transimg2 = step(htrans2,img2,tformMat,polyROI);
            %      figure; imshow(img2);
            %      figure; imshow(transimg2);
            %
            %   See also vision.GeometricTransformEstimator.
        end

        function isInactivePropertyImpl(in) %#ok<MANU>
        end

        function setPortDataTypeConnections(in) %#ok<MANU>
        end

    end
    methods (Abstract)
    end
    properties
        %BackgroundFillValue Background fill value
        %   Specify the value of the pixels that are outside of the input
        %   image. The value can be either scalar or a P-element vector, where
        %   P is the number of color planes. The default value is 0.
        BackgroundFillValue;

        %ClippingStatusOutputPort Enables clipping status flag output
        %   Set this property to true to enable the output of a flag indicating
        %   if any part of the output image is outside the input image. The
        %   default value is false.
        ClippingStatusOutputPort;

        %ErrorTolerance Error tolerance (in pixels)
        %   Specify the maximum error tolerance in pixels for the projective
        %   transformation. This property is applicable when the
        %   ProjectiveTransformMethod property is 'Use quadratic
        %   approximation'. The default value is 1.
        ErrorTolerance;

        %InterpolationMethod Interpolation method 
        %   Specify the InterpolationMethod property as one of ['Nearest
        %   neighbor' | {'Bilinear'} | 'Bicubic'] for calculating the output
        %   pixel value.
        InterpolationMethod;

        %OutputImagePosition Output image position vector [x y width height]
        %   Specify the location and size of output image in pixels, as a
        %   four-element vector of the form: [x y width height]. This property
        %   is applicable when the OutputImagePositionSource property is
        %   'Property'. The default value is [1 1 512 512].
        OutputImagePosition;

        %OutputImagePositionSource How to specify output image location and size
        %   Specify the OutputImagePositionSource property as one of [{'Auto'} |
        %   'Property'].  If this property is set to 'Auto', the output image
        %   location and size are the same values as the input image.
        OutputImagePositionSource;

        %ProjectiveTransformMethod Projective transformation method
        %   Specify as [{'Compute exact values'} | 'Use quadratic
        %   approximation'] the method to compute the projective
        %   transformation.
        ProjectiveTransformMethod;

        %ROIInputPort Enables the region of interest input port
        %   Set this property to true to enable the input of the region of
        %   interest. When set to false, then the whole input image is
        %   processed. The default value of this property is false.
        ROIInputPort;

        %ROIShape Shape of the region of interest
        %   Specify ROIShape as one of [{'Rectangle ROI'} | 'Polygon ROI'].
        %   This property is applicable when the ROIInputPort property is true.
        ROIShape;

        %ROIValidityOutputPort Output flag indicating if any part of ROI is
        %                      outside input image
        %   Set this property to true to enable the output of an ROI flag
        %   indicating when any part of the ROI is outside the input image. This
        %   property is applicable when the ROIInputPort property is true. The
        %   default value is false.
        ROIValidityOutputPort;

        %TransformMatrix Transformation matrix
        %   Specify the applied transformation matrix as a 3-by-2 or Q-by-6
        %   affine transformation matrix or a 3-by-3 or Q-by-9 projective
        %   transformation matrix. Q is the number of transformations. This
        %   property is applicable when the TransformMatrixSource property is
        %   'Property'. The default value is [1 0 0; 0 1 0; 0 0 1].
        TransformMatrix;

        %TransformMatrixSource How to specify transformation matrix
        %   Specify the TransformMatrixSource property as one of ['Property' |
        %   {'Input port'}].
        TransformMatrixSource;

    end
end
