function [Tmax,Emax,T,error,Emissivity,umax,slope_max,intercept_max,dx,dy,suid,uia,T1]=mapper(x,y,hw,skiac,skibc,skicc,skidc,nw,byd,bxd,cyd,cxd,dyd,dxd,d,a,c,b,fcnt)

[Tmax,Emax,umax,T,error,Emissivity,slope_max,intercept_max,dx,dy,suid,uia,T1] = deal(1);

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

assignin('base','suib',suib);

Ja=log(suia./skiac*9.8654*752.97^5/3.7403e-12);
Jb=log(suib./skibc*4.191*578.61^5/3.7403e-12);
Jc=log(suic./skicc*1.2078*10*851.32^5/3.7403e-12);
Jd=log(suid./skidc*7.26917*670.08^5/3.7403e-12);
%performs system responce calibration of raw data

k=2*hw+1;

for m=1:k
    for n=1:k
        if suia(m,n) < 64000 && suib(m,n) < 64000 && suic(m,n) < 64000 && suid(m,n) < 64000
            u=[Ja(m,n) Jb(m,n) Jc(m,n) Jd(m,n)]';
            [wien,bint,~]=regress(u,nw);
            T(m,n)=(-1/wien(2));
            Emissivity(m,n)=wien(1);
            etemp(m,n)=-1/(bint(2));
            error(m,n)=(abs(T(m,n)-etemp(m,n)))/9;
            slope(m,n)=wien(2);
            intercept(m,n)=wien(1);
            %regresses intensity against normalised wavelength and
            %determines T, emissivity and error from fit parameters. Error
            %is divided by 9 to approximate 324 (9x9) pixels
        else
            [suia(m-4,n-4),suib(m-4,n-4),suic(m-4,n-4),suid(m-4,n-4)] = deal(NaN);  
        end
    end
end
%nested loop performs Wien fits at each pixel in the selected sub-region

T1 = T;

%Tv=(T(hw,(1:(hw*2+1))));
%Th=(T(1:(hw*2+1),hw));
%make temperature cross-sections centered on middle of window

%Tv_inv=smooth(1.01*max(Tv)-Tv);
%Th_inv=smooth(1.01*max(Th)-Th);
%smooth and invert temperature cross-sections

%[~,MinIdx_v] = findpeaks(Tv_inv);
%[~,MinIdx_h] = findpeaks(Th_inv);
%find minima in temperature cross-sections

%Iv=(suib(hw,(1:(hw*2+1))));
%Ih=(suib(1:(hw*2+1),hw));
%find equivelent intensities

%Ev=(error(hw,(1:(hw*2+1))));
%Eh=(error(1:(hw*2+1),hw));
%find equivalent errors

%I_Minima=[Iv(MinIdx_v(1)),Iv(MinIdx_v(end)),Ih(MinIdx_h(1)),Ih(MinIdx_h(end))];
%gather first and last vertical and horizontal error minima

%E_Minima=[Ev(MinIdx_v(1)),Ev(MinIdx_v(end)),Eh(MinIdx_h(1)),Eh(MinIdx_h(end))];
%gather first and last vertical and horizontal error minima

%Ecut = min(E_Minima);
%make cutoff at error minimum with the largest error

%Icut = max(I_Minima);
%make cutoff at error minimum with the largest intensiity

Icut2 = (max(suib(:))-min(suib(:)))/10;
%Icut2 = Icut2*3
%make cutoff at 30th intensity percentile

Ecut = 1000;

Icut = 100000;

%Icut2 = 0;

for m=1:k
    for n=1:k
        if (error(m,n) > Ecut && suib(m,n) < Icut) || suib(m,n) < (Icut2*3);
           T(m,n)=NaN;
           Emissivity(m,n)=NaN;
           error(m,n)=NaN;
        end
    end
end
%NaN all pixels outside the three cutoffs

for m=1:k
    for n=1:k
        if  suib(m,n) > ((Icut2*2)+min(suib(:))) && T(m,n)>Tmax;
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
%find peak T and associated paramters from what remains but ignore any peak
%within 10 pixels of the edge