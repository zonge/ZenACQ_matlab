function [status, handles ] = l_SDavailable2( handles,NbD_b_UMASS,COM_Nb )
%l_SDavailable turns COM port channels into SD cards.

progress = waitbar(0,'Wait while loading Zen channels...','Name','Turn to SD mode' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

% CHECK FOR SD cards to appear.   
a=0;
SD_Nb=0;
max_time_SD=40;  % max time to wait for SD

waitbar(0,progress,'Waiting for Channels to pop up as SD drive ...');

while COM_Nb~=SD_Nb
    a=a+1;

    % GET LIST OF CURRENT FILES
    import java.io.*;
    f=File('');
    r=f.listRoots;
    
    SD_Nb=numel(r)-NbD_b_UMASS;  % NUMBER OF SD available
    %disp(['NbD_b_UMASS:' num2str(NbD_b_UMASS) ' | numel(r) :' num2str(numel(r)) '| COM_Nb' num2str(COM_Nb)])

    % UPDATE PROGRESS BAR
    pourcentage=[sprintf('%0.2f',(SD_Nb/COM_Nb)*100) ' %'];
    waitbar(SD_Nb/COM_Nb,progress,[ num2str(SD_Nb) ' SD drive(s) found | ' sprintf('%s',pourcentage)]);

    pause(1) 

    if a==max_time_SD
        msgbox('Waiting for SD cards is taking too long or some channels have no data. Please load your data manually. ');
        status=false;
        close(progress)
        return;
    end

end

close(progress)
status=true;

set(handles.msg_txt,'Value',1);


end

