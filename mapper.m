function [T,E_T,E_E,epsilon,T_max,E_T_max,E_E_max,U_max,m_max,C_max,pr,...
    pc,sb,nw] = mapper(cal_a,cal_b,cal_c,cal_d,d,a,c,b,handles,filepath)
%--------------------------------------------------------------------------
% Function MAPPER
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

%   Based on the concepts detailed in: 

%   1/Campbell, A. J. (2008). Measurement of temperature distributions
%   across laser heated samples by multispectral imaging radiometry. Review
%   of Scientific Instruments, 79(1), 015108.
%   http://doi.org/10.1063/1.2827513

%   2/Walter, M. J., & Koga, K. T. (2004). The effects of chromatic
%   dispersion on temperature measurement in the laser-heated diamond anvil
%   cell. Physics of the Earth and Planetary Interiors, 143-144, 541?558.
%   http://doi.org/10.1016/j.pepi.2003.09.019

%   INPUTS: a,b,c,d = subframes of unknown data, spatially correlated in
%           the CORRELATE function
            
%           cal_a,cal_b,cal_c,cal_d = subframes of thermal calibration
%           file, also spatially correlated using the CORRELATE function

%           nw = array of normalised wavelengths computed for the four
%           filter wavelngths used in Bristol.

%           handles = data structure containing information on graphics
%           elements within the GUI.

%   OUTPUTS: T,E_T,E_E,epsilon = computed maps of temperature, temperature 
%            error, emissivity error and emissivity

%            T_max,E_T_max,E_E_max = peak temperature and associated error
%            in temperature and emissivity

%            U_max = array of normalised intensities used to compute the
%            peak temperature pixel

%            m_max,c_max = gradient and y-intercept of the Wien fit at the
%            peak temperature pixel

%            pr,pc = co-ordinates of the peak temperature pixel

%            sb = smoothed form of subframe b for contouring


%--------------------------------------------------------------------------   

% Constant c1 = 2hc^2*?*1e4 in W cm2 where h is Planck's constant in J s, c
% is the speed of light in m s-1, ? = 3.1415926
c1 = 3.74177e-12;

% Constant c2 = hc/k*1e9 nm K where h is Planck's constant in J s, c is the
% speed of light in m s-1 and k is Boltzmann's constant in J K-1.
c2 = 14387773.54;

%//////////////////////////////////////////////////////////////////////////
% HARDWARE SPECIFIC - REQUIRES EDITING
% Wavelengths in nm
wa = 670.08; %top left
wb = 851.32; %bottom left
wc = 752.97; %top right
wd = 578.61; %bottom right

% Values of Spectral Radiance of calibration source at each wavelength in 
sr_wa = 7.26917; 
sr_wb = 12.0780; 
sr_wc = 9.86540;
sr_wd = 4.19100;

% Width of CCD pixels in microns
pixel_width = 9;

% Magnification of temperature measurement system
system_mag = 50;

% Numerical aperture of system
NA = .26;
%//////////////////////////////////////////////////////////////////////////

% Determines normalised wavelengths for the four filters
nwa = c2/wa; %top left
nwb = c2/wb; %bottom left
nwc = c2/wc; %top right
nwd = c2/wd; %bottom right

% Performs system responce calibration of the raw data and calculates
% normalised intensities
Ja=log(a./cal_a*sr_wa*wa^5/c1);
Jb=log(b./cal_b*sr_wb*wb^5/c1);
Jc=log(c./cal_c*sr_wc*wc^5/c1);
Jd=log(d./cal_d*sr_wd*wd^5/c1);

% Calculate CCD resolution at the image plane
resolution = pixel_width/system_mag;

% Calculate the Abbe diffraction limit of the system
diff_limit = (max([wa wb wc wd])/1000)/(2*NA);

% Calculate bin size required to match diffraction limited system
% resolution
bsz = 2*floor((diff_limit/resolution)/2)+1;

% Calculate integer half-width of bin
bhw = (bsz-1)/2;

% Calculate ROI border width
bw = bhw+1;

% Concatenate normalised wavelengths for fitting
nw = horzcat(ones(bsz^2*4,1),[repmat(nwa,bsz^2,1);repmat(nwb,bsz^2,1);...
    repmat(nwc,bsz^2,1);repmat(nwd,bsz^2,1);]);

% Produces smoothed b quadrant for cutoff and contouring
sb = conv2(b(bw:length(b)-bw,bw:length(b)-bw),ones(bsz,bsz),'same');
sb = sb*(max(b(:))/max(sb(:)));

% Set intensity limit
il = max(sb(:))*get(handles.slider1,'value');

% Automaticlly determines the bit depth of the .TIFF files being used
% and sets the saturation limit to 99% of that value
image_info = imfinfo(char(filepath));
sl = 2^image_info.BitDepth*.99;

% Pre-allocate arrays with NaN
[T,E_T,E_E,epsilon,t_error,slope,intercept] = deal(NaN(length(sb)));

