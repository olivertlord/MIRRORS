function [area_x_tl,area_y_tl,area_width_x,area_width_y,ROI_x_tl,...
    ROI_y_tl, ROI_width] = calculate_ROI(u,hp)
%--------------------------------------------------------------------------
% Function calculate_ROI
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
% Calculates the parameters describing the user selected ROI

% Inputs:
%     u:  structure (unknown)
%     hp: structure (hardware parameters
%
% Outputs:
%     area_x_tl:    scalar (x co-ordinate of top left corner of drawn area)
%     area_y_tl:    scalar (y co-ordinate of top left corner of drawn area)
%     area_width_x: scalar (x width of ROI)
%     area_width_y: scalar (y width of ROI)
%     ROI_x_tl:     scalar (x co-ordinate of top left corner of ROI)
%     ROI_y_tl:     scalar (y co-ordinate of top left corner of ROI)
%     ROI_width:    scalar (width of largest square ROI within drawn area)


%--------------------------------------------------------------------------
% Find centre of quadrant
[a,~,~,~] = divide(u.unk);
[y,x] = size(a);

% Maximum correlation displacement in x
max_disp_x = max(abs([u.u_bxa u.u_cxa u.u_dxa u.u_bxa u.u_cxa u.u_dxa]));

% Maximum correlation displacement in y
max_disp_y = max(abs([u.u_bya u.u_cya u.u_dya u.u_bya u.u_cya u.u_dya]));

% Determine the X and Y co-ordinates of the top left corner of the drawing
% area and its width and height
area_x_tl = hp.bhw + max_disp_x;
area_y_tl = hp.bhw + max_disp_y;
area_width_x = x-(area_x_tl*2);
area_width_y = y-(area_y_tl*2);

% Determine the X and Y co-ordinates of the top left corner of the largest
% possible square ROI centered within the drawing area
ROI_width = min(area_width_x, area_width_y);
ROI_x_tl = area_x_tl+((area_width_x-ROI_width)/2);
ROI_y_tl = area_y_tl+((area_width_y-ROI_width)/2);