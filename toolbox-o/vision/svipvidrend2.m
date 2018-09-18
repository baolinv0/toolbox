function svipvidrend2(varargin)
%SVIPVIDREND2 Video Processing Blockset Video Viewer Block
% Level-2 M-S-function

% Copyright 1995-2011 The MathWorks, Inc.
%   u

if nargin == 1
    mdlInitializeSizes(varargin{1});
else
    feval(varargin{:});
end

% -------------------------------------------------------------------------
function mdlInitializeSizes(block)

if any(strcmp(get_param(bdroot(gcb), 'SimulationStatus'), {'updating', 'initializing'}))
    visionsyslinit;
end

% Register number of ports
isSeparateRGB = isInputSeparateRGB(block);
if isSeparateRGB
    block.NumInputPorts = 3;
else
    block.NumInputPorts = 1;
end

block.NumOutputPorts = 0;
block.SampleTimes = [-1 0]; % Block-based sample time

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;

% Override input port properties
for i=1:block.NumInputPorts,
    block.InputPort(i).Complexity = 0;  % Real
    block.InputPort(i).DimensionsMode = 'inherited'; % To enable vard support
end

% Register parameters
block.NumDialogPrms = 10; % coming from mask

set(block, 'AllowSignalsWithMoreThan2D', 1);    % enable N-D signal

% Set the block simStateCompliance to DisallowSimState because this is a
% sink block
block.SimStateCompliance = 'DisallowSimState';

% Reg methods
block.RegBlockMethod('CheckParameters',          @mdlCheckParameters);

block.RegBlockMethod('SetInputPortSamplingMode', @mdlSetInputPortFrameData);
block.RegBlockMethod('SetInputPortDimensions',   @mdlSetInputPortDimensions);
block.RegBlockMethod('SetInputPortDataType',     @mdlSetInputPortDataType);

block.RegBlockMethod('PostPropagationSetup',     @mdlPostPropSetup); %C-Mex: mdlSetWorkWidths

block.RegBlockMethod('Terminate',               @mdlTerminate);

setConfigName(block);
scopeextensions.ScopeBlock.mdlInitializeSizes(block);

%end of mdlInitializeSizes

% -------------------------------------------------------------------------
function okflag = OK_TO_CHECK_PARAMS()

ss = get_param(bdroot,'simulationstatus');
okflag = strcmp(ss, 'initializing') || ...
    strcmp(ss, 'updating')     || ...
    strcmp(ss, 'running')      || ...
    strcmp(ss, 'paused');

% -------------------------------------------------------------------------
function mdlCheckParameters(block)

% Always call the check,
% because two things need it:
%  1 - error if it's ok_to_check_params, and
%  2 - mdlProcessParams needs to know we're okey-dokey
%
errorID = checkParams(block);
if OK_TO_CHECK_PARAMS()
    if ~isempty(errorID)
        DAStudio.error(errorID{:});
    end
end

blkh = block.BlockHandle;
parentMdl = get(blkh,'parent');
if (isFxptGUItrueDoubleOrTrueSingle(parentMdl))
    DAStudio.error('vision:svipvidrend2:trueDoubleSingleUnsupported');
end
%
% If all the vars are defined, push the changes through
% This gives us "live" parameters while the dialog is open
% and while the simulation is NOT running
%
if isempty(errorID)
    mdlProcessParameters(block);
end

% -------------------------------------------------------------------------
function blockOpen(block) %#ok<DEFNU>

if strcmp(get_param(bdroot(block), 'Lock'), 'on')
    errordlg(DAStudio.message('Spcuilib:scopes:ScopeInLockedSystem', get(block, 'Name')));
    return;
end
set_param(block, 'inputType', 'Obsolete7b');

setConfigName(block);
h = scopeextensions.ScopeBlock.getInstance(block);
h.Visible = 'on';

% -------------------------------------------------------------------------
function mdlSetInputPortFrameData(block, ~, fd)

