function [ handles ] = l_Rx_update_time( handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

date=get(handles.date_push,'String');
hour=get(handles.hour_popup,'Value')-1;
min=get(handles.min_popup,'Value')-1;

date_now_val2=datenum([date ' ' num2str(hour) '-' num2str(min) ],'dd mmm yyyy HH-MM');

t=addtodate(date_now_val2,handles.SCHEDULE.TOTAL_TIME, 'second');
handles.start_time=date_now_val2;

if handles.late==false
end_acq_str=datestr(t,'dd-mmm-yyyy , HH:MM:SS');
set(handles.end_time_str,'String',end_acq_str);
end

end

