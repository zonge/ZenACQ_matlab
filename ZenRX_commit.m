function [ handles ] = ZenRX_commit( handles )
%ZenRX_commit set all the parameters defined by the user

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

%% CHECK INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.error_msg,'Visible','on','String','');  % Make the error msg visible

% CHECK BOARD CAL
stn_box=str2double(get(handles.box_str_val,'String'));
filename=['calibrate/ZEN' num2str(stn_box) '.cal'];
if exist(filename,'file')~=2  % IF file exist
      choice = questdlg('There is no BOARD calibration for this box. Do you want to continue ?','Yes','Yes','No','Yes');
      if strcmp(choice,'No');return;end
end

% CHECK STATION
stn_box=get(handles.stn_box,'String');
if isempty(stn_box)
    beep
    set(handles.error_msg,'Visible','on','String','STATION is empty !')
    set(handles.stn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.stn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.stn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.stn_box,'BackgroundColor',[1.0 0.949 0.867])
    return;
end
if isnan(str2double(stn_box))==1 || str2double(stn_box) ~= floor(str2double(stn_box))
    beep
    set(handles.error_msg,'Visible','on','String','STATION must be an integer !')
    set(handles.stn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.stn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.stn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.stn_box,'BackgroundColor',[1.0 0.949 0.867])  
    return;       
end
% CHECK IF THERE IS A SCHEDULE
if handles.SCHEDULE.TOTAL_TIME==0
    beep
    set(handles.error_msg,'Visible','on','String','No schedule defined !')
    set(handles.schedule_popup,'BackgroundColor','red')
    pause(0.1)
    set(handles.schedule_popup,'BackgroundColor','white')
    pause(0.1)
    set(handles.schedule_popup,'BackgroundColor','red')
    pause(0.1)
    set(handles.schedule_popup,'BackgroundColor','white')
    return;   
end

% CHECK IF SCHEDULE DOESN'T START AFTER THE DEFINE TIME
time_check=60; %second | if someone click commit 30 second before the start time the schedule won't rn
time_dif=handles.start_time-now-time_check/86400;
if time_dif<0
    beep
    set(handles.error_msg,'Visible','on','String','The start time of the schedule is anterior or to close to now.')
    set(handles.hour_popup,'BackgroundColor','red')
    set(handles.min_popup,'BackgroundColor','red')
    set(handles.date_push,'BackgroundColor','red')
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.min_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.date_push,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor','red')
    set(handles.min_popup,'BackgroundColor','red')
    set(handles.date_push,'BackgroundColor','red')
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.min_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.date_push,'BackgroundColor',[1.0 0.949 0.867])
    return;  
end

% CHECK SURVEY DESIGN TABLE CONTENT
tbl_content=get(handles.geometry_table,'data');

% CHECK GEOMETRY
if ~isempty(find(cellfun(@isempty,tbl_content(:,1:3))==1,1))
        beep
        set(handles.error_msg,'Visible','on','String','The survey is not complete !')
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        return;
else
    % CHECK FOR NOT NUMBERS
    MAT=zeros(size(tbl_content,1),2);
    for ch=1:size(tbl_content,1)
        for col=2:3
            MAT(ch,col-1)=str2double(tbl_content{ch,col}); 
        end 
    end
    if sum(sum(isnan(MAT),1))>0
        beep
        set(handles.error_msg,'Visible','on','String','Survey information must be numbers. !')
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        return;
    end
    % CHECK FOR VALUE OUT OF RANGE
    if sum(MAT(:,2)<0) || sum(MAT(:,2)>360)
        beep
        set(handles.error_msg,'Visible','on','String','+ Orientation must be between 0 and 360 !')
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        return;
    end
    
end

% CHECK CRES (WARNING)
if ~isempty(find(cellfun(@isempty,tbl_content(:,4))==1,1))
    set(handles.get_cres,'BackgroundColor','blue')
    pause(0.1)
    set(handles.get_cres,'BackgroundColor','red')
    pause(0.1)
    set(handles.get_cres,'BackgroundColor','blue')
    pause(0.1)
    set(handles.get_cres,'BackgroundColor','red')
    choice = questdlg('There is no contact resistance data. Do you want to continue ?','Yes','Yes','No','Yes');
    if strcmp(choice,'No');return;end
