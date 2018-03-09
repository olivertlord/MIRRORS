function[]=autorun(x,y,w,fi,fl)

close all;

fcnt=0;
fcnt1=0;

scrsz=get(0,'ScreenSize');

[upath]=uigetdir('/Users/oliverlord/Desktop/untitled folder');

tiffs=strcat(upath,'/*.tiff');
dir_content = dir(tiffs);
filenames = {dir_content.name};
filename=filenames(1);
savename=cell2mat(filename(1,1));
slash=strfind(filename,'-');
slashpos=cell2mat(slash(1,1));
savename=savename(1:(slashpos-1));
savename=strcat(savename,'summary_(',num2str(x),',',num2str(y),',',num2str(w),',',num2str(fi),',',num2str(fl),')');
mkdir(upath,savename);
%gathers list of .tiff files in the data folder and prepares folder for
%output

calfilename = '../Calibration/Current/tc.tiff';
ki=imread(calfilename);
%opens and reads thermal calibration file

kid=ki(1:255,1:382);                        %top left 670nm
kia=ki(1:255,384:765);                      %top right 750nm
kic=ki(256:510,1:382);                      %bottom left 850nm
kib=ki(256:510,384:765);                    %bottom right 580nm
%splits calibration file into quadrants

[byd,bxd,cyd,cxd,dyd,dxd,mo]= sc;
%determines offsets based on spatial calibration file

kiac=double(kia(y-w-4:y+w+4,x-w-4:x+w+4));
kibc=double(kib(y-w+byd-4:y+w+byd+4,x-w+bxd-4:x+w+bxd+4));
kicc=double(kic(y-w+cyd-4:y+w+cyd+4,x-w+cxd-4:x+w+cxd+4));
kidc=double(kid(y-w+dyd-4:y+w+dyd+4,x-w+dxd-4:x+w+dxd+4));
%shifts quadrants based on offsets and converts to type double

for m=5:(w*2+5)
    for n=5:(w*2+5)
        skiac(m-4,n-4)=mean(mean(kiac(m-4:m+4,n-4:n+4)));  
        skibc(m-4,n-4)=mean(mean(kibc(m-4:m+4,n-4:n+4)));
        skicc(m-4,n-4)=mean(mean(kicc(m-4:m+4,n-4:n+4)));
        skidc(m-4,n-4)=mean(mean(kidc(m-4:m+4,n-4:n+4)));
    end
end

nw=[(14384000/752.97);(14384000/578.61);(14384000/851.32);(14384000/670.08)];
nw=[ones(4,1) nw];
%determines normalised wavelengths for the four filters

%m=m+2;n=n+2; %Required for proper operation on PC

