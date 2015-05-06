function [ status ] = l_commit_if_Transmitting( handles )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

status=true;

if strcmp(get(handles.set_up,'String'),handles.language.set_up_transmit_str2)
   set(handles.error_msg,'Value',0,'String','Acquisition stopped'); 
   set(handles.box_str,'Value',0)
   set(handles.set_up,'Enable','off')
   
    progress = waitbar(0,handles.language.progress_str6,'Name',handles.language.progress_title2 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   
   
    % STOP PERIOD AND DUTY
    QuickSendReceive(handles.CHANNEL.ch_serial{handles.CH1_index},'adcduty 4294967295',10,'(0x',')');
    QuickSendReceive(handles.CHANNEL.ch_serial{handles.CH1_index},'adcperiod 4294967295',10,'(0x',')');
        
    waitbar(1,progress,sprintf('%s','STOP TRANSMITING'));

    for ch=1:size(handles.CHANNEL.ch_serial,2)
         
        % Datalog 0 (Close file if open)
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},'datalog 0',10,'DataLoggingtoflashcardis:','.');
        
        % Clear schedule
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},'clearschedule',10,'Entirescheduledeleted','T');
        
        % GlobalSave
        fprintf(handles.CHANNEL.ch_serial{ch},'GLOBALSAVE');
        
        waitbar(1,progress,sprintf('%s',handles.language.progress_str6));
    end 
 
    % Wait for global save
    for ch=1:size(handles.CHANNEL.ch_serial,2)
        try
            waitln(handles.CHANNEL.ch_serial{ch},'GlobalSave():Complete','SAVE PARAMETERS',10);
        catch error_c
            msgbox(['Error trying to save | Error msg: ' error_c.message ]);
        end
        pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
        waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',pourcentage));
    end

    close(progress);
   
status=false;
set(handles.set_up,'String',handles.language.set_up_transmit_str) % CHANGE COMMIT STR NAME
set(handles.display_real_time,'Enable','on')
set(handles.check_setup,'Enable','on')
return;
end



