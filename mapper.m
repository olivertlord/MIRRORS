function [T,E,epsilon,T_max,E_max,U_max,m_max,C_max,dx,dy,sb] = mapper...
        (cal_a,cal_b,cal_c,cal_d,nw,d,a,c,b,handles)
%--------------------------------------------------------------------------
% Function MAPPER
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
%   Performes system responce calibration on raw data for each subframe and
%   then computes temperatures, errors and emissivities for each pixel by
%   fitting the Wien approximation to the Planck function to the 9 * 9 * 4
%   = 324 wavelength/intensity datapoints available in a 9 * 9 bin centered
%   on each pixel. The size of this bin is hardware dependent. In the
%   system used at Bristol, the spatial resolution is 0.2 microns per pixel
%   at the detector. This is beyond the diffraction limit, but in fact,
%   chromatic dispersion leads to a true system resolution of ~2 microns.
%   The binning chosen here is designed to replicate that reolution and
%   prevent computationally intensive oversampling.

%   INPUTS: a,b,c,d = subframes of unknown data, spatially correlated in
%           the CORRELATE function
            
%           cal_a,cal_b,cal_c,cal_d = subframes of thermal calibration
%           file, also spatially correlated using the CORRELATE function

%           nw = array of normalised wavelengths computed for the four
%           filter wavelngths used in Bristol.

%           handles = datat structure containing information on graphics
%           elements within the GUI.

%   OUTPUTS: T,E,epsilon = computed maps of temperature, error and
%            emissivity

%            T_max,E_max = peak temperature and associated error

%            U_max = array of normalised intensities used to compute the
%            peak temperature pixel

%            m_max,c_max = gradient and y-intercept of the Wien fit at the
%            peak temperature pixel

%            dx,dy = co-ordinates of the peak temperature pixel

%            sb = smoothed form of subframe b for contouring


%--------------------------------------------------------------------------   

% Performs system responce calibration of the raw data
Ja=log(a./cal_a*7.26917*670.08^5/3.7403e-12);
Jb=log(b./cal_b*9.8654*752.97^5/3.7403e-12);
Jc=log(c./cal_c*1.2078*10*851.32^5/3.7403e-12);
Jd=log(d./cal_d*4.191*578.61^5/3.7403e-12);

% Produces smoothed b quadrant for cutoff and contouring
sb = conv2(b(5:length(b)-5,5:length(b)-5),ones(9,9),'same');
sb = sb*(max(b(:))/max(sb(:)));

% Bin in x
for m=5:length(a)-5
    
    % Bin in y
    for n=5:length(a)-5
        
        % Only fit data if the peak intensity of quadrant b is larger than
        % the value set by the user AND none of the quadrants contain a
        % pixel with a value of > 99% of the bitdepth of the TIFF file
        if  ((max(sb(:))*get(handles.slider1,'value')) < sb(m-4,n-4)) &&...
                ([a(m,n) b(m,n) c(m,n) d(m,n)]) <...
                getappdata(0,'saturation_limit')
            
            % Concatenate calibrated pixels from each subframe
            u=[reshape(Ja(m-4:m+4,n-4:n+4),1,81) reshape(Jb(m-4:m+4,...
                n-4:n+4),1,81) reshape(Jc(m-4:m+4,n-4:n+4),1,81)...
                reshape(Jd(m-4:m+4,n-4:n+4),1,81)]';
            
            % Remove an -Inf values
            u(u==-Inf)=NaN;
            
            % Fit with Wien approximation to the Planck function
            [wien,bint,~]=regress(u,nw);
            
            % Determine T from fit
            T(m-4,n-4)=real((-1/wien(2)));
            
            % Determine emissivity from fit
            epsilon(m-4,n-4)=wien(1);
            
            % Determine E from fit
            etemp(m-4,n-4)=-1/(bint(2));
            E(m-4,n-4)=(abs(T(m-4,n-4)-etemp(m-4,n-4)));
            
            % Extract fitting parameters
            slope(m-4,n-4)=wien(2);
            intercept(m-4,n-4)=wien(1);
        else
            [T(m-4,n-4), E(m-4,n-4), epsilon(m-4,n-4)] = deal(NaN);  
        end
    end
end

% Perform T correction is user has selected it
% After: Walter, M. J., & Koga, K. T. (2004). The effects of chromatic
% dispersion on temperature measurement in the laser-heated diamond anvil
% cell. Physics of the Earth and Planetary Interiors, 143-144, 541?558.
% http://doi.org/10.1016/j.pepi.2003.09.019
if get(handles.checkbox2,'Value') == 1
    Ex = E - min(E(:));
    T = T - ((-0.0216.*(Ex.*Ex))+(17.882.*Ex));
end

% Determine peak temperature based on user choice
if get(handles.radiobutton1,'value') == 1   
    
    % Find max intensity point
    [~, p] = max(sb(:));
    
elseif get(handles.radiobutton2,'value') == 1
    
    % Find min E point
    E(E==0)=NaN;
    [~, p] = min(E(:));
    
elseif get(handles.radiobutton5,'Value') == 1
    
    % Find max T point
    [~, p] = max(T(:));

end

% Determine array indices of peak temperature
[pr, pc] = ind2sub(size(E),p);

% Fix to the edge if within 4 pixels of the edge, to prevent problems with
% determining U_max
pr(pr<4) = 5;
pc(pc<4) = 5;

% Output parameters of chosen point
[T_max, dx, dy, E_max,m_max, C_max] = deal(T(pr,pc), pr, pc, E(pr,pc),...
    slope(pr,pc), intercept(pr,pc));

% Concatenate array of U_max at chosen point
U_max=[reshape(Ja(pr:pr+8,pc:pc+8),1,81) reshape(Jb(pr:pr+8,pc:pc+8)...
    ,1,81) reshape(Jc(pr:pr+8,pc:pc+8),1,81)...
    reshape(Jd(pr:pr+8,pc:pc+8),1,81)]';

% Eliminate -Inf values of U_max
U_max(U_max==-Inf)=NaN;