function [a,b,c,d] = extract_ROI(fullframe,ROI,...
            bya, bxa, cya, cxa, dya, dxa)
%--------------------------------------------------------------------------
% Function extract_ROI
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
% Extracts the ROI from each quadrant of an image based on correlation
% parameters determined in correlate.m

% Inputs:
%       
%       fullframe = raw image file
%           
%       pos = position of ROI [x,y,w,h] where x and y refer to top left
%           
%       bya = shift of b relative to a in dimension y
%           
%       bxa = shift of b relative to a in dimension x
%           
%       cya = shift of c relative to a in dimension y
%           
%       cxa = shift of c relative to a in dimension x
%           
%       dya = shift of d relative to a in dimension y
%           
%       dxa = shift of d relative to a in dimension x

% Outputs:
% 
%       a,b,c,d = image subframe arrays

%--------------------------------------------------------------------------

% Extract individual variables from pos
x = ROI(1);
y = ROI(2);
w = ROI(3);
h = ROI(4);

% Divide fullframe into quadrants
[a,b,c,d] = divide(fullframe);

% Shifts quadrants based on offsets
a = a(y:y+h-1,x:x+w-1);
b = b(y+bya:y+h-1+bya,x+bxa:x+w-1+bxa);
c = c(y+cya:y+h-1+cya,x+cxa:x+w-1+cxa);
d = d(y+dya:y+h-1+dya,x+dxa:x+w-1+dxa);