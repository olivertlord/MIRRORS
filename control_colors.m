function [] = control_colors(flag,h)
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
% Inputs:

%   flag: a 12-element cell array where each element is either 0 or 1. The
%         first 6 elements control the color of pushbutton1-3, edit1, 
%         edit2, and pushbutton4 in that order. The next 6 elements control 
%         the enabled state in the same order. 0 = red or 'off', 1 = green 
%         or 'on'. 
% 
%   h:    a structure containing handles to the graphical elements in the 
%         GUI.

%--------------------------------------------------------------------------

% Creates array of figure handles
buttons = [h.pushbutton1 h.pushbutton2 h.pushbutton3 h.pushbutton4...
    h.pushbutton5 h.pushbutton6 h.pushbutton7 h.pushbutton8];

% Set background colour of graphical element in array h to red or green
% depending on flag value
for i = 1:8
    if flag{i} == 0
        set(buttons(i),'BackgroundColor',[.8 .8 0.8]); % grey
    else
        set(buttons(i),'BackgroundColor',[0 .8 0]); % green
    end
end

% Set enabled state of graphical element in array h to red or green
% depending on flag value
for i = 9:16
    if flag{i} == 0
        set(buttons(i-8),'Enable','off')
    else
        set(buttons(i-8),'Enable','on')
    end
end

end