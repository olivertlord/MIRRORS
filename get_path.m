function [filename, filepath] = get_path(cell_array,dir,pos)

%--------------------------------------------------------------------------
% Function get_path
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
% Extracts filename from cell_array or string if cell_array is only one
% element long

% Inputs:
%   
%       cell_array = filename stored as cell_array or string

%       dir        = current directory

%       pos        = current position within array

% Outputs:
% 
%       filename = string containing filename

%       filepath = string containing filepath

%--------------------------------------------------------------------------

% Extract filename from cell array
if isa(cell_array, 'cell')
    filename = cell_array(1,pos);
    filename = filename{1};
else
    filename = cell_array;
end

% Determines path to unknown file
filepath = char(strcat(dir,'/',filename));