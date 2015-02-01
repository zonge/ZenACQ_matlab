function [ handles ] = ZenRX_commit( handles )
%ZenRX_commit set all the parameters defined by the user

% Zonge International Inc.
% Created by Marc Benoit
% Dec 10, 2014


% IF COMMIT CONTINUE ELSE 
if strcmp(get(handles.set_up,'String'),handles.language.set_up_transmit_str2)
   set(handles.error_msg,'Value',0,'String','Acquisition stopped'); 
   set(handles.box_str,'Value',0)
   set(handles.set_up,'String',handles.language.set_up_str)
   
    progress = waitbar(0,handles.language.progress_str6,'Name',handles.language.progress_title2 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   
   
    for ch=1:size(handles.CHANNEL.ch_serial,2)
         
        % Clear schedule
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},'clearschedule',10,'Entirescheduledeleted','T');
         
        % Datalog 0
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},'datalog 0',10,'DataLoggingtoflashcardis:','.');
        
        % GlobalSave
        fprintf(handles.CHANNEL.ch_serial{ch},'GLOBALSAVE');
        
        waitbar(1,progress,sprintf('%s',handles.language.progress_str6));
    end 

   

% WAIT FOR GLOBAL SAVE
for ch=1:size(handles.CHANNEL.ch_serial,2)
    try
        waitln(handles.CHANNEL.ch_serial{ch},'GlobalSave():Complete','SAVE PARAMETERS',10);
    catch error_c
         msgbox(['Error trying to save | Error msg: ' error_c.message ]);
    end
      
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',pourcentage));
    
end

close(progress);
    
   
   return
end




%% CHECK INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.error_msg,'Visible','on','String','');  % Make the error msg visible
survey_type=str2double(handles.setting.ZenACQ_mode);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK SURVEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% CHECK STATION
Xstn_box=get(handles.Xstn_box,'String');
if isempty(Xstn_box)
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg2)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])
    return;
end
if isnan(str2double(Xstn_box))==1 || str2double(Xstn_box) ~= floor(str2double(Xstn_box))
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.input_err1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])  
    return;       
end

Ystn_box=get(handles.Ystn_box,'String');
if isempty(Ystn_box)
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg2)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])
    return;
end
if isnan(str2double(Ystn_box))==1 || str2double(Ystn_box) ~= floor(str2double(Ystn_box))
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.input_err1)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])  
    return;       
end


% CHECK SURVEY DESIGN TABLE CONTENT
tbl_content=get(handles.geometry_table,'data');

    for ch=1:size(tbl_content,1)
         if strcmp(tbl_content{ch,1},'Off'); continue;end
        for col=2:7
            if isempty(tbl_content{ch,col}) || isnan(tbl_content{ch,col}) 
                       beep
                       set(handles.error_msg,'Visible','on','String',handles.language.commit_msg5)
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
    end  

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK CALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CHECK BOARD CAL
zen_box=str2double(get(handles.box_str_val,'String'));
filename=['calibrate/ZEN' num2str(zen_box) '.cal'];
if exist(filename,'file')~=2  % IF file exist
      choice = questdlg(handles.language.commit_msg1,handles.language.yes,handles.language.yes,handles.language.no,handles.language.yes);
      if strcmp(choice,handles.language.no);return;end
end

