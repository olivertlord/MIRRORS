function [bya,bxa,cya,cxa,dya,dxa] = correlate(raw)
%--------------------------------------------------------------------------
% Function CORRELATE
%--------------------------------------------------------------------------
% Written and tested on Matlab R2014a (Windows 7) & R2017a (OS X 10.13)

% Copyright 2018 Oliver Lord, Weiwei Wang
% email: oliver.lord@bristol.ac.uk
 
% This file is part of MIRRORS.
 
% MIRRORS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
 
% MIRRORS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
 
% You should have received a copy of the GNU General Public License
% along with MIRRORS.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
%   Divides an image into four quadrants (sub-frames) and then correlates
%   sub frame b, c and d relative to a by computing the correlation matrix
%   of the two input matrices. The x and y positions at which the
%   correlation is strongest are determined and these are used to determine
%   offsets in both x and y directions for later use by function MAPPER.

%   Wavelengths of each quadrant at Bristol
%   a = top left (670 nm)
%   b = top right (750 nm)
%   c = bottom left (850 nm)
%   d = bottom right (580 nm)

% Inputs:
% 
%     raw: matrix of raw image data
% 
% Outputs:
% 
%     bya: offset in y direction of subframe b relative to a
%     bxa: offset in x direction of subframe b relative to a
%     cya: offset in y direction of subframe c relative to a
%     cxa: offset in x direction of subframe c relative to a
%     dya: offset in y direction of subframe d relative to a
%     dxa: offset in x direction of subframe d relative to a

%--------------------------------------------------------------------------

% Divide raw image file into quadrants
[a,b,c,d] = divide(raw);

% Find centre of quadrant
[xc,yc] = find_quadrant_centre(a);

% Determine half-width of sqaure domain of side 50% the length of the
% shortest side of the quadrant
cor_hw = floor(.5*min(xc,yc));

% Select subframe from quadrant for correlation
cor_a = a(xc-cor_hw:xc+cor_hw,yc-cor_hw:yc+cor_hw);
cor_b = b(xc-cor_hw:xc+cor_hw,yc-cor_hw:yc+cor_hw);
cor_c = c(xc-cor_hw:xc+cor_hw,yc-cor_hw:yc+cor_hw);
cor_d = d(xc-cor_hw:xc+cor_hw,yc-cor_hw:yc+cor_hw);

cc = xcorr2(cor_b,cor_a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
bya = (ypeak-size(cor_a,1));
bxa = (xpeak-size(cor_a,2));

cc = xcorr2(cor_c,cor_a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
cya = (ypeak-size(cor_a,1));
cxa = (xpeak-size(cor_a,2));

cc = xcorr2(cor_d,cor_a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
dya = (ypeak-size(cor_a,1));
dxa = (xpeak-size(cor_a,2));