% EnforceScalarValue overloads key methods to prevent the creation of
% object arrays. Value classes that inherit from it will get overloads of
%
%  horzcat vertcat cat repmat subsref subsasgn
%
% that throw errors when invoked for array creation. This class supports
% codegen.
%
% Examples of syntaxes that will error out:
%
%  obj(1)
%  obj(ones(3,3))
%  obj(2) = obj
%  [obj obj] % horzcat
%  [obj;obj] % vertcat
%  obj(1).property
%  repmat(obj,3,3)
%  cat(2,obj,obj)
%
% Errors are thrown as caller if objects are accessed from the command
% line. Otherwise the full error stack is thrown so that the error can be
% traced.

classdef EnforceScalarValue < vision.internal.enforcescalar.ValueBase
    
    methods(Access = private, Static)
        % Redirect for codegen. We need this until an overloaded subsref is
        % allowed for codegen (g912825)
        function name = matlabCodegenRedirect(~)
            name = 'vision.internal.enforcescalar.ValueCodegen';
        end
    end
    methods(Hidden, Sealed)
        function objArray = horzcat(obj, varargin) %#ok<*STOUT>
            try
                objArray = horzcat@vision.internal.enforcescalar.ValueBase(obj,varargin{:});
            catch e
                if vision.internal.enforcescalar.isCalledFromCommandLine(dbstack)
                    throwAsCaller(e)
                else
                    rethrow(e)
                end
            end
        end
        
        function objArray = vertcat(obj, varargin)
            try
                objArray = vertcat@vision.internal.enforcescalar.ValueBase(obj,varargin{:});
            catch e
                if vision.internal.enforcescalar.isCalledFromCommandLine(dbstack)
                    throwAsCaller(e)
                else
                    rethrow(e)
                end
            end
        end
        
        function objArray = cat(dim, varargin)
            try
                objArray = cat@vision.internal.enforcescalar.ValueBase(dim,varargin{:});
            catch e
                if vision.internal.enforcescalar.isCalledFromCommandLine(dbstack)
                    throwAsCaller(e)
                else
                    rethrow(e)
                end
            end
        end
        
        function objArray = repmat(obj, varargin)
            try
                objArray = repmat@vision.internal.enforcescalar.ValueBase(obj,varargin{:});
            catch e
                if vision.internal.enforcescalar.isCalledFromCommandLine(dbstack)
                    throwAsCaller(e)
                else
                    rethrow(e)
                end
            end
        end
        
        %------------------------------------------------------------------
        % Overload subsasgn to error for array formation and
        % parentheses-style indexing
        %------------------------------------------------------------------
        function sobj = subsasgn(obj, s, val)
            try
                sobj = subsasgn@vision.internal.enforcescalar.ValueBase(obj,s, val);
            catch e
                if vision.internal.enforcescalar.isCalledFromCommandLine(dbstack)
                    throwAsCaller(e)
                else
                    rethrow(e)
                end
            end
        end
        
        %------------------------------------------------------------------
        % Overload subsref to error for array formation and
        % parentheses-style indexing.
        %------------------------------------------------------------------
        function varargout = subsref(obj,s)
            try
                switch s(1).type
                    case '()'
                        enforceNoArray(obj);
                    otherwise
                        [varargout{1:nargout}] = builtin('subsref',obj,s);
                end
            catch e
                if vision.internal.enforcescalar.isCalledFromCommandLine(dbstack)
                    throwAsCaller(e)
                else
                    rethrow(e)
                end
            end
        end
    end
    
    methods(Access = protected, Sealed)
        function enforceNoArray(obj)
            error(message('vision:dims:arrayNotSupported',class(obj)));
        end
    end
end
