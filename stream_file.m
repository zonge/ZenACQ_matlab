function [ raw_data_dir ] = stream_file( handles )
%COPY FILE THROUGH THE STREAMING COMMAND AND DELETE AFTER COPIED

% GET VARIABLES
folder=['calibrate' filesep 'brd_temp'];
user_name=getenv('USERNAME');
date=datestr(now,'yyyy-mm-dd');
time = datestr(now,'HH_MM');
Box_Nb=handles.CHANNEL.ch_info{1,1}.BoxNb;
date_dir=[folder filesep date];
time_dir=[date_dir filesep time '_' user_name '_ZEN' num2str(Box_Nb)];
raw_data_dir=[time_dir filesep 'ZenRawData'];

     progress = waitbar(0,'Transfer Calibration','Name','Calibration' ...
     ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
     handles.main.GUI.width_bar handles.main.GUI.height_bar]);   
     %set(progress, 'WindowStyle','modal', 'CloseRequestFcn','');


for ch=1:size(handles.CHANNEL.ch_serial,2) % LOOP THROUGH CHANNELS
    
  %[c.List_Files,c.Nb_of_Files] = list_SDfiles(handles.CHANNEL.ch_serial{ch});
  c.List_Files{1,1}.name{1,1}='01_LCAL.Z3D';
  c.List_Files{1,1}.name{2,1}='02_LCAL.Z3D';
  c.List_Files{1,1}.name{3,1}='03_LCAL.Z3D';
  c.List_Files{1,1}.name{4,1}='04_LCAL.Z3D';
  c.List_Files{1,1}.name{5,1}='05_LCAL.Z3D';
  c.List_Files{1,1}.name{6,1}='06_MCAL.Z3D';
  c.List_Files{1,1}.name{7,1}='07_MCAL.Z3D';
  c.List_Files{1,1}.name{8,1}='08_MCAL.Z3D';
  c.List_Files{1,1}.name{9,1}='09_MCAL.Z3D';
  c.List_Files{1,1}.name{10,1}='10_MCAL.Z3D';
  c.List_Files{1,1}.name{11,1}='11_MCAL.Z3D';
  c.List_Files{1,1}.name{12,1}='01_HCAL.Z3D';
  c.List_Files{1,1}.name{13,1}='02_HCAL.Z3D';
  c.List_Files{1,1}.name{14,1}='03_HCAL.Z3D';
  c.List_Files{1,1}.name{15,1}='04_HCAL.Z3D';
  c.List_Files{1,1}.name{16,1}='05_HCAL.Z3D';
  c.List_Files{1,1}.name{17,1}='06_HCAL.Z3D';
  c.List_Files{1,1}.name{18,1}='07_HCAL.Z3D';
  c.List_Files{1,1}.name{19,1}='08_HCAL.Z3D';
  c.Nb_of_Files=19;
  
  if c.Nb_of_Files==0 % If no file --> go to next channel
    continue
  end
  
  pourcentage=[sprintf('%0.2f',((ch-1)/size(handles.CHANNEL.ch_serial,2))*100) ' %'];

  for filenb=1:c.Nb_of_Files % LOOP THROUGH FILES
      
    ch_exist=1;
    
    keepGoing=0;
    filename=c.List_Files{1,1}.name{filenb,1};
    
    % Skip calibration file if not a calibration
    if size(filename,2)<8 ; 
        continue ; 
    end
    
    if strcmp(filename(end-8:end),'_LCAL.Z3D')
    	keepGoing=1;
    elseif strcmp(filename(end-8:end),'_MCAL.Z3D')
        keepGoing=1;    
    elseif strcmp(filename(end-8:end),'_HCAL.Z3D')
        keepGoing=1;
    end
                  
    if keepGoing==0
        continue
    end
    
    waitbar((ch-1)/size(handles.CHANNEL.ch_serial,2),progress...
        ,sprintf('%s',['Transfer calibration : Ch ' num2str(ch) ' - ' filename(1:2) ':' filename(4:end) ' - ' pourcentage]));

    % FLUSH OUTPUT BUFFER
    LLL=handles.CHANNEL.ch_serial{ch}.BytesAvailable;
    if LLL>0
    fread(handles.CHANNEL.ch_serial{ch},LLL);
    end

    % SEND STREAMING COMMAND
    Command=['STREAMFILE ' filename];
    status=false;
    inc_send=0;
    while status~=true 
        inc_send=inc_send+1;
        pause(0.1);
        fprintf(handles.CHANNEL.ch_serial{ch},Command);                      % SEND COMMAND
    
        % CHECK FOR ANSWER
        [data,status] = waitln_bin(handles.CHANNEL.ch_serial{ch},Command);   % RECEIVE DATA
        
        % SEND ONCE AGAIN IF NO ANSWER
        if inc_send>1  % If no answer after 1 try, stop
            break;
        end 
    end
    
    % If file does not exist
         for i=1:size(data,1)-14
         if data(i,1)==102 && data(i+1,1)==97 && data(i+2,1)==105 && data(i+3,1)==108 ...
                 && data(i+4,1)==101 && data(i+5,1)==100 && data(i+6,1)==32 && data(i+7,1)==119 ...
                 && data(i+8,1)==105 && data(i+9,1)==116 && data(i+10,1)==104 && data(i+11,1)==58 ...
                 && data(i+12,1)==32 && data(i+13,1)==52           
         ch_exist=0;  
         break;
         end
         end
         
         if ch_exist==0;disp('No Valid Data found');continue;end
    
    % Find start
    for i=1:size(data,1)-16
        if data(i,1)==10 && data(i+1,1)==10 && data(i+2,1)==10 && data(i+3,1)==71 ...
                && data(i+4,1)==80 && data(i+5,1)==83 && data(i+6,1)==32 && data(i+7,1)==66 ...
                && data(i+8,1)==114 && data(i+9,1)==100 && data(i+10,1)==51 && data(i+11,1)==51 ...
                && data(i+12,1)==57 && data(i+13,1)==32 && data(i+14,1)==76 && data(i+15,1)==111
        
        data(1:i-1)=[];   
        break;
        end
    end
    
    % Find last second
    lastflag=0;
    found=0;j=0;
    while found==0
        j=j+1;
        i=size(data,1)-8-j;
        if data(i,1)==255 && data(i+1,1)==255 && data(i+2,1)==255 && data(i+3,1)==127 ...
             && data(i+4,1)==0 && data(i+5,1)==0 && data(i+6,1)==0 && data(i+7,1)==128
        lastflag=i;
        found=1;
        end
        
    end
     
    
    % Find end
    for i=lastflag:size(data,1)-16
        if  data(i,1)==83 && data(i+1,1)==116 && data(i+2,1)==114 && data(i+3,1)==101 && data(i+4,1)==97 && data(i+5,1)==109 ...
                && data(i+6,1)==70 && data(i+7,1)==105 && data(i+8,1)==108 && data(i+9,1)==101 ...
                && data(i+10,1)==32 && data(i+11,1)==67 && data(i+12,1)==111 && data(i+13,1)==109 && data(i+14,1)==109
        
        data(i-8:end)=[];   
        break;
        end
    end
    
    
    channel=handles.CHANNEL.ch_info{1,ch}.ChNb;
    folder_dir=[raw_data_dir filesep 'ZEN' num2str(Box_Nb) '_CH' num2str(channel)];

    % Create folders if they dont exist
    if ~exist(folder,'dir');mkdir(folder);end
    if ~exist(date_dir,'dir');mkdir(date_dir);end
    if ~exist(time_dir,'dir');mkdir(time_dir);end
    if ~exist(raw_data_dir,'dir');mkdir(raw_data_dir);end
    if ~exist(folder_dir,'dir');mkdir(folder_dir);end  
    fileID = fopen([folder_dir filesep filename],'w');
    fwrite(fileID,data);
    fclose(fileID);


    % DELETE FILE
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},['DELETEFILE ' filename],10,'leteFileCommand','Deleted');

  end
end

delete(progress)

end

