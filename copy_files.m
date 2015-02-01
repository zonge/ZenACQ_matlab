function raw_data_dir=copy_files(left_bar,bottom_bar,width_bar,height_bar,path_output,EXTENSION,no_cal_file)
%Copy Z3D files from SD cards to an OUTPUT define path

if nargin==6
no_cal_file=false;
end

raw_data_dir='empty';

% PARAMETER
MIN_SIZE=1024;      % bytes

% GET VARIABLES
user_name=getenv('USERNAME');
date=datestr(now,'yyyy-mm-dd');
time = datestr(now,'HH_MM');

% Get the list of current drives

if ismac==1
    volume_list=dir('/Volumes');
    r=cell(size(volume_list,1)-3,1);
    for i=4:size(volume_list,1)
    r{i-3}=['/Volumes/' volume_list(i).name '/'];
    end
elseif ispc==1
    import java.io.*;
    f=File('');
    r=f.listRoots;
end

% INTIATE PROGRESS BAR
progress = waitbar(0,'COPY Z3DS...','Name','Copy Z3Ds' ...
    ,'Position',[left_bar bottom_bar width_bar height_bar]);

% FIND TOTAL NUMBER OF FILE TO COPY (FOR PROGRESS BAR)
total_files=0;
for i=1:numel(r)   
     list=dir_fixed([char(r(i)) EXTENSION]);
     %list=dir([char(r(i)) EXTENSION]);
     if ~isempty(list) && ~strcmp(char(r(i)),'C:\') && ~strcmp(char(r(i)),'D:\')
         for j=1:size(list,1)
          if list(j).bytes>MIN_SIZE && ~strcmp(list(j).name(1:3),'ZEN')
              total_files=total_files+1;
          end
         end
     end
end
% MAIN LOOP
file_nb=0;
for i=1:numel(r)
     list=dir_fixed([char(r(i)) EXTENSION]);
     %list=dir([char(r(i)) EXTENSION]);  
     if ~isempty(list) && ~strcmp(char(r(i)),'C:\') && ~strcmp(char(r(i)),'D:\')
         for j=1:size(list,1)
          if list(j).bytes>MIN_SIZE && ~strcmp(list(j).name(1:3),'ZEN')
              
              % Skip calibration file if not a calibration
              if no_cal_file==false
                  if strcmp(list(j).name(end-8:end),'_HCAL.Z3D') || strcmp(list(j).name(end-8:end),'_MCAL.Z3D') || strcmp(list(j).name(end-8:end),'_LCAL.Z3D')
                      continue
                  end
              end
              
              file_nb=file_nb+1;
              
              % SOURCE
              source=([char(r(i)) list(j).name]);
              disp(['COPY : ' source ' size : ' num2str(list(j).bytes)])
              
              % Open file
              fid = fopen(source);
              header = fscanf(fid,'%c',512);
              fclose(fid);
                
              % Read header
              HEADER=textscan(header,'%s','delimiter','\n;,&');
              channel=str2double(parsing(HEADER{1,1},'channel ',':=',2));
              Box_Nb=str2double(parsing(HEADER{1,1},'box number ',':=',2));
              
              % Fix backward compatibility with older firware
              if isnan(channel);channel=str2double(parsing(HEADER{1,1},'channel',':=',2)); end
              if isnan(Box_Nb);Box_Nb=str2double(parsing(HEADER{1,1},'box number',':=',2));end
            
              % Create folders
              date_dir=[path_output filesep date];
              time_dir=[date_dir filesep time '_' user_name '_ZEN' num2str(Box_Nb)];
              raw_data_dir=[time_dir filesep 'ZenRawData'];
              folder_dir=[raw_data_dir filesep 'ZEN' num2str(Box_Nb) '_CH' num2str(channel)];
              if ~exist(date_dir,'dir');mkdir(date_dir);end
              if ~exist(time_dir,'dir');mkdir(time_dir);end
              if ~exist(raw_data_dir,'dir');mkdir(raw_data_dir);end
              if ~exist(folder_dir,'dir');mkdir(folder_dir);end  
              
              % Copy files
              destination=folder_dir;
              copyfile(source,destination,'f'); 
             
              pourcentage=[sprintf('%0.2f',(file_nb/total_files)*100) ' %'];
              waitbar(file_nb/total_files,progress,sprintf('%s',pourcentage));
              
           end
          end
         
     end
end

if nargin==6 && file_nb>0
    attach_folder='attachment';
    list=dir(attach_folder);
    isfile=~[list.isdir];
    filenames={list(isfile).name};
    for i=1:size(filenames,2)
        copyfile([attach_folder filesep filenames{1,i} ],time_dir,'f'); 
    end
end

close(progress);
