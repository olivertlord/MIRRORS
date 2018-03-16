function [byd,bxd,cyd,cxd,dyd,dxd]= correlate(a,b,c,d)

cc = xcorr2(double(b),double(a));
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
byd = (ypeak-size(a,1));
bxd = (xpeak-size(a,2));

cc = xcorr2(double(c),double(a));
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
cyd = (ypeak-size(a,1));
cxd = (xpeak-size(a,2));

cc = xcorr2(double(d),double(a));
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
dyd = (ypeak-size(a,1));
dxd = (xpeak-size(a,2));


