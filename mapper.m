function [T,E,epsilon,T_max,E_max,U_max,m_max,C_max,pr,pc,sb,nw] = mapper...
        (cal_a,cal_b,cal_c,cal_d,d,a,c,b,handles)
%--------------------------------------------------------------------------
% Function MAPPER
%--------------------------------------------------------------------------
% Version 1.6
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

%   Based on the concepts detailed in: Campbell, A. J. (2008). Measurement
%   of temperature distributions across laser heated samples by
%   multispectral imaging radiometry. Review of Scientific Instruments,
%   79(1), 015108. http://doi.org/10.1063/1.2827513

%   INPUTS: a,b,c,d = subframes of unknown data, spatially correlated in
%           the CORRELATE function
            
%           cal_a,cal_b,cal_c,cal_d = subframes of thermal calibration
%           file, also spatially correlated using the CORRELATE function

%           nw = array of normalised wavelengths computed for the four
%           filter wavelngths used in Bristol.

%           handles = data structure containing information on graphics
%           elements within the GUI.

%   OUTPUTS: T,E,epsilon = computed maps of temperature, error and
%            emissivity

%            T_max,E_max = peak temperature and associated error

%            U_max = array of normalised intensities used to compute the
%            peak temperature pixel

%            m_max,c_max = gradient and y-intercept of the Wien fit at the
%            peak temperature pixel

%            pr,pc = co-ordinates of the peak temperature pixel

%            sb = smoothed form of subframe b for contouring


%--------------------------------------------------------------------------   

%//////////////////////////////////////////////////////////////////////////
% HARDWARE SPECIFIC - REQUIRES EDITING
% Determines normalised wavelengths for the four filters

nwa = 14384000/670.08;
nwb = 14384000/752.97;
nwc = 14384000/851.32;
nwd = 14384000/578.61;

%//////////////////////////////////////////////////////////////////////////

% Concatenate normalised wavelengths for fitting
nw = horzcat(ones(324,1),[repmat(nwa,81,1);repmat(nwb,81,1);...
    repmat(nwc,81,1);repmat(nwd,81,1);]);

% Performs system responce calibration of the raw data
Ja=log(a./cal_a*7.26917*670.08^5/3.7403e-12);
Jb=log(b./cal_b*9.8654*752.97^5/3.7403e-12);
Jc=log(c./cal_c*1.2078*10*851.32^5/3.7403e-12);
Jd=log(d./cal_d*4.191*578.61^5/3.7403e-12);

% Produces smoothed b quadrant for cutoff and contouring
sb = conv2(b(5:length(b)-5,5:length(b)-5),ones(9,9),'same');
sb = sb*(max(b(:))/max(sb(:)));

% Get saturation limit and intensity limit
sl = getappdata(0,'saturation_limit');
il = max(sb(:))*get(handles.slider1,'value');
assignin('base','sb',sb)

% Pre-allocate arrays with NaN
[T,E,epsilon,etemp,slope,intercept] = deal(NaN(length(sb)));

% Bin in x
for m=5:length(a)-5
    
    % Bin in y
    for n=5:length(a)-5
        
        % Only fit data if the peak intensity of quadrant b is larger than
        % the value set by the user AND none of the quadrants contain a
        % pixel with a value of > 99% of the bitdepth of the TIFF file
        if  il < sb(m-4,n-4) && a(m,n) < sl && b(m,n) < sl && c(m,n) < sl...
                && d(m,n)< sl
            
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
    [pr, pc] = ind2sub(size(E),p);
    Ex = E - E(pr,pc);
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
    C_max = wien(1);
    
    % Find average T within top 10 percentile intensity contour, and
    % associated stamdard error
    [T_max,E_max] = deal(nanmean(T(sb>cut)),std(T(sb>cut))/sqrt(points));
    
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
    [pr, pc] = ind2sub(size(E),p);
    
    % Output parameters of chosen point
    [T_max,E_max,m_max,C_max] = deal(nanmean(T(p)),nanmean(E(p)),...
        nanmean(slope(p)), nanmean(intercept(p)));    
    
    % Fix to the edge if within 4 pixels of the edge, to prevent problems
    % with determining U_max
    pr(pr<4) = 5;
    pc(pc<4) = 5;
    
    % Concatenate array of U_max at chosen point
    U_max=[reshape(Ja(pr:pr+8,pc:pc+8),1,81) reshape(Jb(pr:pr+8,pc:pc+8)...
        ,1,81) reshape(Jc(pr:pr+8,pc:pc+8),1,81)...
        reshape(Jd(pr:pr+8,pc:pc+8),1,81)]';    
end

% Eliminate -Inf values of U_max
U_max(U_max==-Inf)=NaN;