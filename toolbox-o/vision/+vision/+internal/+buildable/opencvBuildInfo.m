function opencvBuildInfo(buildInfo, context, fcnName, needNonFreeLib)
% opencvBuildInfo: Lists all the libraries required for openCV library
% based code generation

% File extensions
[~, linkLibExt, execLibExt] = context.getStdLibInfo();
group = 'BlockModules';

% Header paths
buildInfo.addIncludePaths(fullfile(matlabroot,'extern','include'));

% Platform specific link and non-build files
arch            = computer('arch');
pathBinArch     = fullfile(matlabroot,'bin',arch,filesep);
libName         = ['libmw' fcnName];

%--------------------------------------------------------------------------
% Set OpenCV version
%--------------------------------------------------------------------------
ocv_version = '2.4.9';

switch arch
    case {'win32','win64'}        
        % associate bridge lib file: (matabroot)\extern\lib\win64\microsoft\libmwfcnName.lib        

        libDir = images.internal.getImportLibDirName(context); 
        
        linkLibPath     = fullfile(matlabroot,'extern','lib',arch,libDir);
        linkFilesNoExt  = {libName}; %#ok<*EMCA>
        linkFiles       = strcat(linkFilesNoExt, linkLibExt);
        
        ocv_ver_no_dots = strrep(ocv_version,'.','');
        ocv_libs        = strcat({'opencv_core','opencv_imgproc'}, ocv_ver_no_dots);
        
        % Non-build files
        % associate open cv 3p libraries L:\Adsp\matlab\bin\win64
        nonBuildFilesNoExt = [libName, ocv_libs, 'tbb'];
        nonBuildFilesNoExt = AddHighGuiLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        nonBuildFilesNoExt = AddObjDetectLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        nonBuildFilesNoExt = AddFeaturesLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        nonBuildFilesNoExt = AddFlannLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        nonBuildFilesNoExt = AddCalib3DLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        nonBuildFilesNoExt = AddNonFreeLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        nonBuildFilesNoExt = AddVideoLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        nonBuildFilesNoExt = AddGPULibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots);
        
        nonBuildFiles = strcat(pathBinArch,nonBuildFilesNoExt, execLibExt);                
    case {'glnxa64','maci64'}
        linkLibPath     = pathBinArch;
        linkFilesNoExt  = {libName}; %#ok<*EMCA>
        linkFiles       = strcat(linkFilesNoExt, linkLibExt);
        
        ocv_major_ver = ocv_version(1:end-2);
        %
        nonBuildFilesNoExt = {'libopencv_core', ...
            'libopencv_features2d', ...
            'libopencv_imgproc', ...
            'libopencv_legacy', ...
            'libopencv_ml', ...
            'libopencv_nonfree', ... % always needed
            'libopencv_objdetect', ...
            'libopencv_photo', ...
            'libopencv_calib3d', ...
            'libopencv_video', ...
            'libopencv_flann', ...
            'libopencv_contrib', ...
            'libopencv_highgui', ...
            'libopencv_stitching', ...            
            'libopencv_videostab', ...
            'libopencv_gpu'};
        
        if strcmpi(arch,'glnxa64')
            nonBuildFiles = strcat(pathBinArch,nonBuildFilesNoExt, strcat('.so.',ocv_major_ver));
            % cvst function specific library
            nonBuildFiles{end+1} = strcat(pathBinArch,[libName '.so']);
            % boost [only used by pointTracker]
            nonBuildFiles = AddBoostLibsIfNeeded(nonBuildFiles, pathBinArch, fcnName);
            % tbb [used by all]
            nonBuildFiles = AddTbbLibs(nonBuildFiles, pathBinArch);
            % glnxa64 specific runtime libs
            nonBuildFiles = AddGLNXRTlibs(nonBuildFiles);
        else % maci64                                  
            
            nonBuildFiles = strcat(pathBinArch,nonBuildFilesNoExt, strcat('.',ocv_major_ver,'.dylib'));
            % cvst function specific library
            nonBuildFiles{end+1} = strcat(pathBinArch,[libName '.dylib']);
            % boost [only used by pointTracker]
            nonBuildFiles = AddBoostLibsIfNeeded(nonBuildFiles, pathBinArch, fcnName);
            % tbb (implicitly used by libopencv_core.2.4.dylib)
            nonBuildFiles{end+1} = strcat(pathBinArch,'libtbb.dylib');
        end
        
    otherwise
        % unsupported
        assert(false,[ arch ' operating system not supported']);
end

nonBuildFiles = AddCUDALibs(nonBuildFiles, pathBinArch);

linkPriority    = '';
linkPrecompiled = true;
linkLinkonly    = true;
buildInfo.addLinkObjects(linkFiles,linkLibPath,linkPriority,...
    linkPrecompiled,linkLinkonly,group);

buildInfo.addNonBuildFiles(nonBuildFiles,'',group);

%==========================================================================
function nonBuildFiles = AddBoostLibsIfNeeded(nonBuildFiles, pathBinArch, fcnName)
% boost: used by only pointTracker
if strcmp(fcnName, 'pointTracker')
    arch = computer('arch');
    if strcmpi(arch, 'glnxa64')
        boostFileSys = getBoostLibName(pathBinArch, 'libboost_filesystem.so.*');
        boostSys = getBoostLibName(pathBinArch, 'libboost_system.so.*');
        nonBuildFiles{end+1} = strcat(pathBinArch, boostFileSys);
        nonBuildFiles{end+1} = strcat(pathBinArch, boostSys);
    else % must be maci64
        nonBuildFiles{end+1} = strcat(pathBinArch,'libboost_filesystem.dylib');
        nonBuildFiles{end+1} = strcat(pathBinArch,'libboost_system.dylib');
    end
