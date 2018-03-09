function[]=autorun(x,y,w,m,n,cutoff1,cutoff2)

[byd,bxd,cyd,cxd,dyd,dxd]= sc;
close all
fcnt=0;
scrsz=get(0,'ScreenSize');
[upath]=uigetdir('C:\Documents and Settings\Laser Control\Desktop\Data','Select data folder');
tiffs=strcat(upath,'\*.tiff');
dir_content = dir(tiffs);
filenames = {dir_content.name};

mkdir(upath,'visualisation');

[calfile,calpath]=uigetfile('C:\MATLAB7\work\4 COLOR\Calibration files\.tiff','Select thermal calibration file');
calfilename = strcat(calpath,'\',calfile);

ki=imread(calfilename);

kid=ki(1:255,1:382);                     %top left 670nm
kia=ki(1:255,384:765);                   %top right 750nm
kic=ki(256:510,1:382);                   %bottom left 800nm
kib=ki(256:510,384:765);                 %bottom right 900nm

kiac=double(kia(y-w-8:y+w+8,x-w-8:x+w+8));
kibc=double(kib(y-w+byd-8:y+w+byd+8,x-w+bxd-8:x+w+bxd+8));
kicc=double(kic(y-w+cyd-8:y+w+cyd+8,x-w+cxd-8:x+w+cxd+8));
kidc=double(kid(y-w+dyd-8:y+w+dyd+8,x-w+dxd-8:x+w+dxd+8));

% for a=5:((w+4)*2+5)
%     for b=5:((w+4)*2+5)
%         nkia(a-4,b-4)=mean(mean(kiac(a-4:a+4,b-4:b+4)));  % Average the neighbour four pixels
%         nkib(a-4,b-4)=mean(mean(kibc(a-4:a+4,b-4:b+4)));
%         nkic(a-4,b-4)=mean(mean(kicc(a-4:a+4,b-4:b+4)));
%         nkid(a-4,b-4)=mean(mean(kidc(a-4:a+4,b-4:b+4)));
%     end
% end

vp=[(repmat(14384000/901.61,81,1));(repmat(14384000/800.2,81,1));(repmat(14384000/752.97,81,1));(repmat(14384000/670.08,81,1))];
v=[ones(324,1) vp];

vm=[(14384000/901.61);(14384000/800.2);(14384000/752.97);(14384000/670.08)];
vmean=[ones(4,1) vm];

fm=n;
m=m+2;n=n+2;

for i=m:n
    
    fcnt=fcnt+1;
    
    filename=filenames(i-2)
    location=strcat(upath,'/',(filename));
    lf=char(location);
    raw=imread(lf);
           
    [Tmax,Emax,T,error,ui_average,Emissivity,dx,dy,umax,umean,slope,intercept]=dataprep(x,y,raw,w,cutoff1,cutoff2,kiac,kibc,kicc,kidc,v,byd,bxd,cyd,cxd,dyd,dxd,fm);
    
    close all
    
    Tmaximum(fcnt)=Tmax;
    Emaximum(fcnt)=Emax;
  
    prefix=regexprep(filename,'.tiff','');
    prefix=regexprep(prefix,'-','_');
    
    Tmap=strcat(prefix,'_','T');
    Tmap=strcat(upath,'\visualisation\',Tmap);
    Tmap=char(Tmap);
    save(Tmap,'T','-ASCII');
    
    Emap=strcat(prefix,'_','E');
    Emap=strcat(upath,'\visualisation\',Emap);
    Emap=char(Emap);
    save(Emap,'error','-ASCII');
    
    Wmap=strcat(prefix,'_','W');
    Wmap=strcat(upath,'\visualisation\',Wmap);
    Wmap=char(Wmap);
    save(Wmap,'Emissivity','-ASCII');
    
    figure(1);
    plot(v(:,2),umax,'O')
    title(strcat((num2str(round(Tmax))),' +/- ',(num2str(round(Emax)))));
    set(1,'Name','Wien Fitting','position', [5 770 scrsz(3)/5.5 scrsz(4)/3.8],'MenuBar','None','Toolbar','None');
    hold on
    plot(vmean(:,2),umean,'rs')
    xline=linspace(15954,21467,100);
    yline=intercept+(slope*xline);
    plot(xline,yline,'-r')
        
    figure(2);
    set(2,'NextPlot', 'Add', 'Name','Temperature vs. Acquisition','position', [5 450 scrsz(3)/5.5 scrsz(4)/3.8],'MenuBar','None','Toolbar','None');
    plot(Tmaximum,'O');
          
    figure(3);
    Clim = [(min(T(:))) (max(T(:)))];
    imagesc(T,Clim);
    colorbar;
    set(3,'Name','2D Temperature Mapping','position', [380 590 scrsz(3)/4 scrsz(4)/2.35],'MenuBar','None','Toolbar','None');
    hold on
    contour(ui_average,10);
    hold off
    
    figure(4);
    Clim = [0 1];
    imagesc((error/(max(max(error)))),Clim);
    colorbar('EastOutside');
    set(4,'Name','Error Map','position', [870 590 scrsz(3)/4 scrsz(4)/2.35],'MenuBar','None','Toolbar','None');
    
    figure(5);
    Clim = [0 .5];
    %nraw = raw/max(raw(:));
    imagesc(ui_average);
    colorbar('EastOutside');
    set(5,'Name','Intensity Map (all)','position', [1360 590 scrsz(3)/4 scrsz(4)/2.35],'MenuBar','None','Toolbar','None');
    
    %figure(6);
    %plot(T(dx,(1:(w*2))),Emissivity(dx,(1:(w*2))),T((1:(w*2)),dy),Emissivity((1:(w*2)),dy));
    %set(6,'Name','Temperature vs. Emissivity','position', [5 130 scrsz(3)/5.5 scrsz(4)/3.8],'MenuBar','None','Toolbar','None');
    
    figure(6);
    plot(error,T,'rs')
    set(6,'Name','Temperature vs. Error','position', [5 130 scrsz(3)/5.5 scrsz(4)/3.8],'MenuBar','None','Toolbar','None');
     
    seq(fcnt)=fcnt;
    timevalue(fcnt) = datenum(dir_content(i-2).date);
    S = datevec(timevalue(fcnt));
    elapsedSec(fcnt) = (S(1,6) + (S(1,5)*60) + (S(1,4)*60*60));
    elapsedSecNorm(fcnt) = round(elapsedSec(fcnt)-elapsedSec(1));
    autoresult = [seq',timevalue',elapsedSecNorm',Tmaximum',Emaximum'];
    assignin('base', 'autoresult', autoresult)
    assignin('base', 'T', T)
    
    progress=(100/fm)*(i-2)      
end

savename=cell2mat(filename(1,1));
slash=strfind(filename,'-');
slashpos=cell2mat(slash(1,1));
savename=savename(1:(slashpos-1));
savename=strcat(savename,'_summary.txt')
result=strcat(upath,'\',savename);
result=char(result);
save (result,'autoresult','-ASCII','-double');