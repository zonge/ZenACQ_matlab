function status = l_commit_check_input( handles )
% CHECK IF USER INFORMATION IS VALID.

status=true;

%% CHECK INPUT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.error_msg,'Visible','on','String','');  % Make the error msg visible
survey_type=str2double(handles.setting.ZenACQ_mode);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK SURVEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% CHECK STATION
Xstn_box=get(handles.Xstn_box,'String');
if isempty(Xstn_box)
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg2)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])
    status=false;
    return;
end
if isnan(str2double(Xstn_box))==1 || str2double(Xstn_box) ~= floor(str2double(Xstn_box))
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.input_err1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867]) 
    status=false;
    return;       
end

Ystn_box=get(handles.Ystn_box,'String');
if isempty(Ystn_box)
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg2)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])
    status=false;
    return;
end
if isnan(str2double(Ystn_box))==1 || str2double(Ystn_box) ~= floor(str2double(Ystn_box))
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.input_err1)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Ystn_box,'BackgroundColor',[1.0 0.949 0.867])
    status=false;
    return;       
end


% CHECK SURVEY DESIGN TABLE CONTENT
tbl_content=get(handles.geometry_table,'data');

    for ch=1:size(tbl_content,1)
         if strcmp(tbl_content{ch,1},'Off'); continue;end
        for col=2:7
            if isempty(tbl_content{ch,col}) || isnan(tbl_content{ch,col}) 
                       beep
                       set(handles.error_msg,'Visible','on','String',handles.language.commit_msg5)
                       set(handles.survey_panel,'BackgroundColor','red')
                       pause(0.1)
                       set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
                       pause(0.1)
                       set(handles.survey_panel,'BackgroundColor','red')
                       pause(0.1)
                       set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
                       status=false;
                       return; 
            end
        end
    end  

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK CALS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CHECK BOARD CAL
zen_box=str2double(get(handles.box_str_val,'String'));
filename=['calibrate/ZEN' num2str(zen_box) '.cal'];
if exist(filename,'file')~=2  % IF file exist
      choice = questdlg(handles.language.commit_msg1,handles.language.yes,handles.language.yes,handles.language.no,handles.language.yes);
      if strcmp(choice,handles.language.no);status=false;return;end
end

% CHECK ANTENNA CAL
filepath =['calibrate\' handles.main.calibrate_file_name];        
if exist(filepath,'file')~=2 % CHECK IF FILE DOESNT EXIST
    choice = questdlg(handles.language.commit_msg8,handles.language.yes,handles.language.yes,handles.language.no,handles.language.yes);
    if strcmp(choice,handles.language.no);status=false;return;end
else % IF FILE EXIST, CHECK IF ANTENNA ARE IN THE FILE
    tbl_content=get(handles.geometry_table,'data');
    for ch=1:size(tbl_content,1)
        if strcmp(tbl_content{ch,1}(1),'H');
            [~,ant_list] = read_antenna_file( filepath ); % CHECK IF ANTENNA EXIST
            ant_exist=find(ant_list==tbl_content{ch,6}, 1);
            if isempty(ant_exist) % IF IT DOESN"T EXIST BEEP AND MESSAGE
                beep
                w=msgbox(['#' num2str(tbl_content{ch,6}) ' is not found in ' handles.main.calibrate_file_name '.' ]);
                uiwait(w);
            end  
        end 
    end
end

% CHECK TX CAL
if handles.main.type==1 % TX
    filename =['calibrate\' handles.main.TX_cal_file_name];        
if exist(filename,'file')~=2 % IF FILE DOESNT EXIST
    for ch=1:size(tbl_content,1)
         if strcmp(tbl_content{ch,1}(1:2),'TX');
            errordlg('TX.cal is requiered to take data.','TX File Error');
            status=false;
            return;
        end
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK TRANSMITTER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CONFIRM TRANSMIT ACTION
if handles.main.type==1 && survey_type==2  % TX
    choice = questdlg(handles.language.transmit_popup_msg,handles.language.ZenTitle2 ...
        ,handles.language.yes,handles.language.no,handles.language.no);
    if strcmp(choice,handles.language.no);status=false;return;end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK SCHEDULE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CHECK IF THERE IS A SCHEDULE
if handles.SCHEDULE.TOTAL_TIME==0
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg3)
    set(handles.schedule_popup,'BackgroundColor','red')
    pause(0.1)
    set(handles.schedule_popup,'BackgroundColor','white')
    pause(0.1)
    set(handles.schedule_popup,'BackgroundColor','red')
    pause(0.1)
    set(handles.schedule_popup,'BackgroundColor','white')
    status=false;
    return;   
end

% CHECK IF SCHEDULE DOESN'T START AFTER THE DEFINE TIME
if handles.main.type==0
time_check=60; %second | if someone click commit 60 second before the start time the schedule won't rn
now_val=get(handles.status_sync_val,'Value');
time_dif=handles.start_time-now_val-time_check/86400;
if time_dif<0
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg4)
    set(handles.hour_popup,'BackgroundColor','red')
    set(handles.min_popup,'BackgroundColor','red')
    set(handles.date_push,'BackgroundColor','red')
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.min_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.date_push,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor','red')
    set(handles.min_popup,'BackgroundColor','red')
    set(handles.date_push,'BackgroundColor','red')
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.min_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.date_push,'BackgroundColor',[1.0 0.949 0.867])
    status=false;
    return;  
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

