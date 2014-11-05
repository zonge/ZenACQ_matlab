function  handles = ZenRX_ini(handles)

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
set(handles.stn_str,'String',handles.language.stn_str)
set(handles.line_str,'String',handles.language.line_str)
set(handles.SX_azimut_str,'String',handles.language.SX_azimuth_str)
set(handles.a_space_str,'String',handles.language.a_space_str)
set(handles.s_space_str,'String',handles.language.s_space_str)
set(handles.z_positive_str,'String',handles.language.z_positive_str)
set(handles.save_push,'String',handles.language.save_push_str)
set(handles.check_setup,'String',handles.language.check_setup_str)

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
        warndlg(handles.language.version_err1,handles.language.ZenTitle)
    end
    
else
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RX TIMER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A.pass=handles;
handles.timer_RX = timer('TimerFcn',@timer_RX,'BusyMode','queue','UserData'...
                                  ,A,'ExecutionMode','fixedRate','Period',1.0,'Name','Rx_timer');
start(handles.timer_RX);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SURVEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if str2double(handles.setting.ZenACQ_mode)==2 && handles.main.type==0
    set(handles.general_info_panel,'Visible','off')
    set(handles.schedule_panel,'Position',[0.018 0.577 0.967 0.327])
else
    
end
% READ SURVEY FILE
survey_file_name = 'survey.zen';
if exist(survey_file_name,'file')==2
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

if handles.main.type==1 % TX
    set(handles.start_time_str,'Visible','off')
    set(handles.date_push,'Visible','off')
    set(handles.hour_popup,'Visible','off')
    set(handles.min_popup,'Visible','off')
    set(handles.end_time_str0,'Visible','off')
    set(handles.end_time_str,'Visible','off')
    set(handles.set_up,'Visible','off','String',handles.language.set_up_transmit_str)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEOMETRY DESIGN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOAD LAST SAVED DESIGN FILE
survey_type=str2double(handles.setting.ZenACQ_mode);
if handles.main.type==0
    handles.SCH.last_design=handles.setting.Rx_geometry_selected_MT;
elseif handles.main.type==0 && survey_type==2
    handles.SCH.last_design=handles.setting.Rx_geometry_selected_IP_RX; 
elseif handles.main.type==1 && survey_type==2
    handles.SCH.last_design=handles.setting.Rx_geometry_selected_IP_TX;
end

% FIND DESIGN
main_file=l_find_design( handles );

% Initiate H-field and TX
handles.Ant=[];
handles.TX=[];

% UPDATE TABLE
handles=m_get_design( main_file,handles,false );

UTM_toggle=get(handles.utm_checkbox,'Value'); %returns toggle state of utm_checkbox
DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String'));
S_space=str2double(get(handles.s_space_box,'String'));  
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=0;  % initiate
ZenUTM.Y=0;  % initiate


% Initiate CRES
    for i=1:size(handles.CHANNEL.ch_info,2)
        handles.CRES_values{i}=0;
    end

if handles.main.type==1 % TX
set(handles.check_setup,'Visible','off')
set(handles.z_positive_str,'Visible','off')
set(handles.z_positive,'Visible','off')
set(handles.utm_zone_str,'Visible','off')
set(handles.altitude_str,'Visible','off')
set(handles.altitude_str,'Visible','off')
end

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOGO
rgb = imread('Zonge_Int_logo_color.jpg');
axes(handles.logo)
image(rgb);
axis off;

end