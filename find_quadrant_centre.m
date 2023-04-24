function [xc,yc] = find_quadrant_centre(quadrant)
%--------------------------------------------------------------------------
% Function DIVIDE
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
% Finds the centre of a quadrant.

% Inputs:
% 
%       quadrant = matrix representing quadrant of an image

% Outputs:
% 
%       xc, yc = x, y co-ordinates of quadrant center

%--------------------------------------------------------------------------

% Determine size of quadrant
[cor_x,cor_y] = size(quadrant);

% Determine centre of quadrant
xc = floor(cor_x/2);
yc = floor(cor_y/2);