% CHECK ATENNA CAL
filepath =['calibrate\' handles.main.calibrate_file_name];        
if exist(filepath,'file')~=2 % CHECK IF FILE DOESNT EXIST
    choice = questdlg(handles.language.commit_msg8,handles.language.yes,handles.language.yes,handles.language.no,handles.language.yes);
    if strcmp(choice,handles.language.no);return;end
else % IF FILE EXIST, CHECK IF ANTENNA ARE IN THE FILE
    tbl_content=get(handles.geometry_table,'data');
    for ch=1:size(tbl_content,1)
        if strcmp(tbl_content{ch,1}(1),'H');
            [~,ant_list] = read_antenna_file( filepath ); % CHECK IF ANTENNA EXIST
            ant_exist=find(ant_list==tbl_content{ch,6}, 1);
            if isempty(ant_exist) % IF IT DOESN"T EXIST BEEP AND MESSAGE
                beep
                w=msgbox(['#' num2str(tbl_content{ch,6}) ' is not found in ' handles.main.calibrate_file_name '.' ]);
                uiwait(w)
            end  
        end 
    end
end

% CHECK TX CAL
if handles.main.type==1 % TX
    filename =['calibrate\' handles.main.TX_cal_file_name];        
if exist(filename,'file')~=2 % IF FILE DOESNT EXIST
    for ch=1:size(tbl_content,1)
         if strcmp(tbl_content{ch,1}(1:2),'TX');
            errordlg('TX.cal is requiered to take data.','TX File Error');
            return
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK TRANSMITTER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONFIRM TRANSMIT ACTION
if handles.main.type==1 && survey_type==2  % TX
    choice = questdlg(handles.language.transmit_popup_msg,handles.language.ZenTitle2 ...
        ,handles.language.yes,handles.language.no,handles.language.no);
    if strcmp(choice,handles.language.no);return;end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK SCHEDULE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles = l_Rx_update_time( handles ); % update start and end time

% CHECK IF THERE IS A SCHEDULE
if handles.SCHEDULE.TOTAL_TIME==0
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg3)
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
if handles.main.type==0
time_check=60; %second | if someone click commit 60 second before the start time the schedule won't rn
now_val=get(handles.status_sync_val,'Value');
time_dif=handles.start_time-now_val-time_check/86400;
if time_dif<0
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg4)
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
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
%% SAVE SURVEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Get GUI information
job_operator_box=get(handles.job_operator_box,'String');
job_number_box=get(handles.job_number_box,'String');
job_name_box=get(handles.job_name_box,'String');
job_by_box=get(handles.job_by_box,'String');
job_for_box=get(handles.job_for_box,'String');

