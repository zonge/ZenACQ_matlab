function [ handles,run_in,status ] = l_commit_set_schedule( handles,nb_chn )
% SET AND SAVE SCHEDULE TO CHANNELS

status=true;
tbl_content=get(handles.geometry_table,'data');
survey_type=str2double(handles.setting.ZenACQ_mode);

if handles.main.type==1 % TX
DUTY=handles.main.duty_cycle;
else
DUTY=100;
end

% ADJUST SCHEDULE IF LATE.
if handles.late==true
    [ DELAY_SCHEDULE,STATUS ] = l_Offset_schedule( handles );
    if STATUS==false;
        w=msgbox('The schedule is already complete at this time pick a anterior time for the ZenRX start time','ZenACQ');
        uiwait(w);
        status=false;
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
        SR(1,i)=str2double(handles.setting.ZenCSsr);
        FREQ(1,i)=USED_SCHEDULE(i,1).TX_freq;
    else  % RX
        SR(1,i)=USED_SCHEDULE(i,1).sr;
        if str2double(handles.CHANNEL.ch_info{1, 1}.version) > 4264
            FREQ(1,i)=0.00048828125;
        else
            FREQ(1,i)=1;
        end
    end
    gain(1,i)=log2(double(USED_SCHEDULE(i,1).gain));
    run_for(1,i)=USED_SCHEDULE(i,1).duration;
end
handles=l_Rx_update_time( handles );


time_between_files=handles.main.time_btw_sch;
time_zone=str2double(handles.setting.time_zone)*3600/86400;

TX_action=false;
if handles.main.type==1 && (survey_type==2 || survey_type==3)  % TX
    Elapsed_time=size(handles.CHANNEL.ch_serial,2)*0.2+nb_chn*size(USED_SCHEDULE,1)*0.2*2+size(handles.CHANNEL.ch_serial,2)*1.5+25;
    local_time=get(handles.status_sync_val,'Value');
    handles.start_time=local_time+Elapsed_time/86400; % LOCAL TIME
    TX_action=true;
end
set_time_dec=handles.start_time-time_zone+16/86400; % GPS TIME
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






%% RECCORD SAVE SCHEDULE (DEBUG)
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



end

