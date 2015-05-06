function [ ] = l_sch_set_table( handles,nb_schedule )

data=cell(nb_schedule,3);
inc=0;
for i=1:nb_schedule
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dec_time=double(handles.SCHEDULE(i,1).duration)/86400;
    
    timeORduration=get(handles.time2duration,'Value');
    
    if timeORduration==0
    
    if dec_time*86400>1
        [ day_str2, hour_str2, min_str2, sec_str2 ] = l_sch_displayTime( dec_time );
        data{i,1}=[day_str2 hour_str2 min_str2 sec_str2];
    else 
        data{i,1}='less than a second';
    end
        column1_name='Duration';
    elseif timeORduration==1
        
        column1_name='Time';
        
        Start=datestr(handles.start_date+inc, 'DD/mm/YY-HH:MM:SS');
        inc=dec_time+inc;
        End=datestr(handles.start_date+inc, 'DD/mm/YY-HH:MM:SS');
        data{i,1}=[Start ' --> ' End];
        
        inc=inc+(handles.main.time_btw_sch/86400);
        
    end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TABLE 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  



if handles.main.type==0 % RX
    column2_name='SR';
    SR=handles.SCHEDULE(i,1).sr;    
    switch SR
        case 0
            SR_str='Low Band (256Hz)';
        case 1
            SR_str='512 Hz';
        case 2
            SR_str='Mid Band (1024 Hz)';
        case 3
            SR_str='2048 Hz';
        case 4
            SR_str='High Band (4096Hz)';
        case 99
            SR_str='Break';
    end
    
    data{i,2}=SR_str;
    
elseif handles.main.type==1 % TX
    column2_name='TX Frequency';
    data{i,2}=handles.SCHEDULE(i,1).TX_freq;
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TABLE 3  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
     
if handles.main.type==0
    data{i,3}=gain_str;
elseif handles.main.type==1
    data{i,3}=handles.SCHEDULE(i,1).duration*handles.SCHEDULE(i,1).TX_freq;  
end

end

set(handles.schedule_tbl,'Data',data)
set(handles.schedule_tbl,'ColumnName',{column1_name,column2_name})

end

