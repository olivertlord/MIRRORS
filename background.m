function bkg = background(raw)

%--------------------------------------------------------------------------
% Function background
%--------------------------------------------------------------------------
% Written and tested on Matlab R2022b (mac)

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
% Calculates the background intensity of a raw image

% Inputs:
%     raw: matrix (image)
%
% Outputs:
%     bkg: scalar (background)

%--------------------------------------------------------------------------

% Determines background intensity using image corners of unknown
% file
bkg = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
    raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));