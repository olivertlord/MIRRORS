function [] = plot_axes(xlab, ylab, title_string, x, y, plot_type, dy, dx, sb, microns)
%--------------------------------------------------------------------------
% Function PLOT_AXES
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
%   Detailed explanation goes here

x(x==0) = -1;
if strcmp(title_string,'Image difference metric') == 0
    y(y==0) = 1;
else
    y(isnan(y)) = 0;
end
if length(y) == 1
    y(isnan(y)) = 0.00001;
end
if strcmp(title_string,'Image difference metric') == 0
    ylim ([(nanmin(y(:))-0.01*nanmin(y(:))) (nanmax(y(:))+0.01*nanmax(y(:)))])
else
    if isempty(y(y>0)) == 1
        ylim ([min(y) 0.00001])
    else
        ylim ([min(y(y>0)) max(y+0.00001)])
    end
end

xlim ([(nanmin(x(:))-0.01*nanmin(x(:))) abs((nanmax(x(:))+0.01*nanmax(x(:))))])
xlabel(xlab, 'FontSize', 16);
ylabel(ylab, 'FontSize', 16);
title(title_string, 'FontSize', 18);

if plot_type == 1
    originalSize = get(gca, 'Position');
    colormap jet;
    colorbar('location','NorthOutside');
    set(gca, 'Position', originalSize);
    hold on
    contour(microns,microns,sb,10,'k');
    plot(microns(dy),microns(dx),'ws','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','w','MarkerFaceColor','w')
    hold off
end
drawnow;
end

