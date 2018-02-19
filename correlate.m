function [bya,bxa,cya,cxa,dya,dxa] = correlate(a,b,c,d)
%--------------------------------------------------------------------------
% Function CORRELATE
%--------------------------------------------------------------------------
% Written and tested on Matlab R2014a (Windows 7) & R2017a (OS X 10.13)

% Copyright 2018 Oliver Lord, Weiwei Wang
% email: oliver.lord@bristol.ac.uk
 
% This file is part of IRiS.
 
% IRiS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
 
% IRiS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
 
% You should have received a copy of the GNU General Public License
% along with IRiS.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
%   Correlates sub frame b, c and d relative to a by computing the
%   correlation matrix of the two input matrices. The x and y positions at
%   which the correlation is strongest are determined and these are used to
%   determine offsets in both x and y directions for later use by function
%   MAPPER.

%   INPUTS: a,b,c,d = subframes

%   OUTPUTS: bya,bxa,cya,cxa,dya,dxa = x and y offsects of b, c and d
%            relative to a


%--------------------------------------------------------------------------
cc = xcorr2(b,a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
bya = (ypeak-size(a,1));
bxa = (xpeak-size(a,2));

cc = xcorr2(c,a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
cya = (ypeak-size(a,1));
cxa = (xpeak-size(a,2));

cc = xcorr2(d,a);
[~, imax] = max(abs(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),imax(1));
dya = (ypeak-size(a,1));
dxa = (xpeak-size(a,2));