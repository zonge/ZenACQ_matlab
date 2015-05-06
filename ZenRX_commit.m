function [ handles ] = ZenRX_commit( handles )
%ZenRX_commit set all the parameters defined by the user

% Zonge International Inc.
% Created by Marc Benoit
% Feb 22, 2014


% [TX] CHECK IF ALREADY TRANSMITTING 
isTranmiting = l_commit_if_Transmitting( handles );if isTranmiting==false;return;end

% GET SCHEDULE INFOS
handles = l_Rx_update_time( handles ); % update start and end time

% CHECK IF INPUT USER INFORMATION IS VALID
status_input = l_commit_check_input( handles );if status_input==false;return;end

% [TX] Disable Transmiting possibility
if handles.main.type==1;set(handles.set_up,'Enable','off');end

% SAVE SURVEY INFORMATION INTO A FILE
status_survey_input=l_commit_save_survey( handles );if status_survey_input==false;return;end

% SET CHANNEL METADATA
nb_chn=l_commit_set_meta( handles );

% SET CHANNEL SYSTEM CAL
l_write_sys_cal( handles );

% SET CHANNEL ANTENNA CAL
l_write_ant_cal( handles );

% SET SCHEDULE
[handles,run_in,status_sch] = l_commit_set_schedule( handles,nb_chn );if status_sch==false;return;end

% SET COUNTDOWN [DISPLAY]
countdown_time=addtodate(handles.start_time, 0, 'second');
set(handles.error_msg,'Value',countdown_time)  % Set start countdown.
if run_in<60;run_in=60;end % if the acquisition is less than a minute.
end_time=addtodate(handles.start_time, run_in-handles.main.time_btw_sch, 'second');
set(handles.box_str,'Value',end_time)  % Set end countdown.

% [TX] CHANGE COMMIT STRING MSG [DISPLAY]
survey_type=str2double(handles.setting.ZenACQ_mode);
if handles.main.type==1 && (survey_type==2 || survey_type==3)  % TX
set(handles.set_up,'Visible','on','Enable','on','String',handles.language.set_up_transmit_str2);
set(handles.display_real_time,'Enable','off')
set(handles.check_setup,'Enable','off')
end

end