function [w,x,y,fi,fl,filenumber,savename,writerObj,expname]...
    = data_prep(handles)
%--------------------------------------------------------------------------
% Function DATA_PREP
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
%  Performs a variety of data preparation tasks before fitting is executed,
%  in both live and post-processing mode.

%   INPUTS: handles = data structure containing information on graphics
%           elements within the GUI.

%   OUTPUTS: w,x,y = half-width and center position of subframe

%            fi,fl = start and end file numbers (user defined)

%            filenumber = list of filenumbers extrcated from filenames in
%            working directory

%            lastpath.lastpath = path to working directory

%            cal_a,calb,cal_c,cal_d = spatially correlated thermal
%            calibration subframes

%            savename = unique folder name for output

%            writerObj = videofile object opened for recording GUI output
%            as movie frames

%            expname = the name of the folder containing the users data;
%            the program assumes this is the name of the experiment and
%            uses it to construct filenames for output.


%--------------------------------------------------------------------------
% Calculate center and half-width of subframe
subframe = getappdata(0,'subframe');
w = 2*floor((subframe(3)/2)/2)+1;
x = round(subframe(1))+w;
y = round(subframe(2))+w;

%--------------------------------------------------------------------------
% Get user inputted first and last files to be analysed    
fi = eval(get(handles.edit1,'string'));
fl = eval(get(handles.edit2,'string'));

%--------------------------------------------------------------------------
% Gets list of positions of good data in the folder, filenumbers of those
% data and the path to the folder
filenumber = getappdata(0,'filenumber');

%--------------------------------------------------------------------------
% Clear all axes
arrayfun(@cla,findall(0,'type','axes'))
fclose('all');

%--------------------------------------------------------------------------
% Load previous file path from .MAT file
lastpath = matfile('lastpath.mat','Writable',true);

%--------------------------------------------------------------------------
% Create output directory if Save Output checkbox is ticked
if get(handles.checkbox2,'Value') == 1
    
    % Create output folder
    savename = strcat('MIRRORS_output_',regexprep(datestr(clock),...
        ' |-|:','_'));
    mkdir(lastpath.lastpath,savename);

    setappdata(0,'savename',savename);
    
    % Extract parent folder name
    expname = strsplit(lastpath.lastpath,{'/','\'});
    
    load('calibration.mat');
    load('hardware_parameters.mat');
    
    save(strcat(lastpath.lastpath,'/',savename,'/','calibration.mat'),'cal','name');
    save(strcat(lastpath.lastpath,'/',savename,'/','hardware_parameters.mat'),...
        'wa','wb','wc','wd','sr_wa','sr_wb','sr_wc','sr_wd',...
        'pixel_width','system_mag','NA');
    
    % Open video file
    videofile = char(strcat(lastpath.lastpath,'/',savename,'/',expname(end),'_VIDEO.avi'));
    
    % Sets up video recording of ouput screen
    writerObj = VideoWriter(videofile);
    writerObj.FrameRate = 2;
    open(writerObj);
else
    [savename,expname,writerObj] = deal([]);
end
