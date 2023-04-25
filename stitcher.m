function stitched_filenames = stitcher(names,path,j)
%--------------------------------------------------------------------------
% Function DIVIDE
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
% Stitches four images into one based on alphabetical suffixes in file
% names. 
% 
% Wavelengths of each quadrant at Bristol
% a = top left (670 nm)
% b = top right (750 nm)
% c = bottom left (850 nm)
% d = bottom right (580 nm)
% 
% Inputs:

%       names = array of filenames to be stitched

%       path  = path to location of files to be stitched

%       j     = file counter in live mode

% Outputs:

%       stitched_filenames = cell array of filenames of stitched images

%       timestamps         = cell array of timestamps

%--------------------------------------------------------------------------

% Load .MAT files
[u,~,~] = initialise_mode('true');

% Determine indices within selected file list to each quadrant
a_idx = find(contains(names,'_a'));
b_idx = find(contains(names,'_b'));
c_idx = find(contains(names,'_c'));
d_idx = find(contains(names,'_d'));

% Read in, stitch and read out each set of four images
stitched_filenames = cell(1,length(a_idx));
for i=1:length(a_idx)
    tl = imread(char(strcat(path,'/',names(:,a_idx(i)))));
    bl = imread(char(strcat(path,'/',names(:,b_idx(i)))));
    tr = imread(char(strcat(path,'/',names(:,c_idx(i)))));
    br = imread(char(strcat(path,'/',names(:,d_idx(i)))));

    top_row = horzcat(tl,tr);
    bottom_row = horzcat(bl,br);

    full_image = vertcat(top_row,bottom_row);
    
    stitched_filenames{i} = strrep(names{:,a_idx(i)},'_a','');

    imwrite(full_image,strcat(path,'/',stitched_filenames{i}));
    
    % Select whether single file or array of files is being processed
    if j == 1
        pos = i;
    else
        pos = j;
    end
    
    % Update timestamps of new files based on timestamps of files being
    % stitched
    tmp = u.timestamps;
    if ~isequal(u.mode,'test')
        tmp(:,pos) = save_timestamps(path,names(:,a_idx(i)),1);
    else
        tmp(:,pos) = save_timestamps(path,names(:,a_idx(i)),0);
    end
    u.timestamps = tmp;
end