% Loop over ROI to determine temperature and emissivity at each pixel
% Bin in x
for m=bw:length(a)-bw
    
    % Bin in y
    for n=bw:length(a)-bw

        % Only fit data if the peak intensity of quadrant b is larger than
        % the value set by the user AND none of the quadrants contain a
        % pixel with a value of > 99% of the bitdepth of the TIFF file
        if  il < sb(m-bhw,n-bhw) & a(m,n) < sl & b(m,n) < sl...
                & c(m,n) < sl & d(m,n)< sl
            
            % Concatenate calibrated pixels from each subframe
            u=[reshape(Ja(m-bhw:m+bhw,n-bhw:n+bhw),1,bsz^2)...
                reshape(Jb(m-bhw:m+bhw,n-bhw:n+bhw),1,bsz^2)...
                reshape(Jc(m-bhw:m+bhw,n-bhw:n+bhw),1,bsz^2)...
                reshape(Jd(m-bhw:m+bhw,n-bhw:n+bhw),1,bsz^2)]';
                   
            % Remove an -Inf values
            u(u==-Inf)=NaN;
            
            % Fit with Wien approximation to the Planck function
            [wien,bint,~]=regress(u,nw);
            
            % Determine T from fit
            T(m-bhw,n-bhw)=real((-1/wien(2)));
            
            % Determine emissivity from fit
            epsilon(m-bhw,n-bhw)=wien(1);
            
            % Determine error in temperature from fit
            t_error(m-bhw,n-bhw)=-1/(bint(2));
            E_T(m-bhw,n-bhw)=(abs(T(m-bhw,n-bhw)-t_error(m-bhw,n-bhw)));
            
            % Determine error in emissivity from fit
            E_E(m-bhw,n-bhw)=(abs(epsilon(m-bhw,n-bhw)-bint(1)));
            
            % Extract fitting parameters
            slope(m-bhw,n-bhw)=wien(2);
            intercept(m-bhw,n-bhw)=wien(1);  
        end
    end
end

% Perform T correction if user has selected it. In this implementation it
% is assumed that the error associated with the maximum intensity pixel is
% optimal and that any error greater than that value is due to chromatic
% aberration.
% After: Walter, M. J., & Koga, K. T. (2004). The effects of chromatic
% dispersion on temperature measurement in the laser-heated diamond anvil
% cell. Physics of the Earth and Planetary Interiors, 143-144, 541?558.
% http://doi.org/10.1016/j.pepi.2003.09.019
if get(handles.checkbox2,'Value') == 1
    [~, p] = max(sb(:));
    [pr, pc] = ind2sub(size(E_T),p);
    Ex = E_T - E_T(pr,pc);
    T = T - ((-0.0216.*(Ex.*Ex))+(17.882.*Ex));
end

% Determine peak temperature based on user choice
if get(handles.radiobutton1,'value') == 1   
    
    % Find max intensity point
    [~, p] = max(sb(:));
    
elseif get(handles.radiobutton2,'value') == 1
    
    % Find min E point
    E_T(E_T==0)=NaN;
    [~, p] = min(E_T(:));
    
elseif get(handles.radiobutton3,'Value') == 1
    
    % Find max T point
    [~, p] = max(T(:));
    
elseif get(handles.radiobutton7,'Value') == 1
    
    % Cutoff for averaging
    cut = 0.8*max(sb(:));
    points = length(sb(sb>cut));
    
    % Re-create U_max from all pixels for which the corresponding pixel in
    % sb is > cut
    U_max = [reshape(Ja(sb>cut),1,points) reshape(Jb(sb>cut),1,points)...
        reshape(Jc(sb>cut),1,points) reshape(Jd(sb>cut),1,points)]';
    
    % Re-calculate nw due to new length of U_max
    nw = horzcat(ones(points*4,1),[repmat(nwa,points,1); repmat(nwb,...
        points,1); repmat(nwc,points,1);repmat(nwd,points,1);]);
    
    % Fit with Wien approximation to the Planck function to the new U_max
    % and nw values
    [wien,~,~]=regress(U_max,nw);
    
    % Extract fitting parameters
    m_max = wien(2);
    C_max = real(wien(1));
    
    % Find average T within top 10 percentile intensity contour, and
    % associated standard error
    [T_max,E_T_max,E_E_max] = deal(nanmean(T(sb>cut)),...
        std(T(sb>cut))/sqrt(points),std(intercept(sb>cut))/sqrt(points));
    
    % Determine indices of max intensity peak and pass to variables pr
    % and pc so that peak position / cross sections can be plotted
    [~, p] = max(sb(:));
    [pr, pc] = ind2sub(size(sb),p);

end

% Compute variables if maximum intensity, minimum error or maximum
% temperature selected by user
if get(handles.radiobutton7,'Value') ~= 1
    
    % Determine indices of selected peak and pass to variables pr and pc so
    % that peak position / cross sections can be plotted
    [pr, pc] = ind2sub(size(E_T),p);
    
    % Output parameters of chosen point
    [T_max,E_T_max,E_E_max,m_max,C_max] = deal(nanmean(T(p)),...
        nanmean(E_T(p)),nanmean(E_E(p)),nanmean(slope(p)),...
        nanmean(intercept(p)));    
    
    % Fix to the edge if within 4 pixels of the edge, to prevent problems
    % with determining U_max
    pr(pr<bhw) = bw;
    pc(pc<bhw) = bw;
    
    % Concatenate array of U_max at chosen point
    U_max=[reshape(Ja(pr:pr+bhw*2,pc:pc+bhw*2),1,bsz^2)... 
        reshape(Jb(pr:pr+bhw*2,pc:pc+bhw*2),1,bsz^2)...
        reshape(Jc(pr:pr+bhw*2,pc:pc+bhw*2),1,bsz^2)...
        reshape(Jd(pr:pr+bhw*2,pc:pc+bhw*2),1,bsz^2)]';    
end

% Eliminate -Inf values of U_max
U_max(U_max==-Inf)=NaN;