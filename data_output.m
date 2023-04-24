function [timestamp,eS] = data_output(handles,filename,c1,T_max,...
    E_T_max,C_max,E_E_max,T_dif_metric,T,E_T,E,E_E,T_dif,mu_x,...
    mu_y,sb,savename)
%--------------------------------------------------------------------------
% Function DATA_OUTPUT
%--------------------------------------------------------------------------
% Version 1.6 Written and tested on Matlab R2014a (Windows 7) & R2017a (OS
% X 10.13)

% Copyright 2018 Oliver Lord, Weiwei Wang email: oliver.lord@bristol.ac.uk
 
% This file is part of MIRRORS.
 
% MIRRORS is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.
 
% MIRRORS is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
% more details.
 
% You should have received a copy of the GNU General Public License along
% with MIRRORS.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
% Computes timestamps and creates summary datat array 'result'. Saves map
% data into a text file for every unknown file

% Inputs:
%   
%       handles: a structure containing handles to objects in the GUI.
%       
%       filename: a string containing the name of the file to process.
%       
%       c1: a flag indicating whether this is the first file to be
%           processed.
%       
%       T_max: a scalar containing the peak temperature.
% 
%       E_T_max: a scalar containing the error associated with the peak
%                temperature.
% 
%       C_max: a scalar containing the emissivity.
% 
%       E_E_max: a scalar containing the error associated with the
%                emissivity.
% 
%       T_dif_metric: a scalar containing the average of the difference
%                     map.
% 
%       T: a matrix containing the computed temperature map.
% 
%       E_T: a matrix containing the computed error map.
% 
%       E: a matrix containing the computed emissivity map.
% 
%       E_E: a matrix containing the computed error map for the emissivity.
% 
%       T_dif: a matrix containing the computed difference map.
% 
%       mu_x: a vector containing the x-coordinates of the pixels.
% 
%       mu_y: a vector containing the y-coordinates of the pixels.
% 
%       sb: a vector containing the computed Stefan-Boltzmann values.
% 
%       savename: a string containing the name of the output folder.

% Outputs:
% 
%       timevector: a vector containing the timestamp of the processed
%                   file.
% 
%       elapsedSec: a scalar containing the number of elapsed seconds since
%                   the processing of the first file.
% 
%       T_max: a scalar containing the peak temperature.
% 
%       E_T_max: a scalar containing the error associated with the peak
%                temperature.
% 
%       T_dif_metric: a scalar containing the average of the difference
%                     map.
%--------------------------------------------------------------------------

% Load previous file path from .MAT file
[u,~,~] = initialise_mode('false');

% Get current timestamp and convert to seconds
tmp = u.timestamps;
timestamp = tmp(:,c1);
timevector = datevec(timestamp{1});
timeSec = (timevector(1,6) + (timevector(1,5)*60)...
    + (timevector(1,4)*60*60));

% Get initial timestamp and convert to seconds
timestamp_0 = tmp(:,1);
timevector_0 = datevec(timestamp_0{1});
timeSec_0 = (timevector_0(1,6) + (timevector_0(1,5)*60)...
    + (timevector_0(1,4)*60*60));

% Convert to elapsed seconds
eS = round(timeSec-timeSec_0);

%--------------------------------------------------------------------------
if get(handles.checkbox2,'Value') == 1        
    
    % On first pass
    if c1 == 1
        
        % Open summary file
        fid = fopen(char(strcat(u.path,'/',savename,'/',...
            'SUMMARY.txt')),'w');
        
        % Write header to file
        fprintf(fid,'%8s\t%9s\t%20s\t%10s\t%10s\t%10s\t%10s\t%10s\n',...
            'filename','timestamp','elapsed time (s)','T (K)',...
            'error (K)','emissivity','error','difference');
        
        % Write header to workspace
        fprintf('%8s\t%9s\t%24s\t%10s\t%10s\t%10s\t%10s\t%10s\n',...
            'filename','timestamp','elapsed time (s)','T (K)',...
            'error (K)','emissivity','error','difference')
    end
    
    % re-open summary file
    fid = fopen(char(strcat(u.path,'/',savename,'/',...
        'SUMMARY.txt')),'a');
    
    % Write summary data to file
    fprintf(fid,...
        '%2s\t%10s\t%5.0f\t%25.0f\t%3.0f\t%13.2f\t%17.2f\t%3.2f\n',...
        filename,timestamp{1},eS,T_max,E_T_max,C_max,E_E_max,...
        T_dif_metric);
    
    % Write summary data to workspace
    fprintf('%10s\t%10s\t%5.0f\t%25.0f\t%3.0f\t%13.2f\t%17.2f\t%3.2f\n',...
        filename(1:15),timestamp{1},eS,T_max,E_T_max,C_max,E_E_max,...
        T_dif_metric);
    
    % Generates data table containing all three maps
    [x1,y1] = meshgrid(1:size(T,1),1:size(T,2));
    [mux,muy] = meshgrid(mu_x,mu_y);
    
    % Concatenate output array
    xyz = real([x1(:) y1(:) mux(:) muy(:) sb(:) T(:) E_T(:) E(:)...
        E_E(:) T_dif(:)]);

    % Creates file name for map data and saves it
    map_file=char(strcat(u.path,'/',savename,'/',regexprep(filename,...
        '\.[^\.]*$', ''),'_map.txt'));
    save(map_file,'xyz','-ASCII');
    
end
    
end