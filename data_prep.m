function [w,x,y,fi,fl,filenumber,upath,cal_a,cal_b,cal_c,...
    cal_d,savename,writerObj,expname] = data_prep(handles)
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

%            upath = path to working directory

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
upath = getappdata(0,'upath');


%--------------------------------------------------------------------------
% Clear all axes
arrayfun(@cla,findall(0,'type','axes'))
fclose('all');


%--------------------------------------------------------------------------
% Reads in unknown file and convert to double precision
cal_image = imread('calibration/tc.tiff');
cal = im2double(cal_image);

% Divides background subtracted image into four quadrants
cal_a = cal(1:size(cal,1)/2,1:size(cal,2)/2,:);
cal_b = cal(size(cal,1)/2+1:size(cal,1),1:size(cal,2)/2,:);
cal_c = cal(1:size(cal,1)/2,size(cal,2)/2+1:size(cal,2),:);
cal_d = cal(size(cal,1)/2+1:size(cal,1),size(cal,2)/2+1:size(cal,2),:);

% Wavelengths of each quadrant at Bristol
% a = top left (670 nm)
% b = top right (750 nm)
% c = bottom left (850 nm)
% d = bottom right (580 nm)

% Returns spatially correlated calibration subframes
[bya,bxa,cya,cxa,dya,dxa] = correlate(cal_a,cal_b,cal_c,cal_d);

% Shifts quadrants based on offsets and pads by 10 pixels
cal_a=cal_a(y-w-4:y+w+4,x-w-4:x+w+4);
cal_b=cal_b(y-w+bya-4:y+w+bya+4,x-w+bxa-4:x+w+bxa+4);
cal_c=cal_c(y-w+cya-4:y+w+cya+4,x-w+cxa-4:x+w+cxa+4);
cal_d=cal_d(y-w+dya-4:y+w+dya+4,x-w+dxa-4:x+w+dxa+4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEVELPOPER CODE - DO NOT EDIT BELOW THIS LINE ---------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% Update timestamps by reading and re-writing a single byte when processing
% example data

ex_dir=regexprep(upath,{'\.','\/','//'},{'','',''});

if ~isempty(strfind(ex_dir,'exampledata')) == 1
    
    % Get new directory content and determine listpos
    dir_content = dir('./example/data/example*');
    setappdata(0,'dir_content',dir_content)
    listpos = length(dir_content)-10:1:length(dir_content);
    setappdata(0,'listpos',listpos)

    % Update timestamps by reading and re-writing a single byte IF they are
    % equal
    if strcmp(dir_content(1).date,dir_content(2).date) == 0
        
        for i = 1:length(dir_content)
            current = dir_content(i).name;
            pause(1)
            fid = fopen(strcat('./example/data/',current),'r+');
            byte = fread(fid, 1);
            fseek(fid, 0, 'bof');
            fwrite(fid, byte);
            fclose(fid);
        end
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEVELPOPER CODE - DO NOT EDIT ABOVE THIS LINE ---------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% Create output directory if Save Output checkbox is ticked
if get(handles.checkbox2,'Value') == 1
    
    % Create output folder
    savename = strcat('MIRRORS_output_',regexprep(datestr(clock),...
        ' |-|:','_'));
    mkdir(upath,savename);
    setappdata(0,'savename',savename);
    
    % Extract parent folder name
    expname = strsplit(upath,{'/','\'});
    
    % Open video file
    videofile = char(strcat(upath,'/',savename,'/',expname(end),'_VIDEO.avi'));
    
    % Sets up video recording of ouput screen
    writerObj = VideoWriter(videofile);
    writerObj.FrameRate = 2;
    open(writerObj);
else
    [savename,expname,writerObj] = deal([]);
end
