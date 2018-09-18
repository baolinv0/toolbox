
%--------------------------------------------------------------
% This function will poke around the file system to see if the
% files can be loaded even though they are not at the specified
% locations. This can happen, for example, when moving between
% operating systems.
function newPath = tryToAdjustPath(origPath, currentSessionFilePath,...
    origFullSessionFileName)

% strip off the path regardless of the operating system
fileName = getFilename(origPath);

% see if the file can be found at the same location as the
% session file
newPath = fullfile(currentSessionFilePath,fileName);
ok = exist(newPath,'file');

% try again; this time look at the relative path upwards of
% the session file location
if ~ok
    relativePath = getRelativePath(origPath);
    newPath = fullfile(relativePath,fileName);
    ok = exist(newPath,'file');
end

% try again; see if the file can be found on MATLAB path
if ~ok
    newPath = which(fileName);
    ok = ~isempty(newPath);
end

if ~ok 
    error(message('vision:uitools:missingImageFiles'));
end

%--------------------------------------------------------------
% gets file name regardless of the operating system
    function fname = getFilename(path)
        
        unixDelimiters = strfind(path,'/');
        windowsDelimiters = strfind(path,'\');
        
        if ~isempty(unixDelimiters)
            last = unixDelimiters(end);
        else % must be windows
            last = windowsDelimiters(end);
        end
        
        fname = path(last+1:end);
    end
%--------------------------------------------------------------
    function path = getRelativePath(oldPath)
        path = '';
        
        fname = getFilename(oldPath);
        imageFilePathLength = length(oldPath)-length(fname);
        
        fname = getFilename(origFullSessionFileName);
        atSavingTimeSessionFilePathLength = ...
            length(origFullSessionFileName) - length(fname);
        
        fullImagePath = oldPath;
        imageFilePath = fullImagePath(1:imageFilePathLength);
        
        atSavingTimeSessionFilePath = ...
            origFullSessionFileName(1:atSavingTimeSessionFilePathLength);
        
        % process only up the filesystem tree
        if(imageFilePathLength >= atSavingTimeSessionFilePathLength)
            idx = imageFilePathLength - strfind(fliplr(imageFilePath), ...
                fliplr(atSavingTimeSessionFilePath)) + 2;
            path = imageFilePath(idx:end);
            
            % adjust delimeters so that the path is valid across
            % different platforms
            path = getPathForCurrentPlatform();
            
            path = [currentSessionFilePath, path];
        end
        
        %----------------------------------------------------------
        function pathOut = getPathForCurrentPlatform
            pathOut = path;
            
            if isempty(strfind(path,filesep))
                if filesep == '/'
                    storedFileSeparator = '\';
                else
                    storedFileSeparator = '/';
                end
                idx = strfind(path,storedFileSeparator);
                pathOut(idx) = filesep;
            end
        end
    end % getRelativePath
end
