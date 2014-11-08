function [ handles ] = ZenRX_commit( handles )
%ZenRX_commit set all the parameters defined by the user

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014


%% CHECK INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.error_msg,'Visible','on','String','');  % Make the error msg visible

% CHECK BOARD CAL
zen_box=str2double(get(handles.box_str_val,'String'));
filename=['calibrate/ZEN' num2str(zen_box) '.cal'];
if exist(filename,'file')~=2  % IF file exist
      choice = questdlg(handles.language.commit_msg1,handles.language.yes,handles.language.yes,handles.language.no,handles.language.yes);
      if strcmp(choice,handles.language.no);return;end
end

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
time_dif=handles.start_time-now-time_check/86400;
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
        for col=8:9
        if handles.main.type==1 % TX
                   if isempty(tbl_content{ch,col})
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
         
    end


% CHECK SETUP (WARNING)
if handles.main.type==0
if  sum(~cellfun(@isempty,tbl_content(:,10)))==0
    set(handles.check_setup,'BackgroundColor','red')
    pause(0.1)
    set(handles.check_setup,'BackgroundColor',[0.757 0.867 0.776])
    pause(0.1)
    set(handles.check_setup,'BackgroundColor','red')
    pause(0.1)
    set(handles.check_setup,'BackgroundColor',[0.757 0.867 0.776])
    choice = questdlg(handles.language.commit_msg6,handles.language.ZenTitle2,handles.language.yes,handles.language.no,handles.language.no);
    if strcmp(choice,handles.language.yes)
        handles = ZenRX_Cres( handles );
        return;
    end
end
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
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
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
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
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
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
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
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
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
a_space=get(handles.a_space_box,'String');
s_space=get(handles.s_space_box,'String');
survey_type=str2double(handles.setting.ZenACQ_mode);
switch survey_type
    case 1
        survey_type_str='MT';
    case 2
        survey_type_str='IP';
end

nb_chn=0;
for ch=1:size(handles.CHANNEL.ch_serial,2)
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
    
    if strcmp(tbl_content{index,1},'Off'); continue;end

    nb_chn=nb_chn+1;
    
        meta_str0=['METADATA JOB.NAME,' job_name_box ...
        '|JOB.FOR,' job_for_box ...
        '|JOB.BY,' job_by_box ...
        '|JOB.NUMBER,' job_number_box ...
        '|GDP.OPERATOR,' job_operator_box ...
        '|SURVEY.TYPE,' survey_type_str ...
        '|'];
    
    
    if handles.main.type==0
        if ~isempty(tbl_content(index,10))
            CRES=['|CH.CRES,' num2str(tbl_content{index,10})];
        if strcmp(CRES,'|CH.CRES,Inf')
            CRES='|CH.CRES,1.0e9';
        end
        else
            CRES='';
        end
    
        meta_str1=['METADATA RX.XYZ0,' Stn_num ...
                     '|LINE.NAME,' Line_num ...
                     '|RX.ASpace,' a_space ...
                     '|RX.SSpace,' s_space ...
                   '|Unit.Length,' 'm' ...
                       CRES '|'];
    elseif handles.main.type==1
        meta_str1=['METADATA RX.XYZ0,' Stn_num ...
                     '|LINE.NAME,' Line_num ...
                     '|RX.ASpace,' a_space ...
                     '|RX.SSpace,' s_space ...
                   '|Unit.Length,' 'm' ...
                   ];
    end
    
    
    if strcmp(tbl_content{index,1}(1),'E')
    
    meta_str2=['METADATA CH.CMP,' num2str(tbl_content{index,1}) ...
                '|CH.NUMBER,' num2str(str2double(Xstn_num)+(tbl_content{index,2}+tbl_content{index,4})/2) ...
                '|CH.LENGTH,' num2str(tbl_content{index,6}) ... %% ?
               '|CH.AZIMUTH,' num2str(tbl_content{index,7}) ...
                  '|CH.XYZ1,' [num2str(tbl_content{index,2}) ':' num2str(tbl_content{index,4})] ...
                  '|CH.XYZ2,' [num2str(tbl_content{index,3}) ':' num2str(tbl_content{index,5})] ...
                  '|'];
              
    elseif strcmp(tbl_content{index,1}(1),'H')
        
    meta_str2=['METADATA CH.CMP,' num2str(tbl_content{index,1}) ...
                '|CH.NUMBER,' num2str(tbl_content{index,6}) ...
                '|CH.LENGTH,' '0' ...
               '|CH.AZIMUTH,' num2str(tbl_content{index,7}) ...
                  '|CH.XYZ1,' [num2str(tbl_content{index,2}) ':' num2str(tbl_content{index,4})] ...
                  '|CH.XYZ2,' [num2str(tbl_content{index,3}) ':' num2str(tbl_content{index,5})] ...
                  '|'];
              
    elseif strcmp(tbl_content{index,1}(1),'T')

        switch tbl_content{index,8}
            case 'GGT-30'
                TXsense='0.05';
            case 'GGT-10'
                TXsense='0.1';
            case 'GGT-3'
                TXsense='0.1';
            case 'ZT-30'
                TXsense='1.0';
            case 'NT-20'
                TXsense='1.0';
        end
            
        
        meta_str2=['METADATA CH.CMP,' 'Ref' ...
                  '|CH.NUMBER,' num2str(str2double(Xstn_num)+(tbl_content{index,2}+tbl_content{index,4})/2) ...
                  '|CH.LENGTH,' num2str(tbl_content{index,6}) ...
                  '|CH.AZIMUTH,' num2str(tbl_content{index,7}) ...
                  '|CH.XYZ1,' [num2str(tbl_content{index,2}) ':' num2str(tbl_content{index,4})] ...
                  '|CH.XYZ2,' [num2str(tbl_content{index,3}) ':' num2str(tbl_content{index,5})] ...
                  '|TX.TYPE,' tbl_content{index,8} ...
                  '|TX.SENSE,' TXsense ...
                  '|TX.SN,' tbl_content{index,9} ...
                  '|'];
        
    end
    
    if handles.main.type==0
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str0,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    elseif handles.main.type==1 && survey_type==2
       QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str0,10,'WroteNumMetaDataRecords(0x',')toEEProm'); 
    end
    
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str1,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str2,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str2 ' ' pourcentage]));
end

