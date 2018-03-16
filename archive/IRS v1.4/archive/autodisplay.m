function[]=autodisplay
[upath]=uigetdir
%specify the data folder

dir_content = dir(upath);
n=size(dir_content);
n=((n(1)-3)/3);
filenames = {dir_content.name};
fcnt=1;


for i=1:n
    k=fcnt*2+i;
    filename=filenames{k+1};
    location=strcat(upath,'\',filename);
    %lef=char(location)
   
    Error=textread(location);
    filename=filenames{k+2};
    location=strcat(upath,'\',filename);
    %ltf=char(location)
    
    Temp=textread(location);
    
    Emax(fcnt)=max(Error(:));
    Tmax(fcnt)=max(Temp(:));
    
    
    scrsz=get(0,'ScreenSize');
    figure(1)
    plot(fcnt,Tmax,'O')
    set(1,'Name','Temperature vs. Acquisition','position', [1 scrsz(4)/2 scrsz(3)/3 scrsz(4)/1.6875]);
    hold on

    figure(2)
    mesh(Temp)
    set(2,'Name','Temperature Map','position', [scrsz(3)/3 scrsz(4)/2 scrsz(3)/3 scrsz(4)/1.6875]);
    
    figure(3)
    mesh(Error)
      fcnt=fcnt+1;
   set(3,'Name','Error Map','position', [scrsz(3)/1.5 scrsz(4)/2 scrsz(3)/3 scrsz(4)/1.6875]);
  pause(2)
end

    
   

    
 

    