end
    
%% SAVE SURVEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get GUI information
job_operator_box=get(handles.job_operator_box,'String');
job_number_box=get(handles.job_number_box,'String');
job_name_box=get(handles.job_name_box,'String');
job_by_box=get(handles.job_by_box,'String');
job_for_box=get(handles.job_for_box,'String');

% CHECK SURVEY Value
if size(job_operator_box,2)>64
    beep
    set(handles.error_msg,'Visible','on','String','Maximum character is 64')
    set(handles.job_operator_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor',[1 1 1])
    return;
    
elseif size(job_number_box,2)>64
    beep
    set(handles.error_msg,'Visible','on','String','Maximum character is 64')
    set(handles.job_number_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor',[1 1 1])
    return;
    
elseif size(job_name_box,2)>64
    beep
    set(handles.error_msg,'Visible','on','String','Maximum character is 64')
    set(handles.job_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor',[1 1 1])
    return;
        
elseif size(job_by_box,2)>64
    beep
    set(handles.error_msg,'Visible','on','String','Maximum character is 64')
    set(handles.job_by_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor',[1 1 1])
    return;
    
elseif size(job_for_box,2)>64
    beep
    set(handles.error_msg,'Visible','on','String','Maximum number of characters is : 64')
    set(handles.job_for_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_for_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_for_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_for_box,'BackgroundColor',[1 1 1])
    return;
    
end


fid = fopen('survey.zen','w+');

fprintf(fid,'$job_operator_box = %s\n',job_operator_box);
fprintf(fid,'$job_number_box = %s\n',job_number_box);
fprintf(fid,'$job_name_box = %s\n',job_name_box);
fprintf(fid,'$job_by_box = %s\n',job_by_box);
fprintf(fid,'$job_for_box = %s',job_for_box);

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% SET METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progress = waitbar(0,'Clear Metadata','Name','Metadata' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

% Clear metadata
for ch=1:size(handles.CHANNEL.ch_serial,2)
QuickSendReceive(handles.CHANNEL.ch_serial{ch},'metadata clear',10,'WroteNumMetaDataRecords(0x',')');
end

%% SET METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tbl_content=get(handles.geometry_table,'data');
ch_num=get(handles.geometry_table,'RowName');
Stn_num=get(handles.stn_box,'String');
for ch=1:size(handles.CHANNEL.ch_serial,2)
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
    
    if strcmp(tbl_content{index,1}(1),'E')
    
    meta_str=['METADATA CH.CMP,' tbl_content{index,1} ...
                   '|CH.NUMBER,' Stn_num ...
                   '|CH.LENGTH,' tbl_content{index,2} ...
                  '|CH.AZIMUTH,' tbl_content{index,3} ...
                      '|RX.STN,' Stn_num ];
              
    elseif strcmp(tbl_content{index,1}(1),'H')
        
    meta_str=['METADATA CH.CMP,' tbl_content{index,1} ...
                   '|CH.NUMBER,' tbl_content{index,2} ...
                   '|CH.LENGTH,' '0' ...
                  '|CH.AZIMUTH,' tbl_content{index,3} ...
                      '|RX.STN,' Stn_num ];
        
    end
    
    if isempty(find(cellfun(@isempty,tbl_content(:,4))==1,1))
      CRES=['|CH.CRES,' tbl_content{index,4}];
      if strcmp(CRES,'|CH.CRES,Inf')
          CRES='|CH.CRES,1.0e32';
      end
    else
      CRES='';
    end
    
    
    meta_str2=[meta_str '|JOB.NAME,' job_name_box ...
        '|JOB.FOR,' job_for_box ...
        '|JOB.BY,' job_by_box ...
        '|JOB.NUMBER,' job_number_box ...
        '|GDP.OPERATOR,' job_operator_box ...
        CRES '|'];
      
    
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str2,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',['Set Metadata : ' pourcentage]));
end

close(progress)


% SET CAL

if exist(filename,'file')==2
    
     % READ BOARD CAL
     formatSpec = '%s%s%s%s%f%s%f%s%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
     fileID = fopen(filename,'r');
     dataArray = textscan(fileID, formatSpec, 'Delimiter', '\t', 'HeaderLines' ,3, 'ReturnOnError', false);
     fclose(fileID);

    progress = waitbar(0,'SET CALIBRATION','Name','Metadata' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

for ch=1:size(handles.CHANNEL.ch_serial,2)
    
     AA='';
     AA1='';
     for i=1:size(dataArray{1,1},1)
         if dataArray{1,10}(i,1)==256
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,9}(i,1)) ':00000000:' num2str(dataArray{1,13}(i,1)) ':' num2str(dataArray{1,14}(i,1)) ', ' ];
                AA=[AA  str];
            end
         end
         if dataArray{1,10}(i,1)==4096
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,9}(i,1)) ':00000004:' num2str(dataArray{1,13}(i,1)) ':' num2str(dataArray{1,14}(i,1)) ', ' ];
                AA1=[AA1  str];
            end
         end
     end

     
     end_first_block=strfind(AA,', 1:')-1;
     end_second_block=strfind(AA1,', 16:')-1;
    
    meta_str1=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
                   ',     ' AA(1:end_first_block) '|'];
    meta_str2=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
                   ',     ' AA(end_first_block+3:end-2) '|'];
    meta_str3=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
                   ',     ' AA1(1:end_second_block) '|'];
    meta_str4=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
                   ',     ' AA1(end_second_block+3:end-2) '|'];
              
    
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str1,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str2,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str3,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str4,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',['Set Metadata : ' pourcentage]));
end