close(progress)


%% SET CAL

if exist(filename,'file')==2
    
     % READ BOARD CAL
     formatSpec = '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %[^\n\r]';
     fileID = fopen(filename,'r');
     dataArray = textscan(fileID, formatSpec, 'HeaderLines' ,12, 'ReturnOnError', false);
     fclose(fileID);

    progress = waitbar(0,handles.language.progress_str3,'Name',handles.language.progress_title1 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

for ch=1:size(handles.CHANNEL.ch_serial,2)
    
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
    
    if strcmp(tbl_content{index,1},'Off'); continue;end
     AA='';AA1='';AA2='';
     for i=1:size(dataArray{1,1},1)
         if dataArray{1,4}(i,1)==256
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,3}(i,1)) ':' dataArray{1,2}{i,1} ':' num2str(dataArray{1,7}(i,1)) ':' num2str(dataArray{1,8}(i,1)) ', ' ];
                AA=[AA  str];
            end
         end
         if dataArray{1,4}(i,1)==4096
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,3}(i,1)) ':' dataArray{1,2}{i,1} ':' num2str(dataArray{1,7}(i,1)) ':' num2str(dataArray{1,8}(i,1)) ', ' ];
                AA1=[AA1  str];
            end
         end
         if dataArray{1,4}(i,1)==1024
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,3}(i,1)) ':' dataArray{1,2}{i,1} ':' num2str(dataArray{1,7}(i,1)) ':' num2str(dataArray{1,8}(i,1)) ', ' ];
                AA2=[AA2  str];
            end
         end
     end

    survey_type=str2double(handles.setting.ZenACQ_mode);
    
    if survey_type==1 % MT
            
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
    
    elseif survey_type==2 % IP
        
        meta_str=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ',     ' AA2 '|'];
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str,10,'WroteNumMetaDataRecords(0x',')toEEProm');
        
    end
     

    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str2 ' ' pourcentage]));
end

close(progress)
end

%% SET ZEN FOR SCHEDULE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if handles.main.type==1 && survey_type==2
DUTY=50;
else
DUTY=0;
end
FREQ=zeros(1,size(handles.SCHEDULE.OBJ,1));
SR=zeros(1,size(handles.SCHEDULE.OBJ,1));
gain=zeros(1,size(handles.SCHEDULE.OBJ,1));
run_for=zeros(1,size(handles.SCHEDULE.OBJ,1));

for i=1:size(handles.SCHEDULE.OBJ,1)
    if handles.main.type==1 && survey_type==2
        SR(1,i)=2;
        FREQ(1,i)=handles.SCHEDULE.OBJ(i,1).TX_freq;
    else
        SR(1,i)=handles.SCHEDULE.OBJ(i,1).sr;
        FREQ(1,i)=0;
    end
    gain(1,i)=log2(double(handles.SCHEDULE.OBJ(i,1).gain));
    run_for(1,i)=handles.SCHEDULE.OBJ(i,1).duration;
end

handles=l_Rx_update_time( handles );

time_between_files=handles.main.time_btw_sch;
time_zone=str2double(handles.setting.time_zone)*3600/86400;
TX_action=false;
if handles.main.type==1 && survey_type==2
    Elapsed_time=size(handles.CHANNEL.ch_serial,2)*0.2+nb_chn*size(handles.SCHEDULE.OBJ,1)*0.2*2+size(handles.CHANNEL.ch_serial,2)*1.5+7;
    handles.start_time=now+Elapsed_time/86400;
    TX_action=true;
end
set_time_dec=handles.start_time-time_zone+60/86400;%+16/86400
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
[run_in]=l_run_schedule(start_time,TX_action,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,0,tbl_content);



% GLOBAL SAVE
progress = waitbar(0,handles.language.progress_str5,'Name',handles.language.progress_title3 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   
for ch=1:size(handles.CHANNEL.ch_serial,2)

    QuickSendReceive(handles.CHANNEL.ch_serial{ch},'globalsave',10,'Brd339>',0);
    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str5 ' ' pourcentage]));
end
close(progress)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET COUNTDOWN
countdown_time=addtodate(handles.start_time, -3, 'second');
set(handles.error_msg,'Value',countdown_time)  % Set start countdown.
if run_in<60+time_between_files
    run_in=60+time_between_files;
end
end_time=addtodate(handles.start_time, run_in-time_between_files-2, 'second');
set(handles.box_str,'Value',end_time)  % Set end countdown.

end