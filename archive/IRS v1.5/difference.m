function [difT, difT_metric] = difference(T, sa, counter_1, w)

persistent T0_field

if counter_1 == 1
    T0_field = zeros((w*2));
end
%initial T field = 0 on first pass

T1_field = (T - min(T(:)))/(max(T(:)) - min(T(:)));
%determines normalised temperature field
    
I1_field = (sa - min(sa(:)))/(max(sa(:)) - min(sa(:)));    
%determines normalised intensity field equal in size to T

difT = abs(T1_field-T0_field).*I1_field;
%determines difference map weighted by intensity
    
if counter_1 == 1
    difT = NaN(length(difT));
end
%on first pass, converts map to NaN
   
difT_metric = nanmean(difT(:));
%calculates average difference metric
    
T0_field = T1_field;
%sets intial T field to current T map
