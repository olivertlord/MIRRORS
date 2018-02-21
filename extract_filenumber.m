function [filenumber] = extract_filenumber(filename)
%--------------------------------------------------------------------------
% Function EXTRACT_FILENUMBER
%--------------------------------------------------------------------------
% Version 1.6
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
%   Extracts filenumbers from filenames.Assumes that the last characters
%   before the file extension will be a group of digits defining a sequence
%   number.

%   INPUTS: filename = current filename

%   OUTPUTS: filenumber = sequential file number

%--------------------------------------------------------------------------
% Removes extension from the filename
filename = regexprep(filename, '\.[^\.]*$', '');

% Compute length of filename
n = length(filename);

% Initialise counter
c1 = 1;

% For each element in filename, starting with the last
for i = n:-1:1
    
    % If it is a digit, add it to filenumber
    if isstrprop(filename(i),'digit') == 1
        filenumber(c1) = filename(i);
        
    % As soon as a non numeric character is detected break the loop
    else
        break
    end

% Increment counter
c1 = c1 + 1;

end

% Flip the number and convert it from a string to a number
filenumber=str2double(fliplr(filenumber));