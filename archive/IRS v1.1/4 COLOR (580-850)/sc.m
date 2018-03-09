function [byd,bxd,cyd,cxd,dyd,dxd,mo]= sc(raw);

filename = '../Calibration/Current/sc.tiff';

raw=imread(filename);

d=raw(1:255,1:382);                     %top left 670nm
a=raw(1:255,384:765);                   %top right 750nm
c=raw(256:510,1:382);                   %bottom left 850nm
b=raw(256:510,384:765);                 %bottom right 580nm

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

mo=max([bxd byd cxd cyd dxd dyd]);
%determines the maximum offset

assignin('base','a',a)
assignin('base','b',b)
assignin('base','c',c)
assignin('base','d',d)


