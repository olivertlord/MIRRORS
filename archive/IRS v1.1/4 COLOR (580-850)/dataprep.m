function [Tmax,Emax,T,error,ui_average,Emissivity,dx,dy,umax,umean,slope,intercept]=dataprep(x,y,raw,hw,cutoff1,cutoff2,kiac,kibc,kicc,kidc,v,byd,bxd,cyd,cxd,dyd,dxd,fm)
scrsz=get(0,'ScreenSize');
maxtemp = 1;

d=raw(1:255,1:382);                     %top left 670nm
a=raw(1:255,384:765);                   %top right 750nm
c=raw(256:510,1:382);                   %bottom left 850nm
b=raw(256:510,384:765);                 %bottom right 580nm

uia=double(a(y-hw-8:y+hw+8,x-hw-8:x+hw+8));
uib=double(b(y-hw+byd-8:y+hw+byd+8,x-hw+bxd-8:x+hw+bxd+8));
uic=double(c(y-hw+cyd-8:y+hw+cyd+8,x-hw+cxd-8:x+hw+cxd+8));
uid=double(d(y-hw+dyd-8:y+hw+dyd+8,x-hw+dxd-8:x+hw+dxd+8));

ui_average = (uia+uib+uic+uid)/4;
ui_average = ui_average-(min(ui_average(:)));
ui_average = ui_average/((max(ui_average(:)))-(min(ui_average(:))));

Ja=log(uia./kiac*9.8654*752.97^5/3.7403e-12);
Jb=log(uib./kibc*4.191*578.61^5/3.7403e-12);
Jc=log(uic./kicc*1.2078*10*851.32^5/3.7403e-12);
Jd=log(uid./kidc*7.26917*670.08^5/3.7403e-12);

for m=5:(hw*2+5)
    for n=5:(hw*2+5)
        sJa{m-4,n-4}=Ja(m-4:m+4,n-4:n+4);  % collect 9*9 array of pixels centred around each
        sJb{m-4,n-4}=Jb(m-4:m+4,n-4:n+4);
        sJc{m-4,n-4}=Jc(m-4:m+4,n-4:n+4);
        sJd{m-4,n-4}=Jd(m-4:m+4,n-4:n+4);
    end
end

k=2*hw+1;
for m=1:k
    for n=1:k
        
        if (ui_average(m,n) < (cutoff1));
           T(m,n)=NaN;
           Emissivity(m,n)=NaN;
           error(m,n)=NaN;
        else
            uJa=sJa{m,n}(:);
            uJb=sJb{m,n}(:);
            uJc=sJc{m,n}(:);
            uJd=sJd{m,n}(:);
            u=[uJa;uJb;uJc;uJd];
        
            [wien,bint,stats]=regress(u,v);
            T(m,n)=(-1/wien(2)-6); %correction brings 4color and spec into line when using cal as unknown and 670-830 wavelength range
            Emissivity(m,n)=wien(1);
            etemp(m,n)=(-1/(bint(2))-6);
            error(m,n)=abs(T(m,n)-etemp(m,n)); 
            
            if T(m,n)>maxtemp;
               maxtemp=T(m,n);
               umax=u;
               umean=[(mean(uJa)),(mean(uJb)),(mean(uJc)),(mean(uJd))];
               slope=wien(2);
               intercept=wien(1);
            end
        end
    end
end

for m=1:k
    for n=1:k
        if (error(m,n)/(max(max(error)))) > cutoff2;
           T(m,n)=NaN;
           Emissivity(m,n)=NaN;
           error(m,n)=NaN;
        end
    end
end
Tmax=max(T(:));
[num,idx]=max(T(:));
[dx,dy]=ind2sub(size(T),idx);
Emax=error(dx,dy);

%OLD-CODE-----------------------------------------------------------------------------------------------

% for m=5:((hw+4)*2+5)
%     for n=5:((hw+4)*2+5)
%         na(m-4,n-4)=mean(mean(uia(m-4:m+4,n-4:n+4)));  % Average the neighbour four pixels
%         nb(m-4,n-4)=mean(mean(uib(m-4:m+4,n-4:n+4)));
%         nc(m-4,n-4)=mean(mean(uic(m-4:m+4,n-4:n+4)));
%         nd(m-4,n-4)=mean(mean(uid(m-4:m+4,n-4:n+4)));
%     end
% end