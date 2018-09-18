function tf = isCalledFromCommandLine(stack)
% Return true if the number of elements on stack is less than 1. This
% indicates the stack is from the command line versus a function or script.

tf = numel(stack) <= 1;