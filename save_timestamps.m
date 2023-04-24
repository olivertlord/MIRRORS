function [timestamps] = save_timestamps(path, filenames,increment)
%--------------------------------------------------------------------------
% Function save_timestamps
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
% Saves timestamps to unknown.mat
% 
% Inputs:

%       path      = path to file

%       filenames = array of filenames to be stitched

%       increment = time in seconds to be added to each timestamp

% Outputs:
        
%       timestamps = cell array of timestamps

%--------------------------------------------------------------------------

timestamps = cell(1,length(filenames));
for i = 1:length(filenames)

    % Get the file's current modification time
    FileInfo = dir(fullfile(path,filenames{i}));
    fileTime = datetime(FileInfo.date, 'InputFormat',...
        'dd-MMM-yyyy HH:mm:ss');

    % Add the specified number of seconds to the file's timestamp if it is
    % the same as the previous
    if (i > 1) && (isequal(fileTime,timestamps{i-1}))
        newFileTime = fileTime + seconds(increment);
    else
        newFileTime = fileTime;
    end
    
    % Update the file's modification time to the new timestamp
    timestamps{i} = newFileTime;

end
end