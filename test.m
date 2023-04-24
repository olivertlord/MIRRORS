function [] = test(example_source, output_name, handles)
%--------------------------------------------------------------------------
% Function test
%--------------------------------------------------------------------------
% Written and tested on Matlab 2022b (mac)

% Copyright 2018 Oliver Lord, Weiwei Wang
% email: oliver.lord@bristol.ac.uk
 
% This file is part of MIRRORS.
 
% MIRRORS is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
 
% MIRRORS is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
 
% You should have received a copy of the GNU General Public License
% along with MIRRORS.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
% Performs test fit of data in example folder
% 
% Inputs:

% Outputs:


%--------------------------------------------------------------------------


% Delete old output folders
folders = {'1_camera', '4_camera','.'};
for f = 1:length(folders)
    folder_path = fullfile(example_source, folders{f});
    full_list = dir(folder_path);
    
    for i = 1:length(full_list)
        if full_list(i).isdir && ~any(strcmp(full_list(i).name,...
                {'.','..','1_camera','4_camera'}))
            file_path = fullfile(folder_path, full_list(i).name);
            if isfolder(file_path)
                rmdir(file_path, 's');
            end
        end
    end
end

% Load .MAT file for storing list of unknown data to be fitted
[u,c,~] = initialise_mode('true');

% Delete existing test data and result
if exist(strcat(u.path,'/','test_data'), 'file')==2
  delete(strcat(u.path,'/','test_data'));
end
if exist(strcat(u.path,'/','result'), 'file')==2
  delete(strcat(u.path,'/','result'));
end

% Enable test mode flag in unknown.mat
u.mode = 'test';

% Set user options
set(handles.slider1,'Value',0.25)
set(handles.checkbox1,'Value',1)
set(handles.checkbox2,'Value',1)
set(handles.checkbox3,'Value',1)

% Read in calibration data and convert to double
cal_image = imread(strcat(example_source,'/tc_example.tiff'));
c.cal = im2double(cal_image);
c.name = 'tc_example.tiff';

% Write current calibration name to GUI
set(handles.text20,'String',c.name);

% Loop level 1: combinations of number of cameras and number of wavelengths
for l = 1:4
    
    % 1 camera, 4 colors
    if l == 1
        set(handles.pushbutton9,'BackgroundColor', [0 .8 0])
        set(handles.pushbutton10,'BackgroundColor', [.8 .8 .8])  
        set(handles.pushbutton14,'BackgroundColor', [0 .8 0])
        set(handles.pushbutton15,'BackgroundColor', [.8 .8 .8])
        source = strcat(example_source,'/1_camera/');
    
    % 4 cameras, 4 colors
    elseif l == 2
        set(handles.pushbutton10,'BackgroundColor', [0 .8 0])
        set(handles.pushbutton9,'BackgroundColor', [.8 .8 .8])
        source = strcat(example_source,'/4_camera/');
    
    % 4 camersas, 3 colors
    elseif l == 3
        set(handles.pushbutton15,'BackgroundColor', [0 .8 0])
        set(handles.pushbutton14,'BackgroundColor', [.8 .8 .8]) 
        source = strcat(example_source,'/4_camera/');
    
    % 1 camera, 3 colors
    elseif l == 4
        set(handles.pushbutton9,'BackgroundColor', [0 .8 0])
        set(handles.pushbutton10,'BackgroundColor', [.8 .8 .8])  
        source = strcat(example_source,'/1_camera/');

    end
    
    % Extract list of items in target directory
    test_list = dir(strcat(source,'/example_0*'));
    
    % Update .MAT file with directory target
    u.path = source;

    for m = 1:5

        for n = 6:9

            % Update .MAT file with filenames to be fitted
            u.names = {test_list.name};
            
            % Ensure timestamps are not equal
            u.timestamps = save_timestamps(source,u.names,1);
            
            % Set peak temperature radiobutton
            set(handles.(['radiobutton' num2str(m)]),'Value',1)
            
            % Set optional plot radiobutton
            set(handles.(['radiobutton' num2str(n)]),'Value',1)
            
            % Run POST PROCESS button
            callback_function = get(handles.pushbutton2, 'Callback');
            feval(callback_function, handles.pushbutton2, []);
            
            % Run SELECT ROI button
            callback_function = get(handles.pushbutton3, 'Callback');
            feval(callback_function, handles.pushbutton3, []);

            % Run PROCESS button
            callback_function = get(handles.pushbutton4, 'Callback');
            feval(callback_function, handles.pushbutton4, []);
    
            % Get current directory content
            full_list = dir(strcat(source));
            assignin('base',"full_list",full_list)
    
            % Remove existing folders and concatenate SUMMARY data into
            % benchmark
            for i = 1:length(full_list) 
                if full_list(i).isdir && ~ismember(full_list(i).name,...
                        {'.', '..'})                
                    st = readmatrix(strcat(source,full_list(i).name,...
                        '/SUMMARY.txt'),delimitedTextImportOptions);
                    fid = fopen(strcat(example_source,'/',output_name),...
                        'a+');
                    fprintf(fid,'%s\n',st{2:end});
                    fclose(fid);
                    rmdir(strcat(source,'/',full_list(i).name),'s');
                end
            end
        end
    end
end

% Disable testing mode
u.mode = 'op';

% Update path
u.path = example_source;

% Determine difference
benchmark = readmatrix(strcat(u.path,'/','benchmark_data'));
test_result = readmatrix(strcat(u.path,'/','test_data'));
difference = benchmark - test_result;

% Save result to file
assignin("base","difference",difference)
fid = fopen(strcat(u.path,'/','result'),'a+');
fprintf(fid,[repmat('%10.5f\t', 1, size(difference,2)) '\n'], difference');
fclose(fid);