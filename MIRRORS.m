function varargout = MIRRORS(varargin)
%--------------------------------------------------------------------------
% MIRRORS (MultIspectRal imaging RadiOmetRy Software)
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
%MIRRORS M-file for MIRRORS.fig
%      MIRRORS, by itself, creates a new MIRRORS or raises the existing
%      singleton*.
%
%      H = MIRRORS returns the handle to a new MIRRORS or the handle to
%      the existing singleton*.
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

%      hObject    handle to checkbox1 (see GCBO)
%      eventdata  reserved - to be defined in a future version of MATLAB
%      handles    structure with handles and user data (see GUIDATA)

%      handles    structure with handles and user data (see GUIDATA)
%      varargin   unrecognized PropertyName/PropertyValue pairs from the
%           command line (see VARARGIN)
%      varargout  cell array for returning output args (see VARARGOUT);

%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MIRRORS

% Last Modified by GUIDE v2.5 17-May-2018 10:36:06


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
function edit1_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

if ispc && isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~) %#ok<DEFNU>

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%--------------------------------------------------------------------------
% --- Executes just before MIRRORS is made visible.
function MIRRORS_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.

% Choose default command line output for MIRRORS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Creates array of handles to axes within the GUI
plots = [handles.axes2 handles.axes3 handles.axes4 handles.axes5...
    handles.axes6 handles.axes7];

% Hide EXAMPLE DATA button
set(handles.pushbutton5,'visible','off');

% VERSION NUMBER
set(handles.text17,'String','1.6.14');

% Sets aspect ratio for all axes within the GUI to 1:1
for i=1:6
   axes(plots(i)); %#ok<LAXES>
   pbaspect([1 1 1])
end

% Initialises auto mode system flag and intitial filname
setappdata(0,'auto_flag',0);
auto_filename = ('blank');

% Makes auto mode system flag and intitial filname available to all
% functions within the GUI
setappdata(0,'auto_flag',0);
setappdata(0,'auto_filename',auto_filename);

% Forces GUI to screen centre at start-up 
movegui(gcf,'center');

% Initialise button colors and enabled state
control_colors({0 0 0 0 0 0 1 1 0 0 0 0},handles);

% Suppress non integer index and complex number warnings
warning('off','MATLAB:colon:nonIntegerIndex');
warning('off','MATLAB:plot:IgnoreImaginaryXYPart');


