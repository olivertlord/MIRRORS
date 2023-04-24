function [] = map_plot(x,y,map,clim,colour_scheme,...
    contour_matrix,dx,dy,plot_title)
%--------------------------------------------------------------------------
% Function map_plot
%--------------------------------------------------------------------------
% Written and tested on Matlab 2022b (mac)

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
%   Determines parameters at the user-chosen peak pixel.

%   INPUTS:  x,y,map,Clim_min,Clim_max,colour_scheme,...
%    contour_matrix,dx,dy,title

%   OUTPUTS: NONE

%--------------------------------------------------------------------------
cla

% Plot matrix
imagesc(x,y,map,clim);

% Set NaNs to transparent
%set(h, 'AlphaData', ~isnan(map))

% Add colorbar and intensity contour
originalSize = get(gca, 'Position');
colormap(colour_scheme);
colorbar('location','NorthOutside');
set(gca, 'Position', originalSize);

% Plot contour
hold on
contour(y*(length(y)/length(x)),x*(length(x)/length(y)),contour_matrix,10,'w');
plot(y(dy),x(dx),'ws','LineWidth',2,'MarkerSize',10,...
    'MarkerEdgeColor','w','MarkerFaceColor','w')

% Update plot limits
xlim([min(min(x),min(y)) max(max(x),max(y))]);
ylim([min(min(x),min(y)) max(max(x),max(y))]);
hold off

% Set axes labels and plot title
xlabel('Distance (microns)', 'FontSize', 14);
ylabel('Distance (microns)', 'FontSize', 14);
title(plot_title,'FontSize',14); 
pbaspect([1 1 1])