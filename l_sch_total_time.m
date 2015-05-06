function [] = l_sch_total_time( handles,nb_schedule )

Total_time=0;
inc=0;
for i=1:nb_schedule
    handles.SCHEDULE(nb_schedule,1).duration;
    Total_time=Total_time+double(handles.SCHEDULE(i,1).duration)+inc;
    inc=handles.main.time_btw_sch;
end
Total_time=Total_time/86400;

    [ day_str2, hour_str2, min_str2, sec_str2 ] = l_sch_displayTime( Total_time );

Total_time_str=[day_str2 hour_str2 min_str2 sec_str2];
set(handles.total_time_str2,'String',Total_time_str,'Visible','on');
set(handles.total_time_str,'Visible','on');

end