%--------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = MIRRORS_OutputFcn(~, ~, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
% UNUSED CALLBACK FUNCTIONS


% --- Executes on button press in checkbox2.
function checkbox2_Callback(~, ~, ~) %#ok<DEFNU>


%--------------------------------------------------------------------------
% --- Executes when user presses LIVE button
function pushbutton1_Callback(~, ~, handles) %#ok<DEFNU>

if getappdata(0,'auto_flag') == 1
    
    % Update button states
    control_colors({0 0 0 0 0 0 1 1 0 0 0 0}, handles)
    
    % Reset auto_flag to 0
    setappdata(0,'auto_flag','0');
    
else
    
    % Reset auto_flag to 1
    setappdata(0,'auto_flag',1);
    
    % Clear all axes within GUI
    arrayfun(@cla,findall(0,'type','axes'))
    fclose('all');
    
    % Reset textboxes to 0
    set(handles.edit1,'String','0')
    set(handles.edit2,'String','0')
    
    % Update button states
    control_colors({1 0 0 0 0 0 1 1 0 0 0 0}, handles)
    
    % Deletes ROI if one already exists
    hfindROI = findobj(handles.axes1,'Type','hggroup');
    delete(hfindROI)
    
    % Default intensity cutoff to 25% and disable
    set(handles.slider1,'Value',0.25);
    set(handles.text12,'String','25 %');
    set(handles.slider1,'Enable','off');
    
    % Ask user to point to folder containing .TIF files to be processed
    upath = uigetdir('/Users/oliverlord/Dropbox/Work/EXPERIMENTS/');
    setappdata(0,'upath',upath);
 
    % Collect list of current .TIFF files
    dir_content = dir(strcat(upath,'/*.tiff'));
    initial_list = {dir_content.name};
    
    % Initialise counter c1
    c1 = 1;

    while getappdata(0,'auto_flag') == 1
        
        % Collects new list of filenames
        pause(0.1);
        dir_content = dir(strcat(upath,'/*.tiff'));
        new_list = {dir_content.name};
        
        % Executes if a new file appears in the target folder
        if length(new_list) > length(initial_list)
            
            % Determines path to unknown file
            filepath = char(strcat(upath,'/',(dir_content(end).name)));
            
            % Reads in unknown file and convert to double precision
            raw_image = imread(filepath);
            raw = im2double(raw_image);
            
            % Determines background intensity using image corners
            background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
                raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
            
            % Subtracts background
            raw = raw-background;
            
            % Calls DATA_PREP function on the first pass
            if c1 == 1
                
                % Determine center of top right quadrant and set halfwidth
                x = round(0.75*(length(raw(1,:))));
                y = round(0.25*(length(raw(:,1))));
                w = 200;
                setappdata(0,'subframe',[x-(w/2) y-(w/2) w w])
                
                [w,x,y,~,~,~,upath,cal_a,cal_b,cal_c,cal_d,savename,...
                    writerObj,expname] = data_prep(handles);
            end
                      
            % Divides background subtracted image into four quadrants
            a = raw(1:size(raw,1)/2,1:size(raw,2)/2,:);
            b = raw(size(raw,1)/2+1:size(raw,1),1:size(raw,2)/2,:);
            c = raw(1:size(raw,1)/2,size(raw,2)/2+1:size(raw,2),:);
            d = raw(size(raw,1)/2+1:size(raw,1),size(raw,2)/2+1:size...
                (raw,2),:);
            
            % Wavelengths of each quadrant at Bristol
            % a = top left (670 nm)
            % b = top right (750 nm)
            % c = bottom left (850 nm)
            % d = bottom right (580 nm)
            
            % Returns spatial correlation parameters for first file in the
            % dataset
            if c1 == 1
                [bya,bxa,cya,cxa,dya,dxa] = correlate(a,b,c,d);
            end
            
            % Shifts quadrants based on offsets and pads by 4 pixels
            a = a(y-w-4:y+w+4,x-w-4:x+w+4);
            b = b(y-w+bya-4:y+w+bya+4,x-w+bxa-4:x+w+bxa+4);
            c = c(y-w+cya-4:y+w+cya+4,x-w+cxa-4:x+w+cxa+4);
            d = d(y-w+dya-4:y+w+dya+4,x-w+dxa-4:x+w+dxa+4);         
            
            % Calls mapper function to calculate temperature, error and
            % emissivity maps, and also returns maximum T and associated
            % errors, intensities, wien slope and intercept and map indices
            % and smoothed b quadrant for plotting countours later
            [T,E_T,E_E,epsilon,T_max(c1),E_T_max(c1),E_E_max(c1),U_max,...
                m_max,C_max(c1),dx,dy,sb,nw] = mapper(cal_a,cal_b,cal_c,...
                cal_d,d,a,c,b,handles,filepath); %#ok<AGROW>
            
            % Calls difference function to calculate the difference map and
            % associated metric.
            [T_dif,T_dif_metric(c1)] = difference(T, sb, c1,...
                background); %#ok<AGROW>
            
            % Create concatenated summary output array and save to
            % workspace and save current map data to .txt file
            [result(c1,:),timevector] = data_output(dir_content(c1),...
                1,c1,T_max(c1),E_T_max(c1),C_max(c1),E_E_max(c1),...
                T_dif_metric(c1),T,E_T,epsilon,E_E,T_dif,upath,savename); %#ok<AGROW>
            assignin('base', 'result', result);
            
            % Extracts filenumber from filename
            filenumber(c1) = extract_filenumber(dir_content(end).name);
            
            % Calculates job progress
            progress = 'N/A';
            
            % Set Colour Limits for difference plot such that it is only
            % extended if but never reduced
            [Clim_min(c1), Clim_max(c1)] = deal(min(T_dif(:)),...
                max(T_dif(:))); %#ok<AGROW>
            [Clim_min(isnan(Clim_min)), Clim_max(isnan(Clim_max))]...
                = deal(0,0.001); %#ok<AGROW>
            
            % Calls data_plot function
            data_plot(handles,nw,T_max,E_T_max,E_E_max,U_max,m_max,C_max,c1,...
                filenumber,raw,timevector,result(:,3),T_dif_metric,T,...
                dx,dy,progress,T_dif,E_T,Clim_min,Clim_max,sb,epsilon,1);
            
            % Writes current GUI frame to movie
            movegui(gcf,'center')
            frame=getframe(gcf);
            writeVideo(writerObj,frame);
            
            % Increment counter c1
            c1 = c1 + 1;
            
            initial_list = new_list;
        end
    end
    
    % Closes video file on loop exit
    close(writerObj);

    % Saves summary data to text file
    summary_file = char(strcat(upath,'/',savename,'/',expname(end),...
        '_SUMMARY.txt'));
    save (summary_file,'result','-ASCII','-double');
    
end


%--------------------------------------------------------------------------
% --- Executes on press of POST PROCESS button
function pushbutton2_Callback(~, ~, handles)

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

% Default intensity cutoff to 25% and enable
set(handles.slider1,'Value',0.25);
set(handles.text12,'String','25 %');
set(handles.slider1,'Enable','on');

% Ask user to point to folder containing .TIF files to be processed
[upath]=uigetdir('/Users/oliverlord/Dropbox/Work/EXPERIMENTS/');

% Create array containing file metadata on all .TIF files in folder
dir_content = dir(strcat(upath,'/*.tiff'));
setappdata(0,'dir_content',dir_content);

% Determine number of .TIF files in folder
total=size(dir_content,1);

% Set string of text5 to current folder path
set(handles.text5,'string',upath);

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
    
    % Determines background intensity
    background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
        raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
    
    % Forces top right plot option to 'difference'
    set(handles.radiobutton4,'Value',1);
    
    % Divides background subtracted image into four quadrants
    a = raw(1:round(size(raw,1))/2,1:round(size(raw,2))/2,:);
    b = raw(size(raw,1)/2+1:size(raw,1),1:size(raw,2)/2,:);
    c = raw(1:size(raw,1)/2,size(raw,2)/2+1:size(raw,2),:);
    d = raw(size(raw,1)/2+1:size(raw,1),size(raw,2)/2+1:size(raw,2),:);

    % Wavelengths of each quadrant at Bristol
    % a = top left (670 nm)
    % b = bottom left (850 nm)
    % c = top right (750 nm)
    % d = bottom right (580 nm)
    
    % Automaticlly determines the bit depth of the .TIFF files being used
    % and sets the saturation limit to 99% of that value
    image_info = imfinfo(char(strcat(upath,'/',(filenames(i)))));
    saturation_limit = 2^image_info.BitDepth*.95;
    
    % Assigns each file in sequence to filenumber array if the weakest of
    % the four hotspots is stronger than double the background if user has
    % chosen to fit saturated images

    if saturate == 1 
        if min(max([d(:) a(:) c(:) b(:)])) > 2*background;
            filenumber(c1) = extract_filenumber(cell2mat(filenames(i)))...
               ; %#ok<AGROW>
            listpos(c1)=i;
            data_plot(handles,[0 1],[NaN NaN],[NaN NaN],[NaN NaN],NaN,...
                NaN,NaN,c1,filenumber,raw,0,[0 1],NaN,[1 2],1,1,[0 1],0,...
                [0 1],[1 2],0,1,[0,1;0,1],[NaN,NaN])
            
            c1 = c1+1;
        end
    % Assigns each file in sequence to filenumber array if the weakest of
    % the four hotspots is stronger than double the background AND none are 
    %brighter than the detector bit depth if user has chosen NOT to fit
    %saturated images    
    else
        if (min(max([d(:) a(:) c(:) b(:)])) > 2*background) &&...
                (max(max([d(:) a(:) c(:) b(:)])) < saturation_limit);
            filenumber(c1) = extract_filenumber(cell2mat(filenames(i)))...
                ; %#ok<AGROW>  
            listpos(c1)=i;
            data_plot(handles,[0 1],[NaN NaN],[NaN NaN],[NaN NaN],NaN,...
                NaN,NaN,c1,filenumber,raw,0,[0 1],NaN,[1 2],1,1,[0 1],0,...
                [0 1],[1 2],0,1,[0,1;0,1],[NaN,NaN],c1)
            c1 = c1+1;
        end
    end
end

% Update button states
flag = getappdata(0,'flag');
[flag{2},flag{9}] = deal(1);
control_colors(flag, handles)

% Make data available between functions within GUI
setappdata(0,'filenumber',filenumber)
setappdata(0,'listpos',listpos)
setappdata(0,'dir_content',dir_content)
setappdata(0,'upath',upath)


%--------------------------------------------------------------------------
% --- Executes on press of SELECT ROI button
function pushbutton3_Callback(~, ~, handles) %#ok<DEFNU>

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
function edit1_Callback(~, ~, handles) %#ok<DEFNU>

% Gets user entered value of first file to fit
fi = eval(get(handles.edit1,'string'));

% Access previously stored array filenumber
filenumber = getappdata(0,'filenumber');

% Converts fi to first GOOD file if user selects earlier file of last GOOD
% file if user selects a later file
if ~ismember(fi,filenumber(filenumber>0)) == 1
    [~,idx] = min(abs(filenumber-fi));
    fi= filenumber(idx);
end

% Set edit box to error checked fl
set(handles.edit1,'string',num2str(fi));

% Updates button states
flag = getappdata(0,'flag');
[flag{4},flag{11}] = deal(1);
control_colors(flag, handles)


%--------------------------------------------------------------------------
% --- Executes when user selects END box
function edit2_Callback(~, ~, handles) %#ok<DEFNU>

% Gets user entered value of last file to fit
fl = eval(get(handles.edit2,'string'));

% Access previously stored array filenumbers
filenumber = getappdata(0,'filenumber');

% Converts fl to last GOOD file if user selects later file
if ~ismember(fl,filenumber(filenumber>0)) == 1
    [~,idx] = min(abs(filenumber-fl));
    fl = filenumber(idx);
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


%--------------------------------------------------------------------------
% --- Executes when user presses PROCESS button
function pushbutton4_Callback(~, ~, handles) %#ok<DEFNU>

% Reset auto_flag to 0
setappdata(0,'auto_flag','0');
    
% Calls DATA_PREP function which returns parameters for the sequential
% fitting
[w,x,y,fi,fl,filenumber,upath,cal_a,cal_b,cal_c,cal_d,savename,...
    writerObj,expname] = data_prep(handles);

% Get list of .TIFF files from appdata
dir_content = getappdata(0,'dir_content')

%Get list of positions in folder of files to be fitted
listpos = getappdata(0,'listpos');

% Determine start and end positions within file list;
[start_file,~] = find(filenumber'==fi);
[end_file,~] = find(filenumber'==fl);

% Initialise c1
c1 = 1;

% Calculates temperature, error and difference maps and associated output
% for each file and plots and stores the results.
for i=start_file:end_file
    i
    listpos
    dir_content.name
    % Determines path to unknown file
    filepath = char(strcat(upath,'/',(dir_content(listpos(i)).name)));
    
    % Reads in unknown file and convert to double precision
    raw_image = imread(filepath);
    raw = im2double(raw_image);
    
    % Determines background intensity using image corners
    background = mean(mean([raw(1:10,1:10) raw(1:10,end-9:end)...
        raw(end-9:end,1:10) raw(end-9:end,end-9:end)]));
    
    % Subtracts background
    raw = raw-background;
    
    % Divides background subtracted image into four quadrants
    a = raw(1:size(raw,1)/2,1:size(raw,2)/2,:);
    b = raw(size(raw,1)/2+1:size(raw,1),1:size(raw,2)/2,:);
    c = raw(1:size(raw,1)/2,size(raw,2)/2+1:size(raw,2),:);
    d = raw(size(raw,1)/2+1:size(raw,1),size(raw,2)/2+1:size(raw,2),:);
    
    % Wavelengths of each quadrant at Bristol
    % a = top left (670 nm)
    % b = top right (750 nm)
    % c = bottom left (850 nm)
    % d = bottom right (580 nm)
    
    % Returns spatial correlation parameters for first file in the dataset
    if c1 == 1
        [bya,bxa,cya,cxa,dya,dxa] = correlate(a,b,c,d);
    end
    
    % Shifts quadrants based on offsets and pads by 4 pixels
    a=a(y-w-4:y+w+4,x-w-4:x+w+4);
    b=b(y-w+bya-4:y+w+bya+4,x-w+bxa-4:x+w+bxa+4);
    c=c(y-w+cya-4:y+w+cya+4,x-w+cxa-4:x+w+cxa+4);
    d=d(y-w+dya-4:y+w+dya+4,x-w+dxa-4:x+w+dxa+4);
    
    % Calls mapper function to calculate temperature, error and emissivity
    % maps, and also returns maximum T and associated errors, intensities,
    % wien slope and intercept and map indices and smoothed b quadrant for
    % plotting countours later
    [T,E_T,E_E,epsilon,T_max(c1),E_T_max(c1),E_E_max(c1),U_max,m_max,...
        C_max(c1),dx,dy,sb,nw] = mapper(cal_a,cal_b,cal_c,cal_d,d,a,c,b,...
        handles,filepath); %#ok<AGROW>
    
    % Calls difference function to calculate the difference map and
    % associated metric.
    [T_dif,T_dif_metric(c1)] = difference(T, sb, c1, background);...
        %#ok<AGROW>
    
    % Create concatenated summary output array and save to workspace and
    % save current map data to .txt file
    [result(c1,:),timevector] = data_output(dir_content(listpos(i)),...
        1,c1,T_max(c1),E_T_max(c1),C_max(c1),E_E_max(c1),...
        T_dif_metric(c1),T,E_T,epsilon,E_E,T_dif,upath,savename); %#ok<AGROW>
    assignin('base', 'result', result);
    
    % Calculates job progress
    progress = ceil(c1/(fl-fi+1)*100);
    
    % Set Colour Limits for difference plot such that it is only extended
    % but never reduced
    [Clim_min(c1), Clim_max(c1)] = deal(min(T_dif(:)), max(T_dif(:)));...
        %#ok<AGROW>
    [Clim_min(isnan(Clim_min)), Clim_max(isnan(Clim_max))]...
        = deal(0,0.001); %#ok<AGROW>

    % Calls data_plot function
    data_plot(handles,nw,T_max,E_T_max,E_E_max,U_max,m_max,C_max,i,...
        filenumber,raw,timevector,result(:,3),T_dif_metric,T,dx,dy,...
        progress,T_dif,E_T,Clim_min,Clim_max,sb,epsilon,1);
    
    % Writes current GUI frame to movie
    movegui(gcf,'center')
    frame=getframe(gcf);
    setappdata(0,'frame',frame);
    writeVideo(writerObj,frame);
    
    % Increment counter c1
    c1 = c1 + 1;
  
end

% Closes video file on loop exit
close(writerObj);

% Saves summary data to text file
summary_file = char(strcat(upath,'/',savename,'/',expname(end),...
    '_SUMMARY.txt'));
save (summary_file,'result','-ASCII','-double');


%--------------------------------------------------------------------------
% --- Executes on slider movement.
function slider1_Callback(~, ~, handles) %#ok<DEFNU>

% Get current slider value
slider_val = get(handles.slider1,'Value')*100;

%Set textbox to current slider value
set(handles.text12,'String',strcat(num2str(round(slider_val)),{' '},'%'));

%--------------------------------------------------------------------------
% --- Executes on button press in Fit saturated images chackbox.
function checkbox1_Callback(~, ~, handles) %#ok<DEFNU>
pushbutton2_Callback([], [], handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEVELPOPER CODE - DO NOT EDIT BELOW THIS LINE ---------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% --- Executes when EXAMPLE DATA button is pushed
function pushbutton5_Callback(~, ~, handles)

% --- PREFLIGHT ALTERATIONS -----------------------------------------------

% Change tc.tiff to tc_example.tiff
movefile('./calibration/tc.tiff','./calibration/tc_temp.tiff')
movefile('./example/tc_example.tiff','./calibration/tc.tiff')

% Fix subframe position
setappdata(0,'subframe',[474 28 200 200])

% Fix file range
set(handles.edit1,'string','1')
set(handles.edit2,'string','11')

% Fix filenumber list and upath
setappdata(0,'filenumber',[1 2 3 4 5 6 7 8 9 10 11]);
setappdata(0,'upath','./example/data');

% Get current directory content
dir_content = dir('./example/data');

% Remove existing folders
for i = 1:length(dir_content) 
    if dir_content(i).isdir == 1 & dir_content(i).name ~= '.' %#ok<AND2>
       rmdir(strcat('./example/data/',dir_content(i).name),'s');
    end
end

% --- TEST 1 --------------------------------------------------------------

% Set user options
set(handles.slider1,'Value',0.25)
set(handles.checkbox1,'Value',1)
set(handles.checkbox2,'Value',0)
set(handles.radiobutton1,'Value',1)
set(handles.radiobutton4,'Value',1)

% Run PROCESS button
pushbutton4_Callback([], [], handles)

% Get folder name of output directory
savename = getappdata(0,'savename');

% Change output folder name to test_1
movefile(strcat('./example/data/',savename),strcat('./example/data/','test_1'))

% Get last frame of GUI window
frame = getappdata(0,'frame');
imwrite(frame.cdata,'./example/data/test_1/test_1.png')

% --- TEST 2 --------------------------------------------------------------

set(handles.radiobutton2,'Value',1)
set(handles.radiobutton5,'Value',1)

pushbutton4_Callback([], [], handles)

savename = getappdata(0,'savename');

movefile(strcat('./example/data/',savename),strcat('./example/data/','test_2'))

frame = getappdata(0,'frame');
imwrite(frame.cdata,'./example/data/test_2/test_2.png')

% --- TEST 3 --------------------------------------------------------------

set(handles.radiobutton3,'Value',1)
set(handles.radiobutton6,'Value',1)

pushbutton4_Callback([], [], handles)

savename = getappdata(0,'savename');

movefile(strcat('./example/data/',savename),strcat('./example/data/','test_3'))

frame = getappdata(0,'frame');
imwrite(frame.cdata,'./example/data/test_3/test_3.png')

% --- TEST 4 --------------------------------------------------------------

set(handles.radiobutton7,'Value',1)
set(handles.radiobutton8,'Value',1)

pushbutton4_Callback([], [], handles)

savename = getappdata(0,'savename');

movefile(strcat('./example/data/',savename),strcat('./example/data/','test_4'))

frame = getappdata(0,'frame');
imwrite(frame.cdata,'./example/data/test_4/test_4.png')

% --- POSTFLIGHT ALTERATIONS ----------------------------------------------

% Change tc_example.tiff back to tc.tiff
movefile('./calibration/tc.tiff','./example/tc_example.tiff')
movefile('./calibration/tc_temp.tiff','./calibration/tc.tiff')
