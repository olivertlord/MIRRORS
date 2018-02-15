function varargout = IRS(varargin)
%--------------------------------------------------------------------------
% IRiS (Imaging Radiometry Software)
%--------------------------------------------------------------------------
% Version 1.5
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
%IRS M-file for IRS.fig
%      IRS, by itself, creates a new IRS or raises the existing
%      singleton*.
%
%      H = IRS returns the handle to a new IRS or the handle to
%      the existing singleton*.
%
%      IRS('Property','Value',...) creates a new IRS using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to IRS_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      IRS('CALLBACK') and IRS('CALLBACK',hObject,...) call the
%      local function named CALLBACK in IRS.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IRS

% Last Modified by GUIDE v2.5 13-Feb-2018 12:53:47


%--------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IRS_OpeningFcn, ...
                   'gui_OutputFcn',  @IRS_OutputFcn, ...
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


%--------------------------------------------------------------------------
% --- Executes just before IRS is made visible.
function IRS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for IRS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Creates array of handles to axes within the GUI
plots = [handles.axes2 handles.axes3 handles.axes4 handles.axes5...
    handles.axes6 handles.axes7];

% Sets aspect ratio for all axes within the GUI to 1:1
for i=1:6
   axes(plots(i));
   pbaspect([1 1 1])
end

% Initialises auto mode system flag and intitial filname
auto_flag = 0;
auto_filename = ('blank');

% Makes auto mode system flag and intitial filname available to all
% functions within the GUI
setappdata(0,'auto_flag',auto_flag);
setappdata(0,'auto_filename',auto_filename);

% Forces GUI to screen centre at start-up 
movegui(gcf,'center');

% Initialise button colors and enabled state
flag = {0 0 0 0 0 0 1 1 0 0 0 0};
control_colors(flag,handles);


%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = IRS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
% --- Executes on press of POST PROCESS button
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear all axes within GUI
arrayfun(@cla,findall(0,'type','axes'))
fclose('all');

% Reset textboxes to 0
set(handles.edit1,'String','0')
set(handles.edit2,'String','0')

% Update button states
flag = {0 0 0 0 0 0 1 1 0 0 0 0};
control_colors(flag, handles)

% Deletes ROI if one already exists
hfindROI = findobj(gca,'Type','hggroup');    
delete(hfindROI)

% Ask user to point to folder containing .TIF files to be processed
[upath]=uigetdir('/Users/oliverlord/Dropbox/Work/EXPERIMENTS/');

% Create array containing file metadata on all .TIF files in folder
dir_content = dir(strcat(upath,'/*.tiff'));
setappdata(0,'dir_content',dir_content);

% Determine number of .TIF files in folder
total=size(dir_content,1);

% Set string of text5 to current folder path
set(handles.text5,'string',upath);

% Pre-allocate array based on number of files in the folder 
good_data = zeros(1,total);

% List filenames of .TIF files in folder
filenames = {dir_content.name};

% Get state of checkbox one: 1 if user wants to attempt to fit saturated
% images
saturate = get(handles.checkbox1,'value');

% Initialise c1
c1 = 1;

% Creates list of .TIF files to be fitted
for i=1:total
    
    % Reads in unknown file  
    raw=imread(char(strcat(upath,'/',(filenames(i)))));
    
    % Extracts filenumber from filename
    filenumber(i) = extract_filenumber(cell2mat(filenames(i)));
    
    % Determines background intensity
    background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
        raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
    
    %//////////////////////////////////////////////////////////////////////
    % HARDWARE SPECIFIC - REQUIRES EDITING
    % Divides background subtracted image into four quadrants
    
    % a = top right (750 nm)
    % b = bottom right (580 nm)
    % c = bottom left (850 nm)
    % d = top left (670 nm)
    [a,b,c,d] = deal(raw(1:255,1:382),raw(1:255,384:765),...
        raw(256:510,1:382),raw(256:510,384:765));
    %//////////////////////////////////////////////////////////////////////

    % Assigns each file in sequence to GOOD_DATA array if the weakest of
    % the four hotspots is stronger than double the background if user has
    % chosen to fit saturated images
    if saturate == 1 
        if min(max([d(:) a(:) c(:) b(:)])) > 2*background;
            good_data(i) = i;
            imagesc(raw,'parent',handles.axes1)
            plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},...
                (num2str(filenumber(i)))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
            c1 = c1+1;
        end
        
    % Assigns each file in sequence to GOOD_DATA array if the weakest of
    % the four hotspots is stronger than double the background AND none are 
    %brighter than the detector bit depth if user has chosen NOT to fit
    %saturated images    
    else
        if (min(max([d(:) a(:) c(:) b(:)])) > 2*background) &&...
                (max(max([d(:) a(:) c(:) b(:)])) < 62000);
            good_data(i) = i;
            imagesc(raw,'parent',handles.axes1)
            plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},...
                (num2str(filenumber(i)))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
            c1 = c1+1;
        end
    end
end

% Update button states
flag = getappdata(0,'flag');
[flag{2},flag{9}] = deal(1);
control_colors(flag, handles)

