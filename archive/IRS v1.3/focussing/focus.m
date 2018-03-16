close all
clear all
[ufile,upath]=uigetfile('C:\MATLAB7\work\4 COLOR(580-850)\Calibration files\*.*','Select the .csv file')
filename = strcat(upath,'\',ufile)
A=csvread(filename);
x = A(:,1);
y = A(:,2);

plot(x,y)
hold on

lf = sigm_fit(x,y)

yl = lf(1) + (lf(2)-lf(1)) ./ (1 + 10.^((lf(3)-x)*lf(4)));

plot(x,yl,'r')

dx = diff(x);
dy = diff(yl);
df = abs(dy./dx);
df = [df;0];
height = max(df);

% plot(x,df)
% hold on

% [muhat, sigmahat] = normfit(df)
% [C,I] = max(df)
% 
% %[FWHM,centre]=gaussfit(x,df)
% 
% b = (2*(sigmahat^2));
% xg = (x-(I-2)).^2;
% c = -(xg./b);
% d = 2.71828.^c;
% e = d.*C;
% 
% plot (e,'r')
% text(10,height,sprintf('FWHM = %0.5g',sigmahat*2))

