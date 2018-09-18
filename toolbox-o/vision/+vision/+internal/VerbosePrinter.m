% VerbosePrinter is part of the vision.internal.MessagePrinter
% infrastructure.
%
% Example
% ------- 
%   isVerbose = true;
%   printer = vision.internal.MessagePrinter.configure(isVerbose); 
%   printer.print('message');

classdef VerbosePrinter < vision.internal.MessagePrinter

    methods      
        function print(~, varargin)
            fprintf(varargin{:});            
        end 
        
        function this = printMessageNoReturn(this, msgID, varargin)
            msg = getString(message(msgID, varargin{:}));
            this.print(msg);
        end
        
        function linebreak(this, numBreaks)
            if nargin <= 1
                numBreaks = 1;
            end
            
            this.print(repmat(sprintf('\n'),1,numBreaks));
        end
    end
end 