% Make data available between functions within GUI
setappdata(0,'good_data',good_data)
setappdata(0,'filenumber',filenumber)
setappdata(0,'dir_content',dir_content)
setappdata(0,'upath',upath)

%--------------------------------------------------------------------------
% --- Executes on press of SELECT ROI button
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update button states
flag = getappdata(0,'flag');
[flag{3},flag{6},flag{12}] = deal(0);
control_colors(flag, handles)

% Deletes interactive ROI if one already exists
hfindROI = findobj(handles.axes1,'Type','hggroup');    
delete(hfindROI)

% Deletes fixed ROI if one already exists
hfindrect = findobj(handles.axes1,'Type','rectangle');
delete(hfindrect)

% Creates resizeable ROI rectangle and waits until user double clicks
% inside it, and then reads out position pixel position of top left corner
% and size (constrined to a square, and a region with a 20 pixel hold off
% from the edge of the frame to allow space for misalignment and padding
% pixel binning).
ROI = imrect(handles.axes1, [474 28 200 200]);
fcn = makeConstrainToRectFcn('imrect',[364 745],[20 235]);
setPositionConstraintFcn(ROI,fcn);
setFixedAspectRatioMode(ROI,'True');
subframe = wait(ROI);

% Make ROI position avaialble to other functions
setappdata(0,'subframe',subframe);

% Updates button states
flag = getappdata(0,'flag');
[flag{3},flag{10}] = deal(1);
control_colors(flag, handles)

%--------------------------------------------------------------------------
% --- Executes when user selects START box
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets user entered value of first file to fit
fi = eval(get(handles.edit1,'string'))

% Access previously stored array GOOD_DATA
filenumber = getappdata(0,'filenumber')

% Converts fi to first GOOD file if user selects earlier file of last GOOD
% file if user selects a later file
if ~ismember(fi,filenumber(filenumber>0)) == 1
    if fi > max(filenumber)
        a = 10
        fi = max(filenumber)
    else 
        fi = min(filenumber);
    end
end

% Set edit box to error checked fl
set(handles.edit1,'string',num2str(fi));

% Updates button states
flag = getappdata(0,'flag');
[flag{4},flag{11}] = deal(1);
control_colors(flag, handles)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
% --- Executes when user selects END box
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets user entered value of last file to fit
fl = eval(get(handles.edit2,'string'));

% Access previously stored array GOOD_DATA
filenumber = getappdata(0,'filenumber');

% Converts fl to last GOOD file if user selects later file
if ~ismember(fl,filenumber(filenumber>0)) == 1
    if fl > max(filenumber)
        fl = max(filenumber);
    else 
        fl = eval(get(handles.edit1,'string'));
    end
end
    
% Converts fl to fi if user enters a value of fl < fi    
if fl < eval(get(handles.edit1,'string'))
    fl = eval(get(handles.edit1,'string'));    
end

% Set edit box to error checked fl
set(handles.edit2,'string',num2str(fl));

% Updates button states
flag = getappdata(0,'flag');
flag{5} = 1;
control_colors(flag, handles)


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
% --- Executes when user presses PROCESS button
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calls DATA_PREP function which returns parameters for the sequential
% fitting
[w,x,y,fi,fl,good_data,filenumber,upath,cal_a,cal_b,cal_c,cal_d,nw,...
    dir_content,savename] = data_prep(handles);

% Initialise c1
c1 = 1;

% Calculates temperature, error and difference maps and associated output
% for each file in GOOD_DATA array and plots and stores the results.
for i=good_data(good_data>=fi & good_data<=fl)

    % Determines path to unknown file
    filepath = char(strcat(upath,'/',(dir_content(i).name)));
    
    % Reads in unknown file
    raw = imread(filepath);
    
    % Determines background intensity using image corners
    background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
        raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
    
    % Subtracts background
    raw = raw-background;
    
    % Plots fullframe in bottom right axes
    imagesc(raw,'parent',handles.axes1);
    hold on
    rectangle('position',[x+384-w y-w w*2 w*2],'EdgeColor',...
        'w','LineWidth',2);
    hold off
    plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},...
        (num2str(filenumber(i)))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
    
    % Returns spatially correlated unknown subframes for first file in the
    % dataset
    if c1 == 1
        [a, b, c, d]= correlate(raw, x, y, w);
    end
    
    % Calls mapper function to calculate temperature, error and emissivity
    % maps, and also returns maximum T and associated errors, intensities,
    % wien slope and intercept and map indices and smoothed b quadrant for
    % plotting countours later
    [T,E,epsilon,T_max,E_max,U_max,m_max,C_max,dx,dy,sb] = mapper...
        (cal_a,cal_b,cal_c,cal_d,nw,d,a,c,b,handles);
    
    % Calls difference function to calculate the difference map and
    % associated metric.
    [T_dif,T_dif_metric(c1)] = difference(T, sb, c1, w, background); 
    
    % Create concatenated summary output array and save to workspace and
    % save current map data to .txt file
    result = data_output(dir_content,i,c1,T_max,E_max,T_dif_metric,...
    T,E,epsilon,T_dif,upath,savename,dir_content(i).name);
    assignin('base', 'result', result);
    
    % Increment counter c1
    c1 = c1 + 1;
 
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton5


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
