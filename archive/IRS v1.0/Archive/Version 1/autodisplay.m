function[]=autodisplay
close all
[upath]=uigetdir();
%specify the data folder

dir_content = dir(upath);
n=size(dir_content);
n=((n(1)-3)/4)
filenames = {dir_content.name};
fcnt=1;
scrsz=get(0,'ScreenSize');

for i=1:n
    k=fcnt*3+n-1
    
    filename=filenames{k+1};
    location=strcat(upath,'\',filename)
    Error=textread(location);
    
    filename=filenames{k+2};
    location=strcat(upath,'\',filename)
    Temp=textread(location);
    
    filename=filenames{k+3};
    location=strcat(upath,'\',filename)
    Emissivity=textread(location);
    
    %Tmax(fcnt)=max(Temp(:));
    
    [Tmax(fcnt),idx]=max(Temp(:));
    [dx,dy]=ind2sub(size(Temp),idx)
    
    figure(1);
    plot(Tmax(fcnt),'O');
    set(1,'Name','Temperature vs. Acquisition','position', [5 1300 scrsz(3)/5.5 scrsz(4)/3.8]);
    hold on
    
    figure(2);
    imagesc(Temp);
    colorbar;
    set(2,'Name','2D Temperature Mapping','position', [600 745 scrsz(3)/4 scrsz(4)/2.35]);
    
    figure(3);
    imagesc(Error);
    colorbar;
    set(3,'Name','Error Map','position', [600 35 scrsz(3)/4 scrsz(4)/2.35]);
        
    [w1,w2]= size(Temp);
    w=(w1-1)/2;
    
    figure(4);
    plot(Temp(dx,(1:(w*2))),Emissivity(dx,(1:(w*2))),Temp((1:(w*2)),dy),Emissivity((1:(w*2)),dy));
    %plot(Temp(90,1:180),Emissivity(90,1:180),Temp(1:180,90),Emissivity(1:180,90));
    set(4,'Name','Temperature vs. Emissivity','position', [5 500 scrsz(3)/5.5 scrsz(4)/3.8]);
    
    choice = waitforbuttonpress;
    if choice == 1
        kkey = get(gcf,'CurrentCharacter') 
        if kkey == 'w'
           fcnt=fcnt+1;
        end
      if kkey == 's'
           fcnt=fcnt-1;
       end
        close all
    end
end

    
   

    
 

    
