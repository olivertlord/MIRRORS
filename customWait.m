function pos = customWait(hROI)
%--------------------------------------------------------------------------
% Function customWait
%--------------------------------------------------------------------------
% Written and tested on Matlab R2022b (Mac)
% 
% From MATLAB help centre
%--------------------------------------------------------------------------
%   Blocks the program execution when you click an ROI

%   INPUTS: hROI = ROI object

%   OUTPUTS: pos = ROI position [x, y, w, h]

%--------------------------------------------------------------------------

% Listen for mouse clicks on the ROI
l = addlistener(hROI,'ROIClicked',@clickCallback);

% Block program execution
uiwait;

% Remove listener
delete(l);

% Return the current position
pos = hROI.Position;

end