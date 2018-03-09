function[]=autorun(x,y,w,m,n,cutoff1,cutoff2)

[byd,bxd,cyd,cxd,dyd,dxd]= sc;
close all
fcnt=0;
scrsz=get(0,'ScreenSize');
[upath]=uigetdir('/Volumes/OLLIE 1TB/Work/EXPERIMENTS/Oliver Lord/','Select data folder');
tiffs=strcat(upath,'\*.tiff');
dir_content = dir(tiffs);
filenames = {dir_content.name};

mkdir(upath,'visualisation');

calfilename = '/Volumes/OLLIE 1TB/Work/Methods & Techniques/Temperature measurement/Imaging Radiometry Software/4 COLOR (670-900)/Calibration files/25.11.13 (dacb) Calibration/tc.tiff';

ki=imread(calfilename);

kid=ki(1:255,1:382);                     %top left 670nm
kia=ki(1:255,384:765);                   %top right 750nm
kic=ki(256:510,1:382);                   %bottom left 800nm
kib=ki(256:510,384:765);                 %bottom right 900nm

kiac=double(kia(y-w-8:y+w+8,x-w-8:x+w+8));
kibc=double(kib(y-w+byd-8:y+w+byd+8,x-w+bxd-8:x+w+bxd+8));
kicc=double(kic(y-w+cyd-8:y+w+cyd+8,x-w+cxd-8:x+w+cxd+8));
kidc=double(kid(y-w+dyd-8:y+w+dyd+8,x-w+dxd-8:x+w+dxd+8));

vp=[(repmat(14384000/901.61,81,1));(repmat(14384000/800.2,81,1));(repmat(14384000/752.97,81,1));(repmat(14384000/670.08,81,1))];
v=[ones(324,1) vp];

vm=[(14384000/901.61);(14384000/800.2);(14384000/752.97);(14384000/670.08)];
vmean=[ones(4,1) vm];

fm=n;
%m=m+2;n=n+2; %Required for proper operation on PC

