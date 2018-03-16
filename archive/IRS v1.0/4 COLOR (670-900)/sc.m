function [byd,bxd,cyd,cxd,dyd,dxd]= sc(raw);

filename = '/Volumes/OLLIE 1TB/Work/Methods & Techniques/Temperature measurement/Imaging Radiometry Software/4 COLOR (670-900)/Calibration files/25.11.13 (dacb) Calibration/sc.tiff';

raw=imread(filename);

d=raw(1:255,1:382);                     %top left 670nm
a=raw(1:255,384:765);                   %top right 750nm
c=raw(256:510,1:382);                   %bottom left 800nm
b=raw(256:510,384:765);                 %bottom right 900nm

[num,idx]=max(a(:));
[ax,ay]=ind2sub(size(a),idx);

[num,idx]=max(b(:));
[bx,by]=ind2sub(size(b),idx);

[num,idx]=max(c(:));
[cx,cy]=ind2sub(size(c),idx);

[num,idx]=max(d(:));
[dx,dy]=ind2sub(size(d),idx);

bxd=by-ay;
byd=bx-ax;

cxd=cy-ay;
cyd=cx-ax;

dxd=dy-ay;
dyd=dx-ax;


