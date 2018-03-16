function varargout = IRS(varargin)
% IRS MATLAB code for IRS.fig
%      IRS, by itself, creates a new IRS or raises the existing
%      singleton*.
%
%      H = IRS returns the handle to a new IRS or the handle to
%      the existing singleton*.
%
%      IRS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IRS.M with the given input arguments.
%
%      IRS('Property','Value',...) creates a new IRS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IRS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IRS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IRS

% Last Modified by GUIDE v2.5 21-Jun-2016 12:13:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
set(0, 'DefaulttextInterpreter', 'none');
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IRS_OpeningFcn, ...
                   'gui_OutputFcn',  @IRS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before IRS is made visible.
function IRS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IRS (see VARARGIN)

% Choose default command line output for IRS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IRS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IRS_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

set(handles.checkbox1,'Value',1);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

set(handles.pushbutton1,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.pushbutton2,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.pushbutton3,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.edit2,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.edit2,'string',' ');
set(handles.edit3,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.edit3,'string',' ');
set(handles.text10,'string',' ');

[upath]=uigetdir('/Users/oliverlord/Desktop/untitled folder');
tiffs=strcat(upath,'/*.tiff');
dir_content = dir(tiffs);
total=size(dir_content,1);
set(handles.text10,'string',total);
set(handles.text5,'string',upath);
set(handles.pushbutton1,'Backgroundcolor',[0 .8 0]);

filenames = {dir_content.name};

good_data = zeros(1,total);

saturate = get(handles.checkbox1,'value')

for i=1:total
    filename=filenames(i);
    location=char(strcat(upath,'/',(filename)));
    raw=imread(location);
    %reads unknown file  

    tl = mean(raw(1:10,1:10));
    tr = mean(raw(1:10,755:765));
    bl = mean(raw(500:510,1:10));
    br = mean(raw(500:510,755:765));
    corners = [tl,tr,bl,br];
    noise = mean(corners);
    %determines background intensity
    
    maxD = max(max(raw(1:255,1:382)));
    maxA = max(max(raw(1:255,384:765)));
    maxC = max(max(raw(256:510,1:382)));
    maxB = max(max(raw(256:510,384:765)));
    %find 80th percentile intensity
    
    if saturate == 1 
        if maxA*0.8 > noise*2 && maxB*0.8 > noise*2 && maxC*0.8 > noise*2 && maxD*0.8 > noise*2;
            good_data(i) = i;
        end
    else
        if maxA*0.8 > noise*2 && maxB*0.8 > noise*2 && maxC*0.8 > noise*2 && maxD*0.8 > noise*2 && maxA < 64000 && maxB < 64000 && maxC < 64000 && maxD <64000;
            good_data(i) = i;
        end
    end
end

filename=filenames(max(good_data));
location=char(strcat(upath,'/',(filename)));
raw=imread(location)-noise;
d=raw(1:255,1:382);                     %top left 670nm
%reads unknown file

axes(handles.axes1) 
axis equal;
imagesc(d);
xlabel('X: pixels','FontSize',16);
ylabel('Y: pixels','FontSize',16);
title_string=strcat({'INTENSITY MAP: Last good file = '},num2str(max(good_data)));
title(title_string,'FontSize',18,'FontWeight','bold');

setappdata(0,'good_data',good_data);
setappdata(0,'noise',noise);

complete = findobj('Backgroundcolor',[0 .8 0]);

if size(complete,1) == 4 
    set(handles.pushbutton3,'Backgroundcolor',[0 .8 0]);
end

setappdata(0,'filenames',filenames);
setappdata(0,'dir_content',dir_content);

function edit2_Callback(hObject, eventdata, handles)

fi = eval(get(handles.edit2,'string'));
set(handles.edit2,'Backgroundcolor',[0 .8 0]);

good_data = find(getappdata(0,'good_data'));
if fi < min(good_data)
    fi = min(good_data);
    set(handles.edit2,'string',fi);
end

complete = findobj('Backgroundcolor',[0 .8 0]);

if size(complete,1) == 4 
    set(handles.pushbutton3,'Backgroundcolor',[0 .8 0]);
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

fl = eval(get(handles.edit3,'string'));
set(handles.edit3,'Backgroundcolor',[0 .8 0]);

good_data = getappdata(0,'good_data');
if fl > max(good_data)
    fl = max(good_data);
    set(handles.edit3,'string',fl);
end

complete = findobj('Backgroundcolor',[0 .8 0]);

if size(complete,1) == 4 
    set(handles.pushbutton3,'Backgroundcolor',[0 .8 0]);
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

hfindROI = findobj(gca,'Type','hggroup');    
delete(hfindROI)

