function [ day_str2, hour_str2, min_str2, sec_str2 ] = l_sch_displayTime( dec_time )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    hour_str=datestr(dec_time, 'HH');
    min_str=datestr(dec_time, 'MM');
    sec_str=datestr(dec_time, 'SS');
    day_str=datestr(dec_time, 'DD');
    if str2double(day_str)>1
        day_str2=[day_str ' ' 'days '];
    elseif str2double(day_str)==1
        day_str2=[day_str ' ' 'day '];
    else
        day_str2='';
    end
    
    if str2double(sec_str)>1
        sec_str2=[sec_str ' ' 'secs'];
    elseif str2double(sec_str)==1
        sec_str2=[sec_str ' ' 'sec'];
    else
        sec_str2='';
    end
    
    if str2double(min_str)>1
        min_str2=[min_str ' ' 'mins '];
    elseif str2double(min_str)==1
        min_str2=[min_str ' ' 'min '];
    else
        min_str2='';
    end
    
    if str2double(hour_str)>1
        hour_str2=[hour_str ' ' 'hours '];
    elseif str2double(hour_str)==1
        hour_str2=[hour_str ' ' 'hour '];
    else
        hour_str2='';
    end
    

end