% CHECK SURVEY Value
if size(job_operator_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_operator_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor',[1 1 1])
    return;
    
elseif size(job_number_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_number_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor',[1 1 1])
    return;
    
elseif size(job_name_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor',[1 1 1])
    return;
        
elseif size(job_by_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_by_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor',[1 1 1])
    return;
    
elseif size(job_for_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if handles.main.type==1 % if TX Disable Transmit
    set(handles.set_up,'Enable','off')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SET METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progress = waitbar(0,handles.language.progress_str1,'Name',handles.language.progress_title1 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

% Clear metadata
for ch=1:size(handles.CHANNEL.ch_serial,2)
QuickSendReceive(handles.CHANNEL.ch_serial{ch},'metadata clear',10,'WroteNumMetaDataRecords(0x',')');
end

%% SET METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tbl_content=get(handles.geometry_table,'data');
ch_num=get(handles.geometry_table,'RowName');
Xstn_num=get(handles.Xstn_box,'String');
Ystn_num=get(handles.Ystn_box,'String');
Stn_num=[Xstn_num ':' Ystn_num];
Line_num=get(handles.line_box,'String');
LineName='';
if ~isempty(Line_num)
	LineName=['LINE.NAME,' Line_num '|'];
end
a_space=get(handles.a_space_box,'String');
s_space=get(handles.s_space_box,'String');
switch survey_type
    case 1
        survey_type_str='MT';
    case 2
        survey_type_str='CRIP';
    case 3
        survey_type_str='TDIP'; 
end

Zpositive=get(handles.z_positive,'Value');
xazimuth = str2double(get(handles.SX_azimut_box,'String'));
if Zpositive==2
  yazimuth = xazimuth - 90;
else % zpositive==down
  yazimuth = xazimuth + 90;
end
yazimuth = mod(yazimuth+2*360,360);


nb_chn=0;
for ch=1:size(handles.CHANNEL.ch_serial,2)
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
    
    if strcmp(tbl_content{index,1},'Off'); continue;end

    nb_chn=nb_chn+1;
    
        % META 1
        meta_str1=['METADATA GDP.PROGVER,' [handles.main.ProgramName ',' handles.main.ProgramVersion] ...
                   '|GDP.OPERATOR,' job_operator_box ...
                   '|SURVEY.TYPE,' survey_type_str ...
                   '|Unit.Length,' 'm' ...
                   '|'];
    
        % META 2
        meta_str2=['METADATA JOB.NAME,' job_name_box ...
                   '|JOB.FOR,' job_for_box ...
                   '|JOB.BY,' job_by_box ...
                   '|JOB.NUMBER,' job_number_box ...
                   '|'];
    
        % META 3
        meta_str3=['METADATA ' LineName  ...
                   'RX.XYZ0,' Stn_num ...
                   '|RX.XAZIMUTH,' num2str(xazimuth)  ...
                   '|RX.YAZIMUTH,' num2str(yazimuth)  ...
                   '|RX.ASpace,' a_space ...
                   '|RX.SSpace,' s_space ...
                   '|'];
    
        % META 4
    if strcmp(tbl_content{index,1}(1),'E')
    
        meta_str4=['METADATA CH.CMP,' num2str(tbl_content{index,1}) ...
                   '|CH.NUMBER,' num2str(str2double(Xstn_num)+(tbl_content{index,2}+tbl_content{index,4})/2) ...
                   '|CH.LENGTH,' num2str(tbl_content{index,6}) ... %% ?
                   '|CH.AZIMUTH,' num2str(tbl_content{index,7}) ...
                   '|CH.XYZ1,' [num2str(tbl_content{index,2}) ':' num2str(tbl_content{index,4})] ...
                   '|CH.XYZ2,' [num2str(tbl_content{index,3}) ':' num2str(tbl_content{index,5})] ...
                   '|'];
              
    elseif strcmp(tbl_content{index,1}(1),'H')
        
        meta_str4=['METADATA CH.CMP,' num2str(tbl_content{index,1}) ...
                   '|CH.NUMBER,' num2str(tbl_content{index,6}) ...
                   '|CH.LENGTH,' '0' ...
                   '|CH.AZIMUTH,' num2str(tbl_content{index,7}) ...
                   '|CH.XYZ1,' [num2str(tbl_content{index,2}) ':' num2str(tbl_content{index,4})] ...
                   '|CH.XYZ2,' [num2str(tbl_content{index,3}) ':' num2str(tbl_content{index,5})] ...
                   '|'];
              
    elseif strcmp(tbl_content{index,1}(1:2),'TX')
    
        filepath =['calibrate' filesep handles.main.TX_cal_file_name];
        TX=read_tx_file( filepath );
    
        for tx_i=1:size(TX,1);if strcmp(TX(tx_i).Serial,tbl_content{index,6});break;end;end 
    
        TXsense=TX(tx_i).Sense; 
        TXtype=TX(tx_i).Type;
        TXSerial=TX(tx_i).Serial;
        CH_length_TX=num2str(sqrt((tbl_content{index,2}-tbl_content{index,4})^2+(tbl_content{index,3}-tbl_content{index,5})^2)*a_space/s_space);
        
        meta_str4=['METADATA CH.CMP,' 'Ref' ...
                   '|CH.NUMBER,' num2str(str2double(Xstn_num)+(tbl_content{index,2}+tbl_content{index,4})/2) ...
                   '|CH.LENGTH,' CH_length_TX ...
                   '|CH.AZIMUTH,' num2str(tbl_content{index,7}) ...
                   '|CH.XYZ1,' [num2str(tbl_content{index,2}) ':' num2str(tbl_content{index,4})] ...
                   '|CH.XYZ2,' [num2str(tbl_content{index,3}) ':' num2str(tbl_content{index,5})] ...
                   '|TX.TYPE,' TXtype ...
                   '|TX.SENSE,' TXsense ...
                   '|TX.SN,' TXSerial ...
                   '|'];
              
    end
    
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str1,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str2,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str3,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str4,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str2 ' ' pourcentage]));
end

close(progress)


%% SET SYSTEM CAL
l_write_sys_cal( handles );

%% SET ANTENNA CAL
l_write_ant_cal( handles );

%% SET SCHEDULE 
if handles.main.type==1 % TX
DUTY=handles.main.duty_cycle;
else
DUTY=0;
end

% ADJUST SCHEDULE IF LATE.
if handles.late==true
    [ DELAY_SCHEDULE,STATUS ] = l_Offset_schedule( handles );
    if STATUS==false;
        w=msgbox('The schedule is already complete at this time pick a anterior time for the ZenRX start time','ZenACQ');
        uiwait(w);
        return;
    end
    USED_SCHEDULE=DELAY_SCHEDULE;
    
elseif handles.late==false
    USED_SCHEDULE=handles.SCHEDULE.OBJ;
end

FREQ=zeros(1,size(USED_SCHEDULE,1));
SR=zeros(1,size(USED_SCHEDULE,1));
gain=zeros(1,size(USED_SCHEDULE,1));
run_for=zeros(1,size(USED_SCHEDULE,1));

for i=1:size(USED_SCHEDULE,1)
    if handles.main.type==1 && (survey_type==2 || survey_type==3)  % TX
        SR(1,i)=2;
        FREQ(1,i)=USED_SCHEDULE(i,1).TX_freq;
    else
        SR(1,i)=USED_SCHEDULE(i,1).sr;
        FREQ(1,i)=0;
    end
    gain(1,i)=log2(double(USED_SCHEDULE(i,1).gain));
    run_for(1,i)=USED_SCHEDULE(i,1).duration;
end

handles=l_Rx_update_time( handles );

time_between_files=handles.main.time_btw_sch;
time_zone=str2double(handles.setting.time_zone)*3600/86400;
TX_action=false;
if handles.main.type==1 && (survey_type==2 || survey_type==3)  % TX
    Elapsed_time=size(handles.CHANNEL.ch_serial,2)*0.2+nb_chn*size(USED_SCHEDULE,1)*0.2*2+size(handles.CHANNEL.ch_serial,2)*1.5+7;
    handles.start_time=now+Elapsed_time/86400;
    TX_action=true;
end
set_time_dec=handles.start_time-time_zone+16/86400;
start_time=datestr(set_time_dec,'yyyy-mm-dd,HH:MM:SS');

% ALGORYTHM FOR THE NOMENCLATURE
day=str2double(datestr(set_time_dec,'dd'));
hour=str2double(datestr(set_time_dec,'HH'));
minut=str2double(datestr(set_time_dec,'MM'));
if minut>35;minut=minut-36;end
String = 'abcdefghijklmnopqrstuvwxyz0123456789';
l1=String(day+1); l2=String(hour+1); l3=String(minut+1);
letters=['_' l1 l2 l3 ];

      
% RUN ACQUISTION
[run_in]=l_run_schedule(start_time,TX_action,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,0,tbl_content);


%% GLOBAL SAVE
progress = waitbar(0,handles.language.progress_str5,'Name',handles.language.progress_title3 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);  
for ch=1:size(handles.CHANNEL.ch_serial,2)
	% GlobalSave
    fprintf(handles.CHANNEL.ch_serial{ch},'GLOBALSAVE');
end
for ch=1:size(handles.CHANNEL.ch_serial,2)
    try
        waitln(handles.CHANNEL.ch_serial{ch},'GlobalSave():Complete','SAVE PARAMETERS',10);
    catch error_c
         msgbox(['Error trying to save | Error msg: ' error_c.message ]);
    end
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str5 ' ' pourcentage]));
end
close(progress)


