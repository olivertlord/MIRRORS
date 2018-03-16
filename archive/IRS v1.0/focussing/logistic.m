function f = logistic(Qinf,a,thalf,t)
f = Qinf./(1 + exp(-a*(t-thalf)))   % Compute function value at x