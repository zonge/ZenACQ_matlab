function [ time ] = l_run_schedule_low(obj,file_name,time,delay,duration,SR,GAIN,PERIOD,DUTY,newFile)

format = 'yyyy-mm-dd,HH:MM:SS';

time_n=datenum(time,format);
time_n=addtodate(time_n, delay, 'second'); % ex: ADD 10 seconds. start in 10s
str_start = datestr(time_n,format,'local');

time_n=addtodate(time_n, duration, 'second'); % ex : ADD 30 seconds. Take data for 30 seconds
str_end = datestr(time_n,format,'local');

cmd1=['SCHEDULEACTION ' str_start ',y,y,' num2str(PERIOD) ',' num2str(DUTY) ',' num2str(SR) ',' num2str(GAIN) ',0,0,' newFile ',n,n,n,' upper(file_name)];
cmd2=['SCHEDULEACTION ' str_end ',y,n,' num2str(2^32-1) ',' num2str(2^32-1) ',' num2str(SR) ',' num2str(GAIN) ',0,0,n,n,n,n,ZDONE.Z3D'];

QuickSendReceive(obj,cmd1,5,'ScheduleActionCommand:AddedZ3ScheduleEntry:','-');
QuickSendReceive(obj,cmd2,5,'ScheduleActionCommand:AddedZ3ScheduleEntry:','-');


end

