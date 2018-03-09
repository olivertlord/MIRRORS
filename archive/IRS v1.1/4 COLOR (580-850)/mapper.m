function [Tmax,Emax,T,error,Emissivity,umax,slope_max,intercept_max,dx,dy,suib,suia]=mapper(noise,x,y,raw,hw,skiac,skibc,skicc,skidc,nw,byd,bxd,cyd,cxd,dyd,dxd)

Tmax = 1;
Emax = 1;

d=raw(1:255,1:382);                     %top left 670nm
a=raw(1:255,384:765);                   %top right 750nm
c=raw(256:510,1:382);                   %bottom left 850nm
b=raw(256:510,384:765);                 %bottom right 580nm
%splits unknown file into quadrants

uia=double(a(y-hw-4:y+hw+4,x-hw-4:x+hw+4));
uib=double(b(y-hw+byd-4:y+hw+byd+4,x-hw+bxd-4:x+hw+bxd+4));
uic=double(c(y-hw+cyd-4:y+hw+cyd+4,x-hw+cxd-4:x+hw+cxd+4));
uid=double(d(y-hw+dyd-4:y+hw+dyd+4,x-hw+dxd-4:x+hw+dxd+4));
%shifts quadrants based on offsets and converts to type double

for m=5:(hw*2+5)
    for n=5:(hw*2+5)
        suia(m-4,n-4)=mean(mean(uia(m-4:m+4,n-4:n+4)));  
        suib(m-4,n-4)=mean(mean(uib(m-4:m+4,n-4:n+4)));
        suic(m-4,n-4)=mean(mean(uic(m-4:m+4,n-4:n+4)));
        suid(m-4,n-4)=mean(mean(uid(m-4:m+4,n-4:n+4)));
    end
end
%averages the calibrated data over a 9x9 box centered on each pixel

Ja=log(suia./skiac*9.8654*752.97^5/3.7403e-12);
Jb=log(suib./skibc*4.191*578.61^5/3.7403e-12);
Jc=log(suic./skicc*1.2078*10*851.32^5/3.7403e-12);
Jd=log(suid./skidc*7.26917*670.08^5/3.7403e-12);
%performs system responce calibration of raw data

k=2*hw+1;

for m=1:k
    for n=1:k
        
        u=[Ja(m,n) Jb(m,n) Jc(m,n) Jd(m,n)]';
        [wien,bint,stats]=regress(u,nw);
        T(m,n)=(-1/wien(2));
        Emissivity(m,n)=wien(1);
        etemp(m,n)=-1/(bint(2));
        error(m,n)=(abs(T(m,n)-etemp(m,n)))/9;
        %regresses intensity against normalised wavelength and
        %determines T, emissivity and error from fit parameters. Error
        %is divided by 9 to approximate 324 (9x9) pixels
        
        slope(m,n)=wien(2);
        intercept(m,n)=wien(1);
    end
end
%nested loop performs Wien fits at each pixel in the selected sub-region

Tv=(T(hw,(1:(hw*2+1))));
Th=(T(1:(hw*2+1),hw));

Tv_inv=smooth(1.01*max(Tv)-Tv);
Th_inv=smooth(1.01*max(Th)-Th);

[~,MinIdx_v] = findpeaks(Tv_inv);
[~,MinIdx_h] = findpeaks(Th_inv);

Iv=(suib(hw,(1:(hw*2+1))));
Ih=(suib(1:(hw*2+1),hw));

Ev=(error(hw,(1:(hw*2+1))));
Eh=(error(1:(hw*2+1),hw));

E_Minima=[Ev(MinIdx_v(1)),Ev(MinIdx_v(end)),Eh(MinIdx_h(1)),Eh(MinIdx_h(end))];

I_Minima=[Iv(MinIdx_v(1)),Iv(MinIdx_v(end)),Ih(MinIdx_h(1)),Ih(MinIdx_h(end))];

Ecut = max(E_Minima);

Icut = max(I_Minima);

Icut2 = ((max(suib(:))-min(suib(:)))/10)+min(suib(:));

for m=1:k
    for n=1:k
        if (error(m,n) > Ecut & suib(m,n) < Icut) | suib(m,n) < Icut2;
           T(m,n)=NaN;
           Emissivity(m,n)=NaN;
           error(m,n)=NaN;
        end
    end
end

for m=11:k-10
    for n=11:k-10
        if  isempty(find(isnan(T(m-10:m+10,n-10:n+10)))) & T(m,n)>Tmax;
            Tmax=T(m,n);
            dx = m;
            dy = n;
            Emax=error(dx,dy);
            slope_max=slope(dx,dy);
            intercept_max=intercept(dx,dy);
            umax=[Ja(dx,dy) Jb(dx,dy) Jc(dx,dy) Jd(dx,dy)]';
        end
    end
end

%OLD-CODE-----------------------------------------------------------------------------------------------

% for m=5:((hw+4)*2+5)
%     for n=5:((hw+4)*2+5)
%         na(m-4,n-4)=mean(mean(uia(m-4:m+4,n-4:n+4)));  % Average the neighbour four pixels
%         nb(m-4,n-4)=mean(mean(uib(m-4:m+4,n-4:n+4)));
%         nc(m-4,n-4)=mean(mean(uic(m-4:m+4,n-4:n+4)));
%         nd(m-4,n-4)=mean(mean(uid(m-4:m+4,n-4:n+4)));
%     end
% end

%ui_average = (uia+uib+uic+uid)/4;
% ui_average = ui_average-(min(ui_average(:)));
% ui_average = ui_average/((max(ui_average(:)))-(min(ui_average(:))));

% uJa=sJa{m,n}(:);
% uJb=sJb{m,n}(:);
% uJc=sJc{m,n}(:);
% uJd=sJd{m,n}(:);
% u=[uJa;uJb;uJc;uJd];

%etemp(m,n)=(-1/(bint(2))-6);

% umean=[(mean(uJa)),(mean(uJb)),(mean(uJc)),(mean(uJd))];

% for m=1:k
%     for n=1:k
%         if (error(m,n)/(max(max(error)))) > ec;
%            T(m,n)=NaN;
%            Emissivity(m,n)=NaN;
%            error(m,n)=NaN;
%         end
%     end
% end

% Tmax=max(T(:));
% [num,idx]=max(T(:));
% [dx,dy]=ind2sub(size(T),idx);
% Emax=error(dx,dy);