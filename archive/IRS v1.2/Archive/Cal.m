function [Tmax,Emax,T,error,rsquare,uia,uib,uic,uid,nraw]=cal(x,y,raw,hw,cutoff);
nraw(1:510,1:765)=0;
for m=5:506
    for n=5:761
nraw(m,n)=mean(mean(raw(m-4:m+4,n-4:n+4)));
    end
end

a=nraw(1:255,1:382);
ref=max(a(:));
                                         %top left 900nm
b=nraw(1:255,384:765);                   %top right 800nm
c=nraw(256:510,1:382);                   %bottom left 750nm
d=nraw(256:510,384:765);                 %bottom right 670nm

uia=a(y-hw:y+hw,x-hw:x+hw);
uib=b(y-hw:y+hw,x-hw+3:x+hw+3);
uic=c(y-hw+4:y+hw+4,x-hw+5:x+hw+5);
uid=d(y-hw+4:y+hw+4,x-hw+4:x+hw+4);

ki=imread('tc.tiff');

nki(1:510,1:765)=0;
for m=5:506
    for n=5:761
nki(m,n)=mean(mean(ki(m-4:m+4,n-4:n+4)));  % Average the neighbour four pixels
    end
end

kia=nki(1:255,1:382);                     %top left 900nm
kib=nki(1:255,384:765);                   %top right 800nm
kic=nki(256:510,1:382);                   %bottom left 750nm
kid=nki(256:510,384:765);                 %bottom right 670nm


kiac=kia(y-hw:y+hw,x-hw:x+hw);
kibc=kib(y-hw:y+hw,x-hw+3:x+hw+3);
kicc=kic(y-hw+4:y+hw+4,x-hw+5:x+hw+5);
kidc=kid(y-hw+4:y+hw+4,x-hw+4:x+hw+4);

Ja=log(uia./kiac*1.276*10*900^5/3.7403e-12);
Jb=log(uib./kibc*1.108*10*800^5/3.7403e-12);
Jc=log(uic./kicc*9.776*750^5/3.7403e-12);
Jd=log(uid./kidc*7.269*670^5/3.7403e-12);


%ref=1.0*log(b(35,328)/kib(35,328)*1.108*10*800^5/3.7403e-12)



wa=14384000/900;
wb=14384000/800;
wc=14384000/750;
wd=14384000/670;

v=[wa,wb,wc,wd];
%v=[wb,wc,wd];


k=2*hw+1;
for m=1:k
    for n=1:k
       
        u=[Ja(m,n),Jb(m,n),Jc(m,n),Jd(m,n)];
        %u=[Jb(m,n),Jc(m,n),Jd(m,n)];
        figure(1);
        plot(v,u,'-rs')
        scrsz=get(0,'ScreenSize');
        set(1,'Name','Wien Fitting','position', [5 scrsz(4)/1.50 scrsz(3)/5.5 scrsz(4)/3.8]);
        hold on
        [w,s]=polyfit(u,v,1);
        T(m,n)=-w(1,1);
        ste=sqrt(diag(inv(s.R)*inv(s.R')).*s.normr.^2./s.df);
        error(m,n)=ste(1);
        rsquare(m,n)=1-s.normr^2/norm(v-mean(v))^2;
        if uib(m,n) < (ref*cutoff);
            T(m,n)=NaN;
            error(m,n)=NaN;
            rsquare(m,n)=NaN;
        end
         %if rsquare(m,n) < cutoff;
         %   T(m,n)=NaN;
         %   error(m,n)=NaN;
         %   rsquare(m,n)=NaN;
         %end
       
    end
end

Tmax=max(T(:))
[num,idx]=max(T(:));
[dx,dy]=ind2sub(size(T),idx);
Emax=error(dx,dy)

figure(3);
f3=imagesc(T);
colorbar('EastOutside');
set(3,'Name','2D Temperature Mapping','position', [810 35 scrsz(3)/3.35 scrsz(4)/2.2]);

figure(4);
f4=imagesc(error);
colorbar('EastOutside');
set(4,'Name','error','position', [1395 35 scrsz(3)/3.7 scrsz(4)/2.2]);


