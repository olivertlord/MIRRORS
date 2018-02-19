function [w,x,y,fi,fl,good_data,filenumber,upath,cal_a,cal_b,cal_c,...
    cal_d,nw,savename,writerObj,expname] = data_prep(handles)
%--------------------------------------------------------------------------
% Function DATA_PREP
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

% Calculate center and half-width of subframe
subframe = getappdata(0,'subframe');
w = round(subframe(3)/2);
x = round(subframe(1))+w-384;
y = round(subframe(2))+w;

% Get user inputted first and last files to be analysed    
fi = eval(get(handles.edit1,'string'));
fl = eval(get(handles.edit2,'string'));

% Gets list of positions of good data in the folder, filenumbers of those
% data and the path to the folder
good_data = getappdata(0,'good_data');
filenumber = getappdata(0,'filenumber');
upath = getappdata(0,'upath');

% Clear all axes
arrayfun(@cla,findall(0,'type','axes'))
fclose('all');

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

% Shifts quadrants based on offsets and pads by 4 pixels
cal_a=cal_a(y-w-4:y+w+4,x-w-4:x+w+4);
cal_b=cal_b(y-w+bya-4:y+w+bya+4,x-w+bxa-4:x+w+bxa+4);
cal_c=cal_c(y-w+cya-4:y+w+cya+4,x-w+cxa-4:x+w+cxa+4);
cal_d=cal_d(y-w+dya-4:y+w+dya+4,x-w+dxa-4:x+w+dxa+4);

%//////////////////////////////////////////////////////////////////////////
% HARDWARE SPECIFIC - REQUIRES EDITING
% Determines normalised wavelengths for the four filters
nw = horzcat(ones(324,1),[repmat((14384000/670.08),81,1);...
    repmat((14384000/752.97),81,1); repmat((14384000/851.32),81,1);
    repmat((14384000/578.61),81,1);]);
%//////////////////////////////////////////////////////////////////////////

% Create output directory
savename = strcat('IRiS_output_',regexprep(datestr(datetime),' |-|:','_'));
mkdir(upath,savename);

% Extract parent folder name
expname = strsplit(upath,{'/','\'});

% Open video file
videofile = char(strcat(upath,'/',savename,'/',expname(end),'_VIDEO.avi'));

% Sets up video recording of ouput screen
writerObj = VideoWriter(videofile);
writerObj.FrameRate = 2;
open(writerObj);

end

