function [ run_in ] = l_run_schedule(time,cal,mux,letter,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,run_in )
    
    ADC_freq=2097152; %ADC speed CONSTANT VARIABLE

    
    progress = waitbar(0,'Set Schedule...','Name','Set Schedule' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);    

    for ch=1:size(handles.CHANNEL.ch_serial,2)
         
        % Clear schedule
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},'clearschedule',10,'Entirescheduledeleted','T');
        
        waitbar(1,progress,sprintf('%s','Clear Schedule '));
    end    
    
    if cal==true
        
    period=(ADC_freq/FREQ)-1;
    duty=(DUTY*ADC_freq/100/FREQ)-1;
    if DUTY==0;duty=0;end
    if FREQ==0;period=0;end
    
    % CAL voltage
    QuickSendReceive(handles.CHANNEL.ch_serial{C.index_ch1},'calvoltage 0.5',10,'Voltageto:',';');
        
    % CAL ADC period
    QuickSendReceive(handles.CHANNEL.ch_serial{C.index_ch1},['adcperiod ' num2str(period)],10,'perioddivisorsetto:','.');

    % CAL ADC Duty
    QuickSendReceive(handles.CHANNEL.ch_serial{C.index_ch1},['adcduty ' num2str(duty)],10,'dutydivisorsetto:','.');

    % CAL channel
    QuickSendReceive(handles.CHANNEL.ch_serial{C.index_ch1},'calchannels 0x00',10,'maskiscurrentlysetto:0x','.');

    end
        
    for ch=1:size(handles.CHANNEL.ch_serial,2)
         
        % Set Mux
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},['adcmux ' num2str(mux)],10,'MuxRegisteriscurrently:0x',0);  
        
    end 
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Send Schedule command
    max_schedule=size(SR,2); 
    for schedule=1:max_schedule
        
        period=(ADC_freq/FREQ(schedule))-1;
        duty=(DUTY*ADC_freq/100/FREQ(schedule))-1;
        if DUTY==0;duty=0;end
        if FREQ(schedule)==0;period=0;end
        
        
        for ch=1:size(handles.CHANNEL.ch_serial,2)
            file_name=[sprintf('%.2d',schedule) letter '.z3d'];
            l_run_schedule_low(handles.CHANNEL.ch_serial{ch},file_name,time,run_in,run_for(schedule),SR(schedule),gain(schedule),period,duty);
        end
        
        pourcentage=[sprintf('%0.2f',(schedule/max_schedule)*100) ' %'];
        waitbar(schedule/max_schedule,progress,sprintf('%s',['Set schedule :' pourcentage]));
        
        run_in=run_in+time_between_files+run_for(schedule);
    end
    
    close(progress)

end
