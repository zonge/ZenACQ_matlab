function [ handles,CH1_index,status ] = connection_process( handles )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%% CONNECT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

status=0;
CH1_index=[];

COM=findCOM;
if strcmp(COM,'NONE');msgbox('No Zen connected');status=1;return;end

progress = waitbar(0,'Wait while loading Zen channels...','Name','Connect to Zen channels...' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

% LOOP FOR SERIAL PORT CONNECTIONS
check_nb_of_1_ch=0;
connected_ch=0; % to allows to continue without breaking if one channel is not responding
for i=1:size(COM,1)
    [~,ch_serial,status_connect]=connect1(COM{i});

    if status_connect==0
        connected_ch=connected_ch+1;
        
        C.ch_serial{connected_ch}=ch_serial;
        
        pourcentage=[sprintf('%0.2f',(i/(size(COM,1)*2))*100) ' %'];
        waitbar((i/(size(COM,1)*2)),progress,sprintf('%s',pourcentage));

    end
end
% LOOP FOR DATA
for i=1:connected_ch
    [ch_info,status_connect]=connect2(C.ch_serial{i});
    
    ch_info.BoardSN=QuickSendReceive(C.ch_serial{i},'version',10,'FPGAserialnumber:0x',',buildnumber:');
    
    if status_connect==0
        
        C.ch_info{i}=ch_info;
    
        if  C.ch_info{i}.ChNb==1
            CH1_index=i;
            check_nb_of_1_ch=check_nb_of_1_ch+1;
        end  
        
        pourcentage=[sprintf('%0.2f',((i+size(COM,1))/(size(COM,1)*2))*100) ' %'];
        waitbar(((i+size(COM,1))/(size(COM,1)*2)),progress,sprintf('%s',pourcentage));
    end
end

close(progress)

 if connected_ch==0
     status=1;
     return;
 end

% Check number of channel 1 found.
if check_nb_of_1_ch>1
    status=1;
    errordlg(['There is ' num2str(check_nb_of_1_ch) ...
    'There are more than one channel 1.'] ...
    ,'Channels 1 Error');
end


% RE-INITIATE 339 IF NEEDED
% Check if ok
initiate_status=true;
for i=1:connected_ch
    if C.ch_info{1,i}.LogData~=0  || C.ch_info{1,i}.LogTerminal~=0 || C.ch_info{1,i}.Datatype~=1
        initiate_status=false;
        break
    end
end

% Initiate
if initiate_status==false
msg=warndlg('This Zenbox is not configure properly. Click OK to fix it. ','Zen initialization');
uiwait(msg)
Zen_default( handles,C,connected_ch );
end
% HANDLES CHANNELS VARIABLES
handles.CHANNEL=C;

end

