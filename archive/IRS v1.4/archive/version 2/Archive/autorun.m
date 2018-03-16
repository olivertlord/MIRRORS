function[]=autorun(x,y,w,m,n,cutoff)

[upath]=uigetdir;
%specify the data folder

dir_content = dir(upath);
filenames = {dir_content.name};
fcnt=0;
m=m+2;n=n+2;
for i=m:n
    fcnt=fcnt+1;
   
    filename=filenames(i);
    location=strcat(upath,'\',(filename));
    lf=char(location)
    raw=imread(lf);
    [Tmax,Emax,TEMP,error,rs,uia,uib,uic,uid,nraw]= Cal(x,y,raw,w,cutoff);
    scrsz=get(0,'ScreenSize');
    figure(2)
    plot(fcnt,Tmax,'O')
    set(2,'Name','Temperature vs. Acquisition','position', [5 scrsz(4)/3 scrsz(3)/5.5 scrsz(4)/3.8]);
    hold on
    figure(3);
    f3=imagesc(TEMP);
    colorbar('EastOutside');
    set(3,'Name','2D Temperature Mapping','position', [400 545 scrsz(3)/4 scrsz(4)/2.35]);
    %figure(4);
    %f4=imagesc(error);
    %colorbar('EastOutside');
    %set(4,'Name','error','position', [1395 35 scrsz(3)/3.7 scrsz(4)/2.2]);
    Tmaxium(fcnt)=Tmax;
    Emaxium(fcnt)=Emax;
    prefix=regexprep(filename,'.tiff','');
    prefix=regexprep(prefix,'-','_');
    Tmap=strcat(prefix,'_','T');
    Tmap=strcat(upath,'\',Tmap);
    Tmap=char(Tmap);
    
    figure(4);
    f4=imagesc(rs);
    colorbar('EastOutside');
    set(4,'Name','R squared','position', [400 35 scrsz(3)/4 scrsz(4)/2.35]);
    
    figure(5);
    uia = uia/max(uia(:));
    uib = uib/max(uib(:));
    uic = uic/max(uic(:));
    uid = uid/max(uid(:));
    ui_relative = (uia+uib+uic+uid)/4;
    f5=imagesc(ui_relative);
    colorbar('EastOutside');
    set(5,'Name','Averaged Intensity Map','position', [930 545 scrsz(3)/4 scrsz(4)/2.35]);
    
    figure(6);
    nraw = nraw/max(nraw(:));
    Clims = [0 .1];
    f6 = imagesc(nraw,Clims);
    colorbar('EastOutside');
    set(6,'Name','Intensity Map (all)','position', [930 35 scrsz(3)/4 scrsz(4)/2.35]);
    
    %figure(2)
    %plot(fcnt,Tmax,'O')
    %set(2,'Name','Temperature vs. Acquisition','position', [scrsz(3)/5.4 scrsz(4)/1.50 scrsz(3)/5 scrsz(4)/3.8]);
    %hold on
    %T_map=[Tmap, ' = TEMP']
    %eval(T_map);
    
    %assignin('base', char(Tmap), TEMP)
    save(Tmap,'TEMP','-ASCII');
    Emap=strcat(prefix,'_','E');
    Emap=strcat(upath,'\',Emap);
    Emap=char(Emap);
    
    %E_map=[Emap, ' = error'];
    %eval(E_map);
    %assignin('base', char(Emap), error)
    save(Emap,'error','-ASCII');
    seq(fcnt)=fcnt;
    %filenum=fcnt+2;
    timevalue(fcnt) = datenum(dir_content(i).date);
    S = datevec(timevalue(fcnt));
    elapsedSec(fcnt) = (S(1,6) + (S(1,5)*60) + (S(1,4)*60*60));
    elapsedSecNorm(fcnt) = round(elapsedSec(fcnt)-elapsedSec(1));
    autoresult = [seq',timevalue',elapsedSecNorm',Tmaxium',Emaxium'];
    %assignin('base', 'autoresult', autoresult);
  clear uia uib uic uid nraw ui_relative
end

result=strcat(upath,'\','summary.txt');
result=char(result);
  save (result,'autoresult','-ASCII');
  
    
   

    
 

    
