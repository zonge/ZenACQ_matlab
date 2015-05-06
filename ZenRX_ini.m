    function handles = ZenRX_ini(handles)

% GET PARAMETERS FROM ZenACQ
ZenACQ_vars=getappdata(0,'tunnel');
handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;

% ZEN RX PARAMETER
handles.main.extra_time=120;  % Extra given time from now to the display date
handles.main.time_btw_sch=10; % time between two schedule

% SET WINDOWS NAME
set(handles.ZenRX,'Name',[handles.main.ProgramName ' ' num2str(handles.main.ProgramVersion) ])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LANGUAGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.box_str,'String',handles.language.box_str)
set(handles.status_channel,'String',handles.language.status_channel_str)
set(handles.status_sats,'String',handles.language.status_sats_str)
set(handles.status_sync,'String',handles.language.status_sync_str)

set(handles.general_info_panel,'Title',handles.language.general_info_panel_str)
set(handles.job_name_str,'String',handles.language.job_name_str)
set(handles.job_number_str,'String',handles.language.job_number_str)
set(handles.job_by_str,'String',handles.language.job_by_str)
set(handles.job_for_str,'String',handles.language.job_for_str)
set(handles.operator_str,'String',handles.language.operator_str)

set(handles.schedule_panel,'Title',handles.language.schedule_panel_str)
set(handles.new_push,'String',handles.language.new_push_str)
set(handles.edit_push,'String',handles.language.edit_push_str)
set(handles.start_time_str,'String',handles.language.start_time_str)
set(handles.end_time_str0,'String',handles.language.end_time_str)
set(handles.date_push,'String',handles.language.data_push_str)

set(handles.survey_panel,'Title',handles.language.survey_panel_str)
if handles.main.type==1 % TX
    set(handles.stn_str,'String','TX STN :')
else
    set(handles.stn_str,'String',handles.language.stn_str)
end
set(handles.line_str,'String',handles.language.line_str)
set(handles.SX_azimut_str,'String',handles.language.SX_azimuth_str)
set(handles.a_space_str,'String',handles.language.a_space_str)
set(handles.s_space_str,'String',handles.language.s_space_str)
set(handles.z_positive_str,'String',handles.language.z_positive_str)
set(handles.save_push,'String',handles.language.save_push_str)
set(handles.check_setup,'String',handles.language.check_setup_str)
set(handles.display_survey,'String',handles.language.display_survey_str)
set(handles.display_real_time,'String',handles.language.display_real_time_str)


set(handles.set_up,'String',handles.language.set_up_str)
set(handles.version_txt,'String',handles.language.version_str)
set(handles.gps_time_str,'String',handles.language.gps_time_str)
set(handles.status_volts,'String',handles.language.status_volts_str)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SERIAL CONNECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ handles,CH1_index,status ] = connection_process( handles );

if status==0
    handles.CH1_index=CH1_index;
    set(handles.box_str_val,'String',handles.CHANNEL.ch_info{1,1}.BoxNb);
    set(handles.status_channel_val,'String',num2str(size(handles.CHANNEL.ch_info,2)));
    
    version=cell(size(handles.CHANNEL.ch_info,2),1);
    for i=1:size(handles.CHANNEL.ch_info,2)
        version{i,1}=handles.CHANNEL.ch_info{1,i}.version;
    end
    
    test_version=sum(cell2mat(strfind(version,version{1,1})));
    if test_version==size(handles.CHANNEL.ch_info,2)
        set(handles.version_txt,'String',[handles.language.version_str ' ' version{1,1}]);     
    else
        set(handles.version_txt,'String',handles.language.version_err2,'ForegroundColor','Red') 
        w=warndlg(handles.language.version_err1,handles.language.ZenTitle);
        uiwait(w);
    end
    
