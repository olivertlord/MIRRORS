function [T_dif,T_dif_metric] = difference(T, sb, c1, background)

if (c1 == 1) || (max(sb(:)) < background*4)
    setappdata(0,'T0_field',(T - min(T(:)))/(max(T(:)) - min(T(:))));
    T_dif = NaN(length(T));
    T_dif_metric = NaN;
else
    T0_field = getappdata(0,'T0_field');
    
    T1_field = (T - min(T(:)))/(max(T(:)) - min(T(:)));
    %determines normalised temperature field
    
    I1_field = (sb - min(sb(:)))/(max(sb(:)) - min(sb(:)));
    %determines normalised intensity field equal in size to T
    
    T_dif = abs(T1_field-T0_field).*I1_field;
    %determines difference map weighted by intensity
    
    T_dif_metric = nanmean(T_dif(:));
    %calculates average difference metric
    
    T0_field = T1_field;
    setappdata(0,'T0_field',T0_field);
    %sets intial T field to current T map
end
%initial T field = 0 on first pass
