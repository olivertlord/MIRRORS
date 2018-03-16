function [Qinf,a,thalf] = logistic_fit(t, data)
% Call fminsearch with a random starting point.

start_point = rand(1, 3);

Qinf = 1000;
a = -.1;
thalf = 50;

options = optimset('Display','final','TolX',1);

logistic_str = @(t) logistic(Qinf,a,t,thalf);

[Qinf,a,thalf] = fminsearch(logistic_str,0,options)