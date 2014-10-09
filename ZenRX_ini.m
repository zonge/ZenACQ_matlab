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
        set(handles.version_txt,'String',['version : ' version{1,1}]);     
    else
        set(handles.version_txt,'String','This box uses different firmwares !!','ForegroundColor','Red') 
        warndlg('Your ZenBox does not have the same firmware on all the channels. Please go to Options to upgrade to the most recent firmware.','Zen')
    end
    
    set(handles.status_general_val,'ForegroundColor','green')
else
    set(handles.status_general_val,'ForegroundColor','red')
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GEOMETRY DESIGN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOAD LAST SAVED DESIGN FILE
handles.SCH.last_design=handles.setting.Rx_geometry_selected; 

% FIND DESIGN
main_file=l_find_design( handles );

% UPDATE TABLE
m_get_design( main_file,handles,false )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LOGO
rgb = imread('Zonge_Int_logo_color.jpg');
axes(handles.logo)
image(rgb);
axis off;

end