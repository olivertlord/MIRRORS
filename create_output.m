function [savename, writerObj] = create_output(handles)
%--------------------------------------------------------------------------
% Function create_output
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
%  Performs a variety of data preparation tasks before fitting is executed,
%  in both live and post-processing mode.

%   Inputs:
% 
%       handles = data structure containing information on graphics
%                 elements within the GUI.

%   Outpute: savename  = unique folder name for output

%            writerObj = video writer object

%--------------------------------------------------------------------------
% Clear all axes
arrayfun(@cla,findall(0,'type','axes'))
fclose('all');

%--------------------------------------------------------------------------
% Load previous file path from .MAT file
u = matfile('unknown.mat','Writable',true);

%--------------------------------------------------------------------------
% Create output directory if Save Output checkbox is ticked
if get(handles.checkbox2,'Value') == 1
    
    % Create output folder
    savename = strcat('MIRRORS_output_',regexprep(string(datetime('now')),...
        ' |-|:','_'));

    mkdir(u.path,savename);
    
% Load specific variables from the calibration file
load('calibration.mat', 'cal', 'name');

% Load specific variables from the hardware parameters file
load('hardware_parameters.mat', 'wa', 'wb', 'wc', 'wd', 'sr_wa', 'sr_wb',...
     'sr_wc', 'sr_wd', 'pixel_width', 'system_mag', 'NA');

% Save only the loaded variables to the calibration file
save(strcat(u.path,'/',savename,'/','calibration.mat'),'cal','name');

% Save only the loaded variables to the hardware parameters file
save(strcat(u.path,'/',savename,'/','hardware_parameters.mat'),...
        'wa','wb','wc','wd','sr_wa','sr_wb','sr_wc','sr_wd',...
        'pixel_width','system_mag','NA');
else
    savename = [];
end

%--------------------------------------------------------------------------
% Sets up video recording of ouput screen
videofile = char(strcat(u.path,'/',savename,'/','VIDEO.avi'));
writerObj = VideoWriter(videofile);
writerObj.FrameRate = 1;
open(writerObj)
setappdata(0,'writerObj',writerObj);