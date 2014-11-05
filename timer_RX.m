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
        disp('Error when close the windows')
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
        set(handles.error_msg,'String',handles.language.timer_msg1);        
        
    else                                    % SHOW COUNTDOWN UNTIL BEGINNING OF THE FIRST SCHEDULE
        set(handles.error_msg,'String',[handles.language.timer_msg2 ' ' dif_str]);
    end
elseif msg_val==-1                          % START COUNTDOWN UNTIL END OF ACQUISITION
    end_time=get(handles.box_str,'Value');
    dif_end=end_time-time;
    if dif_end>0                            % DISPLAY COUNTDOWN
        end_time_str=datestr(dif_end,'dd-HH:MM:SS');
        set(handles.error_msg,'String',[handles.language.timer_msg3 ' ' end_time_str]);
    else                                    % END OF COUNTDOWN, STOP DISPLAYING.
        set(handles.error_msg,'String','');
        if handles.main.type==1 % if TX Disable Transmit
            set(handles.set_up,'Enable','on')
        end
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
         set(handles.local_time_val,'Value',1)
         timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'gettime',10,'LastTime&DatefromGPSwas:','(');
         time_GPS_dec=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS')+time_zone+leak_second;
         dif_time=time_GPS_dec-time;
         GPS_dif_time=datestr(dif_time,'dd, HH:MM:SS');

         if abs(dif_time*86400)>120
             warndlg([handles.language.time_zone_err1 ' ' ...
                 GPS_dif_time ], handles.language.time_zone_err2)
         end
         end
     
     getlla=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'GETLLA',10,'LastlocationfromGpswas:','m');  
     getlla_cell=textscan(getlla,'%fox%fo@%f');
     Alt=getlla_cell{1,3};
     [x,y,utmzone] = deg2utm(getlla_cell{1,1},getlla_cell{1,2});   
     set(handles.utm_checkbox,'Visible','on')
     set(handles.utm_zone_str,'String',[handles.language.zen_zone_str ' ' utmzone],'Value',round(x*1)/1)
     set(handles.altitude_str,'String',[handles.language.zen_altitude ' ' num2str(round(Alt)) ' m'],'Value',round(y*1)/1)

         if handles.main.type==1 % TX
            set(handles.set_up,'Visible','on')
            set(handles.error_msg,'String','')
         end
     
     else
         set(handles.status_sync_val,'ForegroundColor','red')
         
         if handles.main.type==1 % TX
            set(handles.set_up,'Visible','off')
            set(handles.error_msg,'String',handles.language.transmit_msg)
         end
     end

end

 %% ACTIONS every multiple of 7 seconds. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if mod(second,7)==0

    % NUMSAT
    numsat=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'numsats',10,'Lastpacketshowed','sattelites.');
    set(handles.status_sats_val,'String',numsat);

    % VOLTAGE
    Voltage_str=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'TESTPWRADCS',10,'TestPwrAdcs:','Vx');

    set(handles.status_volts_val,'String',Voltage_str);
    if str2double(Voltage_str)<9
        set(handles.status_volts_val,'Value',1);  
    else
        set(handles.status_volts_val,'Value',0);  
    end

    
end

%% UPDATE GUI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_display=datestr(time,'mmm dd, yyyy HH:MM:SS');
set(handles.local_time_val,'String',time_display)

voltage_status=get(handles.status_volts_val,'Value');
if voltage_status==1
    set(handles.status_volts_val,'BackgroundColor','red');
    set(handles.status_volts,'BackgroundColor','red');
    pause(0.1)
    set(handles.status_volts_val,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.status_volts,'BackgroundColor',[0.94 0.94 0.94]);
else
    set(handles.status_volts_val,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.status_volts,'BackgroundColor',[0.94 0.94 0.94]);
end