else
    set(handles.ZenRX,'Visible','off')
     set(handles.general_info_panel,'Visible','off')
     set(handles.schedule_panel,'Visible','off')
     set(handles.survey_panel,'Visible','off')
     set(handles.set_up,'Visible','off')
     set(handles.box_str,'Visible','off')
     set(handles.box_str_val,'Visible','off')
     set(handles.status_channel,'Visible','off')
     set(handles.status_channel_val,'Visible','off')
     set(handles.logo,'Visible','off')
     set(handles.local_time_val,'Visible','off')
     set(handles.status_sats,'Visible','off')
     set(handles.status_sats_val,'Visible','off')
     set(handles.status_sync,'Visible','off')
     set(handles.status_sync_val,'Visible','off')
     set(handles.version_txt,'Visible','off')
     set(handles.status_volts,'Visible','off')
     set(handles.board_cal_status,'Visible','off')
     set(handles.board_cal_str,'Visible','off')
     set(handles.antenna_cal_status,'Visible','off')
     set(handles.antenna_cal_str,'Visible','off')
     set(handles.delete_all_files,'Visible','off')
     
     
     set(handles.error_msg,'String','ERROR !!')
     
    
     return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SURVEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if str2double(handles.setting.ZenACQ_mode)==2 && handles.main.type==0
    set(handles.general_info_panel,'Visible','off')
    set(handles.schedule_panel,'Position',[0.015 0.583 0.972 0.327])
end

% READ SURVEY FILE
survey_file_name = 'survey.zen';
if exist(survey_file_name,'file')==2 % if exist load infos.
handles.survey = m_get_survey_key(survey_file_name,handles,true);
set(handles.job_operator_box,'String',handles.survey.job_operator)
set(handles.job_number_box,'String',handles.survey.job_number)
set(handles.job_name_box,'String',handles.survey.job_name)
set(handles.job_by_box,'String',handles.survey.job_by)
set(handles.job_for_box,'String',handles.survey.job_for)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCHEDULE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOAD LAST SAVED SCHEDULE FILE
handles.SCH.last_schedule=handles.setting.Rx_schedule_selected; 

% FIND SCHEDULE
main_file=l_find_schedule( handles );

% CREATE SCH OBJ
handles.SCHEDULE.TOTAL_TIME=0;
if ~isempty(main_file)
    handles.SCHEDULE = m_get_sch_obj( main_file,handles,true );
    set(handles.quick_summary_str,'String',handles.SCHEDULE.SUMMARY);
    set(handles.quick_summary_str,'Value',handles.SCHEDULE.TOTAL_TIME);
end

% SET SCHEDULE START TIME
date_now_val= addtodate(now, handles.main.extra_time, 'second');
date_now=datestr(date_now_val,'dd mmm yyyy');
hour_now=str2double(datestr(date_now_val,'HH'));
min_now=str2double(datestr(date_now_val,'MM'));
set(handles.date_push,'String',date_now);
set(handles.hour_popup,'Value',hour_now+1);
set(handles.min_popup,'Value',min_now+1);
date_now_val2=datenum([date_now ' ' num2str(hour_now) '-' num2str(min_now) ],'dd mmm yyyy HH-MM');
t=addtodate(date_now_val2,handles.SCHEDULE.TOTAL_TIME+handles.main.extra_time, 'second');
end_acq_str=datestr(t,'dd-mmm-yyyy , HH:MM:SS');
set(handles.end_time_str,'String',end_acq_str);
handles.start_time=date_now_val2;
handles.late=false;
handles.official_start_time=0;

if handles.main.type==1 % TX
    set(handles.start_time_str,'Visible','off')
    set(handles.date_push,'Visible','off')
    set(handles.hour_popup,'Visible','off')
    set(handles.min_popup,'Visible','off')
    set(handles.end_time_str0,'Visible','off')
    set(handles.end_time_str,'Visible','off')
    set(handles.star_1,'Visible','off')
    set(handles.late_option,'Visible','off')
    set(handles.set_up,'Visible','off','String',handles.language.set_up_transmit_str)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAYOUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOAD LAST SAVED DESIGN FILE
survey_type=str2double(handles.setting.ZenACQ_mode);
if handles.main.type==0
    handles.SCH.last_design=handles.setting.Rx_geometry_selected_MT;
