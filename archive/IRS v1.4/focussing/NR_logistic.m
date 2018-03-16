% This Matlab code provides a function that uses the Newton-Raphson algorithm
% to calculate ML estimates of a simple logistic regression. Most of the
% code comes from Anders Swensen, "Non-linear regression." There are two
% elements in the beta vector, which we wish to estimate.
%
function [beta,J_bar] = NR_logistic(data,beta_start)
x=data(:,1); % x is first column of data
y=data(:,2); % y is second column of data
n=length(x)
diff = 1; beta = beta_start; % initial values
while diff>0.0001 % convergence criterion
beta_old = beta;
p = exp(beta(1)+beta(2)*x)./(1+exp(beta(1)+beta(2)*x));
l = sum(y.*log(p)+(1-y).*log(1-p))
s = [sum(y-p); % scoring function
sum((y-p).*x)];
J_bar = [sum(p.*(1-p)) sum(p.*(1-p).*x); % information matrix
sum(p.*(1-p).*x) sum(p.*(1-p).*x.*x)]
beta = beta_old + J_bar/s % new value of beta
diff = sum(abs(beta-beta_old)); % sum of absolute differences
end