close(progress)
end

%% SET ZEN FOR SCHEDULE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DUTY=0;
FREQ=zeros(1,size(handles.SCHEDULE.OBJ,1));
SR=zeros(1,size(handles.SCHEDULE.OBJ,1));
gain=zeros(1,size(handles.SCHEDULE.OBJ,1));
run_for=zeros(1,size(handles.SCHEDULE.OBJ,1));
        
for i=1:size(handles.SCHEDULE.OBJ,1)
    FREQ(1,i)=0;
    SR(1,i)=handles.SCHEDULE.OBJ(i,1).sr;
    gain(1,i)=log2(double(handles.SCHEDULE.OBJ(i,1).gain));
    run_for(1,i)=handles.SCHEDULE.OBJ(i,1).duration;
end

handles=l_Rx_update_time( handles );

time_between_files=handles.main.time_btw_sch;
time_zone=str2double(handles.setting.time_zone)*3600/86400;
set_time_dec=handles.start_time-time_zone+16/86400;
start_time=datestr(set_time_dec,'yyyy-mm-dd,HH:MM:SS');

% ALGORYTHM FOR THE NOMENCLATURE
day=str2double(datestr(set_time_dec,'dd'));
hour=str2double(datestr(set_time_dec,'HH'));
min=str2double(datestr(set_time_dec,'MM'));
if min>35;min=min-36;end
String = 'abcdefghijklmnopqrstuvwxyz0123456789';
l1=String(day+1); l2=String(hour+1); l3=String(min+1);
letters=['_' l1 l2 l3 ];

      
% RUN ACQUISTION
[run_in]=l_run_schedule(start_time,false,1,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,0);

% GLOBAL SAVE
progress = waitbar(0,'SAVE','Name','Set Schedule' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   
for ch=1:size(handles.CHANNEL.ch_serial,2)
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},'globalsave',10,'Brd339>',0);
    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',['SAVE : ' pourcentage]));
end
close(progress)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET COUNTDOWN
set(handles.error_msg,'Value',handles.start_time)  % Set start countdown.
end_time=addtodate(handles.start_time, run_in, 'second');
set(handles.box_str,'Value',end_time)  % Set end countdown.



end

