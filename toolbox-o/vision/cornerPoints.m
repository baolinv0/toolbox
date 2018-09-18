%cornerPoints Object for storing corner points
%
%   cornerPoints object describes corner points.
%
%   POINTS = cornerPoints(LOCATION) constructs a cornerPoints object from
%   LOCATION, an M-by-2 array of [x y] coordinates.
%
%   POINTS = cornerPoints(LOCATION,Name,Value) specifies additional
%   name-value pair arguments described below:
%
%   'Metric'  Value describing strength of detected feature. Metric can
%             be specified as a scalar or a vector whose length matches the
%             number of coordinates in LOCATION.
%
%             Default: 0.0
%
%   Notes:
%   ======
%   - A cornerPoints is always a scalar object which may hold many
%     points. Therefore, NUMEL(aCornerPoints) always returns 1. This may
%     be different from LENGTH(aCornerPoints), which returns the true
%     number of points held by the object.
%
%   cornerPoints methods:
%      selectStrongest  - Select N interest points with strongest metrics
%      plot             - Plot feature points
%      length           - Return number of stored points
%      isempty          - Return true for empty cornerPoints object
%      size             - Return size of the cornerPoints object
%      gather           - Retrieve cornerPoints from the GPU
%
%   cornerPoints properties:
%      Count            - Number of points held by the object
%      Location         - Matrix of [x,y] point coordinates
%      Metric           - Strength of each feature
%
% Example 1
% ---------
% % Detect feature points and show the 10 strongest ones
% I = imread('cameraman.tif');
% points = detectHarrisFeatures(I);
% % Display 10 strongest points
% strongest = points.selectStrongest(10);
% imshow(I); hold on;
% plot(strongest);   % show location and scale
% strongest.Location % display [x y] coordinates
%
% Example 2
% ---------
% % Create a cornerPoints and show the points on the image
% I = checkerboard(50,2,2);
% location = [51    51    51   100   100   100   151   151   151;...
%             50   100   150    50   101   150    50   100   150]';
% points = cornerPoints(location);
% imshow(I); hold on;
% plot(points);
%
% See also detectHarrisFeatures, detectMinEigenFeatures,
%          detectFASTFeatures, extractFeatures, matchFeatures

% Copyright 2012 The MathWorks, Inc.

classdef cornerPoints < vision.internal.FeaturePoints
    
   methods(Access=private, Static)
       function name = matlabCodegenRedirect(~)
         name = 'vision.internal.cornerPoints_cg';
       end
   end
   
   methods (Access='public')
       
       function this = cornerPoints(varargin)         
           this = this@vision.internal.FeaturePoints(varargin{:});
       end
       
       %-------------------------------------------------------------------
       function varargout = plot(this, varargin)
           %plot Plot feature points
           %
           %   cornerPoints.plot plots feature points in the current axis.
           %
           %   cornerPoints.plot(AXES_HANDLE,...) plots using axes with
           %   the handle AXES_HANDLE instead of the current axes (gca).
           %
           %   Example
           %   -------
           %   I = imread('cameraman.tif');
           %   featurePoints = detectHarrisFeatures(I);
           %   imshow(I); hold on;
           %   plot(featurePoints);

           nargoutchk(0,1);
           
           supportsScaleAndOrientation = false;
           
           h = plot@vision.internal.FeaturePoints(this, ...
               supportsScaleAndOrientation, varargin{:});
          
           if nargout == 1
               varargout{1} = h;
           end
       end
       
       %-------------------------------------------------------------------
       function this = selectStrongest(this, N)
           %selectStrongest Return N points with strongest metrics
           %
           %   strongest = selectStrongest(points, N) keeps N
           %   points with strongest metrics.
           %
           %   Example
           %   -------
           %   % create object holding 50 points
           %   points = cornerPoints(ones(50,2), 'Metric', 1:50);
           %   % keep 2 strongest features
           %   points = selectStrongest(points, 2)

           this = selectStrongest@vision.internal.FeaturePoints(this, N);
       end
       
       %-------------------------------------------------------------------
       function out = gather(this)
           %gather Retrieve cornerPoints from the GPU
           %
           %   pointsCPU = gather(pointsGPU) returns a cornerPoints object
           %   whose Location and Metric properties contain data gathered
           %   from the GPU.
           %
           %   Example
           %   -------
           %   pointsGPU = cornerPoints(gpuArray(randn(10,2)));
           %   pointsCPU = gather(pointsGPU)
           
           if isa(this.Location, 'gpuArray')
               % only call gather if input has a gpuArray
               location = gather(this.Location);
               metric   = gather(this.Metric);
               
               out = cornerPoints(location, 'Metric', metric);
           else
               out = this;
           end
       end
   end
   
end

