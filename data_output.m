function result = data_output(dir_content,i,c1,T_max,E_max,T_dif_metric,...
    T,E,epsilon,T_dif,upath,savename,filename)
%--------------------------------------------------------------------------
% Function DATA_OUTPUT
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
%   Detailed description goes here

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
elapsedSec = round(timeSec_0-timeSec);

% Concatenate output array
result = [acq,timestamp,elapsedSec,T_max,E_max,T_dif_metric];

% Generates data table containing all three maps
[x1,y1] = meshgrid(1:length(T),1:length(T));

xyz = [x1(:) y1(:) T(:) E(:) epsilon(:) T_dif(:)];

% Creates unique file name for map data and saves it
map=char(strcat(upath,'/',savename,'/',regexprep(filename,...
    '\.[^\.]*$', ''),'_map.txt'));
save(map,'xyz','-ASCII');

end

