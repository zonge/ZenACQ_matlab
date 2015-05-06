function [ handles ] = l_sch_add_line( handles )

language=handles.language;


gain=get(handles.gain_popup,'Value');
sr_value=get(handles.SR_popup,'Value');
sr_str=get(handles.SR_popup,'String');

% GET SR AND GAIN
if strcmp(sr_str(sr_value),'Low Band')
    sr=0;
elseif strcmp(sr_str(sr_value),'High Band')
    sr=4;
elseif strcmp(sr_str(sr_value),'Mid Band')
    sr=2;
elseif strcmp(sr_str(sr_value),'Break')
    sr=99;
end

survey_type=str2double(handles.setting.ZenACQ_mode);
if handles.main.type==0

day_str=get(handles.day_box,'String');
if isempty(day_str);day=0;else day=str2double(day_str);end
hour_str=get(handles.hour_box,'String');
if isempty(hour_str);hour=0;else hour=str2double(hour_str);end
min_str=get(handles.min_box,'String');
if isempty(min_str);Min=0;else Min=str2double(min_str);end
sec_str=get(handles.sec_box,'String');
if isempty(sec_str);sec=0;else sec=str2double(sec_str);end
DuratioN=day*86400+hour*3600+Min*60+sec;
if isnan(DuratioN)
    beep
   set(handles.error_display,'Visible','on','String',language.ZenSCH_err5)
   return;
elseif DuratioN==0
    beep
   set(handles.error_display,'Visible','on','String',language.ZenSCH_err6)
   return;
elseif DuratioN<20
    beep
   set(handles.error_display,'Visible','on','String','The minimum length is : 20 sec')
   return;
else
   set(handles.error_display,'Visible','off') 
end

elseif (survey_type==2 || survey_type==3) && handles.main.type==1
    
tx_freq_value = get(handles.tx_freq_popup,'Value');
tx_freq_str = get(handles.tx_freq_popup,'String');
tx_freq_str2=tx_freq_str(tx_freq_value);
nb_cycles_value = get(handles.nb_cycles_popup,'Value');
nb_cycles_str = get(handles.nb_cycles_popup,'String');

nb_cycle=str2double(nb_cycles_str(nb_cycles_value));
TX_freq=str2double((strrep(tx_freq_str2{1,1}, 'Hz', '')));

DuratioN=nb_cycle/TX_freq;
end

% Increment the number of schedule.
nb_schedule=handles.nb_schedule;
nb_schedule=nb_schedule+1;

if nb_schedule>16
    beep
    set(handles.error_display,'Visible','on','String',language.ZenSCH_err7)
    return;
end
if handles.main.type==0 % RX
    handles.SCHEDULE(nb_schedule,1)=schedule(DuratioN,sr,gain);    
elseif handles.main.type==1 % TX
    handles.SCHEDULE(nb_schedule,1)=schedule(DuratioN,sr,gain,TX_freq);  % CREATE OBJS
end

l_sch_set_table( handles,nb_schedule );  % UPDATE TABLE

handles.nb_schedule=nb_schedule;    % UPDATE NB of SCHEDULE

set(handles.schedule_tbl,'UserData',[]);  % SET TABLE SELECTION TO NONE

l_sch_total_time( handles,nb_schedule );  % SET TOTAL TIME

if handles.main.type==0
% SET BACK TO NULL
set(handles.day_box,'String','');
set(handles.hour_box,'String','');
set(handles.min_box,'String','');
set(handles.sec_box,'String','');
end

end