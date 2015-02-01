function [status, handles ] = l_SDavailable2( handles,NbD_b_UMASS,COM_Nb )
%l_SDavailable turns COM port channels into SD cards.

% PARAMETERS
time_unit=0;      % time unit increment
SD_Nb=0;          % initialise 
max_time_SD=180;  % max time to wait for SD

% Initiate Progress Bar
progress = waitbar(0,'Waiting for Channels to pop up as SD drive ...','Name','Turn to SD mode' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

% CHECK FOR SD cards to appear. 
while COM_Nb~=SD_Nb
    time_unit=time_unit+1;

    % GET LIST OF CURRENT FILES
    import java.io.*; f=File(''); r=f.listRoots;
    SD_Nb=numel(r)-NbD_b_UMASS;  % NUMBER OF SD available

    % Update Progress Bar
    pourcentage=[sprintf('%0.2f',(SD_Nb/COM_Nb)*100) ' %'];
    waitbar(SD_Nb/COM_Nb,progress,[ num2str(SD_Nb) ' SD drive(s) found | ' sprintf('%s',pourcentage)]);

    % Give a 1 second delay
    pause(1) 
    
    % STOP LOOP IF THE PROCESS IS TAKING LONGER THAN MAX_TIME_SD.
    if time_unit==max_time_SD
        msgbox('Waiting for SD cards is taking too long or some channels have no data. Please load your data manually. ');
        status=false;
        close(progress)
        return;
    end

end

% Clocse Progress bqr
close(progress)

% Set Status
status=true;


end