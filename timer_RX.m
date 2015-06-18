function timer_RX(mTimer,~)

try
    
B=mTimer.UserData;
handles=B.pass;
time_zone=str2double(handles.setting.time_zone)*3600/86400;
leak_second=-16/86400;

% increment time
old_time=get(handles.status_volts,'Value');
dif=now-old_time;
set(handles.status_volts,'Value',now);

SYNCED=get(handles.local_time_val,'Value');
if SYNCED==0
    time=now;
    set(handles.status_sync_val,'Value',time);
else
    time_GPS_dec=get(handles.status_sync_val,'Value');
    time=time_GPS_dec+dif;
    set(handles.status_sync_val,'Value',time);
end

 time_GPS_raw=get(handles.status_sync,'Value');
 time_GPS_raw=time_GPS_raw+dif;
 set(handles.status_sync,'Value',time_GPS_raw);
 time_raw=time_GPS_raw;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% STOP IF ZEN IS DISCONNECTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GET COM PORT NUMBER
COM=findCOM;

% COM PORT NUMBER
if strcmp('NONE',COM{1,1})

    try
       
    %  Main Window Visible
    figHandles = findall(0,'Type','figure');
    for i=1:size(figHandles,1)
       if  strcmp(figHandles(i).Tag,'ZenACQ')
           figHandles(i).Visible='on';
       end
    end
       
    % DELETE EXISTING OPEN SERIAL PORTS
    newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end  
    
    % closes the figure
    delete(handles.ZenRX);

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

    catch
        disp('Error when closing the windows')
    end
   
end


%% COUNTDOWN IF COMMIT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msg_val=get(handles.error_msg,'Value');

%datestr(msg_val,'dd-HH:MM:SS')
if msg_val>0                                % IF THERE IS A SCHEDULE COMMITED/
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
        if get(handles.delete_all_files,'Value')==0
        ZenRX_NbofFiles( handles );         % update number of files
        set(handles.delete_all_files,'Value',1)
        end
        if handles.main.type==1             % if TX Disable Transmit
            set(handles.set_up,'Enable','on','String',handles.language.set_up_transmit_str)
            set(handles.display_real_time,'Enable','on')
            set(handles.check_setup,'Enable','on')
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
     data{1,handles.CHANNEL.ch_info{1,i}.ChNb}=sync_data(end:end);
     % SUM if SYNC
     if data{1,handles.CHANNEL.ch_info{1,i}.ChNb}=='Y'
        total_Y=total_Y+1;
     end
    
end

% Give Sync information for all channels.

j=1;
tooltip_str=char(1:size(data,2)*2);
for i=1:size(data,2)
    tooltip_str(j:j+1)=[data{i} ':'];
    j=j+2;
end
    set(handles.status_sync_val,'TooltipString',tooltip_str(1:end-1));
    set(handles.status_sync,'TooltipString',tooltip_str(1:end-1)); 
    
    %test
    %total_Y=6
    
     % IF THE TOTAL SUM EQUAL THE AMOUNT OF CHANNEL DISPLAY SYNC CIRCLE
     if total_Y==size(handles.CHANNEL.ch_serial,2)
         
         % PLAY SOUND
         already_sync=get(handles.status_sync_val,'ForegroundColor');
          if already_sync(2)~=1
            [sync_sound,f]=audioread('sync_done.mp3');
            sound(sync_sound,f)
          end
          
         set(handles.status_sync_val,'ForegroundColor','green')
         
         % GET TIME
         timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'gettime',10,'LastTime&DatefromGPSwas:','(');
         time_GPS_raw=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS');
         time_GPS_dec=time_GPS_raw+time_zone+leak_second; % LOCAL TIME
              
         
         set(handles.status_sync_val,'Value',time_GPS_dec)
         set(handles.status_sync,'Value',time_GPS_raw)
         dif_time=abs(time_GPS_dec-time);
         GPS_dif_time=datestr(dif_time,'HH:MM:SS');

         if get(handles.local_time_val,'Value')==0
         set(handles.local_time_val,'Value',1)
         if abs(dif_time*86400)>300 
             warndlg([handles.language.time_zone_err1 ' ' ...
                 GPS_dif_time ], handles.language.time_zone_err2)
         end
         end
     
     getlla=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'GETLLA',10,'LastlocationfromGpswas:','m');  
     getlla_cell=textscan(getlla,'%fox%fo@%f');
     Alt=getlla_cell{1,3};
     [x,y,utmzone] = deg2utm(getlla_cell{1,1},getlla_cell{1,2});   
     set(handles.utm_checkbox,'Visible','on')
     set(handles.utm_zone_str,'String',[handles.language.zen_zone_str ' ' utmzone],'Value',round(x))
     set(handles.altitude_str,'String',[handles.language.zen_altitude ' ' num2str(round(Alt)) ' m'],'Value',round(y))

         if handles.main.type==1 % TX
            set(handles.set_up,'Visible','on')
            set(handles.error_msg,'String','')
         end
     
     else
         
         set(handles.status_sync_val,'ForegroundColor','red')
         set(handles.local_time_val,'Value',0)
         
         timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'gettime',10,'LastTime&DatefromGPSwas:','(');
         time_GPS_raw=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS');
         set(handles.status_sync,'Value',time_GPS_raw)
         
         if handles.main.type==1 % TX
            set(handles.set_up,'Visible','off')
            set(handles.error_msg,'String',handles.language.transmit_msg)
         end
     end

