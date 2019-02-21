function varargout = hardware_parameters(varargin)
%--------------------------------------------------------------------------
% hardware_parameters (GUI)
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
%HARDWARE_PARAMETERS MATLAB code file for hardware_parameters.fig
%      HARDWARE_PARAMETERS, by itself, creates a new HARDWARE_PARAMETERS or
%      raises the existing singleton*.
%
%      H = HARDWARE_PARAMETERS returns the handle to a new
%      HARDWARE_PARAMETERS or the handle to the existing singleton*.
%
%      HARDWARE_PARAMETERS('Property','Value',...) creates a new
%      HARDWARE_PARAMETERS using the given property value pairs.
%      Unrecognized properties are passed via varargin to
%      hardware_parameters_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      HARDWARE_PARAMETERS('CALLBACK') and
%      HARDWARE_PARAMETERS('CALLBACK',hObject,...) call the local function
%      named CALLBACK in HARDWARE_PARAMETERS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hardware_parameters

% Last Modified by GUIDE v2.5 17-Oct-2018 14:53:36

%--------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hardware_parameters_OpeningFcn, ...
                   'gui_OutputFcn',  @hardware_parameters_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
% --- Executes just before hardware_parameters is made visible.
function hardware_parameters_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for hardware_parameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Load current hardware_parameters
m = matfile('hardware_parameters.mat','Writable',true);

set(handles.edit1, 'String', num2str(m.wa));
set(handles.edit2, 'String', num2str(m.wb));
set(handles.edit3, 'String', num2str(m.wc));
set(handles.edit4, 'String', num2str(m.wd));
 
set(handles.edit5, 'String', num2str(m.sr_wa));
set(handles.edit6, 'String', num2str(m.sr_wb));
set(handles.edit7, 'String', num2str(m.sr_wc));
set(handles.edit8, 'String', num2str(m.sr_wd));
 
set(handles.edit9, 'String', num2str(m.pixel_width));
 
set(handles.edit10, 'String', num2str(m.system_mag));
 
set(handles.edit11, 'String', num2str(m.NA));

%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = hardware_parameters_OutputFcn(~, ~, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
function edit1_Callback(~, ~, handles)
box = handles.edit1;
check_numeric(box)

%--------------------------------------------------------------------------
function edit2_Callback(~, ~, handles)
box = handles.edit2;
check_numeric(box)

%--------------------------------------------------------------------------
function edit3_Callback(~, ~, handles)
box = handles.edit3;
check_numeric(box)

%--------------------------------------------------------------------------
function edit4_Callback(~, ~, handles)
box = handles.edit4;
check_numeric(box)

%--------------------------------------------------------------------------
function edit5_Callback(~, ~, handles)
box = handles.edit5;
check_numeric(box)

%--------------------------------------------------------------------------
function edit6_Callback(~, ~, handles)
box = handles.edit6;
check_numeric(box)

%--------------------------------------------------------------------------
function edit7_Callback(~, ~, handles)
box = handles.edit7;
check_numeric(box)

%--------------------------------------------------------------------------
function edit8_Callback(~, ~, handles)
box = handles.edit8;
check_numeric(box)

%--------------------------------------------------------------------------
function edit9_Callback(~, ~, handles)
box = handles.edit9;
check_numeric(box)

%--------------------------------------------------------------------------
function edit10_Callback(~, ~, handles)
box = handles.edit10;
check_numeric(box)

%--------------------------------------------------------------------------
function edit11_Callback(~, ~, handles)
box = handles.edit11;
check_numeric(box)

%--------------------------------------------------------------------------
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(~, ~, handles)

m = matfile('hardware_parameters.mat','Writable',true);

m.wa = eval(get(handles.edit1,'String'));
m.wb = eval(get(handles.edit2,'String'));
m.wc = eval(get(handles.edit3,'String'));
m.wd = eval(get(handles.edit4,'String'));

m.sr_wa = eval(get(handles.edit5,'String'));
m.sr_wb = eval(get(handles.edit6,'String'));
m.sr_wc = eval(get(handles.edit7,'String'));
m.sr_wd = eval(get(handles.edit8,'String'));

m.pixel_width = eval(get(handles.edit9,'String'));

m.system_mag = eval(get(handles.edit10,'String'));

m.NA = eval(get(handles.edit11,'String'));

close

%--------------------------------------------------------------------------
% --- Checks that entered data is numerical
function check_numeric(box)
str=get(box,'String');
if isempty(str2num(str))
    set(box,'string','0');
    warndlg('Input must be numerical');
end