function [Tmax,Emax,T,error,emissivity,umax,slope_max,intercept_max,dx,dy,sa]=mapper(skiac,skibc,skicc,skidc,nw,d,a,c,b,handles)

Ja=log(a./skiac*9.8654*752.97^5/3.7403e-12);
Jb=log(b./skibc*4.191*578.61^5/3.7403e-12);
Jc=log(c./skicc*1.2078*10*851.32^5/3.7403e-12);
Jd=log(d./skidc*7.26917*670.08^5/3.7403e-12);
%performs system responce calibration of raw data

% for m=5:length(a)-5
%     for n=5:length(a)-5
%         sa(m-4,n-4) = mean(mean(a(m-4:m+4,n-4:n+4))); 
%     end
% end

sa = conv2(a(5:length(a)-5,5:length(a)-5),ones(9,9),'same');
%produce smoothed a quadrant for cutoff and contouring

for m=5:length(a)-5
    for n=5:length(a)-5
        if  ((max(sa(:))*get(handles.slider1,'value')) < sa(m-4,n-4)) & ([a(m,n) b(m,n) c(m,n) d(m,n)]) < 65000
            u=[reshape(Ja(m-4:m+4,n-4:n+4),1,81) reshape(Jb(m-4:m+4,n-4:n+4),1,81) reshape(Jc(m-4:m+4,n-4:n+4),1,81) reshape(Jd(m-4:m+4,n-4:n+4),1,81)]';
            [wien,bint,~]=regress(u,nw);
            T(m-4,n-4)=(-1/wien(2));
            emissivity(m-4,n-4)=wien(1);
            etemp(m-4,n-4)=-1/(bint(2));
            error(m-4,n-4)=(abs(T(m-4,n-4)-etemp(m-4,n-4)));
            slope(m-4,n-4)=wien(2);
            intercept(m-4,n-4)=wien(1);
        else
            [T(m-4,n-4), error(m-4,n-4), emissivity(m-4,n-4)] = deal(NaN);  
        end
    end
end
%regresses intensity against normalised wavelength for each pixel in
%subframe

peak_choice = get(handles.radiobutton1,'value');
%determine radio button state for peak type

if peak_choice == 1   
    [~, p] = max(sa(:));
    %find max intensity point
    
    [pr, pc] = ind2sub(size(sa),p)
    %determine index of highest intensity point
else
    error(error==0)=NaN;
    [~, p] = min(error(:));
    %find min error point
    
    [pr, pc] = ind2sub(size(error),p);
    %determine index of min error point
end

pr(pr<4) = 5;
pc(pc<4) = 5;

[Tmax, dx, dy, Emax,slope_max, intercept_max] = deal(T(pr,pc), pr, pc, error(pr,pc), slope(pr,pc), intercept(pr,pc));
%output other parameters based on index of chosen point

umax=[reshape(Ja(pr:pr+8,pc:pc+8),1,81) reshape(Jb(pr:pr+8,pc:pc+8),1,81) reshape(Jc(pr:pr+8,pc:pc+8),1,81) reshape(Jd(pr:pr+8,pc:pc+8),1,81)]';
%finds umax at chosen point