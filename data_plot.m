function [] = data_plot(handles,nw,T_max,E_T_max,E_E_max,J_max,m_max,...
    C_max,i,filename,raw,timevector,elapsedSec,T_dif_metric,T,dx,dy,...
    progress,T_dif,mu_x,mu_y,E_T,sb,E,plot_update)
%--------------------------------------------------------------------------
% Function DATA_PLOT
%--------------------------------------------------------------------------
% Version 1.6
% Written and tested on Matlab R2014a (Windows 7) & R2017a (OS X 10.13)

% Copyright 2014 Oliver Lord, Weiwei Wang
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
% Performs all plotting tasks and is called after every new unknown file
% is processed.

% Inputs: 

%         handles: handles of GUI objects

%         nw: normalised wavelengths

%         T_max: maximum temperature

%         E_T_max: error on maximum temperature

%         E_E_max: error on maximum emissivity

%         J_max: normalised intensity of the hottest pixel

%         m_max: slope of linear fit to data

%         C_max: intercept of linear fit to data

%         i: index to determine how many files were processed

%         filename: name of the processed file

%         raw: raw image data

%         timevector: vector containing timestamp in [hrs, min, sec]

%         elapsedSec: elapsed time in seconds

%         T_dif_metric: difference metric of temperature profiles

%         T: temperature map

%         dx: x location of peak pixel

%         dy: y location of peak pixel

%         progress: progress of data processing in percentage

%         T_dif: difference map

%         mu_x: x-axis in microns

%         mu_y: y-axis in microns

%         E_T: error in temperature

%         sb: smoothed intensity map for contouring

%         E: emissivity map

%         plot_update: flag to determine if the plots should be updated

%--------------------------------------------------------------------------
% Ignore MATLAB:contour:ConstantData warning in the case when the unknown
% and the calibration file are the same and thus the matrices are flat
warning('off','MATLAB:contour:ConstantData')

%--------------------------------------------------------------------------
% Close all open files
fclose('all');

%-------------------------------------------------------------------------
% Get colour map chosen by user
contents = cellstr(get(handles.popupmenu1,'String'));
colour_scheme = contents{get(handles.popupmenu1,'Value')};

%-------------------------------------------------------------------------
% Import required .mat files
u = matfile('unknown.mat','Writable',true);

%--------------------------------------------------------------------------
% SUMMARY PLOT: raw image data
axes(handles.axes1)
imagesc(raw)

% Set axes labels and plot title
xlabel('X: pixels', 'FontSize', 14);
ylabel('Y: pixels', 'FontSize', 14);
title(filename,'FontSize',14,'Interpreter','none');

% Plot rectangle on summary plot except when this function is called from
% pushbutton2_Callback
if length(sb) > 2
    rectangle('Position',u.ROI,'EdgeColor','w',...
        'LineWidth',2);
end
axis equal

%--------------------------------------------------------------------------
% Only update remaining plots on first pass pushbutton2_Callback processing
% loop and every time when called form elsewhere
if plot_update == 1

%--------------------------------------------------------------------------
% TOP LEFT PLOT: normalised intensity vs normalised wavelength of hottest
% pixel
axes(handles.axes2)
cla
pbaspect([1 1 1])

plot(nw(:),J_max,'bO','LineWidth',1,'MarkerEdgeColor','b',...
    'MarkerSize',10);

% Set axes labels and plot title
xlabel('Normalised wavelength', 'FontSize', 14);
ylabel('Normalised intensity', 'FontSize', 14);
title((strcat({'Peak temperature: '},(num2str(round(T_max(end)))),...
    ' +/- ',(num2str(round(E_T_max(end)))))),'FontSize',14);
xlim([min(nw)-0.02*max(nw) max(nw)+0.02*max(nw)])

% Overlay linear fit to data
hold on
xline = linspace(min(nw),max(nw),100);
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
xlabel('Elapsed Time (s)', 'FontSize', 14);
ylabel('Temperature (K)', 'FontSize', 14);
title(strcat(string(timevector),{'  '},num2str(round(progress)),'%'),...
    'FontSize',14);
xlim([min(elapsedSec) max(elapsedSec)+1]);
pbaspect([1 1 1])