end

%==========================================================================
function nonBuildFiles = AddTbbLibs(nonBuildFiles, pathBinArch)
% tbb: used by all
nonBuildFiles{end+1} = strcat(pathBinArch,'libtbb.so.2');

%==========================================================================
function nonBuildFiles = AddCUDALibs(nonBuildFiles, pathBinArch)
% CUDA: required by all OpenCV libs when OpenCV is built WITH_CUDA=ON.
cudaLibs = {'cudart', 'nppc', 'nppi', 'npps','cufft'};

arch = computer('arch');
switch arch
    case 'win32'
        % CUDA not enabled on win32
        cudaLibs = [];
    case 'win64'
        cudaLibs = strcat(cudaLibs, '64_70.dll');
    case 'glnxa64'
        cudaLibs = strcat('lib', cudaLibs, '.so.7.0');
    case 'maci64'
        cudaLibs = strcat('lib', cudaLibs, '.7.0.dylib');
    otherwise
        assert(false,[ arch ' operating system not supported']);
end
if ~strcmpi(arch,'win32')  
    cudaLibs = strcat(pathBinArch,cudaLibs);
    for i = 1:numel(cudaLibs)
        nonBuildFiles{end+1} = cudaLibs{i};
    end
end

%==========================================================================
function nonBuildFiles = AddGLNXRTlibs(nonBuildFiles)
% glnxa64 specific runtime libs
arch = computer('arch');
sysosPath = fullfile(matlabroot,'sys','os',arch,filesep);
nonBuildFiles{end+1} = strcat(sysosPath,'libstdc++.so.6');
nonBuildFiles{end+1} = strcat(sysosPath,'libgcc_s.so.1');

%==========================================================================
function nonBuildFilesNoExt = AddHighGuiLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'cascadeClassifier') || ...
        strcmp(fcnName, 'HOGDescriptor') || ...
        strcmp(fcnName, 'extractSurf') || ...  % dependency via nonfree
        strcmp(fcnName, 'fastHessianDetector') % dependency via nonfree
    nonBuildFilesNoExt{end+1} = strcat('opencv_highgui', ocv_ver_no_dots);
end

%==========================================================================
function nonBuildFilesNoExt = AddObjDetectLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'cascadeClassifier') || ...
        strcmp(fcnName, 'HOGDescriptor') || ...
        strcmp(fcnName, 'extractSurf') || ...  % dependency via nonfree
        strcmp(fcnName, 'fastHessianDetector') % dependency via nonfree
    nonBuildFilesNoExt{end+1} = strcat('opencv_objdetect', ocv_ver_no_dots);
end

%==========================================================================
function nonBuildFilesNoExt = AddFeaturesLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'detectFAST') || ...
        strcmp(fcnName, 'detectMser') || ...
        strcmp(fcnName, 'extractFreak') || ...
        strcmp(fcnName, 'disparityBM') || ...
        strcmp(fcnName, 'disparitySGBM') || ...
        strcmp(fcnName, 'extractSurf') || ...
        strcmp(fcnName, 'fastHessianDetector') || ...
        strcmp(fcnName, 'detectBRISK') || ...
        strcmp(fcnName, 'extractBRISK')
    nonBuildFilesNoExt{end+1} = strcat('opencv_features2d', ocv_ver_no_dots);
end

%==========================================================================
function nonBuildFilesNoExt = AddFlannLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'detectFAST') || ...
        strcmp(fcnName, 'detectMser') || ...
        strcmp(fcnName, 'extractFreak') || ...
        strcmp(fcnName, 'disparityBM') || ...
        strcmp(fcnName, 'disparitySGBM') || ...
        strcmp(fcnName, 'extractSurf') || ...
        strcmp(fcnName, 'fastHessianDetector') || ...
        strcmp(fcnName, 'detectBRISK') || ...
        strcmp(fcnName, 'extractBRISK') || ...
        strcmp(fcnName, 'matchFeatures')
    nonBuildFilesNoExt{end+1} = strcat('opencv_flann', ocv_ver_no_dots);
end

%==========================================================================
function nonBuildFilesNoExt = AddCalib3DLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'disparityBM') || ...
        strcmp(fcnName, 'disparitySGBM') || ...
        strcmp(fcnName, 'extractSurf') || ...  % dependency via nonfree
        strcmp(fcnName, 'fastHessianDetector') % dependency via nonfree
    nonBuildFilesNoExt{end+1} = strcat('opencv_calib3d', ocv_ver_no_dots);
end

%==========================================================================
function nonBuildFilesNoExt = AddNonFreeLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'extractSurf') || ...
        strcmp(fcnName, 'fastHessianDetector')
    nonBuildFilesNoExt{end+1} = strcat('opencv_nonfree', ocv_ver_no_dots);
end

%==========================================================================
function nonBuildFilesNoExt = AddVideoLibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'pointTracker') || ...
        strcmp(fcnName, 'extractSurf') || ...  % dependency via nonfree
        strcmp(fcnName, 'fastHessianDetector') % dependency via nonfree
    nonBuildFilesNoExt{end+1} = strcat('opencv_video', ocv_ver_no_dots);
end

%==========================================================================
function nonBuildFilesNoExt = AddGPULibIfNeeded(nonBuildFilesNoExt, fcnName, ocv_ver_no_dots)

if strcmp(fcnName, 'extractSurf') || ...  % dependency via nonfree
        strcmp(fcnName, 'fastHessianDetector') % dependency via nonfree
    nonBuildFilesNoExt{end+1} = strcat('opencv_gpu', ocv_ver_no_dots);
end

%==========================================================================
function libName = getBoostLibName(pathBinArch, libName)
dirInfo = dir(fullfile(pathBinArch, libName));
libName = dirInfo(1).name;