set(handles.pushbutton2,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.pushbutton3,'Backgroundcolor',[1.0 0.6 0.784]);

h = imrect(handles.axes1, [91 28 200 200]);
fcn = makeConstrainToRectFcn('imrect',[20 362],[20 235]);
setPositionConstraintFcn(h,fcn);
setFixedAspectRatioMode(h,'True');

accepted_pos = wait(h);

w = round(accepted_pos(3)/2);
x = round(accepted_pos(1))+w;
y = round(accepted_pos(2))+w;

set(handles.pushbutton2,'Backgroundcolor',[0 .8 0]);

complete = findobj('Backgroundcolor',[0 .8 0]);

setappdata(0,'w',w);
setappdata(0,'x',x);
setappdata(0,'y',y);

if size(complete,1) == 4 
    set(handles.pushbutton3,'Backgroundcolor',[0 .8 0]);
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

filenames = getappdata(0,'filenames');
w = getappdata(0,'w');
x = getappdata(0,'x');
y = getappdata(0,'y');
dir_content = getappdata(0,'dir_content');
fi = eval(get(handles.edit2,'string'));
fl = eval(get(handles.edit3,'string'));
fg = find(getappdata(0,'good_data'));
upath = get(handles.text5,'string');

fcnt=fi;
fcnt1=1;
fcnt2=1;

metric=0;
Clim_min = 0;
Clim_max = 0.001;

scrsz=get(0,'ScreenSize');

calfilename = '../Calibration/Current/tc.tiff';
ki=imread(calfilename);
%opens and reads thermal calibration file

kid=ki(1:255,1:382);                        %top left 670nm
kia=ki(1:255,384:765);                      %top right 750nm
kic=ki(256:510,1:382);                      %bottom left 850nm
kib=ki(256:510,384:765);                    %bottom right 580nm
%splits calibration file into quadrants

filename=filenames(1);
savename=cell2mat(filename(1,1));
slash=strfind(filename,'-');
slashpos=cell2mat(slash(1,1));
savename=savename(1:(slashpos-1));
savename=strcat(savename,'summary_(4color, ',num2str(x),',',num2str(y),',',num2str(w),',',num2str(fi),',',num2str(fl),')');
mkdir(upath,savename);
%gathers list of .tiff files in the data folder and prepares folder for
%output

[byd,bxd,cyd,cxd,dyd,dxd]= correlate(kia,kib,kic,kid);
%determines offsets based on thermal calibration file

kiac=double(kia(y-w-4:y+w+4,x-w-4:x+w+4));
kibc=double(kib(y-w+byd-4:y+w+byd+4,x-w+bxd-4:x+w+bxd+4));
kicc=double(kic(y-w+cyd-4:y+w+cyd+4,x-w+cxd-4:x+w+cxd+4));
kidc=double(kid(y-w+dyd-4:y+w+dyd+4,x-w+dxd-4:x+w+dxd+4));
%shifts quadrants based on offsets and converts to type double

for m=5:(w*2+5)
    for n=5:(w*2+5)
        skiac(m-4,n-4)=mean(mean(kiac(m-4:m+4,n-4:n+4)));  
        skibc(m-4,n-4)=mean(mean(kibc(m-4:m+4,n-4:n+4)));
        skicc(m-4,n-4)=mean(mean(kicc(m-4:m+4,n-4:n+4)));
        skidc(m-4,n-4)=mean(mean(kidc(m-4:m+4,n-4:n+4)));
    end
end
%averages intensities over 9*9 box centred on each pixel of the calibration
%file

nw=[(14384000/752.97);(14384000/578.61);(14384000/851.32);(14384000/670.08)];
nw=[ones(4,1) nw]
%determines normalised wavelengths for the four filters

videofile=strcat(upath,'/',savename,'.avi');
writerObj = VideoWriter(videofile);
writerObj.FrameRate = 2;
open(writerObj);
%sets up video recording

