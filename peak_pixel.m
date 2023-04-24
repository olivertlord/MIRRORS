function [dx, dy, T_max, E_T_max, E_E_max, m_max, C_max, J_max] =...
    peak_pixel(T, E_T, E_E, m, C, idx, bhw, bsz, Ja, Jb, Jc, Jd)
%--------------------------------------------------------------------------
% Function peak_pixel
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
% Determines parameters at the user-chosen peak pixel.

% Inputs:
% 
%     T   = 2D matrix of temperatures

%     E_T = 2D matrix of error in temperature

%     E_E = 2D matrix of error in the emissivity

%     m   = 2D matrix of slope of fit

%     C   = 2D matrix of intercept of fit

%     idx = index of the chosen peak pixel

%     bhw = border half-width of the window used to extract the J matrix

%     bsz = window width

%     Ja, Jb, Jc, Jd = 2D matrix of normalised intensities of quadrants
% 
% Outputs:
% 
%     dx      = x-coordinate of the chosen peak point

%     dy      = y-coordinate of the chosen peak point

%     T_max   = temperature at the chosen peak point

%     E_T_max = error in temperature at the chosen peak point

%     E_E_max = error in emissivity at the chosen peak point

%     m_max   = slope of fit at the chosen peak point

%     C_max   = mintercept of fit at the chosen peak point

%     J_max   = normalised intensity at the chosen peak point

%--------------------------------------------------------------------------

% Determine indices of selected peak and pass to variables dx and dy so
% that peak position / cross sections can be plotted
[dx, dy] = ind2sub(size(T),idx);

% Output parameters of chosen point
[T_max,E_T_max,E_E_max,m_max,C_max] = deal(mean(T(idx),'omitnan'),...
    mean(E_T(idx),'omitnan'),mean(E_E(idx),'omitnan'),...
    mean(m(idx),'omitnan'),mean(C(idx),'omitnan'));    

% Fix to the edge if within 4 pixels of the edge, to prevent problems
% with determining U_max

dx(dx<bhw) = bhw+1;
dy(dy<bhw) = bhw+1;

% Concatenate array of U_max at chosen point
J_max=[reshape(Ja(dx-bhw:dx+bhw,dy-bhw:dy+bhw),1,bsz^2)...
       reshape(Jb(dx-bhw:dx+bhw,dy-bhw:dy+bhw),1,bsz^2)...
       reshape(Jc(dx-bhw:dx+bhw,dy-bhw:dy+bhw),1,bsz^2)...
       reshape(Jd(dx-bhw:dx+bhw,dy-bhw:dy+bhw),1,bsz^2)]';   