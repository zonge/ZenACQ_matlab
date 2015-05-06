function [ run_in ] = l_run_schedule(time,TX_action,letter,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,run_in,tbl_content )
    
    ADC_freq=2097152; %ADC speed CONSTANT VARIABLE
   
    if nargin>11
    ch_num=get(handles.geometry_table,'RowName');
    end
    
    progress = waitbar(0,handles.language.progress_str6,'Name',handles.language.progress_title2 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);    

    for ch=1:size(handles.CHANNEL.ch_serial,2)
         
        % Clear schedule
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},'clearschedule',10,'Entirescheduledeleted','T');
        
        waitbar(1,progress,sprintf('%s',handles.language.progress_str6));
    end 
    
    close(progress)
    
    %if TX_action==true
    if nargin>11 % IF NOT CAL
        
        % CAL voltage
        QuickSendReceive(handles.CHANNEL.ch_serial{handles.CH1_index},'calvoltage 0',10,'Voltageto:',';');
    
        % CAL channel
        QuickSendReceive(handles.CHANNEL.ch_serial{handles.CH1_index},'calchannels 0x00',10,'maskiscurrentlysetto:0x','.');
    
    end
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progress = waitbar(0,handles.language.progress_str4,'Name',handles.language.progress_title2 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);
    
    % Send Schedule command
    max_schedule=size(SR,2); 
    for schedule=1:max_schedule
        
        % Do not run schedule if there is a break (SR=99)
        if SR(schedule)==99;run_in=run_in+time_between_files+run_for(schedule);continue;end
        
        period=(ADC_freq/FREQ(schedule))-1;
        duty=(DUTY*ADC_freq/100/FREQ(schedule))-1;
        if DUTY==0;duty=0;end
        if FREQ(schedule)==0;period=0;end
        
        for ch=1:size(handles.CHANNEL.ch_serial,2)
              
            channel_number_str=''; newFile='y';
            if nargin>11 % SPECIFIC ACTION FOR ACQUISiTION other than Calibration  
                channel_number_str=sprintf('%02d',handles.CHANNEL.ch_info{1,ch}.ChNb); % ADD CHANNEL NUMBER
                index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));

                if strcmp(tbl_content{index,1},'Off'); % IF CHANNEL IS OFF
                    if handles.CHANNEL.ch_info{1,ch}.ChNb==1 && TX_action==true  % If channel 1 is off set schedule to control the TX but don't write file.
                        newFile='n';
                    else
                        continue; % IF A CHANNEL IS OFF DON'T SET SCHEDULE and go to the next iteration
                    end
                end
                
            end
            
            % GENERATE NAME AND SET SCHEDULE
            if iscell(letter)
                file_name=[sprintf('%02d',schedule) letter{1,schedule}, channel_number_str '.z3d'];
            else
                file_name=[sprintf('%02d',schedule) letter channel_number_str '.z3d'];
            end
            
            l_run_schedule_low(handles.CHANNEL.ch_serial{ch},file_name,time,run_in,run_for(schedule),SR(schedule),gain(schedule),period,duty,newFile);
            
        end
        
        pourcentage=[sprintf('%0.2f',(schedule/max_schedule)*100) ' %'];
        waitbar(schedule/max_schedule,progress,sprintf('%s',[handles.language.progress_str4 ' ' pourcentage]));
        run_in=run_in+time_between_files+run_for(schedule);
    end
    
    close(progress)

end