for i=fg(fg>=fi & fg<=fl)
    
    filename=filenames(i)
    location=char(strcat(upath,'/',(filename)));
    raw=imread(location);
    %reads unknown file

    tl = mean(raw(1:10,1:10));
    tr = mean(raw(1:10,755:765));
    bl = mean(raw(500:510,1:10));
    br = mean(raw(500:510,755:765));
    corners = [tl,tr,bl,br];
    noise = mean(corners);
    %determines background intensity
   
    if fcnt1 == 1;
       h=figure(1);
       hold on
       set(h,'outerposition', [50 50 (scrsz(3)*0.9) (scrsz(4)*0.9)]);
    end;
    %first time through loop, makes figure(1)
    
    maxD = max(max(raw(1:255,1:382)));
    maxA = max(max(raw(1:255,384:765)));
    maxC = max(max(raw(256:510,1:382)));
    maxB = max(max(raw(256:510,384:765)));
    %find 80th percentile intensity
    
    if maxA*0.8 > noise*2 && maxB*0.8 > noise*2 && maxC*0.8 > noise*2 && maxD*0.8 > noise*2;
    %only calculate temperatures for files where the 80th intensity percentile
    %is larger than 2*noise
    
        raw = raw-noise;

        d=raw(1:255,1:382);                     %top left 670nm
        a=raw(1:255,384:765);                   %top right 750nm
        c=raw(256:510,1:382);                   %bottom left 850nm
        b=raw(256:510,384:765);                 %bottom right 580nm
        %splits unknown file into quadrants

        if fcnt2 == 1;
            [byd,bxd,cyd,cxd,dyd,dxd]= correlate(a,b,c,d);
            difT=zeros((w*2)+1);
            difT_raw=zeros((w*2)+1);
        end;
        %determines offsets based on first unknown file
               
        if fcnt2 >= 2;
            last = (T - min(T(:)))/(max(T(:)) - min(T(:)));
            last_raw = T;
        end;
        
        [Tmax,Emax,T,error,Emissivity,umax,slope_max,intercept_max,dx,dy,suid,uia]=mapper(x,y,w,skiac,skibc,skicc,skidc,nw,byd,bxd,cyd,cxd,dyd,dxd,d,a,c,b,fcnt);
        %calls mapper function to calculate temperature map
        Tmax
        
        if Tmax ~= 1
        
            if fcnt2 >= 2;
                current_raw = T;
                current = (T - min(T(:)))/(max(T(:)) - min(T(:)));
                csuid = (suid - min(suid(:)))/(max(suid(:)) - min(suid(:)));
                difT = abs(current-last).*csuid;
                difT_raw = current_raw-last_raw;
                metric(fcnt2) = nanmean(difT(:));
            end;
            
            Tmaximum(fcnt2)=Tmax;
            Tmaximum_plot(fcnt2)=Tmax;
            Emaximum(fcnt2)=Emax;
            
            hyphens = (strfind(location, '-'));
            hyphen = hyphens(end);
            r = location((hyphen+1):(strfind(location, '.')-1))
            seq(fcnt2) = str2num(r)
            timevalue(fcnt2) = datenum(dir_content(i).date);
            S = datevec(timevalue(fcnt2));
            elapsedSec(fcnt2) = (S(1,6) + (S(1,5)*60) + (S(1,4)*60*60));
            elapsedSecNorm(fcnt2) = round(elapsedSec(fcnt2)-elapsedSec(1));
            autoresult = [seq',timevalue',elapsedSecNorm',Tmaximum',Emaximum',metric'];
            assignin('base', 'autoresult', autoresult);
            assignin('base', 'T', T);
            %generates summary data including time stamps and peak temperatures
            
            time_plot = elapsedSecNorm;
            
            prefix=regexprep(filename,'.tiff','');
            prefix=regexprep(prefix,'-','_');
            %replaces dashes with underscores
            
            gridsize = size(T);
            [x1,y1] = meshgrid(1:gridsize(1),1:gridsize(2));
            xyz = [x1(:) y1(:) T(:) error(:) Emissivity(:) difT_raw(:)];
            map=char(strcat(upath,'/',savename,'/',prefix,'_map.txt'));
            save(map,'xyz','-ASCII');
            
            ax1=subplot(2,3,1);
            plot(nw(:,2),umax,'O')
            title_string=strcat({'Peak temperature: '},(num2str(round(Tmax))),' +/- ',(num2str(round(Emax))));
            title(title_string,'FontSize',18,'FontWeight','bold');
            xlabel('Normalised wavelength','FontSize',16);
            ylabel('Normalised intensity','FontSize',16);
            %plots normalised intensity vs normalised wavelength of hottest pixel
            
            hold on
            xline=linspace(min(nw(:,2)),max(nw(:,2)),100);
            yline=intercept_max+(slope_max*xline);
            plot(xline,yline,'-r')
            hold off
            %overlays the best fit line onto the wien plot
            
            job_size = size(fg);
            progress = round((fcnt1/job_size(2))*100);
            
            ax2=subplot(2,3,2);
            Tmaximum_plot(Tmaximum_plot==0) = NaN;
            if isnan(Tmaximum_plot(fcnt2));
                time_plot(fcnt2) = NaN;
            end;
            plot(ax2,time_plot,Tmaximum_plot,'--rs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',10);
            xlabel('Elapsed Time (s)','FontSize',16);
            ylabel('Temperature (K)','FontSize',16);
            title_string=strcat(filename,'|',num2str(S(1,4)),':',num2str(S(1,5)),':',num2str(S(1,6)),{'  '},num2str(progress),'%');
            title(title_string,'FontSize',18,'FontWeight','bold');
            xl = xlim;
            %plots temperature vs. acquisition number
            
            microns=w*2*.18;
            xm=linspace(-(microns/2),microns/2,(w*2)+9);
            ym=linspace(-(microns/2),microns/2,(w*2)+9);
            xms=linspace(-(microns/2),microns/2,(w*2)+1);
            yms=linspace(-(microns/2),microns/2,(w*2)+1);
            %pixel to micron conversion
            
            %         ax3=subplot(2,3,3);
            %         %plot(T(w,(1:(w*2))),suib(w,(1:(w*2))),T((1:(w*2)),w),suib((1:(w*2)),w));
            %         plot(xms,T(w,(1:(w*2+1))),xms,fliplr(T((1:(w*2+1)),w)));
            %         axis tight;
            %         legend('horizontal','vertical');
            %         ylabel('Temperature (K)','FontSize',16);
            %         xlabel('Distance (microns)','FontSize',16);
            %         title('Temperature Cross-sections','FontSize',18,'FontWeight','bold');
            %         hold off
            %         %plots temperature vs. emissivity for horizontal and vertical transects
            %         %through the hottest pixel
            
            ax3 = subplot(2,3,5);
            metric(metric==0) = NaN;
            plot(ax3,time_plot,metric,'--r','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',10);
            xlabel('Elapsed Time (s)','FontSize',16);
            ylabel('Image difference metric','FontSize',16);
            xlim(ax3,xl);
            
            ax4=subplot(2,3,4);
            if fcnt2 > 1 && Clim_min > min(difT_raw(:));
                Clim_min = min(difT_raw(:));
            end;
            if fcnt2 > 1 && Clim_max < max(difT_raw(:));
                Clim_max = max(difT_raw(:));
            end;
            Clim = [Clim_min Clim_max];
            originalSize = get(gca, 'Position');
            colormap cool;
            imagesc(xm,ym,difT_raw,Clim);
            xlabel('Distance (microns)','FontSize',16)
            ylabel('Distance (microns)','FontSize',16);
            title('DIFFERENCE MAP','FontSize',18,'FontWeight','bold');
            colorbar('location','WestOutside');
            set(gca, 'Position', originalSize);
            hold on
            contour(xms,yms,suid,10,'k');
            plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'ws',...
                'LineWidth',2,...
                'MarkerSize',10,...
                'MarkerEdgeColor','w',...
                'MarkerFaceColor','w')
            hold off
            %plots difference map
            
            ax5=subplot(2,3,3);
            Clim = [(min(error(:))) (max(error(:)))];
            originalSize = get(gca, 'Position');
            imagesc(xm,ym,error,Clim);
            xlabel('Distance (microns)','FontSize',16)
            title('ERROR MAP','FontSize',18,'FontWeight','bold');
            colorbar;
            hold on
            contour(xms,yms,suid,10,'k');
            plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'ws',...
                'LineWidth',2,...
                'MarkerSize',10,...
                'MarkerEdgeColor','w',...
                'MarkerFaceColor','w')
            hold off
            set(gca, 'Position', originalSize);
            %plots error map
            
            ax6=subplot(2,3,6);
            Clim = [(min(T(:))) Tmax];
            originalSize = get(gca, 'Position');
            colormap jet;
            imagesc(xm,ym,T,Clim);
            xlabel('Distance (microns)','FontSize',16)
            title('TEMPERATURE MAP','FontSize',18,'FontWeight','bold');
            colorbar;
            set(gca, 'Position', originalSize);
            hold on
            contour(xms,yms,suid,10,'k')
            plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'ws',...
                'LineWidth',2,...
                'MarkerSize',10,...
                'MarkerEdgeColor','w',...
                'MarkerFaceColor','w')
            hold off
            %plots temperature map
            
            drawnow;
            
            frame=getframe(gcf);
            writeVideo(writerObj,frame);
            %writes frame to .avi
            
            fcnt2 = fcnt2+1;
        end
        fcnt1=fcnt1+1;
    end
    fcnt=fcnt+1;
end

result=strcat(upath,'/',savename,'.txt');
result=char(result);
save (result,'autoresult','-ASCII','-double');
%saves summary data to text file

close(writerObj);
%closes video file


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

set(handles.pushbutton1,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.pushbutton2,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.pushbutton3,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.edit2,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.edit2,'string',' ');
set(handles.edit3,'Backgroundcolor',[1.0 0.6 0.784]);
set(handles.edit3,'string',' ');
set(handles.text10,'string',' ');
