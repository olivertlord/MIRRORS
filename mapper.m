function [T,sigT,sigE,E,T_max,sigT_max,sigE_max,J_max,m_max,C_max,dx,...
    dy,ni,nw] = mapper(unk_a,unk_b,unk_c,unk_d,cal_a,cal_b,cal_c,cal_d,...
    handles)
%--------------------------------------------------------------------------
% Function MAPPER
%--------------------------------------------------------------------------
% Version 1.6 Written and tested on Matlab R2014a (Windows 7) & R2017a (OS
% X 10.13)

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
% Performes system responce calibration on raw data for each subframe and
% then computes temperatures, errors and emissivities for each pixel by
% fitting the Wien approximation to the Planck function to the
% wavelength/intensity datapoints within a bin. The size of this bin is
% hardware dependent. In the system used at Bristol, the spatial
% resolution is 0.2 microns per pixel at the detector. This is beyond the
% diffraction limit, but in fact, chromatic dispersion leads to a true
% system resolution of ~2 microns. The binning chosen here is designed to
% replicate that reolution and prevent computationally intensive
% oversampling.
% 
% Based on the concepts detailed in:
% 
% 1/Campbell, A. J. (2008). Measurement of temperature distributions
% across laser heated samples by multispectral imaging radiometry. Review
% of Scientific Instruments, 79(1), 015108.
% http://doi.org/10.1063/1.2827513
% 
% 2/Walter, M. J., & Koga, K. T. (2004). The effects of chromatic
% dispersion on temperature measurement in the laser-heated diamond anvil
% cell. Physics of the Earth and Planetary Interiors, 143-144, 541?558.
% http://doi.org/10.1016/j.pepi.2003.09.019

% Inputs:
% 
%       unk_a   = a matrix of uncalibrated raw pixel data from quadrant A
%     
%       unk_b   = a matrix of uncalibrated raw pixel data from quadrant B
%       
%       unk_c   = a matrix of uncalibrated raw pixel data from quadrant C
%     
%       unk_d   = a matrix of uncalibrated raw pixel data from quadrant D
%     
%       cal_a   = a matrix of calibration pixel data for quadrant A 
%       
%       cal_b   = a matrix of calibration pixel data for quadrant B 
% 
%       cal_c   = a matrix of calibration pixel data for quadrant C 
% 
%       cal_d   = a matrix of calibration pixel data for quadrant D 
% 
%       handles = a structure containing handles to GUI objects
% 
% Outputs:
% 
%       T        = a 2D array of temperature values calculated using the
%                  Wien approximation to Planck's law
% 
%       sigT     = a 2D array of temperature error
% 
%       sigE     = a 2D array of error values in the emissivity calculation
% 
%       E        = a 2D array of emissivity values 
% 
%       T_max    = the temperature at the peak pixel
%     
%       sigT_max = the error in the temperature at the peak pixel
% 
%       sigE_max = the error in the emissivity at the peak pixel
% 
%       J_max    = the normalised intensity at the peak pixel
% 
%       m_max    = the slope of the Planck's law fit at the peak pixel
% 
%       C_max    = the intercept of the Planck's law fit at the peak pixel
% 
%       dx       = the x co-ordinate of the peak pixel
% 
%       dy       = the y co-ordinate of the peak pixel
% 
%       ni       = a 2D array of normalised intensities within the ROI
% 
%       nw       = a vector of normalised wavelengths for the four filters

%--------------------------------------------------------------------------

% Constant c1 = 2hc^2*pi*1e4 in W cm2 where h is Planck's constant in J s,
% c is the speed of light in m s-1
c1 = 3.74177e-12;

% Constant c2 = hc/k*1e9 nm K where h is Planck's constant in J s, c is the
% speed of light in m s-1 and k is Boltzmann's constant in J K-1.
c2 = 14387773.54;

% Load current hardware_parameters
load('hardware_parameters.mat','bhw','bsz','wa','wb','wc','wd','sr_wa',...
    'sr_wb','sr_wc','sr_wd');

% Determines normalised wavelengths for the four filters
nwa = c2/wa; %top left
nwb = c2/wb; %bottom left
nwc = c2/wc; %top right
nwd = c2/wd; %bottom right

% Concatenate normalised wavelengths
nw = [repmat(nwa,bsz^2,1);repmat(nwb,bsz^2,1);...
    repmat(nwc,bsz^2,1);repmat(nwd,bsz^2,1);];

% Performs system responce calibration of the raw data and calculates
% normalised intensities within the ROI
Ja=real(log(unk_a./cal_a*sr_wa*wa^5/c1));
Jb=real(log(unk_b./cal_b*sr_wb*wb^5/c1));
Jc=real(log(unk_c./cal_c*sr_wc*wc^5/c1));
Jd=real(log(unk_d./cal_d*sr_wd*wd^5/c1));

% Create 3D array stack of the ROI and remove any -Inf values
Jabcd = cat(3,Ja,Jb,Jc,Jd);
Jabcd(Jabcd==-Inf)=NaN;

