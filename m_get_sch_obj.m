function [ SCHEDULE ] = m_get_sch_obj( ext,handles,display_msg )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GET CONTENT
file_content=l_get_file_content( ext,handles,display_msg );


    % FIND KEY WORDS AND DEFINE OBJECT !
    total_time=0;
    for i=1:size(file_content,1)
        key_sch=l_search_key(['$schline' num2str(i)],file_content,ext);
        sch=textscan(key_sch,'%f;%f;%f');
        total_time=total_time+sch{1,1};
        if handles.main.type==0
            SCHEDULE.OBJ(i,1)=schedule(sch{1,1},sch{1,2},sch{1,3});  % CREATE SCH OBJS
        elseif handles.main.type==1
            SCHEDULE.OBJ(i,1)=schedule(sch{1,1},1024,sch{1,3},sch{1,2});  % CREATE SCH OBJS
        end
        
    end
    total_time=total_time+handles.main.time_btw_sch*(size(file_content,1)-1);
    
    dec_time=double(total_time)/86400;
    [ day_str2, hour_str2, min_str2, sec_str2 ] = l_sch_displayTime( dec_time );
    
    SCHEDULE.SIZE=size(file_content,1);
    SCHEDULE.TOTAL_TIME=total_time;
    SCHEDULE.SUMMARY{1,1}='Total Duration :';
    SCHEDULE.SUMMARY{2,1}=[day_str2 hour_str2 min_str2 sec_str2];
    SCHEDULE.SUMMARY{3,1}='';
    SCHEDULE.SUMMARY{4,1}='Number of schedules :';
    SCHEDULE.SUMMARY{5,1}=[num2str(SCHEDULE.SIZE) ' ' 'schedules'];
    

end