%--------------------------------------------------------------------------
%TOP RIGHT PLOT: various user options
axes(handles.axes4)
cla

% Difference Metric
if get(handles.radiobutton6,'Value') == 1    
    plot(elapsedSec,T_dif_metric,'--bO','LineWidth',1,'MarkerEdgeColor',...
        'b','MarkerFaceColor','b','MarkerSize',10);
    
    % Set axes labels and plot title
    xlabel('Elapsed Time (s)', 'FontSize', 14);
    ylabel('Image difference metric', 'FontSize', 14);
    title('Image difference metric','FontSize',14);
    xlim([min(elapsedSec) max(elapsedSec)+1]);
    
% Temperature cross Sections
elseif get(handles.radiobutton7,'Value') == 1
    cla
    
    % centre lines on middle of hotspot
    plot(mu_x,T((1:length(T)),dy),'r',mu_y,T(dx,(1:width(T))),'g')
    
    % Set axes labels and plot title
    xlabel('Distance (microns)', 'FontSize', 14);
    ylabel('Temperature (K)', 'FontSize', 14);
    title('Temperature Cross Sections','FontSize',14);
    legend('horizontal','vertical','location','northeast');
    
% Emissivity vs Temperature Cross-sections
elseif get(handles.radiobutton8,'Value') == 1
    
    % centre lines on middle of hotspot
    plot(E(1:length(T),dy),T(1:length(T),dy),...
        'go-','MarkerFaceColor','g');
    hold on
    plot(E(dx,(1:length(T))),T(dx,(1:length(T))),...
        'ro-','MarkerFaceColor','r')
    hold off
    
    % Set axes labels and plot title
    ylabel('Temperature (K)', 'FontSize', 14);
    xlabel('Emissivity (nm^5/Jm)', 'FontSize', 14);
    title('Emissivity vs Temperature','FontSize',14);
    legend('horizontal','vertical','location','northeast');
    xlim('auto');

% Emissivity vs Temperature at the peak
elseif get(handles.radiobutton9,'Value') == 1
    cla

    errorbar(real(C_max),T_max,E_E_max,'--bO','LineWidth',1,...
        'MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',10);

    % Set axes labels and plot title
    xlabel('Emissivity (nm^5/Jm)', 'FontSize', 14);
    ylabel('Temperature (K)', 'FontSize', 14);
    title('Emissivity vs. Peak temperature','Fontsize',14);
    xlim('auto');

end
pbaspect([1 1 1])


%--------------------------------------------------------------------------
%BOTTOM LEFT PLOT: temperature map
axes(handles.axes5)  

if ~isnan(J_max)
    % Forces Clim values to be different if they are the same to prevent
    % error 
    cmin=(min(min(T(T>0))));
    cmax=max(T(:));
    if cmin == cmax
        cmax = cmax+1;
    end
end

map_plot(mu_x,mu_y,T,[cmin cmax],colour_scheme,...
    sb,dx,dy,'TEMPERATURE MAP')

%--------------------------------------------------------------------------
%BOTTOM MIDDLE PLOT: error map
axes(handles.axes6)

if ~isnan(J_max)
    % Forces Clim values to be different if they are the same to prevent
    % error 
    cmin=(min(E_T(:)));
    cmax=(max(E_T(:)));
    if cmin == cmax
        cmax = cmax+1;
    end
end

map_plot(mu_x,mu_y,E_T,[cmin cmax],colour_scheme,...
    sb,dx,dy,'ERROR MAP')

%--------------------------------------------------------------------------
%BOTTOM RIGHT PLOT: difference map
axes(handles.axes7);

if ~isnan(J_max)

    if i == 1
        cmin = 0;
        cmax = 0.001;
    else
        ax = gca;

        cmin = ax.CLim(1);
        cmax = ax.CLim(2);

        if min(T_dif(:)) < cmin
            cmin = min(T_dif(:));
        end

        if max(T_dif(:)) > cmax
            cmax = max(T_dif(:));
        end
    end
end

map_plot(mu_x,mu_y,T_dif,[cmin cmax],colour_scheme,...
    sb,dx,dy,'DIFFERENCE MAP')

end

drawnow;

end