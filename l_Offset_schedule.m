function [ DELAY_SCHEDULE,STATUS ] = l_Offset_schedule( handles )
% offset schedule based on original time and defined start time.

STATUS=true;

run_in=handles.official_start_time;
run_mat=zeros(size(handles.SCHEDULE.OBJ,1),1);
for sch=1:size(handles.SCHEDULE.OBJ,1)
    run_mat(sch,1)=run_in;
    run_for=handles.SCHEDULE.OBJ(sch,1).duration;
    run_in=run_in+(handles.main.time_btw_sch+run_for)/86400;
end
 
sch_older=find(run_mat>handles.start_time);

if isempty(sch_older)
   DELAY_SCHEDULE=false;
   STATUS=false;
   return 
end

duratiom_first_sch=(run_mat(sch_older(1))-handles.start_time)*86400-10;

if duratiom_first_sch<60
    sch_list=sch_older;
else
    sch_list=[min(sch_older)-1;sch_older];
end

DELAY_SCHEDULE=handles.SCHEDULE.OBJ(sch_list);

if duratiom_first_sch>=60
    DELAY_SCHEDULE(1,1).duration=duratiom_first_sch;
end


end