% RECCORD SAVE SCHEDULE (DEBUG)
progress = waitbar(0,handles.language.progress_str5,'Name',handles.language.progress_title3 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);  

    if ~exist('debug','dir');mkdir('debug');end

for ch=1:size(handles.CHANNEL.ch_serial,2)

    [ ~,~,data ]=QuickSendReceive(handles.CHANNEL.ch_serial{ch},'showschedule',10,'Brd339>',0);
    
    d=data.Query;
    s=strjoin(d');
    dd=textscan(s,'%s','delimiter',' ');
    formatOut = 'mmddyy_HHMM';
    
    fileID = fopen(['debug\' datestr(now,formatOut) '_ch' num2str(handles.CHANNEL.ch_info{1,ch}.ChNb) '.txt'],'w');
    for i=1:size(dd{1,1},1)
        fprintf(fileID,'%s\n',dd{1,1}{i,1});
    end
    fclose(fileID);
    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str5 ' ' pourcentage]));
end

close(progress)

%% IF TRANSMIT SET COMMIT STRING TO STOP
if handles.main.type==1 && (survey_type==2 || survey_type==3)  % TX
set(handles.set_up,'Visible','on','Enable','on','String',handles.language.set_up_transmit_str2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles = l_Rx_update_time( handles ); % update start and end time

% SET COUNTDOWN
countdown_time=addtodate(handles.start_time, -3, 'second');
set(handles.error_msg,'Value',countdown_time)  % Set start countdown.
if run_in<60+time_between_files
    run_in=60+time_between_files;
end
end_time=addtodate(handles.start_time, run_in-time_between_files-2, 'second');
set(handles.box_str,'Value',end_time)  % Set end countdown.

end