% Create vector where each column contains a square bin of side bsz around
% each pixel pixel in the ROI
J_bin = im2col3(Jabcd, [bsz bsz 4], [1 1 4]);

% Create vector in which each column contains the mean of the intensity in
% the bin and then normalise between 0 and 1.
Js = mean(J_bin(:,:));
ni = (Js - min(Js(:))) / (max(Js(:)) - min(Js(:)));

% Create 3D array stacks of raw quadrants
unk_abcd = cat(3,unk_a,unk_b,unk_c,unk_d);

% Switch between 3-color and 4-color depending on state of buttons state
if isequal(get(handles.pushbutton15,'BackgroundColor'),[0 .8 0])

    % Determine which quadrant is the dimmest
    [~,idx] = min(unk_abcd(:));
    [~,~,v] = ind2sub(size(unk_abcd),idx);

    % NaN nw values to prevent fitting
    start = (v*(bsz^2))-((bsz^2)-1);
    nw(start:(start+(bsz^2))-1) = NaN;
end

% Set upper and lower intensity limits
uil = 0.98;
lil = get(handles.slider1,'value');

% Create maximum value array and vectorise
mva = max(unk_abcd,[],3);
mvv = im2col(mva(bhw+1:length(mva)-bhw,bhw+1:width(mva)-bhw), [1 1],...
    'sliding');

% Fit each patch using the Wien approximation to Planck's law
[parms,se] = deal(repmat([NaN; NaN], 1, width(J_bin)));
for i=1:width(J_bin)

    % Only fit if average intensity of patch is greater than limit
    if  (ni(i) > lil) && (mvv(i) < uil)

        % Perform linear regression
        [parms(:,i),bint] = regress(J_bin(:,i),horzcat(ones(bsz^2*4,1),...
            nw));

        % Determine fit statistics
        se(:,i) = bint(:,1); 

    end
end

% Determine size of mapped area
shape = [size(Ja,1)-(bhw*2),size(Ja,2)-(bhw*2)];

% Create map of slope of fit
m = reshape(parms(2,:),shape);

% Create map of T
T = real((-1./m));

% Determine map of error in T
sigT = abs(T-(-1./reshape(se(2,:),shape)));

% Create map of intercept of fit (emissivity)
E = reshape(parms(1,:),shape);

% Create map of error in E
sigE = abs(E-reshape(se(1,:),shape));

% Create smoothed intensity map
ni = reshape(ni,shape);

% Determine peak temperature based on user choice

% Average T across top 20% intensity values
if get(handles.radiobutton4,'Value') == 1
    
    % Cutoff for averaging
    cut = 0.8*max(ni(:));
    points = length(ni(ni>cut));
    
    % Re-create J_max from all pixels for which the corresponding pixel in
    % sb is > cut
    J_max = [reshape(Ja(ni>cut),1,points) reshape(Jb(ni>cut),1,points)...
        reshape(Jc(ni>cut),1,points) reshape(Jd(ni>cut),1,points)]';
    
    % Re-calculate nw due to new length of J_max
    nw = [repmat(nwa,points,1); repmat(nwb,...
        points,1); repmat(nwc,points,1);repmat(nwd,points,1);];
    
    % Find average T within top 10 percentile intensity contour, and
    % associated standard error
    [m_max,C_max,T_max,sigT_max,sigE_max] = deal(mean(m(ni>cut),...
        'omitnan'),mean(E(ni>cut),'omitnan'),mean(T(ni>cut),'omitnan'),...
        std(T(ni>cut),'omitnan'),std(E(ni>cut),'omitnan'));
    
    % Determine indices of max intensity peak and pass to variables dx and
    % dy so that peak position / cross sections can be plotted
    [~, idx] = max(ni(:));
    [dx, dy] = ind2sub(size(ni),idx);

else

    % Maximum intensity
    if get(handles.radiobutton1,'value') == 1   
        [~, idx] = max(ni(:));

    % Minimum error
    elseif get(handles.radiobutton2,'value') == 1
        sigT(sigT==0)=NaN;
        [~, idx] = min(sigT(:));

    % Maximum T where error is no more than 5 times the minimum
    elseif get(handles.radiobutton3,'Value') == 1
        maxT = max(T(:));
        [idx, ~] = find(T(:)==maxT);
    
    % T at center pixel
    elseif get(handles.radiobutton5,'Value') == 1
        
        % Determine the centre pixel
        [dx,dy]=deal(size(ni,1)/2);
    
        % Convert matrix subscript to vector idx
        idx = sub2ind(size(ni),dx,dy);

    end

    [dx, dy, T_max, sigT_max, sigE_max, m_max, C_max, J_max] =...
        peak_pixel(T, sigT, sigE, m, E, idx, bhw, bsz, Ja, Jb, Jc, Jd);
end

% Eliminate -Inf values of J_max
J_max(J_max==-Inf)=NaN;