for ind=1: block.NumInputPorts
    block.InputPort(ind).SamplingMode = fd;
end

% -------------------------------------------------------------------------
function mdlSetInputPortDataType(block, idx, dtid)

% set the data type for all ports
for ind=1: block.NumInputPorts
    block.InputPort(ind).DatatypeID = dtid;
end

dType = block.InputPort(idx).DatatypeID;
if (dtid > 8) % non-builtin data type
    [dInfo, isScaledDouble] = fixdt(block.InputPort(idx).Datatype);
    if isScaledDouble
        dType = getNonOverrideDTIDforScaledDbl(dInfo);
    end
end

% save the data
h = scopeextensions.ScopeBlock.getInstance(block);
h.setAppData('ValidDataType', dType);

% -------------------------------------------------------------------------
function mdlSetInputPortDimensions(block, ~, di)

blkh = block.BlockHandle;
blockName = get(blkh, 'Name');

% check input dimensions
numDim = length(di);
if block.DialogPrm(10).Data == 1  % Intensity or N-D
    if numDim==2 || (numDim==3 && di(3)==3)
        % Warn if the input is N-D AND colormap or value range is used
        if numDim==3
            if (block.DialogPrm(2).Data==1 && block.DialogPrm(4).Data==1)
                DAStudio.warning('vision:svipvidrend2:colormapAndValueRangeIgnored');
            elseif (block.DialogPrm(2).Data==1)
                DAStudio.warning('vision:svipvidrend2:colormapIgnored');
            elseif (block.DialogPrm(4).Data==1)
                DAStudio.warning('vision:svipvidrend2:valueRangeIgnored');
            end
        end
    elseif numDim~=1
        DAStudio.error('vision:svipvidrend2:inputsMustBeMxNx3', blockName);
    end
elseif numDim >= 3
    % 3 or more dimensions
    DAStudio.error('vision:svipvidrend2:inputsMustBe2D', blockName);
end

% set the dimension for all input ports
for ind=1: block.NumInputPorts
    block.InputPort(ind).Dimensions = di;
end

% -------------------------------------------------------------------------
function mdlPostPropSetup(block)

% Check that we are not using a custom datatype.
h = scopeextensions.ScopeBlock.getInstance(block);
if h.getAppData('ValidDataType') > 8
    DAStudio.error('vision:svipvidrend2:unsupportedDataType');
end

% -------------------------------------------------------------------------
function mdlProcessParameters(block)

if scopeextensions.ScopeBlock.hasInstance(block.BlockHandle)
    h = scopeextensions.ScopeBlock.getInstance(block);
    setScopeParams(h);
end

% -------------------------------------------------------------------------
function mdlTerminate(block) %#ok<INUSD>

% empty

% -------------------------------------------------------------------------
function identifier = checkParams(block)

% Check cb: useColorMap
identifier = checkDataAttributes('integer', block.DialogPrm(2).Data, ...
    'colormap check box', [1 1], [0 1]);
if ~isempty(identifier)
    return;
end

% Check colormapValue:
if block.DialogPrm(2).Data %% useColorMap
    x = double(block.DialogPrm(3).Data{1});
    identifier = checkDataAttributes('float', x, ...
        'colormap check box', [], [0 1]);
    if ~isempty(identifier)
        return;
    end
    if (ndims(x)~=2) || (size(x,2)~=3)
        identifier = {'vision:svipvidrend2:invalidColormapParam'};
        return
    end
end

% Check specRange: cb: useDataRange
identifier = checkDataAttributes('integer', block.DialogPrm(4).Data, ...
    'range of values check box', [1 1], [0 1]);
if ~isempty(identifier)
    return;
end

