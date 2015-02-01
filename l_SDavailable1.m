function [status, handles ] = l_SDavailable1( handles,COM_Nb )
%l_SDavailable turns COM port channels into SD cards.

% PARAMETERS
time_unit=0;  % time unit increment
COM='';       % Initialise string
max_time=10;  % max iteration to wait for COM to turn into SD cards.


% Initiate Progress Bar
progress = waitbar(0,'Wait while loading Zen channels...','Name','Turn to SD mode' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

% LOOP FOR THE LIST OF COM PORT TO BE NULL.
while ~strcmp(COM,'NONE') 
    time_unit=time_unit+1;
    COM=findCOM;
    try
        for i=1:COM_Nb
    
            % SEND UMASS CMD
            fprintf(handles.CHANNEL.ch_serial{i},'umass');
    
            % Update Progress Bar
            pourcentage=[sprintf('%0.2f',((i+size(COM,1))/(size(COM,1)*2))*100) ' %'];
            waitbar(((i+size(COM,1))/(size(COM,1)*2)),progress,sprintf('%s',pourcentage));
            pause(0.2)
            
        end
    catch
        disp('UMASS again');
    end
    
    % Give a 2 second delay
    pause(2)
    
    if time_unit==max_time
        %msgbox('Waiting for SD cards is taking too long. Please load your data manually. ');
        status=false;
        close(progress)
        return;
    end
    
end

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end; pause(0.2);

% Clocse Progress bqr
close(progress)

% Set Status
status=true;

end

