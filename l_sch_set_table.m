function [ ] = l_sch_set_table( handles,nb_schedule )

data=cell(nb_schedule,3);
for i=1:nb_schedule
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dec_time=double(handles.SCHEDULE(i,1).duration)/86400;
    
    [ day_str2, hour_str2, min_str2, sec_str2 ] = l_sch_displayTime( dec_time );
    
    data{i,1}=[day_str2 hour_str2 min_str2 sec_str2];
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SR  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SR=handles.SCHEDULE(i,1).sr;
    
    switch SR
        case 0
            SR_str='Low Band (256Hz)';
        case 1
            SR_str='512 Hz';
        case 2
            SR_str='1024 Hz';
        case 3
            SR_str='2048 Hz';
        case 4
            SR_str='High Band (4096Hz)';
    end
    
    data{i,2}=SR_str;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GAIN  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Gain=handles.SCHEDULE(i,1).gain;
    
     switch Gain
        case 1
            gain_str='x1';
        case 2
            gain_str='x2';
        case 3
            gain_str='x4';
        case 4
            gain_str='x8';
        case 5
            gain_str='x16';
        case 6
            gain_str='x32';
        case 7
            gain_str='x64';
        case 8
            gain_str='Auto';
     end
     
    data{i,3}=gain_str;
end

set(handles.schedule_tbl,'Data',data)

end

