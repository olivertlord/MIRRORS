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

% Initialise counter_1
counter_1 = 1;

% Creates list of .TIF files to be fitted
for i=1:total
    
    % Reads in unknown file  
    raw=imread(char(strcat(upath,'/',(filenames(i)))));
    
    % Determines background intensity
    noise = mean(mean([raw(1:10,1:10) raw(1:10,755:765)...
        raw(501:510,1:10) raw(501:510,755:765)]));
    
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
    % the four hotspots is stronger than double the noise if user has
    % chosen to fit saturated images
    if saturate == 1 
        if min(max([d(:) a(:) c(:) b(:)])) > 2*noise;
            good_data(i) = i;
            axes(handles.axes1);
            imagesc(raw)
            plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},...
                (num2str(i))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
            counter_1 = counter_1+1;
        end
        
    % Assigns each file in sequence to GOOD_DATA array if the weakest of
    % the four hotspots is stronger than double the noise AND none are 
    %brighter than the detector bit depth if user has chosen NOT to fit
    %saturated images    
    else
        if (min(max([d(:) a(:) c(:) b(:)])) > 2*noise) &&...
                (max(max([d(:) a(:) c(:) b(:)])) < 62000);
            good_data(i) = i;
            axes(handles.axes1);
            imagesc(raw)
            plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},...
                (num2str(i))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
            counter_1 = counter_1+1;
        end
    end
end

% Update button states
flag = getappdata(0,'flag');
[flag{2},flag{9}] = deal(1);
control_colors(flag, handles)

% Make data available between functions within GUI
setappdata(0,'good_data',good_data)
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
fi = eval(get(handles.edit1,'string'));

% Access previously stored array GOOD_DATA
good_data = getappdata(0,'good_data');

% Converts fi to first GOOD file if user selects earlier file
if ~ismember(fi,good_data(good_data>0)) == 1
    fi = find(getappdata(0,'good_data'),1);
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
fl = eval(get(handles.edit2,'string'))

% Access previously stored array GOOD_DATA
good_data = getappdata(0,'good_data')

% Converts fl to last GOOD file if user selects later file
if ~ismember(fl,good_data(good_data>0)) == 1
    fl = find(getappdata(0,'good_data'),1,'last');
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

auto_flag = getappdata(0,'auto_flag');
dir_content = getappdata(0,'dir_content');

if auto_flag <= 1

    clear T_hist E_hist acq timestamp elapsedSec timeSec difT_metric

end
    
persistent kiac kibc kicc kidc nw savename videofile writerObj T_hist E_hist acq timestamp elapsedSec timeSec difT_metric

if auto_flag == 0
    
    subframe = getappdata(0,'subframe');
    w = round(subframe(3)/2);
    x = round(subframe(1))+w-384;
    y = round(subframe(2))+w;
    %calculate center and half-width of subframe
    
    fi = eval(get(handles.edit1,'string'));
    fl = eval(get(handles.edit2,'string'));
    %get first and last files to be analysed

    good_data = getappdata(0,'good_data');
    upath = getappdata(0,'upath');
    %gets list of unknown files files and file path
    
    arrayfun(@cla,findall(0,'type','axes'))
    fclose('all');
    %clear axes
    
end

if auto_flag > 0
    
    [fi,fl,good_data] = deal(1);
    dir_content(1) = dir_content(length(dir_content));
    prefix = strsplit(dir_content(1).name,'-');
    upath = getappdata(0,'upath');
     
    [y, x] = deal(128,191);
    w = 80;
    counter_1 = auto_flag;
else
    prefix = strsplit(dir_content(1).name,'-');
    counter_1 = 1;
end
%removes extension from filename

