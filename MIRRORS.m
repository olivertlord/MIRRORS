function varargout = MIRRORS(varargin)
%--------------------------------------------------------------------------
% MIRRORS (MultIspectRal imaging RadiOmetRy Software)
%--------------------------------------------------------------------------
% Version 1.7.9 Written and tested on Matlab R2014a (Windows 7) & R2017a
% (OS X 10.13)

% Copyright 2018 Oliver Lord, Weiwei Wang email: oliver.lord@bristol.ac.uk
 
% This file is part of MIRRORS.
 
% MIRRORS is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.
 
% MIRRORS is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
% more details.
 
% You should have received a copy of the GNU General Public License along
% with MIRRORS.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
%MIRRORS M-file for MIRRORS.fig
%      MIRRORS, by itself, creates a new MIRRORS or raises the existing
%      singleton*.
%
%      H = MIRRORS returns the handle to a new MIRRORS or the handle to the
%      existing singleton*.
%
%      MIRRORS('Property','Value',...) creates a new MIRRORS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to MIRRORS_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MIRRORS('CALLBACK') and MIRRORS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MIRRORS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%      hObject    handle to checkbox1 (see GCBO) eventdata  reserved - to
%      be defined in a future version of MATLAB handles    structure with
%      handles and user data (see GUIDATA)

%      handles    structure with handles and user data (see GUIDATA)
%      varargin   unrecognized PropertyName/PropertyValue pairs from the
%           command line (see VARARGIN)
%      varargout  cell array for returning output args (see VARARGOUT);

%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MIRRORS

% Last Modified by GUIDE v2.5 20-Apr-2023 11:08:59


%--------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MIRRORS_OpeningFcn, ...
                   'gui_OutputFcn',  @MIRRORS_OutputFcn, ...
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

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~) 

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~) 

if isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, ~, ~) 

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
% --- Executes just before MIRRORS is made visible.
function MIRRORS_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for MIRRORS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Make Update Test Data button invisible
set(handles.pushbutton7,'visible','off')

% Creates array of handles to axes within the GUI
plots = [handles.axes2 handles.axes3 handles.axes4 handles.axes5...
    handles.axes6 handles.axes7];

% VERSION NUMBER
set(handles.text17,'String','1.8.0');

% Write current calibration file to GUI window
load('calibration.mat','name');
set(handles.text20,'String',name);

% Sets aspect ratio for all axes within the GUI to 1:1
for i=1:6
   axes(plots(i)); %#ok<LAXES>
   pbaspect([1 1 1])
end

% Forces GUI to screen centre at start-up
movegui(gcf,'center');

% Initialise button colors and enabled state
flag = {0 0 0 0 0 0 1 0    1 1 0 0 1 1 1 1};
control_colors(flag, handles);

% Suppress non integer index and complex number warnings
warning('off','MATLAB:colon:nonIntegerIndex');
warning('off','MATLAB:plot:IgnoreImaginaryXYPart');

% Load matfiles, clear axes
[u,~,~] = initialise_mode(true);

% Ensure test mode is disabled
u.mode = 'op';