end

 %% ACTIONS every multiple of 7 seconds. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if mod(second,7)==0

    % NUMSAT
    numsat=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'numsats',10,'Lastpacketshowed','sattelites.');
    set(handles.status_sats_val,'String',numsat);

    % VOLTAGE
    Voltage_str=QuickSendReceive(handles.CHANNEL.ch_serial{1,handles.CH1_index},'TESTPWRADCS',10,'TestPwrAdcs:','Vx');

    set(handles.status_volts_val,'String',Voltage_str);
    if str2double(Voltage_str)<10
        set(handles.status_volts_val,'Value',2);  
    elseif str2double(Voltage_str)<12
        set(handles.status_volts_val,'Value',1); 
    else
        set(handles.status_volts_val,'Value',0);  
    end
    
    % UPDATE SCHEDULE
    date_pop=get(handles.date_push,'String');
    if strcmp(date_pop,'today'); datestr(date,'dd mmm yyyy'); end
    hour_pop=get(handles.hour_popup,'Value')-1;
    min_pop=get(handles.min_popup,'Value')-1;
    
    date_pop2=datenum([sprintf('%02d',hour_pop) sprintf('%02d',min_pop) ' ' date_pop],'HHMM dd mmm yyyy');
    date_pop2= addtodate(date_pop2, -(handles.main.extra_time), 'second');

    dif=date_pop2-time;

    if dif<0 % if later than the official time
        % SET NEWSCHEDULE START TIME
        date_now_val= addtodate(time, handles.main.extra_time+60, 'second');
        date_now=datestr(date_now_val,'dd mmm yyyy');
        hour_now=str2double(datestr(date_now_val,'HH'));
        min_now=str2double(datestr(date_now_val,'MM'));
        set(handles.date_push,'String',date_now);
        set(handles.hour_popup,'Value',hour_now+1);
        set(handles.min_popup,'Value',min_now+1);
        date_now_val2=datenum([date_now ' ' num2str(hour_now) '-' num2str(min_now) ],'dd mmm yyyy HH-MM');
        TOTAL_TIME=get(handles.quick_summary_str,'Value');
        t=addtodate(date_now_val2,TOTAL_TIME, 'second');
        end_acq_str=datestr(t,'dd-mmm-yyyy , HH:MM:SS');
        if strcmp(get(handles.late_option,'String'),'Late ?')
        set(handles.end_time_str,'String',end_acq_str);
        end
    end

    
end

%% VOLTAGE AND TIME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time_display=datestr(time,'mmm dd, yyyy HH:MM:SS');
time_display_raw=datestr(time_raw,'mmm dd, yyyy HH:MM:SS');

set(handles.local_time_val,'String',time_display);
set(handles.local_time_val,'TooltipString',['Raw GPS time : ' time_display_raw]);

voltage_status=get(handles.status_volts_val,'Value');
if voltage_status==1
    set(handles.status_volts_val,'BackgroundColor','red');
    set(handles.status_volts,'BackgroundColor','red');
    pause(0.1)
    set(handles.status_volts_val,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.status_volts,'BackgroundColor',[0.94 0.94 0.94]);
elseif voltage_status==2
    set(handles.status_volts_val,'BackgroundColor','red');
    set(handles.status_volts,'BackgroundColor','red');
    set(handles.set_up,'BackgroundColor','red');
    pause(0.1)
    set(handles.status_volts_val,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.status_volts,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.set_up,'BackgroundColor',[0 0.447 0.741]);
else
    set(handles.status_volts_val,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.status_volts,'BackgroundColor',[0.94 0.94 0.94]);
    set(handles.set_up,'BackgroundColor',[0 0.447 0.741],'Enable','on');
end

catch
end
