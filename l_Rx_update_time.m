function [ handles ] = l_Rx_update_time( handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

date_now=get(handles.date_push,'String');
hour_now=get(handles.hour_popup,'Value')-1;
min_now=get(handles.min_popup,'Value')-1;

date_now_val2=datenum([date_now ' ' num2str(hour_now) '-' num2str(min_now) ],'dd mmm yyyy HH-MM');
t=addtodate(date_now_val2,handles.SCHEDULE.TOTAL_TIME-handles.main.extra_time, 'second');
end_acq_str=datestr(t,'dd-mmm-yyyy , HH:MM:SS');
set(handles.end_time_str,'String',end_acq_str);
handles.start_time=date_now_val2;

end

