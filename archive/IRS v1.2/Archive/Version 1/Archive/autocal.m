function[]=autocal(x,y,w)

[upath]=uigetdir('C:\Documents and Settings\Laser Control\Desktop\Data\')
%specify the data folder

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
    
    location=strcat(upath,'\',new_files);
    lf=char(location);
    raw=imread(lf);
    pause(1);
    [Tmax,TEMP,error,rs]= Cal(x,y,raw,w);
    prefix=regexprep(new_files,'.tiff','');
    Tmap=strcat(prefix,'_','T');
    Tmap=char(Tmap);
    T_map=[Tmap, ' = TEMP']
    eval(T_map);
    assignin('base', char(Tmap), TEMP)
    
    Emap=strcat(prefix,'_','E');
    Emap=char(Emap);
    E_map=[Emap, ' = error'];
    eval(E_map);
    assignin('base', char(Emap), error)
    % deal with the new files
    current_files = filenames;
  end
  
end