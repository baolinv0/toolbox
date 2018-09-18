% Computer Vision System Toolbox
% Version 7.0 (R2015b) 13-Aug-2015
%
% Video Display
%   vision.DeployableVideoPlayer  - Display video (Windows and Linux)
%   vision.VideoPlayer            - Play video or display image
%   implay                        - View video from files, the MATLAB workspace, or Simulink signals
%
% Video File I/O
%   vision.BinaryFileReader       - Read binary video data from files
%   vision.BinaryFileWriter       - Write binary video data to files
%   vision.VideoFileReader        - Read video frames and audio samples from video file
%   vision.VideoFileWriter        - Write video frames and audio samples to video file
%
% Feature Detection, Extraction and Matching
%   detectHarrisFeatures          - Find corners using the Harris-Stephens algorithm
%   detectMinEigenFeatures        - Find corners using the minimum eigenvalue algorithm
%   detectFASTFeatures            - Find corners using the FAST algorithm
%   detectSURFFeatures            - Find SURF features
%   detectMSERFeatures            - Find MSER features
%   detectBRISKFeatures           - Find BRISK features
%   extractFeatures               - Extract feature vectors from image
%   extractHOGFeatures            - Extract HOG features
%   extractLBPFeatures            - Extract LBP features
%   matchFeatures                 - Find matching features
%   showMatchedFeatures           - Display corresponding feature points
%   vision.BoundaryTracer         - Trace object boundaries in binary images
%   vision.EdgeDetector           - Find edges of objects in images
%   cornerPoints                  - Object for storing corner points
%   SURFPoints                    - Object for storing SURF interest points
%   MSERRegions                   - Object for storing MSER regions
%   BRISKPoints                   - Object for storing BRISK interest points
%   binaryFeatures                - Object for storing binary feature vectors
%
% Object Detection and Recognition
%   ocr                           - Recognize text using Optical Character Recognition
%   ocrText                       - Object for storing OCR results
%   vision.CascadeObjectDetector  - Detect objects using the Viola-Jones algorithm
%   vision.PeopleDetector         - Detect upright people using HOG features
%   trainCascadeObjectDetector    - Train a model for a cascade object detector
%   trainingImageLabeler          - Label images for training a classifier
%   selectStrongestBbox           - Select strongest bounding boxes from overlapping clusters
%   bagOfFeatures                 - Create bag of visual features
%   trainImageCategoryClassifier  - Train bag of features based image category classifier
%   imageCategoryClassifier       - Predict image category
%   indexImages                   - Create an index for image search
%   retrieveImages                - Search for similar images
%   invertedImageIndex            - Search index that maps visual words to images
%   evaluateImageRetrieval        - Evaluate image search results 
%
% Motion Analysis and Tracking
%   assignDetectionsToTracks      - Assign detections to tracks for multi-object tracking
%   vision.BlockMatcher           - Estimate motion between images or video frames
%   vision.ForegroundDetector     - Detect foreground using Gaussian Mixture Models
%   vision.HistogramBasedTracker  - Track object in video based on histogram
%   configureKalmanFilter         - Create a Kalman filter for object tracking
%   vision.KalmanFilter           - Kalman filter
%   opticalFlow                   - Object for storing optical flow
%   opticalFlowFarneback          - Estimate object velocities using Farneback algorithm
%   opticalFlowHS                 - Estimate object velocities using Horn-Schunck algorithm
%   opticalFlowLK                 - Estimate object velocities using Lucas-Kanade algorithm
%   opticalFlowLKDoG              - Estimate object velocities using modified Lucas-Kanade algorithm
%   vision.PointTracker           - Track points in video using Kanade-Lucas-Tomasi (KLT) algorithm
%   vision.TemplateMatcher        - Locate template in image
%
% Camera Calibration
%   cameraCalibrator              - Single camera calibration app
%   stereoCameraCalibrator        - Stereo camera calibration app
%   estimateCameraParameters      - Calibrate a single camera or a stereo camera
%   detectCheckerboardPoints      - Detect a checkerboard pattern in an image
%   generateCheckerboardPoints    - Generate checkerboard point locations
%   showExtrinsics                - Visualize extrinsic camera parameters
%   showReprojectionErrors        - Visualize calibration errors
%   cameraParameters              - Object for storing camera parameters
%   stereoParameters              - Object for storing parameters of a stereo camera system
%   cameraCalibrationErrors       - Object for storing standard errors of estimated camera parameters
%   stereoCalibrationErrors       - Object for storing standard errors of estimated stereo parameters    
%   extrinsics                    - Compute location of a calibrated camera
%   cameraMatrix                  - Compute camera projection matrix
%   undistortImage                - Correct image for lens distortion
%   undistortPoints               - Correct point coordinates for lens distortion
%
% Stereo Vision
%   cameraPose                        - Compute relative rotation and translation between camera poses
%   disparity                         - Compute disparity map
%   epipolarLine                      - Compute epipolar lines for stereo images
%   estimateFundamentalMatrix         - Estimate the fundamental matrix
%   estimateUncalibratedRectification - Uncalibrated stereo rectification
%   isEpipoleInImage                  - Determine whether the epipole is inside the image
%   lineToBorderPoints                - Compute the intersection points of lines and image border
%   reconstructScene                  - Reconstructs a 3-D scene from a disparity map
%   rectifyStereoImages               - Rectifies a pair of stereo images
%   stereoAnaglyph                    - Create a red-cyan anaglyph from a stereo pair of images
%   triangulate                       - Find 3-D locations of matching points in stereo images
%
% Point Cloud Processing
%   pointCloud                        - Object for storing a 3-D point cloud
%   pcdenoise                         - Remove noise from a 3-D point cloud
%   pcdownsample                      - Downsample a 3-D point cloud
%   pcnormals                         - Estimate normal vectors for a point cloud
%   pcmerge                           - Merge two 3-D point clouds
%   pcregrigid                        - Register two point clouds with ICP algorithm
%   pctransform                       - Rigid transform a 3-D point cloud
%   pcfitplane                        - Fit plane to a 3-D point cloud
%   pcfitsphere                       - Fit sphere to a 3-D point cloud
%   pcfitcylinder                     - Fit cylinder to a 3-D point cloud
%   pcshow                            - Plot 3-D point cloud
%   pcshowpair                        - Visualize differences between point clouds
%   pcplayer                          - Player for visualizing streaming 3-D point cloud data
%   pcread                            - Read a 3-D point cloud from PLY file
%   pcwrite                           - Write a 3-D point cloud to PLY file
%   pcfromkinect                      - Get point cloud from Kinect for Windows
%   planeModel                        - Object for storing a parametric plane model
%   sphereModel                       - Object for storing a parametric sphere model
%   cylinderModel                     - Object for storing a parametric cylinder model
%
% Enhancement
%   vision.ContrastAdjuster       - Adjust image contrast by linearly scaling pixel values
%   vision.Deinterlacer           - Remove motion artifacts by deinterlacing input video signal
%   vision.HistogramEqualizer     - Enhance contrast of images using histogram equalization
%   vision.MedianFilter           - Perform 2-D median filtering
%
% Conversions
%   vision.Autothresholder        - Convert intensity image to binary image
%   vision.ChromaResampler        - Downsample or upsample chrominance components of images
%   vision.ColorSpaceConverter    - Image color space conversion
%   vision.DemosaicInterpolator   - Bayer-pattern image conversion to true color
%   vision.GammaCorrector         - Gamma correction
%   vision.ImageComplementer      - Complement image
%   vision.ImageDataTypeConverter - Convert and scale input image to specified output data type
%
% Filtering
%   isfilterseparable             - Check filter separability
%   integralImage                 - Compute integral image
%   integralFilter                - Filter using integral image
%   integralKernel                - Define filter for use with integral images
%   vision.Convolver              - 2-D convolution
%   vision.ImageFilter            - 2-D FIR filtering
%   vision.MedianFilter           - 2-D median filtering
%
% Geometric Transformations
%   estimateGeometricTransform         - Estimate geometric transformation from matching point pairs
%   vision.GeometricRotator            - Rotate image by specified angle
%   vision.GeometricScaler             - Enlarge or shrink image sizes
%   vision.GeometricShearer            - Shift rows or columns of image by linearly varying offset
%   vision.GeometricTranslator         - 2-D translation
%
% Statistics
%   vision.Autocorrelator       - 2-D autocorrelation
%   vision.BlobAnalysis         - Properties of connected regions
%   vision.Crosscorrelator      - 2-D cross-correlation
%   vision.Histogram            - Generate histogram of each input matrix
%   vision.LocalMaximaFinder    - Local maxima
%   vision.Maximum              - Maximum values
%   vision.Mean                 - Mean value
%   vision.Median               - Median values
%   vision.Minimum              - Minimum values
%   vision.PSNR                 - Peak signal-to-noise ratio
%   vision.StandardDeviation    - Standard deviation
%   vision.Variance             - Variance
%
% Text and Graphics
%   insertObjectAnnotation      - Insert annotation in image or video stream
%   insertMarker                - Insert markers in image or video stream
%   insertShape                 - Insert shapes in image or video stream
%   insertText                  - Insert text in image or video stream
%   listTrueTypeFonts           - List available TrueType fonts
%   vision.AlphaBlender         - Combine images, overlay images, or highlight selected pixels
%
% Transforms
%   vision.DCT                  - 2-D discrete cosine transform
%   vision.FFT                  - 2-D fast Fourier transform
%   vision.HoughLines           - Find Cartesian coordinates of lines described by rho and theta pairs
%   vision.HoughTransform       - Hough transform
%   vision.IDCT                 - 2-D inverse discrete cosine transform
%   vision.IFFT                 - 2-D inverse fast Fourier transform
%   vision.Pyramid              - Gaussian pyramid decomposition
%
% Utilities
%   bbox2points                 - Convert a rectangle into a list of points
%   bboxOverlapRatio            - Compute bounding box overlap ratio
%   imageSet                    - Define collection of images
%   vision.ImagePadder          - Pad or crop input image
%   visionSupportPackages       - Launches the support package installer
%
% Demos
%   visiondemos                 - Index of Computer Vision System Toolbox demos
%
% Simulink functionality
%   <a href="matlab:visionlib">visionlib</a>                   - Open Computer Vision System Toolbox Simulink library
%
% See also images/Contents
