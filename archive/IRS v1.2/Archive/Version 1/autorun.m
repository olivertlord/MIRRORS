function[]=autorun(x,y,w,m,n,cutoff1,cutoff2)

[byd,bxd,cyd,cxd,dyd,dxd]= sc
close all
fcnt=0;
scrsz=get(0,'ScreenSize');
[upath]=uigetdir('C:\Documents and Settings\Laser Control\Desktop\Data','Select data folder');
dir_content = dir(upath);
filenames = {dir_content.name};

[calfile,calpath]=uigetfile('C:\MATLAB7\work\4 COLOR\Calibration files\.tiff','Select thermal calibration file');
calfilename = strcat(calpath,'/',calfile);

ki=imread(calfilename);

kid=ki(1:255,1:382);                     %top left 670nm
kic=ki(1:255,384:765);                   %top right 750nm
kib=ki(256:510,1:382);                   %bottom left 800nm
kia=ki(256:510,384:765);                 %bottom right 900nm

for a=y-w-15:y+w+15
    for b=x-w-15:x+w+15
        nkia(a,b)=mean(mean(kia(a-4:a+4,b-4:b+4)));  % Average the neighbour four pixels
        nkib(a,b)=mean(mean(kib(a-4:a+4,b-4:b+4)));
        nkic(a,b)=mean(mean(kic(a-4:a+4,b-4:b+4)));
        nkid(a,b)=mean(mean(kid(a-4:a+4,b-4:b+4)));
    end
end

% kia=double(kia);
% kib=double(kib);
% kic=double(kic);
% kid=double(kid);

kiac=nkia(y-w:y+w,x-w:x+w);
kibc=nkib(y-w+byd:y+w+byd,x-w+bxd:x+w+bxd);
kicc=nkic(y-w+cyd:y+w+cyd,x-w+cxd:x+w+cxd);
kidc=nkid(y-w+dyd:y+w+dyd,x-w+dxd:x+w+dxd);

vp=[(14384000/901.61);(14384000/800.2);(14384000/752.97);(14384000/670.08)];
v=[ones(4,1) vp];

m=m+2;n=n+2;

for i=m:n
    
    fcnt=fcnt+1;
   
    filename=filenames(i);
    location=strcat(upath,'\',(filename));
    lf=char(location);
    raw=imread(lf);
    
    close all
    
    [Tmax,Emax,T,error,ui_average,Emissivity,dx,dy]=dataprep(x,y,raw,w,cutoff1,cutoff2,kiac,kibc,kicc,kidc,v,byd,bxd,cyd,cxd,dyd,dxd);
          
    Tmaximum(fcnt)=Tmax;
    Emaximum(fcnt)=Emax;
  
    prefix=regexprep(filename,'.tiff','');
    prefix=regexprep(prefix,'-','_');
    
    Tmap=strcat(prefix,'_','T');
    Tmap=strcat(upath,'\',Tmap);
    Tmap=char(Tmap);
    save(Tmap,'T','-ASCII');
    
    Emap=strcat(prefix,'_','E');
    Emap=strcat(upath,'\',Emap);
    Emap=char(Emap);
    save(Emap,'error','-ASCII');
    
    Wmap=strcat(prefix,'_','W');
    Wmap=strcat(upath,'\',Wmap);
    Wmap=char(Wmap);
    save(Wmap,'Emissivity','-ASCII');
    
    figure(2);
    set(2,'NextPlot', 'Add', 'Name','Temperature vs. Acquisition','position', [5 450 scrsz(3)/5.5 scrsz(4)/3.8],'MenuBar','None','Toolbar','None');
    plot(Tmaximum,'O');
          
    figure(3);
    Clim = [(min(T(:))) (max(T(:)))];
    imagesc(T);
    colorbar;
    set(3,'Name','2D Temperature Mapping','position', [380 590 scrsz(3)/4 scrsz(4)/2.35],'MenuBar','None','Toolbar','None');
    hold on
    contour(ui_average,10);
    hold off
    
    figure(4);
    %Clim = [min(error) max(error)];
    imagesc(error);
    colorbar('EastOutside');
    set(4,'Name','Error Map','position', [870 590 scrsz(3)/4 scrsz(4)/2.35],'MenuBar','None','Toolbar','None');
    
    figure(5);
    Clim = [0 .5];
    nraw = raw/max(raw(:));
    imagesc(raw);
    colorbar('EastOutside');
    set(5,'Name','Intensity Map (all)','position', [1360 590 scrsz(3)/4 scrsz(4)/2.35],'MenuBar','None','Toolbar','None');
    
    figure(6);
    plot(T(dx,(1:(w*2))),Emissivity(dx,(1:(w*2))),T((1:(w*2)),dy),Emissivity((1:(w*2)),dy));
    set(6,'Name','Temperature vs. Emissivity','position', [5 130 scrsz(3)/5.5 scrsz(4)/3.8],'MenuBar','None','Toolbar','None');
     
    seq(fcnt)=fcnt;
    timevalue(fcnt) = datenum(dir_content(i).date);
    S = datevec(timevalue(fcnt));
    elapsedSec(fcnt) = (S(1,6) + (S(1,5)*60) + (S(1,4)*60*60));
    elapsedSecNorm(fcnt) = round(elapsedSec(fcnt)-elapsedSec(1));
    autoresult = [seq',timevalue',elapsedSecNorm',Tmaximum',Emaximum'];
    assignin('base', 'autoresult', autoresult)
       
end

savename=cell2mat(filename(1,1));
slash=strfind(filename,'-');
slashpos=cell2mat(slash(1,1));
savename=savename(1:(slashpos-1));
savename=strcat(savename,'_summary.txt')
result=strcat(upath,'\',savename);
result=char(result);
save (result,'autoresult','-ASCII');