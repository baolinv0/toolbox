function errorIfInSimulink(name)
%#codegen

% Determine the codegen context. Only MATLAB Coder's MEX and 'Rtw' = {DLL,
% EXE, or LIB} targets are supported.
isSupportedContext = coder.internal.const(...
    coder.target('MEX') || coder.target('Rtw')); 

eml_invariant(isSupportedContext,...
    eml_message('vision:ocvShared:codegenNotSupportedInSimulink',name))