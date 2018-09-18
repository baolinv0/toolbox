% 

%#codegen
%#ok<*EMCLS>
%#ok<*EMCA>        
classdef CameraParametersImpl < vision.internal.EnforceScalarHandle
    properties (GetAccess=public, SetAccess=protected)
        % RadialDistortion A 2-element vector [k1 k2] or a 3-element
        %   vector [k1 k2 k3]. If a 2-element vector is supplied, k3 is
        %   assumed to be 0. The radial distortion is caused by the fact
        %   that light rays are bent more the farther away they are from
        %   the optical center. Distorted location of a point is computed
        %   as follows:
        %     x_distorted = x(1 + k1 * r^2 + k2 * r^4 + k3 * r^6)
        %     y_distorted = y(1 + k1 * r^2 + k2 * r^4 + k3 * r^6)
        %   where [x,y] is a non-distorted image point in normalized image
        %   coordinates in world units with the origin at the optical center,
        %   and r^2 = x^2 + y^2. Typically two coefficients are sufficient,
        %   and k3 is only needed for severe distortion.
        %
        %   Default: [0 0 0]
        RadialDistortion;
        
        % TangentialDistortion A 2-element vector [p1 p2]. Tangential
        %   distortion is caused by the lens not being exactly parallel to
        %   to the image plane. Distorted location of a point is computed
        %   as follows:
        %     x_distorted = x + [2 * p1 * x * y + p2 * (r^2 + 2 * x^2)]
        %     y_distorted = y + [p1 * (r^2 + 2*y^2) + 2 * p2 * x * y]
        %   where [x,y] is a non-distorted image point in normalized image
        %   coordinates in world units with the origin at the optical center,
        %   and r^2 = x^2 + y^2.
        %
        %   Default: [0 0]'
        TangentialDistortion;
        
        % WorldPoints An M-by-2 array of [x,y] world coordinates of
        %   keypoints on the calibration pattern, where M is the number of
        %   keypoints in the pattern.  WorldPoints must be non-empty for
        %   showExtrinsics to work.
        %
        %   Default: []
        WorldPoints;
        
        % WorldUnits A string describing the units, in which the
        %   WorldPoints are specified.
        %
        %   Default: 'mm'
        WorldUnits;
        
        % EstimateSkew A logical scalar that specifies whether image axes
        %   skew was estimated. When set to false, the image axes are
        %   assumed to be exactly perpendicular.
        %
        %   Default: false
        EstimateSkew;
        
        % NumRadialDistortionCoefficients 2 or 3. Specifies the number
        %   of radial distortion coefficients that were estimated.
        %
        %   Default: 2
        NumRadialDistortionCoefficients;
        
        % EstimateTangentialDistortion A logical scalar that specifies
        %   whether tangential distortion was estimated. When set to false,
        %   tangential distortion is assumed to be negligible.
        %
        %   Default: false
        EstimateTangentialDistortion;
        
        % TranslationVectors An M-by-3 matrix containing M translation vectors.
        %   Each vector describes the translation of the camera's image plane
        %   relative to the corresponding calibration pattern in world units.
        %
        %   The transformation relating a world point [X Y Z] and the
        %   corresponding image point [x y] is given by the following equation:
        %              s * [x y 1] = [X Y Z 1] * [R; t] * K
        %   where
        %     - R is the 3-D rotation matrix
        %     - t is the translation vector
        %     - K is the IntrinsicMatrix
        %     - s is a scalar
        %   Note that this equation does not account for lens distortion.
        %   Thus it assumes that the distortion has been removed using
        %   undistortImage function.
        %
        %   Default: []
        TranslationVectors;
        
        % ReprojectionErrors An M-by-2-by-P array of [x,y] pairs representing
        %   the translation in x and y between the reprojected pattern
        %   keypoints and the detected pattern keypoints. These values
        %   indicate the accuracy of the estimated camera parameters. P is
        %   the number of pattern images used to estimate camera
        %   parameters, and M is the number of keypoints in each image.
        ReprojectionErrors;
    end
        
    properties (GetAccess=public, SetAccess=protected)
        % RotationVectors An M-by-3 matrix containing M rotation vectors
        %   Each vector describes the 3-D rotation of the camera's image
        %   plane relative to the corresponding calibration pattern. The
        %   vector specifies the 3-D axis about which the camera is rotated,
        %   and its magnitude is the rotation angle in radians. The
        %   corresponding 3-D rotation matrices are given by the
        %   RotationMatrices property.
        %
        %   Default: []
        RotationVectors;
    end
    
    properties(Dependent)
        % NumPatterns The number of calibration patterns which were used to
        %   estimate the camera extrinsics. This is also the number of
        %   translation and rotation vectors.
        NumPatterns;
        
        % IntrinsicMatrix A 3-by-3 projection matrix of the form
        %   [fx 0 0; s fy 0; cx cy 1], where [cx, cy] are the coordinates
        %   of the optical center (the principal point) in pixels and s is
        %   the skew parameter which is 0 if the x and y axes are exactly
        %   perpendicular. fx = F * sx and fy = F * sy, where F is the
        %   focal length in world units, typically millimeters, and [sx, sy]
        %   are the number of pixels per world unit in the x and y direction
        %   respectively. Thus, fx and fy are in pixels.
        %
        %   Default: eye(3)
        IntrinsicMatrix;
        
        % FocalLength A 2-element vector [fx, fy].  fx = F * sx and
        %   fy = F * sy, where F is the focal length in world units,
        %   typically millimeters, and [sx, sy] are the number of pixels
        %   per world unit in the x and y direction respectively. Thus,
        %   fx and fy are in pixels.
        FocalLength;
        
        % PrincipalPoint A 2-element vector [cx, cy], containing the
        %   coordinates of the optical center of the camera in pixels.
        PrincipalPoint;
        
        % Skew A scalar, containing the camera axes skew, which is 0 if the
        % x and the y axes are exactly perpendicular.
        Skew;
        
        % MeanReprojectionError Average Euclidean distance between
        %   reprojected points and detected points.
        MeanReprojectionError;
        
        % ReprojectedPoints An M-by-2-by-NumPatterns array of [x,y] coordinates of
        %   world points re-projected onto calibration images. M is the
        %   number of points per image. NumPatterns is the number of
        %   patterns.
        ReprojectedPoints;
        
        % RotationMatrices A 3-by-3-by-P array containing P rotation matrices.
        %   Each 3-by-3 matrix represents the 3-D rotation of the camera's
        %   image plane relative to the corresponding calibration pattern.
        %
        %   The transformation relating a world point [X Y Z] and the
        %   corresponding image point [x y] is given by the following equation:
        %              s * [x y 1] = [X Y Z 1] * [R; t] * K
        %   where
        %     - R is the 3-D rotation matrix
        %     - t is the translation vector
        %     - K is the IntrinsicMatrix
        %     - s is a scalar
        %   Note that this equation does not account for lens distortion.
        %   Thus it assumes that the distortion has been removed using
        %   undistortImage function.
        RotationMatrices;
    end
    
    properties (Access=protected, Hidden)
        UndistortMap;
        IntrinsicMatrixInternal;
        Version = ver('vision');
    end
    
    
    methods
        %----------------------------------------------------------------------
        function this = CameraParametersImpl(varargin)
            if isempty(coder.target)                
                parser = inputParser;
                parser.addParameter('IntrinsicMatrix', eye(3),...
                    @vision.internal.calibration.CameraParametersImpl.checkIntrinsicMatrix);
                parser.addParameter('RadialDistortion', [0 0 0], ...
                    @vision.internal.calibration.CameraParametersImpl.checkRadialDistortion);
                parser.addParameter('TangentialDistortion', [0 0],...
                    @vision.internal.calibration.CameraParametersImpl.checkTangentialDistortion);
                parser.addParameter('RotationVectors', zeros(0, 3), ...
                    @vision.internal.calibration.CameraParametersImpl.checkRotationVectors);
                parser.addParameter('TranslationVectors', zeros(0, 3), ...
                    @vision.internal.calibration.CameraParametersImpl.checkTranslationVectors);
                parser.addParameter('WorldPoints', zeros(0, 2), ...
                    @vision.internal.calibration.CameraParametersImpl.checkWorldPoints);
                parser.addParameter('WorldUnits', 'mm',...
                    @vision.internal.calibration.CameraParametersImpl.checkWorldUnits);
                parser.addParameter('EstimateSkew', false, ...
                    @vision.internal.calibration.CameraParametersImpl.checkEstimateSkew);
                parser.addParameter('NumRadialDistortionCoefficients', 2, ...
                    @vision.internal.calibration.CameraParametersImpl.checkNumRadialCoeffs);
                parser.addParameter('EstimateTangentialDistortion', false, ...
                    @vision.internal.calibration.CameraParametersImpl.checkEstimateTangentialDistortion);
                parser.addParameter('ReprojectionErrors', zeros(0, 2), ...
                    @vision.internal.calibration.CameraParametersImpl.checkReprojectionErrors);
                parser.addParameter('Version', ver('vision'));
                
                parser.parse(varargin{:});
                paramStruct = parser.Results;
                
                this.IntrinsicMatrixInternal = paramStruct.IntrinsicMatrix';
                this.RadialDistortion = paramStruct.RadialDistortion(:)';
                this.TangentialDistortion = paramStruct.TangentialDistortion(:)';
                this.WorldPoints = paramStruct.WorldPoints;
                this.WorldUnits = paramStruct.WorldUnits;
                this.EstimateSkew = paramStruct.EstimateSkew;
                this.NumRadialDistortionCoefficients = ...
                    paramStruct.NumRadialDistortionCoefficients;
                this.EstimateTangentialDistortion = ...
                    paramStruct.EstimateTangentialDistortion;
                
                this.RotationVectors = paramStruct.RotationVectors;
                this.TranslationVectors = paramStruct.TranslationVectors;
                if isempty(paramStruct.ReprojectionErrors)
                    this.ReprojectionErrors = zeros(0, 2);
                else
                    this.ReprojectionErrors = paramStruct.ReprojectionErrors;
                end
            else
                parseInputsCodegen(this, varargin{:});
            end
            
            coder.internal.errorIf((isempty(this.RotationVectors) && ...
                    ~isempty(this.TranslationVectors)) || ...
                    (isempty(this.TranslationVectors) && ...
                    ~isempty(this.RotationVectors)),... 
                'vision:calibrate:rotationAndTranslationVectorsMustBeSetTogether');
            
            coder.internal.errorIf(...
                any(size(this.RotationVectors) ~= size(this.TranslationVectors)),...
                'vision:calibrate:rotationAndTranslationVectorsNotSameSize');
            
            coder.internal.errorIf(~isempty(this.ReprojectionErrors) &&...
                size(this.ReprojectionErrors, 3) ~= size(this.TranslationVectors, 1),...
                'vision:calibrate:reprojectionErrorsSizeMismatch');
            
            % Initialize the undistort map property. It must be done in the
            % constructor in order to successfully cache the undistortion
            % map inside a CameraParameters object.
            this.UndistortMap = vision.internal.calibration.ImageTransformer;
        end
        
        %------------------------------------------------------------------
        function paramStruct = toStruct(this)
            % toStruct Convert a cameraParameters object into a struct.
            %   paramStruct = toStruct(cameraParams) returns a struct
            %   containing the camera parameters, which can be used to
            %   create an identical cameraParameters object.
            %
            %   This method is useful for C code generation. You can call
            %   toStruct, and then pass the resulting structure into the generated
            %   code, which re-creates the cameraParameters object.
            paramStruct = saveobj(this);
        end                
    end
    
    methods(Access=private)
        %------------------------------------------------------------------
        function parseInputsCodegen(this, varargin)
            params = struct( ...
                'IntrinsicMatrix',  uint32(0), ...
                'RadialDistortion', uint32(0),...
                'TangentialDistortion', uint32(0), ...
                'RotationVectors', uint32(0),...
                'TranslationVectors', uint32(0),...
                'WorldPoints', uint32(0), ...
                'WorldUnits', uint32(0),...
                'EstimateSkew', uint32(0), ...
                'NumRadialDistortionCoefficients', uint32(0),...
                'EstimateTangentialDistortion', uint32(0),...
                'ReprojectionErrors', uint32(0), ...
                'Version', uint32(0));
            
            popt = struct( ...
                'CaseSensitivity', false, ...
                'StructExpand',    true, ...
                'PartialMatching', true);
            
            optarg = eml_parse_parameter_inputs(params, popt, varargin{:});
            
            intrinsicMatrix = eml_get_parameter_value(...
                optarg.IntrinsicMatrix, eye(3), varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkIntrinsicMatrix(...
                intrinsicMatrix);            
            this.IntrinsicMatrixInternal = intrinsicMatrix';
            
            this.RadialDistortion = eml_get_parameter_value(...
                optarg.RadialDistortion, [0 0 0], varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkRadialDistortion(...
                this.RadialDistortion);
            
            this.TangentialDistortion = eml_get_parameter_value(...
                optarg.TangentialDistortion, [0 0], varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkTangentialDistortion(...
                this.TangentialDistortion);
            
            this.RotationVectors = eml_get_parameter_value(...
                optarg.RotationVectors, zeros(0, 3), varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkRotationVectors(...
                this.RotationVectors);
            
            this.TranslationVectors = eml_get_parameter_value(...
                optarg.TranslationVectors, zeros(0, 3), varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkTranslationVectors(...
                this.TranslationVectors);
            
            this.WorldPoints = eml_get_parameter_value(...
                optarg.WorldPoints, zeros(0, 2), varargin{:});
             vision.internal.calibration.CameraParametersImpl.checkWorldPoints(...
                 this.WorldPoints);
             
            this.WorldUnits = eml_get_parameter_value(...
                optarg.WorldUnits, 'mm', varargin{:});
             vision.internal.calibration.CameraParametersImpl.checkWorldUnits(...
                 this.WorldUnits);
            
            this.EstimateSkew = eml_get_parameter_value(...
                optarg.EstimateSkew, false, varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkEstimateSkew(...
                 this.EstimateSkew);
             
            this.NumRadialDistortionCoefficients = eml_get_parameter_value(...
                optarg.NumRadialDistortionCoefficients, 2, varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkNumRadialCoeffs(...
                 this.NumRadialDistortionCoefficients);
             
            this.EstimateTangentialDistortion = eml_get_parameter_value(...
                optarg.EstimateTangentialDistortion, false, varargin{:});
            vision.internal.calibration.CameraParametersImpl.checkEstimateTangentialDistortion(...
                this.EstimateTangentialDistortion);
            
            reprojErrors = eml_get_parameter_value(...
                optarg.ReprojectionErrors, zeros(0, 2), varargin{:});
            if isempty(reprojErrors)
                this.ReprojectionErrors = zeros(0, 2);
            else
                this.ReprojectionErrors = reprojErrors;
            end
            
            vision.internal.calibration.CameraParametersImpl.checkReprojectionErrors(...
                this.ReprojectionErrors);
            
            eml_get_parameter_value(...
                optarg.Version, '', varargin{:});
        end
    end
    
    
        
    methods
        %------------------------------------------------------------------
        function numPatterns = get.NumPatterns(this)
            numPatterns = size(this.RotationVectors, 1);
        end
        
        %------------------------------------------------------------------
        function intrinsicMatrix = get.IntrinsicMatrix(this)
            intrinsicMatrix = this.IntrinsicMatrixInternal';
        end
        
        %------------------------------------------------------------------
        function meanError = get.MeanReprojectionError(this)
            meanError = computeMeanError(this);
        end
        
        %------------------------------------------------------------------
        function reprojectedPoints = get.ReprojectedPoints(this)
            points = this.WorldPoints;
            reprojectedPoints = zeros([size(points), this.NumPatterns]);
            
            for i = 1:this.NumPatterns
                reprojectedPoints(:, :, i) = ...
                    reprojectWorldPointsOntoPattern(this, i);
            end
            
            % apply distortion
            reprojectedPoints = distortPoints(this, reprojectedPoints);
        end
        
        %------------------------------------------------------------------
        function rotationMatrices = get.RotationMatrices(this)
            rotationMatrices = zeros(3, 3, this.NumPatterns);
            for i = 1:this.NumPatterns
                v = this.RotationVectors(i, :);
                R = vision.internal.calibration.rodriguesVectorToMatrix(v);
                rotationMatrices(:, :, i) = R';
            end
        end
        
        %------------------------------------------------------------------
        function focalLength = get.FocalLength(this)
            focalLength = zeros(1, 2, 'like', this.IntrinsicMatrix);
            focalLength(1) = this.IntrinsicMatrix(1, 1);
            focalLength(2) = this.IntrinsicMatrix(2, 2);
        end
        
        %------------------------------------------------------------------
        function principalPoint = get.PrincipalPoint(this)
            principalPoint = zeros(1, 2, 'like', this.IntrinsicMatrix);
            principalPoint(1) = this.IntrinsicMatrix(3, 1);
            principalPoint(2) = this.IntrinsicMatrix(3, 2);
        end
        
        %------------------------------------------------------------------
        function skew = get.Skew(this)
            skew = this.IntrinsicMatrix(2, 1);
        end
        
        function worldPoints = pointsToWorld(this, rotationMatrix, ...
                translationVector, imagePoints)
            %pointsToWorld Determine world coordinates of image points. 
            %  worldPoints = pointsToWorld(cameraParams, rotationMatrix,
            %  translationVector, imagePoints) maps undistorted image 
            %  points onto points on the X-Y plane in the world coordinates. 
            %
            %  Inputs:
            %  -------
            %  cameraParams      - cameraParameters object. 
            %
            %  rotationMatrix    - 3-by-3 matrix representing rotation 
            %                      of the camera in world coordinates.
            %
            %  translationVector - 3-element vector representing 
            %                      translation of the camera in world 
            %                      coordinates.  
            %
            %  imagePoints       - M-by-2 matrix containing [x, y] 
            %                      coordinates of undistorted image points.
            %                      M is the number of points.
            %
            %  Output:
            %  -------
            %  worldPoints       - M-by-2 matrix containing corresponding 
            %                      [X,Y] world coordinates. Z coordinate 
            %                      for every world point is 0.
            %
            %  Notes
            %  -----
            %  The function does not account for lens distortion. 
            %  imagePoints must either be detected in the undistorted 
            %  image, or they must be undistorted using the undistortPoints
            %  function. If imagePoints are detected in undistorted image,
            %  their coordinates must be translated to the coordinate 
            %  system of the original image.
            %
            %  Class Support
            %  -------------
            %  rotationMatrix, translationVector, and imagePoints must be
            %  real and nonsparse numeric arrays. worldPoints is of class
            %  double if imagePoints are double. Otherwise worldPoints is
            %  of class single.
            %
            %  Example - Measuring Planar Objects with a Calibrated Camera
            %  -----------------------------------------------------------
            %  % This example shows how to measure the diameter of coins in 
            %  % world units using a single calibrated camera.
            %  % <a href="matlab:web(fullfile(matlabroot,'toolbox','vision','visiondemos','html','MeasuringPlanarObjectsExample.html'))">View example</a>
            %
            %
            %  See also estimateCameraParameters, cameraCalibrator,
            %      extrinsics, undistortImage, cameraParameters
            
            [R, t, K, pts, outputClass] = parsePointsToWorldInputs(this, ...
                rotationMatrix, translationVector, imagePoints);
            tform = projective2d([R(1, :); R(2, :); t] * K);
            worldPoints = cast(transformPointsInverse(tform, pts), outputClass);            
        end
        
    end
    
    methods(Access=private)
        %--------------------------------------------------------------
        function [R, t, K, pts, outputClass] = parsePointsToWorldInputs(this,...
                rotationMatrix, translationVector, imagePoints)
            
            vision.internal.inputValidation.validateRotationMatrix(...
                rotationMatrix, 'cameraParameters', 'rotationMatrix');
            vision.internal.inputValidation.validateTranslationVector(...
                translationVector, 'cameraParameters', 'translationVector');
            points = vision.internal.inputValidation.checkAndConvertPoints(...
                imagePoints, 'cameraParameters', 'imagePoints');
            
            % if any of the inputs is double, internal math is done in
            % doubles.  Otherwise, internal math is  done in singles.
            if isa(rotationMatrix, 'double') || isa(translationVector, 'double')...
                || isa(points, 'double')
                R = double(rotationMatrix);
                t = double(translationVector);
                pts = double(points);
                K = double(this.IntrinsicMatrix);
            else
                R = single(rotationMatrix);
                t = single(translationVector);
                pts = single(points);
                K = single(this.IntrinsicMatrix);
            end
            
            % if imagePoints is double, then the output worldPoints is
            % double. Otherwise worldPoints is single.
            if isa(imagePoints, 'double')
                outputClass = 'double';
            else
                outputClass = 'single';
            end

        end
    end
    
    methods(Hidden, Access=public)
        %------------------------------------------------------------------
        % This method is different from the MeanReprojectionError property,
        % because it also computes the mean reprojection error per image.
        %------------------------------------------------------------------
        function [meanError, meanErrorsPerImage] = computeMeanError(this)
            errors = hypot(this.ReprojectionErrors(:, 1, :), ...
                this.ReprojectionErrors(:, 2, :));
            meanErrorsPerImage = squeeze(mean(errors, 1));
            meanError = mean(meanErrorsPerImage);
        end
        
        %------------------------------------------------------------------
        function [Jout, newOrigin] = undistortImageImpl(this, I, interp, ...
                outputView, fillValues)
            % undistortImageImpl implements the core lens undistortion
            % algorithm for the undistortImage.m function.  See help for
            % undistortImage for further details.
            if needToUpdate(this.UndistortMap, I, outputView)
                [xBounds, yBounds] = computeUndistortBounds(this, ...
                    [size(I, 1), size(I, 2)], outputView);

                this.UndistortMap.update(I, this.IntrinsicMatrix, ...
                    this.RadialDistortion, this.TangentialDistortion, ...
                    outputView, xBounds, yBounds);
            end
            
            [J, newOrigin] = transformImage(this.UndistortMap, I, interp, fillValues); 
            
            if strcmp(outputView, 'same')
                Jout = coder.nullcopy(zeros(size(I), 'like', I));
                Jout(:,:,:) = J(1:size(I, 1), 1:size(I, 2), 1:size(I,3));
            else
                Jout = J;
            end
        end        
    end
            
    %----------------------------------------------------------------------
    % constructor parameter validation
    %----------------------------------------------------------------------
    methods(Static)
        %------------------------------------------------------------------        
        function tf = checkIntrinsicMatrix(IntrinsicMatrix)
            validateattributes(IntrinsicMatrix, {'double', 'single'}, ...
                {'2d', 'ncols', 3, 'nrows', 3, 'nonsparse', 'real'}, ...
                'cameraParameters', 'IntrinsicMatrix');
            tf = true;
        end
        
        %------------------------------------------------------------------        
        function tf = checkRadialDistortion(radialDistortion)
            validTypes = {'double', 'single'};
            validateattributes(radialDistortion, validTypes,...
                {'vector', 'real', 'nonsparse'},...
                'cameraParameters', 'RadialDistortion');
            
            if numel(radialDistortion) ~= 2 
                validateattributes(radialDistortion, validTypes,...
                    {'numel', 3}, 'cameraParameters', 'RadialDistortion');
            end
            
            tf = true;
        end
        %------------------------------------------------------------------        
        function tf = checkTangentialDistortion(tangentialDistortion)
            validateattributes(tangentialDistortion, {'double', 'single'},...
                {'vector', 'real', 'nonsparse', 'numel', 2},...
                'cameraParameters', 'TangentialDistortion');
            tf = true;
        end
       
        %------------------------------------------------------------------                
        function tf = checkRotationVectors(rotationVectors)
            tf = true;
            if isempty(rotationVectors)
                return;
            end
            validateattributes(rotationVectors, {'double', 'single'},...
                {'2d', 'real', 'nonsparse', 'ncols', 3},...
                'cameraParameters', 'RotationVectors');
        end
        
        %------------------------------------------------------------------                
        function tf = checkTranslationVectors(translationVectors)
            tf = true;
            if isempty(translationVectors)
                return;
            end
            validateattributes(translationVectors, {'double', 'single'},...
                {'2d', 'real', 'nonsparse', 'ncols', 3},...
                'cameraParameters', 'TranslationVectors');
        end        
        
        %------------------------------------------------------------------                        
        function tf = checkWorldPoints(worldPoints)
            tf = true;
            if isempty(worldPoints)
                return;        
            end    
            validateattributes(worldPoints, {'double', 'single'},...
                {'2d', 'real', 'nonsparse', 'ncols', 2},...
                'cameraParameters', 'WorldPoints');
        end
        
        %------------------------------------------------------------------                        
        function tf = checkWorldUnits(worldUnits)
            tf = true;
            validateattributes(worldUnits, {'char'}, ...
                {'vector'}, 'cameraParameters', 'WorldUnits');
        end
        
        %------------------------------------------------------------------                        
        function tf = checkEstimateSkew(esitmateSkew)
            tf = true;
            validateattributes(esitmateSkew, {'logical'}, {'scalar'}, ...
                'cameraParameters', 'EstimateSkew');
        end
        
        %------------------------------------------------------------------                        
        function tf = checkNumRadialCoeffs(numRadialCoeffs)
            tf = true;
            validateattributes(numRadialCoeffs, {'numeric'}, ...
                {'scalar', 'integer', '>=', 2, '<=', 3}, ...
                 'cameraParameters', 'NumRadialDistortionCoefficients');
        end
        
        %------------------------------------------------------------------                        
        function tf = checkEstimateTangentialDistortion(estimateTangential)
            tf = true;
            validateattributes(estimateTangential, {'logical'}, {'scalar'},...
                'cameraParameters', 'EstimateTangentialDistortion');            
        end
        
        %------------------------------------------------------------------                        
        function tf = checkReprojectionErrors(reprojErrors)
            tf = true;
            if ~isempty(reprojErrors)
                validateattributes(reprojErrors, {'double', 'single'},...
                    {'3d', 'real', 'nonsparse', 'ncols', 2},...
                    'cameraParameters', 'ReprojectionErrors');
            end
        end
    end
    
    methods(Access=private)
        %------------------------------------------------------------------
        % Reproject world points using one set of extrinsics without
        % applying distortion
        %------------------------------------------------------------------
        function reprojectedPoints = ...
                reprojectWorldPointsOntoPattern(this, patternIdx)
            
            points = this.WorldPoints;
            R = vision.internal.calibration.rodriguesVectorToMatrix(...
                this.RotationVectors(patternIdx, :));
            t = this.TranslationVectors(patternIdx, :)';
            tform = projective2d((this.IntrinsicMatrixInternal * ...
                [R(:, 1), R(:, 2), t])');
            reprojectedPoints = transformPointsForward(tform, points);
        end
    end
    
    methods (Hidden=true)
        %------------------------------------------------------------------
        % Apply radial and tangential distortion to a set of points
        %------------------------------------------------------------------
        function distortedPoints = distortPoints(this, points, ~)
            if isempty(coder.target)
                % in matlab use the builtin c++ function
                distortedPoints = visionDistortPoints(points, ...
                    this.IntrinsicMatrixInternal, ...
                    this.RadialDistortion, this.TangentialDistortion);
            else            
                % in codegen use matlab function
                distortedPoints = vision.internal.calibration.distortPoints(...
                    points, this.IntrinsicMatrix, this.RadialDistortion, ...
                    this.TangentialDistortion);
            end
        end    
    end
        
    methods (Hidden=true, Access=public)
        %------------------------------------------------------------------
        % Returns a CameraParameters object with updated reprojection
        % errors.  Used in stereoParameters.
        %------------------------------------------------------------------
        function computeReprojectionErrors(this, imagePoints)
            this.ReprojectionErrors = this.ReprojectedPoints - imagePoints;
        end
        
        %------------------------------------------------------------------
        % Returns a CameraParameters object with new extrinsics.
        %------------------------------------------------------------------
        function setExtrinsics(this, rvecs, tvecs)
            this.RotationVectors = rvecs;
            this.TranslationVectors = tvecs;
        end
    end
        
    %----------------------------------------------------------------------
    % saveobj and loadobj are implemented to ensure compatibility across
    % releases even if architecture of vision.CameraParameters class changes
    methods (Hidden)
       
        function that = saveobj(this)
            that.RadialDistortion = this.RadialDistortion;     
            that.TangentialDistortion = this.TangentialDistortion;
            that.WorldPoints = this.WorldPoints;
            that.WorldUnits = this.WorldUnits;  
            that.EstimateSkew = this.EstimateSkew;
            that.NumRadialDistortionCoefficients = this.NumRadialDistortionCoefficients;
            that.EstimateTangentialDistortion = this.EstimateTangentialDistortion;
            that.RotationVectors = this.RotationVectors;
            that.TranslationVectors = this.TranslationVectors;
            that.ReprojectionErrors = this.ReprojectionErrors;            
            that.IntrinsicMatrix = this.IntrinsicMatrix;
            that.Version = this.Version;
        end
        
    end
    
    
    %--------------------------------------------------------------------------
    
    methods (Static, Hidden)
        
        function this = loadobj(that)
            if isempty(that.ReprojectionErrors)
                reprojErrors = zeros(0, 2, 0);
            else
                reprojErrors = that.ReprojectionErrors;
            end
            
            this = cameraParameters(...
                'IntrinsicMatrix', that.IntrinsicMatrix,...
                'RadialDistortion', that.RadialDistortion,...
                'TangentialDistortion', that.TangentialDistortion,...
                'WorldPoints', that.WorldPoints,...
                'WorldUnits',  that.WorldUnits,...
                'EstimateSkew', that.EstimateSkew,...
                'NumRadialDistortionCoefficients', that.NumRadialDistortionCoefficients,...
                'EstimateTangentialDistortion', that.EstimateTangentialDistortion,...
                'RotationVectors', that.RotationVectors,...
                'TranslationVectors', that.TranslationVectors,...
                'ReprojectionErrors', reprojErrors);
        end
        
    end
    
        methods(Hidden)
        %------------------------------------------------------------------
        function [xBounds, yBounds] = ...
                computeUndistortBounds(this, imageSize, outputView)          
            if strcmp(outputView, 'same')
                xBounds = [1, imageSize(2)];
                yBounds = [1, imageSize(1)];
            else
                [undistortedMask, xBoundsBig, yBoundsBig] = ...
                    createUndistortedMask(this, imageSize, outputView);
                
                if strcmp(outputView, 'full')
                    [xBounds, yBounds] = getFullBounds(undistortedMask, ...
                        xBoundsBig, yBoundsBig);
                else % valid
                    [xBounds, yBounds] = getValidBounds(this, undistortedMask, ...
                        xBoundsBig, yBoundsBig, imageSize);
                end
            end
        end
    end
    
    methods(Access=private)
        %--------------------------------------------------------------------------
        function [undistortedMask, xBoundsBig, yBoundsBig] = ...
                createUndistortedMask(this, imageSize, outputView)
            
            xBounds = [1, imageSize(2)];
            yBounds = [1, imageSize(1)];
            
            width = xBounds(2) - xBounds(1);
            height = yBounds(2) - yBounds(1);            
            
            xBoundsBig = zeros(1, 2, 'like', xBounds);
            yBoundsBig = zeros(1, 2, 'like', yBounds);            
            
            wpad = width;
            hpad = height;
            
            xBoundsBig(1) = xBounds(1) - wpad;
            xBoundsBig(2) = xBounds(2) + wpad;
            yBoundsBig(1) = yBounds(1) - hpad;
            yBoundsBig(2) = yBounds(2) + hpad;
            
            mask = ones(imageSize, 'uint8');
            fillValuesMask = cast(0, 'uint8');
            
            myMap = vision.internal.calibration.ImageTransformer;
            myMap.update(mask, this.IntrinsicMatrix, ...
                this.RadialDistortion, this.TangentialDistortion, ...
                outputView, xBoundsBig, yBoundsBig);
            
            undistortedMask = myMap.transformImage(mask, 'nearest', fillValuesMask);
        end
        
        %------------------------------------------------------------------
        % Compute the circumscribed rectangle of the undistorted image
        % outerBounds is a 4-by-2 matrix of [x,y] coordinates of the corner
        % points: [ul; ur; lr; ll]
        %------------------------------------------------------------------
        function outerBounds = computeOuterBounds(this, imageSize)
            
            boundaryPoints = undistortImageBoundary(this, imageSize);
            
            % find the inner rectangle
            outerBounds = getOuterRectangle(boundaryPoints);
        end
        
        %------------------------------------------------------------------
        function [boundaryPointsUndistorted, numXSamples, numYSamples] = ...
                undistortImageBoundary(this, imageSize)
            
            % sample points along the image boundaries
            [boundaryPoints, numXSamples, numYSamples] = ...
                sampleBoundaryPoints(imageSize);
            
            % undistort the boundary points
            boundaryPointsUndistorted = this.undistortPointsImpl(boundaryPoints);
        end
        
        %--------------------------------------------------------------------------
        function [xBounds, yBounds] = getValidBounds(this, undistortedMask, ...
                xBoundsBig, yBoundsBig, imageSize)
            
            % Get the boundary
            boundaryPixel = getInitialBoundaryPixel(undistortedMask);
            boundaryPixelsUndistorted = bwtraceboundary(undistortedMask, ...
                boundaryPixel, 'W');
            
            % Convert from R-C to x-y
            boundaryPixelsUndistorted = boundaryPixelsUndistorted(:, [2,1]);
            
            % Convert to the coordinate system of the original image
            boundaryPixelsUndistorted(:, 1) = boundaryPixelsUndistorted(:, 1) + xBoundsBig(1);
            boundaryPixelsUndistorted(:, 2) = boundaryPixelsUndistorted(:, 2) + yBoundsBig(1);
            
            % Apply distortion to turn the boundary back into a rectangle
            boundaryPixelsDistorted = distortPoints(this, boundaryPixelsUndistorted);
            
            % Find the pixels that came from the top, bottom, left, and right edges of
            % the original image.
            tolerance = 7;
            topIdx = abs(boundaryPixelsDistorted(:, 2) - 1) < tolerance;
            botIdx = abs(boundaryPixelsDistorted(:, 2) - imageSize(1)) < tolerance;
            leftIdx = abs(boundaryPixelsDistorted(:, 1) - 1) < tolerance;
            rightIdx = abs(boundaryPixelsDistorted(:, 1) - imageSize(2)) < tolerance;
                        
            % Find the inscribed rectangle.
            topPixels = boundaryPixelsUndistorted(topIdx, 2);
            botPixels = boundaryPixelsUndistorted(botIdx, 2);
            leftPixels = boundaryPixelsUndistorted(leftIdx, 1);
            rightPixels = boundaryPixelsUndistorted(rightIdx, 1);

            % Check if we can compute the valid bounds at all
            coder.internal.errorIf(isempty(topPixels) || isempty(botPixels) || ...
                isempty(leftPixels) || isempty(rightPixels), ...
                'vision:calibrate:cannotComputeValidBounds');
            
            top = max(topPixels);
            bot = min(botPixels);
            left = max(leftPixels);
            right = min(rightPixels);
            
            % Check if the valid bounds cross
            if isempty(coder.target) && (left > right || top > bot)
                warning(message('vision:calibrate:badValidUndistortBounds'));
            end
            
            xBounds = sort([ceil(left), floor(right)]);
            yBounds = sort([ceil(top), floor(bot)]);
        end
    end
end


%--------------------------------------------------------------------------
% Get the bounding box of the central connected component of the
% undistortedMask
%--------------------------------------------------------------------------
function [xBounds, yBounds] = getFullBounds(undistortedMask, xBoundsBig,...
    yBoundsBig)
% We have to consider the possibility that there may be more than one
% connected component in the undistorted image.  Our distortion model can
% result in an additional ring of valid pixels around the "correct" valid
% region.

blobAnalyzer = vision.BlobAnalysis;
assert(size(undistortedMask, 1) < 10000);
assert(size(undistortedMask, 2) < 10000);
[~, centroids, bboxes] = step(blobAnalyzer, logical(undistortedMask));

% find centroid closest to the center
center = round(size(undistortedMask) ./ 2);
dists = (centroids(:, 1) - center(2)).^2 + ...
    (centroids(:, 2) - center(1)).^2;
[~, idx] = min(dists);
bbox = bboxes(idx, :);


xBounds = zeros(1, 2, 'like', xBoundsBig);
yBounds = zeros(1, 2, 'like', yBoundsBig);

xBounds(1) = ceil(xBoundsBig(1) + bbox(1)-1);
xBounds(2) = floor(xBounds(1) + bbox(3));

yBounds(1) = ceil(yBoundsBig(1) + bbox(2)-1);
yBounds(2) = floor(yBounds(1) + bbox(4));
end

%--------------------------------------------------------------------------
% Shoot a ray from the center of the image straight down to find the
% initial boundary pixel
%--------------------------------------------------------------------------
function boundaryPixel = getInitialBoundaryPixel(undistortedMask)

sRow = -1;
sCol = -1;
cx = floor(size(undistortedMask, 2) / 2);
for i = floor(size(undistortedMask, 1)/2):size(undistortedMask, 1)
    if undistortedMask(i, cx) == 0
        sRow = i-1;
        sCol = cx;
        break;
    end
end
boundaryPixel = [sRow, sCol];
end