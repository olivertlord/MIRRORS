function [u,c,hp] = initialise_mode(clear)
%--------------------------------------------------------------------------
% Function initialise_mode
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
%   Extracts the ROI from each quadrant of an image based on correlation
%   parameters determined in correlate.m

%   INPUTS: 

%   OUTPUTS: 

%--------------------------------------------------------------------------

% Clear all axes within GUI
if clear == true
    arrayfun(@cla,findall(0,'type','axes'))
    fclose('all');
end

% Load previous file path from .MAT file
u = matfile('unknown.mat','Writable',true);

% Reads in calibration .MAT file
c = matfile('calibration.mat','Writable',true);

% Load calibration.mat
hp = matfile('hardware_parameters.mat','Writable',true);