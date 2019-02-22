function [] = data_plot(handles,nw,T_max,E_T_max,E_E_max,U_max,m_max,...
    C_max,i,filenumber,raw,timevector,elapsedSec,T_dif_metric,T,dx,dy,...
    progress,T_dif,E_T,Clim_min,Clim_max,sb,bsz,epsilon,c1)
%--------------------------------------------------------------------------
% Function DATA_PLOT
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
%   Performs all plotting tasks and is called after every new unknown file
%   is processed.

%   INPUTS: handles = data structure containing information on graphics
%           elements within the GUI.

%           nw = array of normalised wavelengths computed for the four
%           filter wavelngths used in Bristol.

%           T_max,E_T_max = peak temperature and associated error

%           E_E_max = error in the emissivity

%           U_max = array of normalised intensities used to compute the
%           peak temperature pixel

%           m_max,c_max = gradient and y-intercept (emissivity) of the Wien
%           fit at the peak temperature pixel

%           i = the current position within filenumber

%           filenumber = list of filenumbers extrcated from filenames in
%           working directory

%           raw = background corrected fullframe

%           timevector = timestamp in vectorised format

%           elapsedSec = time in seconds since first datatpoint

%           T_dif_metric = average of the difference map

%           T = computed temperature map

%           dx,dy = co-ordinates of peak pixel

%           micorns = array containing distances in mu_pad from the
%           subframe center for each pixel

%           progress = percentage progress through current processing job

%           T_dif = difference map

%           E_T = computed temperature error map

%           Clim_min,Clim_max = minimu_padm and maximu_padm colour limits for
%           differnece map

%           sb = smoothed form of subframe b for contouring

%           c1 = flag; only plot output data if == 1. Speeds up plotting
%           during initial data checking when user presses the post
%           processing button

%   OUTPUTS: NONE


%--------------------------------------------------------------------------
% Close all open files
fclose('all');

%--------------------------------------------------------------------------
% Pixel to micron conversion
mu_pad = linspace(-((length(sb)/2)*.18),((length(sb)/2)*.18),...
    (((length(sb)/2)*2)));

mu = linspace(-(((length(sb)-bsz)/2)*.18),(((length(sb)-bsz)/2)*.18),...
    ((((length(sb)-bsz)/2)*2)));

% Get colour map chosen by user
contents = cellstr(get(handles.popupmenu1,'String'));
colour_scheme = contents{get(handles.popupmenu1,'Value')};

%--------------------------------------------------------------------------
% SUMMARY PLOT: raw image data
axes(handles.axes1)
cla
imagesc(raw)
% Set axes labels and plot title
xlabel('X: pixels', 'FontSize', 16);
ylabel('Y: pixels', 'FontSize', 16);
title((strcat({'DATASET: '},(num2str(filenumber(i))))),'FontSize',18);

% Deletes interactive ROI if one already exists
hfindROI = findobj(handles.axes1,'Type','hggroup');    
delete(hfindROI)

% Deletes fixed ROI if one already exists
hfindrect = findobj(handles.axes1,'Type','rectangle');
delete(hfindrect)

% Plot rectangle on summary plot except when this function is called from
% pushbutton2_Callback
if length(sb) > 2
    rectangle('Position',getappdata(0,'subframe'),'EdgeColor','w',...
        'LineWidth',2);
end
axis equal

%--------------------------------------------------------------------------
% Only update remaining plots on first pass pushbutton2_Callback processing
% loop and every time when called form elsewhere
if c1 == 1

%--------------------------------------------------------------------------
% TOP LEFT PLOT: normalised intensity vs normalised wavelength of hottest
% pixel
axes(handles.axes2)
cla
pbaspect([1 1 1])

plot(nw(:,2),U_max,'bO','LineWidth',1,'MarkerEdgeColor','b',...
    'MarkerSize',10);

% Set axes labels and plot title
xlabel('Normalised wavelength', 'FontSize', 16);
ylabel('Normalised intensity', 'FontSize', 16);
title((strcat({'Peak temperature: '},(num2str(round(T_max(end)))),...
    ' +/- ',(num2str(round(E_T_max(end)))))),'FontSize',18);
xlim([min(nw(:,2))-0.02*max(nw(:,2)) max(nw(:,2))+0.02*max(nw(:,2))])

% Overlay linear fit to data
hold on
xline = linspace(min(nw(:,2)),max(nw(:,2)),100);
yline = polyval([m_max,C_max(end)],xline);
plot(xline,yline,'-r')
hold off
pbaspect([1 1 1])


%--------------------------------------------------------------------------
%TOP MIDDLE PLOT: Peak Temperature History
axes(handles.axes3)
cla
pbaspect([1 1 1])

errorbar(elapsedSec,T_max,E_T_max,'--bO','LineWidth',1,'MarkerEdgeColor'...
    ,'b','MarkerFaceColor','b','MarkerSize',10);

% Set axes labels and plot title
xlabel('Elapsed Time (s)', 'FontSize', 16);
ylabel('Temperature (K)', 'FontSize', 16);
title(strcat(datestr(timevector),{'  '},num2str(progress),'%'),...
    'FontSize',18);
xlim([min(elapsedSec) max(elapsedSec)+1])
pbaspect([1 1 1])


%--------------------------------------------------------------------------
%TOP RIGHT PLOT: various user options
axes(handles.axes4)
cla

% Difference Metric
if get(handles.radiobutton5,'Value') == 1    
    plot(elapsedSec,T_dif_metric,'--bO','LineWidth',1,'MarkerEdgeColor',...
        'b','MarkerFaceColor','b','MarkerSize',10);
    
    % Set axes labels and plot title
    xlabel('Elapsed Time (s)', 'FontSize', 16);
    ylabel('Image difference metric', 'FontSize', 16);
    title('Image difference metric','FontSize',18);
    xlim([min(elapsedSec) max(elapsedSec)+1])
    
