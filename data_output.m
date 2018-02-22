function [result,timevector] = data_output(dir_content,i,c1,T_max,E_max,...
    T_dif_metric,T,E,epsilon,T_dif,upath,savename)
%--------------------------------------------------------------------------
% Function DATA_OUTPUT
%--------------------------------------------------------------------------
% Version 1.6
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
%   Computes timestamps and creates summary datat array 'result'. Saves map
%   data into a text file for every unknown file

%   INPUTS: dir_content = structured array contaning metadata on every
%           .TIFF file in the current directory

%           i = the current position within filenumber

%           c1 = flag used to save initial timestamp into appdata iff == 1

%           T_max,E_max = peak temperature and associated error

%           T_dif_metric = average of the difference map

%           T,E,epsilon = computed maps of temperature, error and
%           emissivity

%           T_dif = difference map

%           upath = path to working directory

%           savename = unique folder name for output

%   OUTPUTS: result = array containing acquisition number, timestamp,
%            elapsedSec, T_max, E_max and T_dif_metric

%            timevector = timestamp in vectorised format


%--------------------------------------------------------------------------
% Determine and store filenumber of each acquisiton in dataset
acq = extract_filenumber(dir_content(i).name);

%Get timestamp
timestamp = datenum(dir_content(i).date);

% Vectorise timestamp
timevector = datevec(timestamp);

% Convert to seconds
timeSec = (timevector(1,6) + (timevector(1,5)*60)...
    + (timevector(1,4)*60*60));

if c1 == 1
    timeSec_0 = timeSec;
    setappdata(0,'timeSec_0',timeSec_0);
else
    timeSec_0 = getappdata(0,'timeSec_0');
end

% Convert to elapsed seconds
elapsedSec = round(timeSec-timeSec_0);


%--------------------------------------------------------------------------
% Concatenate output array
result = [acq,timestamp,elapsedSec,T_max,E_max,T_dif_metric];


%--------------------------------------------------------------------------
% Generates data table containing all three maps
[x1,y1] = meshgrid(1:length(T),1:length(T));

% Concatenate output array
xyz = real([x1(:) y1(:) T(:) E(:) epsilon(:) T_dif(:)]); %#ok<NASGU>

% Creates unique file name for map data and saves it
map=char(strcat(upath,'/',savename,'/',regexprep(dir_content(i)...
    .name,'\.[^\.]*$', ''),'_map.txt'));
save(map,'xyz','-ASCII');

end

