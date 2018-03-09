function[]=autocal(x,y,w)

[upath]=uigetdir('C:\Documents and Settings\Laser Control\Desktop\Data\')
%specify the data folder
fcnt=0;
dir_content = dir(upath);
filenames = {dir_content.name};
current_files = filenames

while true
  pause(2);
  dir_content = dir(upath);
  filenames = {dir_content.name};
  new_files = setdiff(filenames,current_files);
  
  if ~isempty(new_files)
 
    new_files
    fcnt=fcnt+1;
    
    location=strcat(upath,'\',new_files);
    lf=char(location);
    raw=imread(lf);
    pause(1);
    [Tmax,Emax,TEMP,error,rs]= Cal(x,y,raw,w);
    Tmaxium(fcnt)=Tmax;
    Emaxium(fcnt)=Emax;
    prefix=regexprep(new_files,'.tiff','');
    prefix=regexprep(prefix,'-','_');
    Tmap=strcat(prefix,'_','T');
    Tmap=char(Tmap);
    scrsz=get(0,'ScreenSize');
    figure(2)
    plot(fcnt,Tmax,'O')
    set(2,'Name','Temperature vs. Acquisition','position', [scrsz(3)/5.4 scrsz(4)/1.50 scrsz(3)/5 scrsz(4)/3.8]);
    hold on
    %T_map=[Tmap, ' = TEMP']
    %eval(T_map);
    
    
    assignin('base', char(Tmap), TEMP)
    Emap=strcat(prefix,'_','E');
    Emap=char(Emap);
    %E_map=[Emap, ' = error'];
    %eval(E_map);
    assignin('base', char(Emap), error)
    seq(fcnt)=fcnt;
    filenum=fcnt+2;
    timevalue(fcnt) = datenum(dir_content(filenum).date);
    S = datevec(timevalue(fcnt));
    elapsedSec(fcnt) = (S(1,6) + (S(1,5)*60) + (S(1,4)*60*60));
    elapsedSecNorm(fcnt) = round(elapsedSec(fcnt)-elapsedSec(1));
    autoresult = [seq',timevalue',elapsedSecNorm',Tmaxium',Emaxium'];
    assignin('base', 'autoresult', autoresult);
    
    %autoresult(fcnt) = [fcnt',elapsedSecNorm',Tmax'];
  

    % deal with the new files
    current_files = filenames;
    
   

    
  end

    
  
end