elseif handles.main.type==0 && (survey_type==2 || survey_type==3)
    handles.SCH.last_design=handles.setting.Rx_geometry_selected_IP_RX; 
elseif handles.main.type==1 && (survey_type==2 || survey_type==3) % TX
    handles.SCH.last_design=handles.setting.Rx_geometry_selected_IP_TX;
end

% FIND DESIGN
main_file=l_find_design( handles );

% Initiate H-field and TX
handles.Ant=[];
handles.TX=[];


if survey_type==2 || survey_type==3 % IP
   set(handles.station_vs_offset,'Visible','off','Value',true,'String','Station');
   %set(handles.station_vs_offset,'Visible','on','Value',true,'String','Station');
   set(findobj('Tag','layout_table_title'),'String','Station #')
else % MT
   set(handles.station_vs_offset,'Visible','off','Value',false,'String','Offset');
   set(findobj('Tag','layout_table_title'),'String','Station offset')
end

% UPDATE TABLE
handles=m_get_design( main_file,handles,false );

UTM_toggle=get(handles.utm_checkbox,'Value'); %returns toggle state of utm_checkbox
DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String'));
S_space=str2double(get(handles.s_space_box,'String'));  
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
handles.prev_SX_azimuth=SX_azimuth;
handles.z_prev=z_positive;
for i=1:size(DATA,1)
handles.ant_raw_val{i,:}=[z_positive,SX_azimuth,DATA(i,7)];
handles.CRES_values{i}=[];
handles.SP{i}=[];
handles.MaxV{i}=[];
handles.Nb_of_File{i}=[];
end
ZenUTM.X=0;  % initiate
ZenUTM.Y=0;  % initiate

% Initiate Layout display status
global tequila_status
tequila_status=false;

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% update number of files
handles = ZenRX_NbofFiles( handles );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOGO
rgb = imread('Zonge_Int_logo_color.jpg');
axes(handles.logo)
image(rgb);
axis off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK CALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CHECK BOARD CAL
zen_box=str2double(get(handles.box_str_val,'String'));
filename=['calibrate/ZEN' num2str(zen_box) '.cal'];
if exist(filename,'file')~=2  % if file does not exist
      set(handles.board_cal_status,'ForegroundColor','red','TooltipString',['Not found :' filename])
      set(handles.board_cal_str,'TooltipString',['Not found :' filename])
else  % If file exist
      set(handles.board_cal_status,'ForegroundColor','green','TooltipString',['Found :' filename])
      set(handles.board_cal_str,'TooltipString',['Found :' filename])
end

% CHECK ANTENNA CAL
filename =['calibrate\' handles.main.calibrate_file_name];        
if exist(filename,'file')~=2 % IF FILE DOESNT EXIST
    set(handles.antenna_cal_status,'ForegroundColor','red','TooltipString',['Not found :' filename])
    set(handles.antenna_cal_str,'TooltipString',['Not found :' filename])
else % IF FILE EXIST
    set(handles.antenna_cal_status,'ForegroundColor','green','TooltipString',['Found :' filename])
    set(handles.antenna_cal_str,'TooltipString',['Found :' filename])
end

% CHECK TX CAL
if handles.main.type==1 % TX
    set(handles.tx_cal_str,'Visible','on')
    set(handles.tx_cal_status,'Visible','on')
    filename =['calibrate\' handles.main.TX_cal_file_name];        
if exist(filename,'file')~=2 % IF FILE DOESNT EXIST
    set(handles.tx_cal_status,'ForegroundColor','red','TooltipString',['Not found :' filename])
    set(handles.tx_cal_str,'TooltipString',['Not found :' filename])
else % IF FILE EXIST
    set(handles.tx_cal_status,'ForegroundColor','green','TooltipString',['Found :' filename])
    set(handles.tx_cal_str,'TooltipString',['Found :' filename])
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RX TIMER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A.pass=handles;
handles.timer_RX = timer('TimerFcn',@timer_RX,'BusyMode','queue','UserData'...
                                  ,A,'ExecutionMode','fixedRate','Period',1.0,'Name','Rx_timer');
start(handles.timer_RX);

end