for i=m:n
    
    fcnt=fcnt+1;
    
    filename=filenames(i-2)
    location=strcat(upath,'/',(filename));
    lf=char(location);
    raw=imread(lf);
           
    [Tmax,Emax,T,error,ui_average,Emissivity,dx,dy,umax,umean,slope,intercept]=dataprep(x,y,raw,w,cutoff1,cutoff2,kiac,kibc,kicc,kidc,v,byd,bxd,cyd,cxd,dyd,dxd,fm);
    
    Tmaximum(fcnt)=Tmax;
    Emaximum(fcnt)=Emax;
  
    prefix=regexprep(filename,'.tiff','');
    prefix=regexprep(prefix,'-','_');
    
    Tmap=strcat(prefix,'_','T');
    Tmap=strcat(upath,'/visualisation/',Tmap);
    Tmap=char(Tmap);
    save(Tmap,'T','-ASCII');
    
    Emap=strcat(prefix,'_','E');
    Emap=strcat(upath,'/visualisation/',Emap);
    Emap=char(Emap);
    save(Emap,'error','-ASCII');
    
    Wmap=strcat(prefix,'_','W');
    Wmap=strcat(upath,'/visualisation/',Wmap);
    Wmap=char(Wmap);
    save(Wmap,'Emissivity','-ASCII');
    
    if i==m
       h=figure(1);
       hold on
       set(h,'outerposition', [571 709 scrsz(3) scrsz(4)]);
    end;
    
    ax1=subplot(2,3,1);
    plot(v(:,2),umax,'O')
    title_string=strcat({'Temperature vs. Acquisition '},(num2str(round(Tmax))),' +/- ',(num2str(round(Emax))));
    title(title_string,'FontSize',18,'FontWeight','bold');
    xlabel('Normalised wavelength','FontSize',16);
    ylabel('Normalised intensity','FontSize',16);
    hold on
    plot(vmean(:,2),umean,'rs')
    xline=linspace(min(vm),max(vm),100);
    yline=intercept+(slope*xline);
    plot(xline,yline,'-r')
    hold off
        
    ax2=subplot(2,3,2);
    plot(ax2,Tmaximum,'--rs','LineWidth',1,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',10);
    xlabel('Acquisition Number','FontSize',16);
    ylabel('Temperature (K)','FontSize',16);
    title('Temperature vs. Acquisition','FontSize',18,'FontWeight','bold');
          
    microns=w*2*.18;
    xm=linspace(-(microns/2),microns/2,w*2);
    ym=linspace(-(microns/2),microns/2,w*2);

    ax3=subplot(2,3,6);
    Clim = [(min(T(:))) (max(T(:)))];
    originalSize = get(gca, 'Position');
    imagesc(xm,ym,T,Clim);
    xlabel('Distance (microns)','FontSize',16)
    ylabel('Distance (microns)','FontSize',16);
    title('TEMPERATURE MAP','FontSize',18,'FontWeight','bold');
    colorbar;
    set(gca, 'Position', originalSize);
    hold on
    contour(ui_average,10);
    hold off
    
    ax4=subplot(2,3,5);
    Clim = [(min(error(:))) (max(error(:)))];
    originalSize = get(gca, 'Position');
    imagesc(xm,ym,error,Clim);
    xlabel('Distance (microns)','FontSize',16)
    ylabel('Distance (microns)','FontSize',16);
    title('ERROR MAP','FontSize',18,'FontWeight','bold');
    colorbar;
    set(gca, 'Position', originalSize);
    
    ax5=subplot(2,3,4);
    Clim = [0 .5];
    originalSize = get(gca, 'Position');
    imagesc(xm,ym,ui_average);
    xlabel('Distance (microns)','FontSize',16)
    ylabel('Distance (microns)','FontSize',16);
    title('INTENSITY MAP','FontSize',18,'FontWeight','bold');
    colorbar;
    set(gca, 'Position', originalSize);
    
    ax6=subplot(2,3,3);
    plot(T(dx,(1:(w*2))),Emissivity(dx,(1:(w*2))),T((1:(w*2)),dy),Emissivity((1:(w*2)),dy));
    xlabel('Temperature (K)','FontSize',16);
    ylabel('Emissivity','FontSize',16);
    title('Temperature vs. Emissivity','FontSize',18,'FontWeight','bold');
    hold off
    
    drawnow;
     
    seq(fcnt)=fcnt;
    timevalue(fcnt) = datenum(dir_content(i-2).date);
    S = datevec(timevalue(fcnt));
    elapsedSec(fcnt) = (S(1,6) + (S(1,5)*60) + (S(1,4)*60*60));
    elapsedSecNorm(fcnt) = round(elapsedSec(fcnt)-elapsedSec(1));
    autoresult = [seq',timevalue',elapsedSecNorm',Tmaximum',Emaximum'];
    assignin('base', 'autoresult', autoresult)
    assignin('base', 'T', T)     
end

savename=cell2mat(filename(1,1));
slash=strfind(filename,'-');
slashpos=cell2mat(slash(1,1));
savename=savename(1:(slashpos-1));
savename=strcat(savename,'_summary.txt')
result=strcat(upath,'\',savename);
result=char(result);
save (result,'autoresult','-ASCII','-double');

%OLD-CODE-----------------------------------------------------------------------------------------------

% for a=5:((w+4)*2+5)
%     for b=5:((w+4)*2+5)
%         nkia(a-4,b-4)=mean(mean(kiac(a-4:a+4,b-4:b+4)));  % Average the neighbour four pixels
%         nkib(a-4,b-4)=mean(mean(kibc(a-4:a+4,b-4:b+4)));
%         nkic(a-4,b-4)=mean(mean(kicc(a-4:a+4,b-4:b+4)));
%         nkid(a-4,b-4)=mean(mean(kidc(a-4:a+4,b-4:b+4)));
%     end
% end