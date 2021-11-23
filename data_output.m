function [timevector,elapsedSec] = data_output(handles,filename,c1,T_max,...
    E_T_max,C_max,E_E_max,T_dif_metric,T,E_T,epsilon,E_E,T_dif,mu,sb,savename)
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

% Load previous file path from .MAT file
unkmat = matfile('unkmat.mat','Writable',true);

%Get timestamp
dir_content = dir(strcat(unkmat.path,'/',filename));
timestamp = datenum(dir_content.date);

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
if get(handles.checkbox2,'Value') == 1        
    
    % On first pass
    if c1 == 1
        
        % Open summary file
        fid = fopen(char(strcat(unkmat.path,'/',savename,'/',...
            'SUMMARY.txt')),'w');
        
        % Write header to file
        fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n','filename',...
            'timestamp','elapsed time (s)','T (K)','error (K)',...
            'emissivity','error','difference');
        
        % Write header to workspace
        fprintf('%20s\t%15s\t%20s\t%10s\t%10s\t%10s\t%10s\t%10s\n','filename',...
            'timestamp','elapsed time (s)','T (K)','error (K)',...
            'emissivity','error','difference');
    end
    
    % re-open summary file
    fid = fopen(char(strcat(unkmat.path,'/',savename,'/',...
        'SUMMARY.txt')),'a');
    
    % Write summary data to file
    fprintf(fid,'\n%s\t%14d\t%5.0f\t%5.0f\t%5.0f\t%5.2f\t%5.2f\t%5.2f\n',filename,...
        timestamp,elapsedSec,T_max,E_T_max,C_max,E_E_max,T_dif_metric);
    
    % Write summary data to workspace
    fprintf('%20s\t%15d\t%20.0f\t%10.0f\t%10.0f\t%10.2f\t%10.2f\t%10.2f\n',filename,...
        timestamp,elapsedSec,T_max,E_T_max,C_max,E_E_max,T_dif_metric);
    
    % Generates data table containing all three maps
    [x1,y1] = meshgrid(1:length(T),1:length(T));
    [mux,muy] = meshgrid(mu,mu);
    
    % Concatenate output array
    xyz = real([x1(:) y1(:) mux(:) muy(:) sb(:) T(:) E_T(:) epsilon(:)...
        E_E(:) T_dif(:)]);

    % Creates file name for map data and saves it
    map_file=char(strcat(unkmat.path,'/',savename,'/',regexprep(filename,...
        '\.[^\.]*$', ''),'_map.txt'));
    save(map_file,'xyz','-ASCII');
    
end
    
end

