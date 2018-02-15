function [cor_a, cor_b, cor_c, cor_d] = correlate(fullframe, x, y, w)

fullframe = double(fullframe);
%converts to double

[a,b,c,d] = deal(fullframe(1:255,1:382),fullframe(1:255,384:765),fullframe(256:510,1:382),fullframe(256:510,384:765));
%splits fullframe into quadrants

cc = xcorr2(b,a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
byd = (ypeak-size(a,1));
bxd = (xpeak-size(a,2));

cc = xcorr2(c,a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
cyd = (ypeak-size(a,1));
cxd = (xpeak-size(a,2));

cc = xcorr2(d,a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
dyd = (ypeak-size(a,1));
dxd = (xpeak-size(a,2));

cor_a=a(y-w-4:y+w+4,x-w-4:x+w+4);
cor_b=b(y-w+byd-4:y+w+byd+4,x-w+bxd-4:x+w+bxd+4);
cor_c=c(y-w+cyd-4:y+w+cyd+4,x-w+cxd-4:x+w+cxd+4);
cor_d=d(y-w+dyd-4:y+w+dyd+4,x-w+dxd-4:x+w+dxd+4);
%shifts quadrants based on offsets and pads by 4 pixels