function [elapsedSec,T_max,E_T_max,T_diff_metric] = fit(filename,...
    filepath,i,u,c,hp,c1,handles,savename,writerObj,elapsedSec,T_max,...
    E_T_max,T_diff_metric,ttwb)

%--------------------------------------------------------------------------
% Function fit
%--------------------------------------------------------------------------
% Written and tested on Matlab R2022b (mac)

% Copyright 2018 Oliver Lord, Weiwei Wang email: oliver.lord@bristol.ac.uk
 
% This file is part of MIRRORS.
 
% MIRRORS is free software: you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.
 
% MIRRORS is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
% more details.
 
% You should have received a copy of the GNU General Public License along
% with MIRRORS.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
% Performs a fit on a single image.

% Inputs:

%       filename      = A string or cell array containing the name of the
%                       file to be processed.
%       
%       filepath      = A string or cell array containing the path to the
%                       file tobe processed.
%         
%       i             = An integer indicating the index of the file to be
%                       processed.
%         
%       u             = A structure containing parameters related to the
%                       unknown file.
%         
%       c             = A structure containing parameters related to the
%                       calibration file.
%         
%       hp            = A structure containing hyperparameters used for
%                       image processing.
%         
%       c1            = An integer indicating the current file number being
%                       processed.
%         
%       handles       = A structure containing handles to the GUI objects.
%         
%       savename      = A string indicating the name of the file to save
%                       the processed data to.
%         
%       writerObj     = A MATLAB video writer object used to write frames
%                       to a movie.
%         
%       elapsedSec    = A vector containing elapsed time values for each
%                       processed file.
%         
%       T_max         = A vector containing maximum temperature values for
%                       each processed file.
%         
%       E_T_max       = A vector containing maximum error values for each
%                       processed file.
%         
%       T_diff_metric = A vector containing difference metric values for
%                       each processed file.
%         
%       ttwb          = A tooltip waitbar object.

%--------------------------------------------------------------------------

% Extract filename from cell array
[filename,filepath] = get_path(filename,filepath,i);

% Reads in unknown file and convert to double precision
raw = imread(filepath);
unk = im2double(raw);

% Subtracts background from raw image
unk = unk-background(unk);

% Subtract background from calibration file. Note that this is the
% background determined from the current unknown, applied retrospectively
% to the calibration file. This is technically unreasonable, but
% determining a true background for the calibration file, which may consist
% of images that completely fill the frame, by looking at the corners or
% edges is risky.
cal = c.cal-background(unk);

% For the first file that arrives determine spatial correlation parameters,
% if we are in live mode
if (c1 == 1) && (isequal(get(handles.pushbutton1,'BackgroundColor'),...
        [0 .8 0]))       
    [u.u_bya, u.u_bxa, u.u_cya, u.u_cxa, u.u_dya, u.u_dxa] = ...
        correlate(unk);

    % Determine ROI parameters
    [~,~,~,~,ROI_x_tl,ROI_y_tl,ROI_width] = calculate_ROI(u,hp);
    u.ROI = [ROI_x_tl ROI_y_tl ROI_width ROI_width];
end

% Extract ROI from each quadrant of unknown using offsets determined in
% correlate function
[unk_a, unk_b, unk_c, unk_d] = extract_ROI(unk,u.ROI,...
	u.u_bya, u.u_bxa, u.u_cya, u.u_cxa, u.u_dya, u.u_dxa);

% Extract ROI from each quadrant of cal using offsets determined in
% correlate function
[cal_a, cal_b, cal_c, cal_d] = extract_ROI(cal,u.ROI,...
	c.c_bya, c.c_bxa, c.c_cya, c.c_cxa, c.c_dya, c.c_dxa);

% Fit data
[T,E_T,E_E,E,T_max(c1),E_T_max(c1),E_E_max(c1),U_max,m_max,...
	C_max(c1),dx,dy,sb,nw] = mapper(unk_a,unk_b,unk_c,unk_d,...
	cal_a, cal_b, cal_c, cal_d, handles);

% Pixel to micron conversion
mu_x = linspace(-(size(T,2)/2)*hp.resolution,...
	(size(T,2)/2)*hp.resolution,size(T,1));
mu_y = linspace(-(size(T,1)/2)*hp.resolution,...
	(size(T,1)/2)*hp.resolution,size(T,2));

% Calls difference function to calculate the difference map and associated
% metric.
[T_dif,T_dif_metric(c1)] = difference(T, sb, c1, background(unk));

% Create concatenated summary output array and save to workspace and save
% current map data to .txt file if Save Output checkbox ticked
[timestamp,elapsedSec(c1)] = data_output(handles,filename,...
	c1,T_max(c1),E_T_max(c1),C_max(c1),E_E_max(c1),...
	T_dif_metric(c1),T,E_T,E,E_E,T_dif,mu_x,mu_y,sb,savename);

% Calculate progress
if isequal(get(handles.pushbutton2,'BackgroundColor'), [0 .8 0])
    tmp = u.listpos;
    progress = c1/sum(tmp(1,:) == 1)*100;
else
    progress = 100;
end
	
% Calls data_plot function
data_plot(handles,nw,T_max,E_T_max,E_E_max,U_max,m_max,C_max,i,...
	filename,unk,timestamp,elapsedSec,T_dif_metric,T,dx,dy,...
	progress,T_dif,mu_x,mu_y,E_T,sb,E,1);

% Update progress bar
tooltipwaitbar(ttwb, progress);

% Writes current GUI frame to movie
if get(handles.checkbox2,'Value') == 1
	movegui(gcf,'center')
	frame=getframe(gcf);
	writeVideo(writerObj,frame);
end

end