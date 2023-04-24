function [T_dif,T_dif_metric] = difference(T, sb_a, c1, background)
%--------------------------------------------------------------------------
% Function DIFFERENCE
%--------------------------------------------------------------------------
% Written and tested on Matlab R2022b (mac)

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
% Determines the difference map between the current and previous
% normaised temperature maps, modulated by the light intensity such that
% cooler pixels carry a lower weight, to reduce the influence of edge
% effects. Also computes the average of the difference across all pixels
% to yield the image difference metric, designed to be a quantitative
% description of the change in shape of the temperature field independent
% of the change in temperature.

% Inputs:
% 
%       T          = current temperature map

%       sb         = smoothed b quadrant

%       c1         = counter 1

%       background = background intensity determined by averaging the
%                    corners of the fullframe image

% Outputs:
% 
%       T_dif        = difference map

%       T_dif_metric = average of the difference map


%--------------------------------------------------------------------------
% If intensity of image is less than 4*background, do not compute T_dif or
% T_dif_metric but still set T0_field to current T map
if (c1 == 1) || (max(sb_a(:)) < background*4)
    setappdata(0,'T0_field',(T - min(T(:)))/(max(T(:)) - min(T(:))));
    T_dif = NaN(size(T));
    T_dif_metric = NaN;
    
% Else, determine value of T_dif and T_dif_metric
% Modified from: Briggs, R., Daisenberger, D., Lord, O. T., Salamat, A.,
% Bailey, E., Walter, M. J., & McMillan, P. F. (2017). High-pressure
% melting behavior of tin up to 105 GPa. Physical Review B, 95(5), 054102.
% http://doi.org/10.1103/PhysRevB.95.054102 (See Supplementary Information)
else
    % Get previous normalised temperature map
    T0_field = getappdata(0,'T0_field');
    
    % Compute current normalised temperature map
    T1_field = (T - min(T(:)))/(max(T(:)) - min(T(:)));
    
    % Compute current normalised intensity map
    I1_field = (sb_a - min(sb_a(:)))/(max(sb_a(:)) - min(sb_a(:)));

    % Compute intensity weighted difference map
    T_dif = abs(T1_field-T0_field).*I1_field;
    
    % Compute average difference metric
    T_dif_metric = mean(T_dif(:),'omitnan');
    
    T0_field = T1_field;
    setappdata(0,'T0_field',T0_field);
    %sets intial T field to current T map
end