function [w,x,y,fi,fl,good_data,filenumber,upath,cal_a,cal_b,cal_c,cal_d,nw,...
    dir_content,savename] = data_prep(handles)
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

% Opens and reads calibration file
cal = imread('calibration/tc.tiff');

% Returns spatially correlated calibration subframes
[cal_a,cal_b,cal_c,cal_d]= correlate(cal,x, y, w);

%//////////////////////////////////////////////////////////////////////////
% HARDWARE SPECIFIC - REQUIRES EDITING
% Determines normalised wavelengths for the four filters
nw = horzcat(ones(324,1),[repmat((14384000/752.97),81,1);...
    repmat((14384000/578.61),81,1); repmat((14384000/851.32),81,1);...
    repmat((14384000/670.08),81,1)]);
%//////////////////////////////////////////////////////////////////////////

% Get DIR_CONTENT from appdata
dir_content = getappdata(0,'dir_content');

% Create output directory
savename=strcat('IRiS_output_',regexprep(datestr(datetime),' |-|:','_'));
mkdir(upath,savename);

end

