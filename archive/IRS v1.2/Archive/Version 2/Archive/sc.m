function sc (raw);

raw=imread('Spatial Calibration.tiff')

a=raw(1:255,1:382);                     %top left 900nm
b=raw(1:255,384:765);                   %top right 800nm
c=raw(256:510,1:382);                   %bottom left 750nm
d=raw(256:510,384:765);                 %bottom right 670nm

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


