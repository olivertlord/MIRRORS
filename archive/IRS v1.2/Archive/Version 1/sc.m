function [byd,bxd,cyd,cxd,dyd,dxd]= sc(raw);

[ufile,upath]=uigetfile('C:\MATLAB7\work\4 COLOR\Calibration files\.tiff','Select spatial calibration file')
filename = strcat(upath,'/',ufile)

raw=imread(filename);

d=raw(1:255,1:382);                     %top left 670nm
c=raw(1:255,384:765);                   %top right 750nm
b=raw(256:510,1:382);                   %bottom left 800nm
a=raw(256:510,384:765);                 %bottom right 900nm

[num,idx]=max(a(:));
[ax,ay]=ind2sub(size(a),idx);

[num,idx]=max(b(:));
[bx,by]=ind2sub(size(b),idx);

[num,idx]=max(c(:));
[cx,cy]=ind2sub(size(c),idx);

[num,idx]=max(d(:));
[dx,dy]=ind2sub(size(d),idx);

bxd=by-ay
byd=bx-ax

cxd=cy-ay
cyd=cx-ax

dxd=dy-ay
dyd=dx-ax


