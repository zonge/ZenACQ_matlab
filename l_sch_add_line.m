function [ handles ] = l_sch_add_line( handles )

language=handles.language;

% GEt DURATION INFOS
day_str=get(handles.day_box,'String');
if isempty(day_str);day=0;else day=str2double(day_str);end
hour_str=get(handles.hour_box,'String');
if isempty(hour_str);hour=0;else hour=str2double(hour_str);end
min_str=get(handles.min_box,'String');
if isempty(min_str);Min=0;else Min=str2double(min_str);end
sec_str=get(handles.sec_box,'String');
if isempty(sec_str);sec=0;else sec=str2double(sec_str);end
duration=day*86400+hour*3600+Min*60+sec;
if isnan(duration)
    beep
   set(handles.error_display,'Visible','on','String',language.ZenSCH_err5)
   return;
elseif duration==0
    beep
   set(handles.error_display,'Visible','on','String',language.ZenSCH_err6)
   return;
elseif duration<20
    beep
   set(handles.error_display,'Visible','on','String','The minimum length is : 20 sec')
   return;
else
   set(handles.error_display,'Visible','off') 
end

% GET SR AND GAIN
gain=get(handles.gain_popup,'Value');
sr_value=get(handles.SR_popup,'Value');
sr_str=get(handles.SR_popup,'String');
if strcmp(sr_str(sr_value),'Low Band')
    sr=0;
elseif strcmp(sr_str(sr_value),'High Band')
    sr=4;
end

% Increment the number of schedule.
nb_schedule=handles.nb_schedule;
nb_schedule=nb_schedule+1;

if nb_schedule>16
    beep
    set(handles.error_display,'Visible','on','String',language.ZenSCH_err6)
    return;
end

handles.SCHEDULE(nb_schedule,1)=schedule(duration,sr,gain);  % CREATE OBJS

l_sch_set_table( handles,nb_schedule );  % UPDATE TABLE

handles.nb_schedule=nb_schedule;    % UPDATE NB of SCHEDULE

set(handles.schedule_tbl,'UserData',[]);  % SET TABLE SELECTION TO NONE

l_sch_total_time( handles,nb_schedule );  % SET TOTAL TIME

% SET BACK TO NULL
set(handles.day_box,'String','');
set(handles.hour_box,'String','');
set(handles.min_box,'String','');
set(handles.sec_box,'String','');

end