function timer_RX(mTimer,~)
B=mTimer.UserData;
handles=B.pass;
time_zone=str2double(handles.setting.time_zone)*3600/86400;
leak_second=-16/86400;

time=now;

%% STOP IF ZEN IS DISCONNECTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET COM PORT NUMBER
COM=findCOM;

% COM PORT NUMBER
if strcmp('NONE',COM{1,1})

    % DELETE EXISTING OPEN SERIAL PORTS
    newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

    try
    % closes the figure
    delete(handles.ZenRX);
    catch
        disp('error when close')
    end
    
    % DELETE EXISTING TIMER
    Rx_timer=timerfind('Name','Rx_timer');
    if ~isempty(Rx_timer)
        stop(Rx_timer);
        Rx_timer_status=Rx_timer.Running;
            while strcmp(Rx_timer_status,'on')
                Rx_timer_status=Rx_timer.Running;
            end
        delete(Rx_timer);
        return;
    end
    
end


%% COUNTDOWN IF COMMIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msg_val=get(handles.error_msg,'Value');
if msg_val>0                                % IF THERE IS A SCHEDULE COMMITED
    dif=msg_val-time;
    dif_str = datestr(dif,'dd-HH:MM:SS');
    if dif<0                                % IF BEGINNING OF THE SCHEDULE
        set(handles.error_msg,'Value',-1);
        set(handles.error_msg,'String','ZEN is running. Do not unplug');        
        
    else                                    % SHOW COUNTDOWN UNTIL BEGINNING OF THE FIRST SCHEDULE
        set(handles.error_msg,'String',['Starts in ' dif_str]);
    end
elseif msg_val==-1                          % START COUNTDOWN UNTIL END OF ACQUISITION
    end_time=get(handles.box_str,'Value');
    dif_end=end_time-time;
    if dif_end>0                            % DISPLAY COUNTDOWN
        end_time_str=datestr(dif_end,'dd-HH:MM:SS');
        set(handles.error_msg,'String',['Finishes in ' end_time_str]);
    else                                    % END OF COUNTDOWN, STOP DISPLAYING.
        set(handles.error_msg,'String','');
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMMUNICATION TO THE ZEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

second=str2double(datestr(time,'SS'));


%% ACTIONS every multiple of 13 seconds. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if mod(second,13)==0  

% SYNC
total_Y=0;
data=cell(1,size(handles.CHANNEL.ch_serial,2));

for i=1:size(handles.CHANNEL.ch_serial,2)
    
     [sync_data,~]=QuickSendReceive(handles.CHANNEL.ch_serial{1,i},'sync',10,'Synced:',0);
     data{1,i}=sync_data(end:end);
     
     % SUM if SYNC
     if data{1,i}=='Y'
        total_Y=total_Y+1;
     end

end

     % IF THE TOTAL SUM EQUAL THE AMOUNT OF CHANNEL DISPLAY SYNC CIRCLE
     
     if total_Y==size(handles.CHANNEL.ch_serial,2)
         set(handles.status_sync_val,'ForegroundColor','green')
         
         % GET TIME
         if get(handles.local_time_val,'Value')==0
         set(handles.gps_time_str,'Visible','on')
         set(handles.local_time_val,'Value',1)
         timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'gettime',10,'LastTime&DatefromGPSwas:','(');
         time_GPS_dec=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS')+time_zone+leak_second;
         dif_time=time_GPS_dec-time;
         GPS_dif_time=datestr(dif_time,'dd, HH:MM:SS');

         if abs(dif_time*86400)>30
             warndlg(['Your computer time does not match the GPS time. Please verify your Time zone or your computer time settings. Time difference : ' ...
                 GPS_dif_time ],'!! Time Zone Aberation !!')
         end
         end
         
         
     else
         set(handles.status_sync_val,'ForegroundColor','red')
     end

end

 %% ACTIONS every multiple of 7 seconds. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if mod(second,7)==0

    % NUMSAT
    numsat=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'numsats',10,'Lastpacketshowed','sattelites.');
    set(handles.status_sats_val,'String',numsat);

    % VOLTAGE
    Voltage=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'TESTPWRADCS',10,'TestPwrAdcs:','Vx');
    set(handles.status_volts_val,'String',Voltage);

else

    % EXTRAPOLATE TIME BASED ON EVERY 7second value.
    %GPS_time_display=get(handles.gps_time_val,'String');
    %if ~isempty(GPS_time_display)
    %    GPS_time_display=datestr(datenum(GPS_time_display,'mmm dd, yyyy HH:MM:SS')+(1/86400),'mmm dd, yyyy HH:MM:SS');  %% + 16second leak  + time_zone
    %end
end

%% UPDATE GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_display=datestr(time,'mmm dd, yyyy HH:MM:SS');
set(handles.local_time_val,'String',time_display)
