function [T,Emissivity,error]=parmap(suia,suib,suic,suid,ic,noise,Ja,Jb,Jc,Jd,nw,ec,k,m)

for n=1:k
       
        if (suia(m,n) < (ic*noise)) | (suib(m,n) < (ic*noise)) | (suic(m,n) < (ic*noise)) | (suid(m,n) < (ic*noise));
           T(m,n)=NaN;
           Emissivity(m,n)=NaN;
           error(m,n)=NaN;
           %removes data points for which any of the four constituent
           %pixels have normalised intensity < ic * noise
           
        else
            
            u=[Ja(m,n) Jb(m,n) Jc(m,n) Jd(m,n)]';
            [wien,bint,stats]=regress(u,nw);
            T(m,n)=(-1/wien(2));
            Emissivity(m,n)=wien(1);
            etemp(m,n)=-1/(bint(2));
            error(m,n)=(abs(T(m,n)-etemp(m,n)))/9;
            %regresses intensity against normalised wavelength and
            %determines T, emissivity and error from fit parameters. Error
            %is divided by 9 to approximate 324 (9x9) pixels
            
            if error(m,n) > ec;
               T(m,n)=NaN;
               Emissivity(m,n)=NaN;
               error(m,n)=NaN;
            end
            %removes data points for which the error is > ec

            
%             if T(m,n)>Tmax;
%                Tmax=T(m,n);
%                Emax=error(m,n);
%                [num,idx]=max(T(:));
%                [dx,dy]=ind2sub(size(T),idx);
%                slope=wien(2);
%                intercept=wien(1);
%                umax=u;
%                %stores maximum temperature and its associated intensities,
%                %slope, intercept and error
               
            end
        end
    end