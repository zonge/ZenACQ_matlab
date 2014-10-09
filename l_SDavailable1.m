function [status, handles ] = l_SDavailable1( handles,COM_Nb )
%l_SDavailable turns COM port channels into SD cards.
max_time=8;  % max time to wait for COM

progress = waitbar(0,'Wait while loading Zen channels...','Name','Turn to SD mode' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);


% LOOP FOR COM PORT TO DISAPEAR
COM='';
a=0;
while ~strcmp(COM,'NONE') 
    a=a+1;
    COM=findCOM;
    
    try
    for i=1:COM_Nb
    
    fprintf(handles.CHANNEL.ch_serial{i},'umass');

    pourcentage=[sprintf('%0.2f',((i+size(COM,1))/(size(COM,1)*2))*100) ' %'];
    waitbar(((i+size(COM,1))/(size(COM,1)*2)),progress,sprintf('%s',pourcentage));
    pause(0.2)
    end
    catch
        disp('UMASS again')
    end
    
    pause(2)
    
    if a==max_time
        %msgbox('Waiting for SD cards is taking too long. Please load your data manually. ');
        status=false;
        close(progress)
        return;
    end
    
end

%% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end
pause(0.2)
status=true;
close(progress)

end