for i=fi:fl
    
    fcnt=fcnt+1;
    
    filename=filenames(i)
    location=char(strcat(upath,'/',(filename)));
    raw=imread(location);
    %reads unknown file
    
    if i==fi
       h=figure(1);
       hold on
       set(h,'outerposition', [571 709 scrsz(3) scrsz(4)]);
    end;
    %first time through loop, makes figure(1)
    
    noise = 4*(mean(mean(raw(1:8,1:8))));
    %determines background intensity
    
    maxD = max(max(raw(1:255,1:382)));
    maxA = max(max(raw(1:255,384:765)));
    maxC = max(max(raw(256:510,1:382)));
    maxB = max(max(raw(256:510,384:765)));
    
    if maxA*0.8 > noise & maxB*0.8 > noise & maxC*0.8 > noise & maxD*0.8 > noise & maxA < 64000 & maxB < 64000 & maxC < 64000 & maxD <64000;
        
        fcnt1 = fcnt1+1;
        
        [Tmax,Emax,T,error,Emissivity,umax,slope_max,intercept_max,dx,dy,suib,suia]=mapper(noise,x,y,raw,w,skiac,skibc,skicc,skidc,nw,byd,bxd,cyd,cxd,dyd,dxd);
        %calls mapper function to calculate temperature map
    
        Tmaximum(fcnt1)=Tmax;
        Tmaximum_plot(fcnt)=Tmax;
        Emaximum(fcnt1)=Emax;
        
        seq(fcnt1)=fcnt;
        timevalue(fcnt1) = datenum(dir_content(i).date);
        S = datevec(timevalue(fcnt1));
        elapsedSec(fcnt1) = (S(1,6) + (S(1,5)*60) + (S(1,4)*60*60));
        elapsedSecNorm(fcnt1) = round(elapsedSec(fcnt1)-elapsedSec(1));
        autoresult = [seq',timevalue',elapsedSecNorm',Tmaximum',Emaximum'];
        assignin('base', 'autoresult', autoresult)
        assignin('base', 'T', T)
        %generates summary data including time stamps and peak temperatures
        
        prefix=regexprep(filename,'.tiff','');
        prefix=regexprep(prefix,'-','_');
        %replaces dashes with underscores
        
        Tmap=strcat(prefix,'_','T');
        Tmap=char(strcat(upath,'/',savename,'/',Tmap));
        save(Tmap,'T','-ASCII');
        %saves temperature map
        
        Emap=strcat(prefix,'_','E');
        Emap=char(strcat(upath,'/',savename,'/',Emap));
        save(Emap,'error','-ASCII');
        %saves error map
        
        Wmap=strcat(prefix,'_','W');
        Wmap=char(strcat(upath,'/',savename,'/',Wmap));
        save(Wmap,'Emissivity','-ASCII');
        %saves emissivity map
        
        ax1=subplot(2,3,1);
        plot(nw(:,2),umax,'O')
        title_string=strcat({'Peak temperature: '},(num2str(round(Tmax))),' +/- ',(num2str(round(Emax))));
        title(title_string,'FontSize',18,'FontWeight','bold');
        xlabel('Normalised wavelength','FontSize',16);
        ylabel('Normalised intensity','FontSize',16);
        %plots normalised intensity vs normalised wavelength of hottest pixel
        
        hold on
        xline=linspace(min(nw(:,2)),max(nw(:,2)),100);
        yline=intercept_max+(slope_max*xline);
        plot(xline,yline,'-r')
        hold off
        %overlays the best fit line onto the wien plot
        
        ax2=subplot(2,3,2);
        Tmaximum_plot(Tmaximum_plot==0) = NaN;
        plot(ax2,Tmaximum_plot,'--rs','LineWidth',1,...
            'MarkerEdgeColor','b',...
            'MarkerFaceColor','b',...
            'MarkerSize',10);
        xlabel('Acquisition Number','FontSize',16);
        ylabel('Temperature (K)','FontSize',16);
        title_string=strcat(num2str(S(1,4)),':',num2str(S(1,5)),':',num2str(S(1,6)));
        title(title_string,'FontSize',18,'FontWeight','bold');
        %plots temperature vs. acquisition number
        
        microns=w*2*.18;
        xm=linspace(-(microns/2),microns/2,(w*2)+9);
        ym=linspace(-(microns/2),microns/2,(w*2)+9);
        xms=linspace(-(microns/2),microns/2,(w*2)+1);
        yms=linspace(-(microns/2),microns/2,(w*2)+1);
        %pixel to micron conversion
        
        ax3=subplot(2,3,3);
        %plot(T(w,(1:(w*2))),suib(w,(1:(w*2))),T((1:(w*2)),w),suib((1:(w*2)),w));
        plot(xms,T(dx,(1:(w*2+1))),xms,fliplr(T((1:(w*2+1)),dy)));
        axis tight;
        legend('horizontal','vertical');
        ylabel('Temperature (K)','FontSize',16);
        xlabel('Distance (microns)','FontSize',16);
        title('Temperature Cross-sections','FontSize',18,'FontWeight','bold');
        hold off
        %plots temperature vs. emissivity for horizontal and vertical transects
        %through the hottest pixel
        
        ax4=subplot(2,3,4);
        Clim = [min(min(suib)) max(max(suib))];
        originalSize = get(gca, 'Position');
        colormap jet;
        imagesc(xm,ym,suib,Clim);
        xlabel('Distance (microns)','FontSize',16)
        ylabel('Distance (microns)','FontSize',16);
        title('INTENSITY MAP','FontSize',18,'FontWeight','bold');
        colorbar;
        set(gca, 'Position', originalSize);
        hold on
        plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'ws',...
            'LineWidth',2,...
            'MarkerSize',10,...
            'MarkerEdgeColor','w',...
            'MarkerFaceColor','w')
        hold off
        %plots intensity map
        
        ax5=subplot(2,3,5);
        Clim = [(min(error(:))) (max(error(:)))];
        originalSize = get(gca, 'Position');
        imagesc(xm,ym,error,Clim);
        xlabel('Distance (microns)','FontSize',16)
        title('ERROR MAP','FontSize',18,'FontWeight','bold');
        colorbar;
        hold on
        contour(xms,yms,suib,10,'k')
        plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'ws',...
            'LineWidth',2,...
            'MarkerSize',10,...
            'MarkerEdgeColor','w',...
            'MarkerFaceColor','w')
        hold off
        set(gca, 'Position', originalSize);
        %plots error map
        
        ax6=subplot(2,3,6);
        Clim = [(min(T(:))) (max(T(:)))];
        originalSize = get(gca, 'Position');
        imagesc(xm,ym,T,Clim);
        xlabel('Distance (microns)','FontSize',16)
        title('TEMPERATURE MAP','FontSize',18,'FontWeight','bold');
        colorbar;
        set(gca, 'Position', originalSize);
        hold on
        contour(xms,yms,suib,10,'k')
        plot(.18*dy-(microns/2)-.18,.18*dx-(microns/2)-.18,'ws',...
            'LineWidth',2,...
            'MarkerSize',10,...
            'MarkerEdgeColor','w',...
            'MarkerFaceColor','w')
        hold off
        %plots temperature map
        
        drawnow;
        
        mov(fcnt1)=getframe(gcf);
    end
end

result=strcat(upath,'/',savename,'.txt');
result=char(result);
save (result,'autoresult','-ASCII','-double');
%saves summary data to text file


% use 1st frame to get dimensions
[h, w, p] = size(mov(1).cdata);
hf = figure(2); 
% resize figure based on frame's w x h, and place at (150, 150)
set(hf,'Position', [150 150 w h]);
axis off
% Place frames at bottom left
movie(hf,mov,1,10,[0 0 0 0]);
close 2;
% figure(1);
videofile=strcat(upath,'/',savename);
movie2avi(mov,videofile,'fps',5);
%save analysis as video

%OLD-CODE-----------------------------------------------------------------------------------------------

% for a=5:((w+4)*2+5)
%     for b=5:((w+4)*2+5)
%         nkia(a-4,b-4)=mean(mean(kiac(a-4:a+4,b-4:b+4)));  % Average the neighbour four pixels
%         nkib(a-4,b-4)=mean(mean(kibc(a-4:a+4,b-4:b+4)));
%         nkic(a-4,b-4)=mean(mean(kicc(a-4:a+4,b-4:b+4)));
%         nkid(a-4,b-4)=mean(mean(kidc(a-4:a+4,b-4:b+4)));
%     end
% end

% vp=[(repmat(14384000/752.97,81,1));(repmat(14384000/578.61,81,1));(repmat(14384000/851.32,81,1));(repmat(14384000/670.08,81,1))];
% v=[ones(324,1) vp];

%lf=char(location);