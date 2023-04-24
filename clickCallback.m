function clickCallback(~,evt)
%--------------------------------------------------------------------------
% Function clickCallback
%--------------------------------------------------------------------------
% Written and tested on Matlab R2022b (Mac)
% 
% From MATLAB help centre
%--------------------------------------------------------------------------
%   Resumes program execution when ROI clicked.

%   INPUTS: evt = images.roi.ROIClickedEventData object

%   OUTPUTS: NONE

%--------------------------------------------------------------------------
if strcmp(evt.SelectionType,'double')
    uiresume;
end

end