if auto_flag < 2
        
    savename=strcat(prefix{1},'IRiS_',date);
    mkdir(upath,savename);
    %creates directory for output
    
    fullframe = imread('calibration/tc.tiff');
    %opens and reads .TIFF
    
    [kiac,kibc,kicc,kidc]= correlate(fullframe,x, y, w, 0, 1);
    %determines offsets based on thermal calibration file 
    
    nw = horzcat(ones(324,1),[repmat((14384000/752.97),81,1); repmat((14384000/578.61),81,1); repmat((14384000/851.32),81,1); repmat((14384000/670.08),81,1)]);
    %determines normalised wavelengths for the four filters

    videofile=strcat(upath,'/',savename,'/',savename,'.avi');
    
    writerObj = VideoWriter(videofile);
    writerObj.FrameRate = 2;
    open(writerObj);
    setappdata(0,'writerObj',writerObj);
    %sets up video recording
    
end

for i=good_data(good_data>=fi & good_data<=fl)
    
    filename=dir_content(i).name;
    filepath=char(strcat(upath,'/',(filename)));
    %reads unknown file
   
    fullframe = imread(filepath);
    %opens and reads .TIFF
    
    noise = mean(mean([fullframe(1:10,1:10) fullframe(1:10,755:765) fullframe(501:510,1:10) fullframe(501:510,755:765)]));
    %determines background intensity
    
    fullframe = fullframe-noise;
    %subtracts background
    
    if (x-w-4 < 1) || (y-w-4 < 1)
        x = 191;
        y = 128;
    end
    % resets ROI to center if it would have extended outside of the fullframe
    % and caused the program to crash
    
    axes(handles.axes1);
    imagesc(fullframe);
    hold on
    hRectangle = rectangle('position',[x+384-w y-w w*2 w*2],'EdgeColor','w','LineWidth',2);
    hold off
    plot_axes('X: pixels', 'Y: pixels', strcat({'DATASET: '},(num2str(i))),[1,757.35],[1,504.9], 0, 0, 0, 0, 0);
    %plots fullframe   
    
    [a, b, c, d]= correlate(fullframe, x, y, w, auto_flag, counter_1);
    %determines offsets based on first unknown file
    
    [Tmax,Emax,T,error,emissivity,umax,slope_max,intercept_max,dx,dy,sb]=mapper(kiac,kibc,kicc,kidc,nw,d,a,c,b,handles);
    %calls mapper function to calculate temperature map
  
    [difT, difT_metric(counter_1)] = difference(T, sb, counter_1, w);
    %determines difference map and difference metric
    
    if max(sb(:)) < noise*4
        difT_metric(counter_1) = NaN;
    end
    
    assignin('base','difT_metric',difT_metric)
    
    T_hist(counter_1)=Tmax;
    E_hist(counter_1)=Emax;
    
    acq(counter_1) = str2double(filename(end-7:end-5));
    %store max T and associated error
           
    timestamp(counter_1) = datenum(dir_content(i).date);
    %get timestamp
     
    timevector = datevec(timestamp(counter_1));
    %vectorise timestamp
     
    timeSec(counter_1) = (timevector(1,6) + (timevector(1,5)*60) + (timevector(1,4)*60*60));
    %convert timevector to seconds
    
    elapsedSec(counter_1) = round(timeSec(counter_1)-timeSec(1));
    %determine seconds elapsed since start of experiment
    
    autoresult = [acq',timestamp',elapsedSec',T_hist',E_hist',difT_metric'];
    assignin('base', 'autoresult', autoresult);
    %create output array and assign to workspace
            
    [x1,y1] = meshgrid(1:length(T),1:length(T));
    %lists pixel x and y coordinates

    xyz = [x1(:) y1(:) T(:) error(:) emissivity(:) difT(:)];
    %generates data table containing all three maps for each data point

    map=char(strcat(upath,'/',savename,'/',filename(1:end-5),'_map.txt'));
    save(map,'xyz','-ASCII');
    %creates unique file name for map data and saves it
    
    progress = round(counter_1/length(good_data(good_data>=fi & good_data<=fl))*100);
    %calculates job progress
    
    if get(handles.pushbutton5,'Value') == 1
        progress = 100;
    end;
    
    microns=linspace(-(w*.18),w*.18,(w*2));
    %pixel to micron conversion
    
    plot_type = 0;
    %sets plot type to 'graph' so plot_axes function performs correctly
    
    %TOP LEFT PLOT: normalised intensity vs normalised wavelength of hottest pixel
    axes(handles.axes2)
    plot(nw(:,2),umax,'O');
    plot_axes('Normalised wavelength', 'Normalised intensity', strcat({'Peak temperature: '},(num2str(round(Tmax))),' +/- ',(num2str(round(Emax)))), nw(:,2), umax, plot_type, dy, dx, sb, microns);
    hold on
    xline=linspace(min(nw(:,2)),max(nw(:,2)),100);
    yline=intercept_max+(slope_max*xline);
    plot(xline,yline,'-r')
    hold off
    %overlays the best fit line onto the wien plot
    
    %TOP MIDDLE PLOT: Peak Temperature History
    axes(handles.axes3)
    plot(elapsedSec,T_hist,'--rs','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
    plot_axes('Elapsed Time (s)', 'Temperature (K)', strcat(num2str(timevector(1,4)),':',num2str(timevector(1,5)),':',num2str(timevector(1,6)),{'  '},num2str(progress),'%'),elapsedSec,T_hist, plot_type, dy, dx, sb, microns);
    
    if get(handles.radiobutton4,'Value') == 1
        %TOP RIGHT PLOT: Difference Metric History
        axes(handles.axes4)
        plot(elapsedSec,difT_metric,'--rs','LineWidth',1,'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);
        plot_axes('Elapsed Time (s)', 'Image difference metric', 'Image difference metric',elapsedSec,difT_metric, plot_type, dy, dx, sb, microns);
    else
        %TOP RIGHT PLOT: cross-sections
        axes(handles.axes4)
        plot(microns,T(dx,(1:length(T))),'r');
        hold on
        plot(microns,T(1:length(T),dy),'g');
        hold off
        plot_axes('Distance (microns)', 'Temperature (K)', 'Temperature Cross-sections',microns,T(T>0), plot_type, dy, dx, sb, microns);
        legend('horizontal','vertical');
    end
    
    plot_type = 1;
    %sets plot type to 'map' so plot_axes function performs correctly
    
    %BOTTOM LEFT PLOT: difference map
    axes(handles.axes5)
    [Clim_min(counter_1), Clim_max(counter_1)] = deal(min(difT(:)), max(difT(:)));
    [Clim_min(isnan(Clim_min)), Clim_max(isnan(Clim_max))] = deal(0,0.001);
    plot(.18*y-(microns/2)-.18,.18*x-(microns/2)-.18,'ws','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','w','MarkerFaceColor','w') 
    imagesc(microns,microns,difT,[min(Clim_min) max(Clim_max)]);
    plot_axes('Distance (microns)', 'Distance (microns)', 'DIFFERENCE MAP',microns, microns, plot_type, dy, dx, sb, microns);

    %BOTTOM MIDDLE PLOT: error map
    axes(handles.axes6)
    imagesc(microns,microns,error,[(min(error(:))) (max(error(:)))]);    
    plot_axes('Distance (microns)', 'Distance (microns)', 'ERROR MAP',microns, microns, plot_type, dy, dx, sb, microns);

    %BOTTOM RIGHT PLOT: temperature map
    axes(handles.axes7)
    imagesc(microns,microns,T,[(min(min(T(T>0)))) max(T(:))]);
    plot_axes('Distance (microns)', 'Distance (microns)', 'TEMPERATURE MAP',microns, microns, plot_type, dy, dx, sb, microns);
    
    movegui(gcf,'center')
    frame=getframe(gcf);
    writeVideo(writerObj,frame);
    %writes frame to .avi
           
    counter_1 = counter_1 + 1;
end

result=strcat(upath,'/',savename,'/',savename,'.txt');
result=char(result);
save (result,'autoresult','-ASCII','-double');
%saves summary data to text file

if get(handles.pushbutton5,'Value') == 0
    close(writerObj);
end
%closes video file unless in automode

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