%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = MIRRORS_OutputFcn(~, ~, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
% UNUSED CALLBACK FUNCTIONS

% --- Executes on button press in Fit saturated images chackbox.
function checkbox1_Callback(~, ~, ~) 

% --- Executes on button press in checkbox2.
function checkbox2_Callback(~, ~, handles) %#ok<INUSD>

% --- Executes on button press in checkbox3.
function checkbox3_Callback(~, ~, ~)

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(~, ~, handles) %#ok<INUSD>


%--------------------------------------------------------------------------
% --- Executes when user presses LIVE button
function pushbutton1_Callback(~, ~, handles) 

% If user clicks live mode button while in live mode, reset
if isequal(get(handles.pushbutton1,'BackgroundColor'),[0 .8 0])
    
    if get(handles.checkbox2,'Value') == 1
        
        % Closes video file on when reinitialising live mode
        writerObj = getappdata(0,'writerObj');
        close(writerObj);
    end

end

% Switch on and disable saturated / blank checkboxes
set(handles.checkbox1,'Value',1)
set(handles.checkbox1,'Enable','off')
set(handles.checkbox3,'Value',1)
set(handles.checkbox3,'Enable','off')

% Load matfiles, clear axes
[u,c,hp] = initialise_mode(true);
u.timestamps = {[]};

% Update button states
flag = {1 0 0 0 0 0 0 0    1 1 0 0 1 1 1 1};
control_colors(flag, handles);

% Ask user to point to folder containing .TIF files to be processed
test_dir = uigetdir(u.path,'Select Image(s)');

% Test for valid directory, else return
if isequal(test_dir,0)
    
    % Update button states
    flag = {0 0 0 0 0 0 1 0    1 1 0 0 1 1 1 1};
    control_colors(flag, handles);
    return
end
u.path = test_dir;

% Prepares data output
[savename, writerObj] = create_output(handles);

% Set string of text5 to current folder path
set(handles.text5,'string',u.path);

% Collect list of current .TIFF files
dir_content = dir(strcat(u.path,'/*.tif*'));
initial_list = {dir_content.name};

% Initialise progress bar
ttwb = tooltipwaitbar(handles.text25, 0, 'Starting...', false, true);

% Initialise arrays
[elapsedSec,T_max,E_T_max,T_diff_metric] = deal([]);

% Initialise counter c1
c1 = 1;

while isequal(get(handles.pushbutton1,'BackgroundColor'),[0 .8 0])
    
    % Collects new list of filenames
    pause(1);
    dir_content = dir(strcat(u.path,'/*.tif*'));
    new_list = {dir_content.name};
    assignin('base','new_list',new_list)
  
    % Executes when new files appear: 1-camera mode
    if (length(new_list) > length(initial_list)) && (~isequal(get...
            (handles.pushbutton10,'BackgroundColor'), [0 .8 0]))

        % Update timestamps
        tmp = u.timestamps;
        if ~isequal(u.mode,'test')
            tmp(:,c1) = save_timestamps(u.path,new_list(end),1);
        else
            tmp(:,c1) = save_timestamps(u.path,new_list(end),0);
        end
        u.timestamps = tmp;

        % Perform fit
        [elapsedSec,T_max,E_T_max,T_diff_metric] =...
            fit(dir_content(end).name,u.path,1,u,c,hp,c1,handles,...
            savename,writerObj,elapsedSec,T_max,E_T_max,T_diff_metric,ttwb);

        % Increment counter c1
        c1 = c1 + 1;

        % Update list of exisiting files
        initial_list = new_list;

    end
    
    % Executes when new files appear: 4-camera mode
    if (length(new_list)-length(initial_list) >= 4) && (isequal(get...
            (handles.pushbutton10,'BackgroundColor'), [0 .8 0]))

        % Stitch four images into single image
        dir_content(end).name = stitcher...
            ({dir_content(end-3:end).name},u.path,c1);

        % Perform fit
        [elapsedSec,T_max,E_T_max,T_diff_metric] = ...
            fit(dir_content(end).name,u.path,1,u,c,hp,c1,handles,...
            savename,writerObj,elapsedSec,T_max,E_T_max,T_diff_metric,ttwb);

        % Increment counter c1
        c1 = c1 + 1;

        % Update list of exisiting files
        dir_content = dir(strcat(u.path,'/*.tif*'));
        new_list = {dir_content.name};
        initial_list = new_list;

    end

end


%--------------------------------------------------------------------------
% --- Executes on press of POST PROCESS button
function pushbutton2_Callback(~, ~, handles) 

% Clear all axes within GUI
arrayfun(@cla,findall(0,'type','axes'))
fclose('all');

% Re-enable saturated / blank checkboxes
set(handles.checkbox1,'Enable','on')
set(handles.checkbox3,'Enable','on')

% Load matfiles, clear axes
[u,~,~] = initialise_mode(false);

% Update button states
flag = {0 1 0 0 0 0 0 0    0 0 0 0 1 1 1 1};
control_colors(flag, handles);

% Promts user to select unknown file(s), unless in test mode
if ~isequal(u.mode,'test')
    [u.names,test_dir] = uigetfile(strcat(u.path,'/*.tif*'),...
        'Select Image(s)','Multiselect','on');

    % Test for valid directory, else return
    if isequal(test_dir,0)
        
        % Update button states
        flag = {0 0 0 0 0 0 1 0    1 1 0 0 1 1 1 1};
        control_colors(flag, handles);
        return
    end
    u.path = test_dir;

    % Convert to 1x1 cell array if single file selected
    if ~isa(u.names,"cell")
        u.names = {u.names};
    end

    % Save timestamps to unknown.mat
    u.timestamps = save_timestamps(u.path,u.names,0);
end

% If user chooses a four camera system
if isequal(get(handles.pushbutton10,'BackgroundColor'),[0 .8 0])
    u.names = stitcher(u.names,u.path,1);
end

% Set string of text5 to current folder path
set(handles.text5,'string',u.path);

% Creates list of .TIF files to be fitted
for i=1:length(u.names)

    % Extract filename from cell array
    filename = get_path(u.names,u.path,i);
       
    % Reads in unknown file and determines bit dpeth
    raw=imread(char(strcat(u.path,'/',(filename))));

    % Save correlation parmameters to unknown.mat file
    if i == 1
        u.unk = raw;
        [u.u_bya, u.u_bxa, u.u_cya, u.u_cxa, u.u_dya, u.u_dxa] =...
            correlate(raw);
    end
    
    % Determines background intensity
    u.background = background(raw);

    data_plot(handles,[0 1],[NaN NaN],[NaN NaN],[NaN NaN],NaN,...
             NaN,NaN,i,filename,raw,0,[0 1],NaN,[1 2],1,1,[0 1],0,...
             [-1,1],[0 1],[1 2],1,[NaN,NaN],0)
end

% Update button states
flag = {0 1 0 0 0 0 0 0   1 1 1 0 1 1 1 1};
control_colors(flag, handles);


%--------------------------------------------------------------------------
% --- Executes on press of SELECT ROI button
function pushbutton3_Callback(~, ~, handles) 

% Update button states
flag = {0 1 0 0 0 0 0 0   0 0 0 0 0 0 0 0};
control_colors(flag, handles);

% Deletes fixed ROI if one already exists
hfindrect = findobj(handles.axes1,'Tag','redROI');
delete(hfindrect)

% Load matfiles, clear axes
[u,~,hp] = initialise_mode(false);

% Determine ROI parameters
[area_x_tl,area_y_tl,area_width_x,area_width_y,ROI_x_tl,...
    ROI_y_tl, ROI_width] = calculate_ROI(u,hp);

% Creates resizeable ROI
r = drawrectangle(handles.axes1,'Label','DOUBLE CLICK WHEN FINISHED',...
    'Color',[1 0 0],'Position',[ROI_x_tl ROI_y_tl ROI_width, ROI_width],...
    'DrawingArea',[area_x_tl area_y_tl area_width_x area_width_y],...
    'Tag','redROI');

% Listen for mouse clicks on the ROI unless test mode enabled
if ~isequal(u.mode,'test')
    u.ROI = customWait(r);
end

% Update button states
flag = {0 1 1 1 0 0 0 0   1 1 1 1 1 1 1 1};
control_colors(flag, handles);


%--------------------------------------------------------------------------
% --- Executes when user presses PROCESS button
function pushbutton4_Callback(~, ~, handles) 

% Load matfiles, clear axes
[unk,cal,hp] = initialise_mode(true);

% Prepares data output
[savename, writerObj] = create_output(handles);

% Initialise c1
c1 = 1;

% Initialise progress bar
ttwb = tooltipwaitbar(handles.text25, 0, 'Starting...', false, true);

% Initialise arrays
[elapsedSec,T_max,E_T_max,T_diff_metric] = deal([]);

% Get state of checkbox one: 1 if user wants to attempt to fit saturated
% images
if isequal(get(handles.checkbox1,'value'),1)
    saturate = 1;
else
    saturate = 0.98;
end

% Get state of checkbox three: 1 if user wants to attempt to fit blank
% images
if isequal(get(handles.checkbox3,'value'),1)
    blank = 0;
else
    blank = 2*unk.background;
end

% Calculates temperature, error and difference maps and associated output
% for each file and plots and stores the results.
for i=1:length(unk.names)
    
    % Reads in unknown file and determines bit dpeth
    [~, filepath] = get_path(unk.names,unk.path,i);
    raw=imread(filepath);
    raw_metadata = imfinfo(filepath);
    [a,b,c,d] = divide(raw);
    
    if (max(raw(:)) <= saturate*(2^raw_metadata.BitDepth)) &&...
        (min(max([d(:) a(:) c(:) b(:)])) > blank)

        % Perform fit
        [elapsedSec,T_max,E_T_max,T_diff_metric] = fit(unk.names,unk.path,...
            i,unk,cal,hp,c1,handles,savename,writerObj,elapsedSec,T_max,...
            E_T_max,T_diff_metric,ttwb);
        
        % Increment counter c1
        c1 = c1 + 1;
    end
end

% Closes video file on loop exit
if get(handles.checkbox2,'Value') == 1
    close(writerObj);
end


%--------------------------------------------------------------------------
% --- Executes on slider movement.
function slider1_Callback(~, ~, handles) 

% Get current slider value
slider_val = get(handles.slider1,'Value')*100;

%Set textbox to current slider value
set(handles.text12,'String',strcat(num2str(round(slider_val)),{' '},'%'));


%--------------------------------------------------------------------------
% --- Executes when user clisks on the Update Calibration Image button
function pushbutton5_Callback(~, ~, handles) 

% Update button states
flag = {0 1 0 0 0 0 0 0   1 1 1 0 1 1 1 1};
control_colors(flag, handles);

% Load matfiles, clear axes
[~,c,~] = initialise_mode(false);

% Promts user to select calibration file
[names,test_dir] = uigetfile(strcat(c.path,'/*.tif*'),...
    'Select new Calibration Image','Multiselect','on');

% Check for valid directory
if isequal(test_dir,0)
    return
end
c.path = test_dir;

% Convert to 1x1 cell array if single file selected
if ~isa(names,"cell")
    names = {names};
end

% Determine if 1 or 4 calibration images have been selected
if (length(names) ~= 1) && (length(names) ~= 4)
    msgbox('Please select either 1 or 4 images','Error');
else
    if length(names) == 4
        c.name = stitcher(names,c.path,1);
    else
        c.name = names;
    end

% Read in data and convert to double
cal_image = imread(strcat(c.path,char(c.name)));
c.cal = im2double(cal_image);

% Returns spatial correlation parameters for the calibration file
[c.c_bya, c.c_bxa, c.c_cya, c.c_cxa, c.c_dya, c.c_dxa] =...
    correlate(c.cal);

% Write current calibration name to GUI
set(handles.text20,'String',c.name);

end


%--------------------------------------------------------------------------
% --- Executes when user clicks on the Update Hardware Parameters button
function pushbutton6_Callback(~, ~, ~) 
hardware_parameters

%--------------------------------------------------------------------------
% --- Executes when RUN TEST button is pushed
function pushbutton8_Callback(~, ~, handles) 

% Load previous file path from .MAT file
[u,~,~] = initialise_mode('true');

% Ask user to select folder containing example data
u.path = uigetdir(u.path,'Select folder containing example data');

% Run test_fit function
test(u.path,'test_data',handles)


%--------------------------------------------------------------------------
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(~, ~, handles)

% Update button states
if isequal(get(handles.pushbutton9,'BackgroundColor'),[.8 .8 .8])
    set(handles.pushbutton9,'BackgroundColor', [0 .8 0])
    set(handles.pushbutton10,'BackgroundColor', [.8 .8 .8])  

    % Update button states
    flag = {0 0 0 0 0 0 1 0    1 1 0 0 1 1 1 1};
    control_colors(flag, handles);
end


%--------------------------------------------------------------------------
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(~, ~, handles)

% Update button states
if isequal(get(handles.pushbutton10,'BackgroundColor'),[.8 .8 .8])
    set(handles.pushbutton10,'BackgroundColor', [0 .8 0])
    set(handles.pushbutton9,'BackgroundColor', [.8 .8 .8])

    % Update button states
    flag = {0 0 0 0 0 0 1 0    1 1 0 0 1 1 1 1};
    control_colors(flag, handles);
end


%--------------------------------------------------------------------------
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(~, ~, handles)

% Update button states
if isequal(get(handles.pushbutton14,'BackgroundColor'),[.8 .8 .8])
    set(handles.pushbutton14,'BackgroundColor', [0 .8 0])
    set(handles.pushbutton15,'BackgroundColor', [.8 .8 .8])  
end


%--------------------------------------------------------------------------
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(~, ~, handles)

% Update button states
if isequal(get(handles.pushbutton15,'BackgroundColor'),[.8 .8 .8])
    set(handles.pushbutton15,'BackgroundColor', [0 .8 0])
    set(handles.pushbutton14,'BackgroundColor', [.8 .8 .8])  
end
