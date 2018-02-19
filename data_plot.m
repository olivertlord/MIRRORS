function [] = data_plot(handles,nw,T_max,E_max,U_max,m_max,C_max,i,...
    filenumber,raw,timevector,elapsedSec,T_dif_metric,T,dx,dy,microns,...
    progress,T_dif,E,Clim_min,Clim_max,sb,writerObj)

%--------------------------------------------------------------------------
% Function DATA_PLOT
%--------------------------------------------------------------------------
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
%   Detailed description goes here


%--------------------------------------------------------------------------
% SUMMARY PLOT: raw image data
axes(handles.axes1)
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

% Plot rectangle on summary plot
rectangle('Position',getappdata(0,'subframe'),'EdgeColor','w',...
    'LineWidth',2);


%--------------------------------------------------------------------------
% TOP LEFT PLOT: normalised intensity vs normalised wavelength of hottest
% pixel
axes(handles.axes2)
plot(nw(:,2),U_max,'bO','LineWidth',1,'MarkerEdgeColor','b',...
    'MarkerSize',10);

% Set axes labels and plot title
xlabel('Normalised wavelength', 'FontSize', 16);
ylabel('Normalised intensity', 'FontSize', 16);
title((strcat({'Peak temperature: '},(num2str(round(T_max(end)))),' +/- ',...
    (num2str(round(E_max(end)))))),'FontSize',18);
xlim([min(nw(:,2))-0.02*max(nw(:,2)) max(nw(:,2))+0.02*max(nw(:,2))])

% Overlay linear fit to data
hold on
xline = linspace(min(nw(:,2)),max(nw(:,2)),100);
yline = polyval([m_max,C_max],xline);
plot(xline,yline,'-r')
hold off


%--------------------------------------------------------------------------
%TOP MIDDLE PLOT: Peak Temperature History
axes(handles.axes3)
errorbar(elapsedSec,T_max,E_max,'--bO','LineWidth',1,'MarkerEdgeColor','b',...
    'MarkerFaceColor','b','MarkerSize',10);

% Set axes labels and plot title
xlabel('Elapsed Time (s)', 'FontSize', 16);
ylabel('Temperature (K)', 'FontSize', 16);
title(strcat(datestr(timevector),{'  '},num2str(progress),'%'),...
    'FontSize',18);
xlim([min(elapsedSec) max(elapsedSec)+1])


%--------------------------------------------------------------------------
%TOP RIGHT PLOT: various user options
axes(handles.axes4)

% Difference Metric
if get(handles.radiobutton4,'Value') == 1    
    plot(elapsedSec,T_dif_metric,'--bO','LineWidth',1,'MarkerEdgeColor',...
        'b','MarkerFaceColor','b','MarkerSize',10);
    
    % Set axes labels and plot title
    xlabel('Elapsed Time (s)', 'FontSize', 16);
    ylabel('Image difference metric', 'FontSize', 16);
    title('Image difference metric','FontSize',18);
    xlim([min(elapsedSec) max(elapsedSec)+1])
    
% Cross Sections
else
    plot(microns,T(dx,(1:length(T))),'r',microns,T(1:length(T),dy),'g');
    
    % Set axes labels and plot title
    xlabel('Distance (microns)', 'FontSize', 16);
    ylabel('Temperature (K)', 'FontSize', 16);
    title('Temperature Cross Sections','FontSize',18);
    legend('horizontal','vertical');
end


%--------------------------------------------------------------------------
%BOTTOM LEFT PLOT: temperature map
axes(handles.axes5)   

if ~isnan(U_max)
    imagesc(microns,microns,T,[(min(min(T(T>0)))) max(T(:))]);

    % Add colorbar and intensity contour
    originalSize = get(gca, 'Position');
    colormap jet;
    colorbar('location','NorthOutside');
    set(gca, 'Position', originalSize);
    hold on
    contour(microns,microns,sb,10,'k');
    plot(microns(dy),microns(dx),'ws','LineWidth',2,'MarkerSize',10,...
        'MarkerEdgeColor','w','MarkerFaceColor','w')
    hold off
end

% Set axes labels and plot title
xlabel('Distance (microns)', 'FontSize', 16);
ylabel('Distance (microns)', 'FontSize', 16);
title('TEMPERATURE MAP','FontSize',18); 

%--------------------------------------------------------------------------
%BOTTOM MIDDLE PLOT: error map
axes(handles.axes6)

if ~isnan(U_max)
    imagesc(microns,microns,E,[(min(E(:))) (max(E(:)))]);

    % Add colorbar and intensity contour
    originalSize = get(gca, 'Position');
    colormap jet;
    colorbar('location','NorthOutside');
    set(gca, 'Position', originalSize);
    hold on
    contour(microns,microns,sb,10,'k');
    plot(microns(dy),microns(dx),'ws','LineWidth',2,'MarkerSize',10,...
        'MarkerEdgeColor','w','MarkerFaceColor','w')
    hold off
end

% Set axes labels and plot title
xlabel('Distance (microns)', 'FontSize', 16);
ylabel('Distance (microns)', 'FontSize', 16);
title('ERROR MAP','FontSize',18);

%--------------------------------------------------------------------------
%BOTTOM RIGHT PLOT: difference map
axes(handles.axes7)

if ~isnan(U_max)
    imagesc(microns,microns,T_dif,[min(Clim_min) max(Clim_max)]);

    % Add colorbar and intensity contour
    originalSize = get(gca, 'Position');
    colormap jet;
    colorbar('location','NorthOutside');
    set(gca, 'Position', originalSize);
    hold on
    contour(microns,microns,sb,10,'k');
    plot(microns(dy),microns(dx),'ws','LineWidth',2,'MarkerSize',10,...
        'MarkerEdgeColor','w','MarkerFaceColor','w')
    hold off
end

% Set axes labels and plot title
xlabel('Distance (microns)', 'FontSize', 16);
ylabel('Distance (microns)', 'FontSize', 16);
title('DIFFERENCE MAP','FontSize',18);

drawnow;

end