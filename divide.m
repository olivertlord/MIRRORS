function [a,b,c,d] = divide(raw)
%--------------------------------------------------------------------------
% Function DIVIDE
%--------------------------------------------------------------------------
% Written and tested on Matlab 2022b (mac)

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
% Divides a raw image file into four sub frames. 

% Wavelengths of each quadrant at Bristol
% a = top left (670 nm)
% b = top right (750 nm)
% c = bottom left (850 nm)
% d = bottom right (580 nm)

% Inputs: 
% 
%       raw = raw image file

% Outputs:
% 
%       a,b,c,d = image subframe arrays

%--------------------------------------------------------------------------

% Find largest even half-width
y_hw = 2*floor((size(raw,1)/2)/2);
x_hw = 2*floor((size(raw,2)/2)/2);

% Determine border width
y_bw = size(raw,1)-(2*y_hw);
x_bw = size(raw,2)-(2*x_hw);

% Divide fullframe image into four quadrants
a = raw(1:y_hw,1:x_hw,:);
b = raw(y_hw+y_bw+1:size(raw,1),1:x_hw,:);
c = raw(1:y_hw,x_hw+x_bw+1:size(raw,2),:);
d = raw(y_hw+y_bw+1:size(raw,1),x_hw+x_bw+1:size(raw,2),:);