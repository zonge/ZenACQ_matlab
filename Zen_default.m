function [ handles ] = Zen_default( handles,C,connected_ch )
% SET ZENBOX TO DEFAULT STATE

%   Marc Benoit - 10/10/2014
%   Zonge International, Inc

%needs a little time to not beep ??
pause(0.05)

progress = waitbar(0,'Wait while loading Zen channels...','Name','Initialize Zen channels...' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar],'WindowStyle','modal');


for i=1:connected_ch
   [~,status_connect]=connect2(C.ch_serial{i});
   
   if status_connect==0
       
   % CLEAR SCHEDULE
   QuickSendReceive( C.ch_serial{i},'CLEARSCHEDULE',10,'ClearScheduleCommand:','.' );
    
   % DATALOG
   QuickSendReceive( C.ch_serial{i},'datalog 0',10,'DataLog Command:','.' );
   
   pause(1)
   
   % LogTerminalInDatafiles 0
   QuickSendReceive( C.ch_serial{i},'LogTerminalInDatafiles 0',10,'LogTerminalInDatafiles:','.' );
   
   % UseGeneratedPPS
   QuickSendReceive( C.ch_serial{i},'UseGeneratedPPS 0',10,'UseGeneratedPPS:','.' );
   
   % GeneratePPS
   QuickSendReceive( C.ch_serial{i},'GeneratePPS 0',10,'GeneratePPS:','.' );
   
   % ZIGRADIOENABLE
   QuickSendReceive( C.ch_serial{i},'ZIGRADIOENABLE 0',10,'ZigRadioEnabled:','.' );
   
   % DatafileType
   %QuickSendReceive( C.ch_serial{i},'DatafileType binary',10,'DatafileType:','.' );   
   
   % ADC MUX
   QuickSendReceive( C.ch_serial{i},'ADCMUX 1',10,'MuxRegisteriscurrently:','x' );   
   
   % METADATA CLEAR
   QuickSendReceive( C.ch_serial{i},'METADATA CLEAR',10,'NumMetaDataRecords(',')' );   
   
   % ScheduleRunAtGpsSync
   QuickSendReceive( C.ch_serial{i},'ScheduleRunAtGpsSync 0',10,'RunningscheduleatGPStimesync:','.' );   

   % FFTLOG 0
   QuickSendReceive( C.ch_serial{i},'FFTLOG 0',10,'FFTLoggingtoflashcardis:','.' );
   
   % GlobalSave
   fprintf(C.ch_serial{i},'GLOBALSAVE');
   
    pourcentage=[sprintf('%0.2f',(i/connected_ch)*100) ' %'];
    waitbar(i/connected_ch,progress,sprintf('%s',pourcentage));
    
   end
   
end

% WAIT FOR GLOBAL SAVE
for i=1:connected_ch
    try
        waitln(C.ch_serial{i},'GlobalSave():Complete','SAVE PARAMETERS',10);
    catch error_c
         msgbox(['Error trying to save | Error msg: ' error_c.message ]);
    end
      
    pourcentage=[sprintf('%0.2f',(i/connected_ch)*100) ' %'];
    waitbar(i/connected_ch,progress,sprintf('%s',pourcentage));
    
end

close(progress);

end

