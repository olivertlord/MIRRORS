function [Tmax,Emax,T,error,ui_average,Emissivity,dx,dy]=dataprep(x,y,raw,hw,cutoff1,cutoff2,kiac,kibc,kicc,kidc,v,byd,bxd,cyd,cxd,dyd,dxd)
scrsz=get(0,'ScreenSize');
maxtemp = 1;

d=raw(1:255,1:382);                     %top left 670nm
c=raw(1:255,384:765);                   %top right 750nm
b=raw(256:510,1:382);                   %bottom left 800nm
a=raw(256:510,384:765);                 %bottom right 900nm

for m=y-hw-15:y+hw+15
    for n=x-hw-15:x+hw+15
        na(m,n)=mean(mean(a(m-4:m+4,n-4:n+4)));  % Average the neighbour four pixels
        nb(m,n)=mean(mean(b(m-4:m+4,n-4:n+4)));
        nc(m,n)=mean(mean(c(m-4:m+4,n-4:n+4)));
        nd(m,n)=mean(mean(d(m-4:m+4,n-4:n+4)));
    end
end

uia=na(y-hw:y+hw,x-hw:x+hw);
uib=nb(y-hw+byd:y+hw+byd,x-hw+bxd:x+hw+bxd);
uic=nc(y-hw+cyd:y+hw+cyd,x-hw+cxd:x+hw+cxd);
uid=nd(y-hw+dyd:y+hw+dyd,x-hw+dxd:x+hw+dxd);

% uia=double(uia);
% uib=double(uib);
% uic=double(uic);
% uid=double(uid);

ui_average = (uia+uib+uic+uid)/4;
ui_average = ui_average-(min(ui_average(:)));
ui_average = ui_average/((max(ui_average(:)))-(min(ui_average(:))));

Ja=log(uia./kiac*1.2786*10*901.61^5/3.7403e-12);
Jb=log(uib./kibc*1.10767*10*800.2^5/3.7403e-12);
Jc=log(uic./kicc*9.8654*752.97^5/3.7403e-12);
Jd=log(uid./kidc*7.26917*670.08^5/3.7403e-12);

k=2*hw+1;
for m=1:k
    for n=1:k
       
        u=[Ja(m,n),Jb(m,n),Jc(m,n),Jd(m,n)]';
        
        figure(1);
        plot(v(:,2),u,'O')
        set(1,'Name','Wien Fitting','position', [5 770 scrsz(3)/5.5 scrsz(4)/3.8],'MenuBar','None','Toolbar','None');
        hold on
        
        %[w,s]=polyfit(u,v,1);
        %T(m,n)=-w(1,1);
        %Emissivity(m,n)=w(1,2);
        %ste=sqrt(diag(inv(s.R)*inv(s.R')).*s.normr.^2./s.df);
        %error(m,n)=ste(1);
        %rsquare(m,n)=1-s.normr^2/norm(v-mean(v))^2;
        
        [wien,bint,stats]=regress(u,v,0.32);
        T(m,n)=(-1/wien(2)-12.17); %correction brings 4color and spec into line when using cal as unknown and 670-830 wavelength range
        Emissivity(m,n)=wien(1);
        etemp(m,n)=(-1/(bint(2))-12.17);
        error(m,n)=abs(T(m,n)-etemp(m,n));
        
        if T(m,n)>maxtemp;
           maxtemp=T(m,n);
           umax=u;
        end
        
        if ui_average(m,n) < (cutoff1);
           T(m,n)=NaN;
           Emissivity(m,n)=NaN;
           error(m,n)=NaN;
           %rsquare(m,n)=NaN;
        end
        if error(m,n) < cutoff2;
           T(m,n)=NaN;
           Emissivity(m,n)=NaN;
           error(m,n)=NaN;
           %rsquare(m,n)=NaN;
        end
       
    end
end

Tmax=max(T(:))
[num,idx]=max(T(:));
[dx,dy]=ind2sub(size(T),idx);
Emax=error(dx,dy)

assignin('base', 'umax', umax);
assignin('base', 'v', v);
assignin('base', 'ui_average', ui_average);
assignin('base', 'uia', uia);
assignin('base', 'uib', uib);
assignin('base', 'uic', uic);
assignin('base', 'uid', uid);

