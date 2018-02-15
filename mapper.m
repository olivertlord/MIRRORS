function [T,E,epsilon,T_max,E_max,U_max,m_max,C_max,dx,dy,sb] = mapper...
        (cal_a,cal_b,cal_c,cal_d,nw,d,a,c,b,handles)
    
Ja=log(a./cal_a*9.8654*752.97^5/3.7403e-12);
Jb=log(b./cal_b*4.191*578.61^5/3.7403e-12);
Jc=log(c./cal_c*1.2078*10*851.32^5/3.7403e-12);
Jd=log(d./cal_d*7.26917*670.08^5/3.7403e-12);
%performs system responce calibration of raw data

% for m=5:length(a)-5
%     for n=5:length(a)-5
%         sa(m-4,n-4) = mean(mean(a(m-4:m+4,n-4:n+4))); 
%     end
% end

sb = conv2(b(5:length(b)-5,5:length(b)-5),ones(9,9),'same');
sb = sb*(max(b(:))/max(sb(:)));
%produce smoothed b quadrant for cutoff and contouring

for m=5:length(a)-5
    for n=5:length(a)-5
        if  ((max(sb(:))*get(handles.slider1,'value')) < sb(m-4,n-4)) & ([a(m,n) b(m,n) c(m,n) d(m,n)]) < 65000
            u=[reshape(Ja(m-4:m+4,n-4:n+4),1,81) reshape(Jb(m-4:m+4,n-4:n+4),1,81) reshape(Jc(m-4:m+4,n-4:n+4),1,81) reshape(Jd(m-4:m+4,n-4:n+4),1,81)]';
            u(u==-Inf)=NaN;
            [wien,bint,~]=regress(u,nw);
            T(m-4,n-4)=(-1/wien(2));
            epsilon(m-4,n-4)=wien(1);
            etemp(m-4,n-4)=-1/(bint(2));
            E(m-4,n-4)=(abs(T(m-4,n-4)-etemp(m-4,n-4)));
            slope(m-4,n-4)=wien(2);
            intercept(m-4,n-4)=wien(1);
        else
            [T(m-4,n-4), E(m-4,n-4), epsilon(m-4,n-4)] = deal(NaN);  
        end
    end
end
%regresses intensity against normalised wavelength for each pixel in
%subframe

if get(handles.checkbox2,'Value') == 1
    Ex = E - min(E(:));
    T = T - ((-0.0216.*(Ex.*Ex))+(17.882.*Ex));
end

peak_choice = get(handles.radiobutton1,'value');
%determine radio button state for peak type

if get(handles.radiobutton1,'value') == 1   
    [~, p] = max(sb(:));
    %find max intensity point
    
elseif get(handles.radiobutton2,'value') == 1
    E(E==0)=NaN;
    [~, p] = min(E(:));
    %find min E point
    
elseif get(handles.radiobutton5,'Value') == 1
    [~, p] = max(T(:));
    %find max T point
end

[pr, pc] = ind2sub(size(E),p);
%determine index of min E point

pr(pr<4) = 5;
pc(pc<4) = 5;

[T_max, dx, dy, E_max,m_max, C_max] = deal(T(pr,pc), pr, pc, E(pr,pc), slope(pr,pc), intercept(pr,pc));
%output other parameters based on index of chosen point

U_max=[reshape(Ja(pr:pr+8,pc:pc+8),1,81) reshape(Jb(pr:pr+8,pc:pc+8),1,81) reshape(Jc(pr:pr+8,pc:pc+8),1,81) reshape(Jd(pr:pr+8,pc:pc+8),1,81)]';
%finds U_max at chosen point

U_max(U_max==-Inf)=NaN;

assignin('base','epsilon',epsilon)
assignin('base','T',T)