function [] = control_colors(flag,handles)
%--------------------------------------------------------------------------
% Function CONTROL_COLORS
%--------------------------------------------------------------------------
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
%   Conrols colour and enabled state of buttons and edit boxes within the
%   GUI. Input is a 12 element cell array where each element is either 0 or
%   1. The first 6 elements control the colour of pushbutton1-3, edit1,
%   edit2 and pusbutton4 in that order. The next 6 elements control the
%   enabled state in the same order. 0 = red or 'off', 1 = green or 'on'.

% Store current flag values
setappdata(0,'flag',flag);

% Creates array of figure handles
h = [handles.pushbutton1 handles.pushbutton2 handles.pushbutton3...
    handles.edit1 handles.edit2 handles.pushbutton4];

% Set background colour of graphical element in array h to red or green
% depending on flag value
for i = 1:6
    if flag{i} == 0
        set(h(i),'BackgroundColor',[.8 .8 0.8]);
    else
        set(h(i),'BackgroundColor',[0 .8 0]);
    end
end

% Set enabled state of graphical element in array h to red or green
% depending on flag value
for i = 7:12
    if flag{i} == 0
        set(h(i-6),'Enable','off')
    else
        set(h(i-6),'Enable','on')
    end
end

% Turn PROCESS button green and enabled if pushbutton2, pushbutton3 and
% edit1 and edit2 are also green, i.e. if the user has completed all tasks
% necessary to run the post-processing routine
if (flag{2} == 1) && (flag{3} == 1) && (flag{4} == 1) && (flag{5} == 1)
    set(h(6),'Backgroundcolor',[0 .8 0]);
    set(h(6),'Enable','on');
end

end