if block.DialogPrm(4).Data %cb: useDataRange
    % Check minInputVal: eb:
    identifier = checkDataAttributes('float', double(block.DialogPrm(5).Data), ...
         'minimum input value parameter', [1 1], []);
    if ~isempty(identifier)
        return;
    end
    
    % Check maxInputVal: eb:
    identifier = checkDataAttributes('float', double(block.DialogPrm(6).Data), ...
        'maximum input value parameter', [1 1], []);
    if ~isempty(identifier)
        return;
    end
    
    % relationship between minInputVal and maxInputVal
    if (double(block.DialogPrm(5).Data) > double(block.DialogPrm(6).Data))
        identifier = {'vision:svipvidrend2:invalidDataRangeParam'};
        return
    end
end

% Check eb: figure position
identifier = checkDataAttributes('float', double(block.DialogPrm(7).Data), ...
    'figure position parameter', [1 4], []);
if ~isempty(identifier)
    return;
end

% Check AxisZoom: checkbox
identifier = checkDataAttributes('integer', block.DialogPrm(8).Data, ...
    'axis zoom check box', [1 1], [0 1]);
if ~isempty(identifier)
    return;
end

% Check trueSizedOnce: checkbox
identifier = checkDataAttributes('integer', block.DialogPrm(9).Data, ...
    'true size check box', [1 1], [0 1]);
if ~isempty(identifier)
    return;
end

% Check pu: (multidimensional signal or separate color signals)
identifier = checkDataAttributes('integer', block.DialogPrm(10).Data, ...
    'image signal format parameter', [1 1], [1 2]);
if ~isempty(identifier)
    return;
end

% -------------------------------------------------------------------------
% attr: 'integer', 'float'
function identifier = checkDataAttributes(attr, value, name, dimen, range)

if isempty(value)
    identifier = {'vision:svipvidrend2:undefinedParam', name};
elseif ~isnumeric(value)
    identifier = {'vision:svipvidrend2:nonNumericParam', name};
elseif ~isreal(value)
    identifier = {'vision:svipvidrend2:nonRealParam', name};
elseif any(isnan(value)|isinf(value))
    identifier = {'vision:svipvidrend2:infOrNaNParam', name};
elseif issparse(value)
    identifier = {'vision:svipvidrend2:sparseParam', name};
elseif strcmpi(attr, 'integer') && any(floor(value)~=value)
    identifier = {'vision:svipvidrend2:nonIntegerParam', name};
elseif ~isempty(range) && (any(value(:)<range(1)) || any(value(:)>range(2)))
    identifier = {'vision:svipvidrend2:invalidRangeParam', name};
elseif ~isempty(dimen) && any(size(value) ~= dimen)
    identifier = {'vision:svipvidrend2:invalidDimenParam', name};
else
    identifier = [];
end

% ---------------------------------------------------------------
function dType = getNonOverrideDTIDforScaledDbl(dInfo)
FL = dInfo.FractionLength;
WL = dInfo.WordLength;
if (FL ~= 0)
    dType = -1;
    return;
end
if (WL ~= 8 && WL ~= 16 && WL ~= 32)
    dType = -1;
    return;
end 
% 0,1,
if (WL==8)
    dType = 2; %int8
elseif (WL==16) 
    dType = 4; %int16
else
    dType = 6; %int32
end

if ~dInfo.Signed
    dType = dType +1; % unsigned
end

% -------------------------------------------------------------------------
function  flag  = isFxptGUItrueDoubleOrTrueSingle(parentMdl)

overrideMode = get_param(parentMdl,'DataTypeOverride');
flag  = strcmp(overrideMode,'Double') || strcmp(overrideMode,'Single');

% -------------------------------------------------------------------------
function isSeparateRGB = isInputSeparateRGB(block)
% Parameter 1:  1-'RGB', 2-'Intensity', 3-'Obsolete', 4-'Obsolete7b'
% Parameter 10: 1-'One multidimensional signal', 2-'separate color signals'
isSeparateRGB = (block.DialogPrm(1).Data>=3 && block.DialogPrm(10).Data==2) ...
    || block.DialogPrm(1).Data==1;

% -------------------------------------------------------------------------
function setConfigName(block)

scopeextensions.ScopeBlock.setConfigName(block, 'vipscopes.VideoViewerScopeCfg');


% [EOF]
