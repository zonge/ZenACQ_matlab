function [ run_in ] = l_run_schedule(time,cal,letter,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,run_in,tbl_content )
    

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
    
    if cal==true
        
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
        
        period=(ADC_freq/FREQ(schedule))-1;
        duty=(DUTY*ADC_freq/100/FREQ(schedule))-1;
        if DUTY==0;duty=0;end
        if FREQ(schedule)==0;period=0;end
        
        for ch=1:size(handles.CHANNEL.ch_serial,2)
            
            if nargin>11
                index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
                if strcmp(tbl_content{index,1},'Off'); continue;end
            end
            
            %channel_number_str='';
            %if cal==false
            %    channel_number_str=sprintf('%02d',handles.CHANNEL.ch_info{1,ch}.ChNb);
            %end
            
            file_name=[sprintf('%.2d',schedule) letter '.z3d'];
            l_run_schedule_low(handles.CHANNEL.ch_serial{ch},file_name,time,run_in,run_for(schedule),SR(schedule),gain(schedule),period,duty);
            
        end
        
        pourcentage=[sprintf('%0.2f',(schedule/max_schedule)*100) ' %'];
        waitbar(schedule/max_schedule,progress,sprintf('%s',[handles.language.progress_str4 ' ' pourcentage]));
        run_in=run_in+time_between_files+run_for(schedule);
    end
    
    close(progress)

end
