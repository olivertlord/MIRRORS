function[]=autodisplay(Tmax)
close all
[upath]=uigetdir();
%specify the data folder
cutoff = input('Enter error cutoff vlaue');

dir_content = dir(upath);
n=size(dir_content);
n=((n(1)-2)/3);
filenames = {dir_content.name};
fcnt=1;
k=3;
scrsz=get(0,'ScreenSize');

for i=1:n
    
    filename=filenames{k};
    location=strcat(upath,'/',filename);
    Error=textread(location);
    
    filename=filenames{k+1};
    location=strcat(upath,'/',filename);
    Temp=textread(location);
    
    filename=filenames{k+2};
    location=strcat(upath,'/',filename);
    Emissivity=textread(location);
    
    m=size(Error);
    
    for a=1:m(1)
        for b=1:m(2)
            if Error(a,b)>cutoff
               Temp(a,b)=NaN;
               Emissivity(a,b)=NaN;
               Error(a,b)=NaN;
            end
        end
    end
    
    [Tmax(fcnt),idx]=max(Temp(:));
    [dx,dy]=ind2sub(size(Temp),idx);
    
    if i==1
       h=figure(1);
       hold on
       set(h,'outerposition', [571 709 scrsz(3) scrsz(4)]);
    end;
    %first time through loop, makes figure(1)
        
    ax1=subplot(2,2,1);
    plot(ax1,fcnt,Tmax(fcnt),'--rs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',10);
    xlabel('Acquisition Number','FontSize',16);
    ylabel('Temperature (K)','FontSize',16);
    title_string=strcat({'Temperature vs. Acquisition '},num2str(k/3));
    title(title_string,'FontSize',18,'FontWeight','bold');
    h1_note=text(fcnt,Tmax(fcnt),'@','HorizontalAlignment','center','BackgroundColor',[1 0 0],'Color',[1 0 0]);
          
    microns=w*2*.18;
    xm=linspace(-(microns/2),microns/2,(w*2)+9);
    ym=linspace(-(microns/2),microns/2,(w*2)+9);
    xms=linspace(-(microns/2),microns/2,(w*2)+1);
    yms=linspace(-(microns/2),microns/2,(w*2)+1);
    %pixel to micron conversion
    
    ax2=subplot(2,3,2);
    Clim = [min(min(suid)) max(max(suid))];
    originalSize = get(gca, 'Position');
    imagesc(xm,ym,suid,Clim);
    xlabel('Distance (microns)','FontSize',16)
    ylabel('Distance (microns)','FontSize',16);
    title('INTENSITY MAP','FontSize',18,'FontWeight','bold');
    colorbar;
    set(gca, 'Position', originalSize);
    hold on
    plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'w.');
    hold off
    %plots intensity map
    
    ax3=subplot(2,3,3);
    Clim = [(min(error(:))) (max(error(:)))];
    originalSize = get(gca, 'Position');
    imagesc(xm,ym,error,Clim);
    xlabel('Distance (microns)','FontSize',16)
    ylabel('Distance (microns)','FontSize',16);
    title('ERROR MAP','FontSize',18,'FontWeight','bold');
    colorbar;
    hold on
    contour(xms,yms,suid,10,'k') 
    plot((.18*dy)-(microns/2)-.18,(.18*dx)-(microns/2)-.18,'w.');
    hold off
    set(gca, 'Position', originalSize);
    %plots error map

    ax4=subplot(2,3,4);
    Clim = [(min(T(:))) (max(T(:)))];
    originalSize = get(gca, 'Position');
    imagesc(xm,ym,T,Clim);
    xlabel('Distance (microns)','FontSize',16)
    ylabel('Distance (microns)','FontSize',16);
    title('TEMPERATURE MAP','FontSize',18,'FontWeight','bold');
    colorbar;
    set(gca, 'Position', originalSize);
    hold on
    contour(xms,yms,suid,10,'k') 
    plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'w.');
    hold off
    %plots temperature map
    
    mov(fcnt)=getframe(gcf);
    
    Emax(fcnt)=Error(dx,dy);
    
    format bank;
    assignin('base','Tmax',Tmax');
    assignin('base','Emax',Emax');
    assignin('base','mov',mov);
    
    choice = waitforbuttonpress;
    if choice == 1
       
       kkey = get(gcf,'CurrentCharacter');
       
       if kkey == 'w'
          k=k+3;
          fcnt=fcnt+1;
          
          if fcnt<1
             fcnt=1;
             k=3;
          end   
       end
       
       if kkey == 's'
          k=k-3;
          fcnt=fcnt-1;
       end
       
       if kkey == 'm' | i==n
          %close all
          % use 1st frame to get dimensions
          [h, w, p] = size(mov(1).cdata);
          hf = figure(2); 
          % resize figure based on frame's w x h, and place at (150, 150)
          set(hf,'Position', [150 150 w h]);
          axis off
          % Place frames at bottom left
          movie(hf,mov,1,10,[0 0 0 0]);
          close 2;
          figure(1);
          videofile=strcat(upath,'\video');
          movie2avi(mov,videofile,'fps',5)
       end
       
       if kkey == 'q'
          close all;
          
          return
       end
       
       delete(h1_note);
   end
end

%-OLD-CODE-----------------------------------------------------------------
%     Error(all(isnan(Error),2),:)=[];
%     Error(:,all(isnan(Error),1))=[];
%     
%     Temp(all(isnan(Temp),2),:)=[];
%     Temp(:,all(isnan(Temp),1))=[];
%     
%     Emissivity(all(isnan(Emissivity),2),:)=[];
%     Emissivity(:,all(isnan(Emissivity),1))=[];
%     
%     imgSize=size(Error); %#img is your image matrix
%     finalSize=2.*ceil(max(imgSize)/2);   
%     padImg=zeros(finalSize);
%     
%     padImg(finalSize/2+(1:imgSize(1))-floor(imgSize(1)/2),...
%     finalSize/2+(1:imgSize(2))-floor(imgSize(2)/2))=Error;
%     Error = padImg;
%     Error(Error==0)=nan;
%     
%     padImg(finalSize/2+(1:imgSize(1))-floor(imgSize(1)/2),...
%     finalSize/2+(1:imgSize(2))-floor(imgSize(2)/2))=Temp;
%     Temp = padImg;
%     Temp(Temp==0)=nan;
%      
%     padImg(finalSize/2+(1:imgSize(1))-floor(imgSize(1)/2),...
%     finalSize/2+(1:imgSize(2))-floor(imgSize(2)/2))=Emissivity;
%     Emissivity = padImg;
%     Emissivity(Emissivity==0)=nan;
    
   

    
 

    
