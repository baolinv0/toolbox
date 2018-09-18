function standardError = computeStandardError(jacobian, residual)
% computeStandardError compute the standard error of estimated parameters
% standardError = computeStandardError returns a vector containing the
% standard errors of estimated parameters. jacobian is the Jacobian matrix,
% and residual is a vector of residuals.

R = qr(jacobian,0);
n = size(jacobian,1)-size(jacobian,2);
% be careful with memory
clear jacobian;
mse = sum(sum(residual.^2, 2)) / n;
Rinv = inv(R);
Sigma = Rinv*Rinv'*mse;
standardError = full(sqrt(diag(Sigma)));
end