% Temperature cross Sections
elseif get(handles.radiobutton6,'Value') == 1
    cla
    length(T)
    length(mu)
    % centre lines on middle of hotspot
    plot(mu,T(dx,(1:length(T))),'r',mu,T(1:length(T),dy),'g');

    % Set axes labels and plot title
    xlabel('Distance (microns)', 'FontSize', 16);
    ylabel('Temperature (K)', 'FontSize', 16);
    title('Temperature Cross Sections','FontSize',18);
    legend('horizontal','vertical','location','northeast');
    
% Emissivity vs Temperature Cross-sections
elseif get(handles.radiobutton7,'Value') == 1
    
    % centre lines on middle of hotspot
    plot(epsilon(1:length(T),dy),T(1:length(T),dy),...
        'go-','MarkerFaceColor','g');
    hold on
    plot(epsilon(dx,(1:length(T))),T(dx,(1:length(T))),...
        'ro-','MarkerFaceColor','r')
    hold off
    
    % Set axes labels and plot title
    ylabel('Temperature (K)', 'FontSize', 16);
    xlabel('Emissivity (nm^5/Jm)', 'FontSize', 16);
    title('Emissivity vs Temperature','FontSize',18);
    legend('horizontal','vertical','location','northeast');
    xlim('auto');

% Emissivity vs Temperature at the peak
elseif get(handles.radiobutton8,'Value') == 1
    cla

    errorbar(real(C_max),T_max,E_E_max,'--bO','LineWidth',1,...
        'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);

    % Set axes labels and plot title
    xlabel('Emissivity (nm^5/Jm)', 'FontSize', 16);
    ylabel('Temperature (K)', 'FontSize', 16);
    title('Emissivity vs. Temperature at peak','Fontsize',18);
    xlim('auto');

end
pbaspect([1 1 1])


%--------------------------------------------------------------------------
%BOTTOM LEFT PLOT: temperature map
axes(handles.axes5)  
cla

if ~isnan(U_max)
    % Forces Clim values to be different if they are the same to prevent
    % error 
    Clim_min=(min(min(T(T>0))));
    Clim_max=max(T(:));
    if Clim_min == Clim_max
        Clim_max = Clim_max+1;
    end
    
    imagesc(mu_pad,mu_pad,T,[Clim_min Clim_max]);

    % add colorbar and intensity contour
    originalSize = get(gca, 'Position');
    colormap(colour_scheme);
    colorbar('location','NorthOutside');
    set(gca, 'Position', originalSize);
    hold on
    contour(mu_pad,mu_pad,sb,10,'k');
    plot(mu(dy),mu(dx),'ws','LineWidth',2,'MarkerSize',10,...
        'MarkerEdgeColor','w','MarkerFaceColor','w')
    xlim([min(mu) max(mu)])
    ylim([min(mu) max(mu)])
    hold off
end

% Set axes labels and plot title
xlabel('Distance (microns)', 'FontSize', 16);
ylabel('Distance (microns)', 'FontSize', 16);
title('TEMPERATURE MAP','FontSize',18); 
pbaspect([1 1 1])


%--------------------------------------------------------------------------
%BOTTOM MIDDLE PLOT: error map
axes(handles.axes6)
cla

if ~isnan(U_max)
    % Forces Clim values to be different if they are the same to prevent
    % error 
    Clim_min=(min(E_T(:)));
    Clim_max=(max(E_T(:)));
    if Clim_min == Clim_max
        Clim_max = Clim_max+1;
    end
    
    imagesc(mu_pad,mu_pad,E_T,[Clim_min Clim_max]);

    % add colorbar and intensity contour
    originalSize = get(gca, 'Position');
    colormap(colour_scheme);
    colorbar('location','NorthOutside');
    set(gca, 'Position', originalSize);
    hold on
    contour(mu_pad,mu_pad,sb,10,'k');
    plot(mu(dy),mu(dx),'ws','LineWidth',2,'MarkerSize',10,...
        'MarkerEdgeColor','w','MarkerFaceColor','w')
    xlim([min(mu) max(mu)])
    ylim([min(mu) max(mu)])
    hold off
end

% Set axes labels and plot title
xlabel('Distance (microns)', 'FontSize', 16);
ylabel('Distance (microns)', 'FontSize', 16);
title('ERROR MAP','FontSize',18);
pbaspect([1 1 1])


%--------------------------------------------------------------------------
%BOTTOM RIGHT PLOT: difference map
axes(handles.axes7)
cla

if ~isnan(U_max)
    imagesc(mu_pad,mu_pad,T_dif,[min(Clim_min) max(Clim_max)]);

    % add colorbar and intensity contour
    originalSize = get(gca, 'Position');
    colormap(colour_scheme)
    colorbar('location','NorthOutside');
    set(gca, 'Position', originalSize);
    hold on
    contour(mu_pad,mu_pad,sb,10,'k');
    plot(mu(dy),mu(dx),'ws','LineWidth',2,'MarkerSize',10,...
        'MarkerEdgeColor','w','MarkerFaceColor','w')
    xlim([min(mu) max(mu)])
    ylim([min(mu) max(mu)])
    hold off
end

% Set axes labels and plot title
xlabel('Distance (microns)', 'FontSize', 16);
ylabel('Distance (microns)', 'FontSize', 16);
title('DIFFERENCE MAP','FontSize',18);
pbaspect([1 1 1])

end

drawnow;

end