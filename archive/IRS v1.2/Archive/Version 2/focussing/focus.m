close all
clear all
ufile=uigetfile('*.csv','select the .csv file');
A=csvread(ufile);
x = A(:,1)
y = A(:,2)

dx = diff(x);
dy = diff(y);

df = abs(dy./dx);
df = [df;0];
height = max(df)
endofdata = size(df);

for i = 1:(endofdata(1));
    df(i) = df(i)-(height*.15)
    if df(i) < 0
        df(i)= 0;
    end
end

plot (df)
hold on

[FWHM,centre]=gaussfit(x,df)

b = (2*(FWHM^2));
x = (x-centre).^2;
c = -(x./b);
d = 2.71828.^c;
e = d.*height;

plot (e,'r')
text(10,height,sprintf('FWHM = %0.5g',FWHM))
