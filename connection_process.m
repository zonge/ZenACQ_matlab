function [ handles,CH1_index,status ] = connection_process( handles )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%%% CONNECT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INITIALIZATION
status=0;
CH1_index=[];

% FIND COM PORTS
COM=findCOM;
if strcmp(COM,'NONE');msgbox('No Zen connected');status=1;return;end

% Initiate Progress Bar
progress = waitbar(0,'Wait while loading Zen channels...','Name','Connect to Zen channels...' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

% LOOP FOR SERIAL PORT CONNECTIONS
connected_ch=0;
for i=1:size(COM,1)
    
    [~,ch_serial,status_connect]=connect1(COM{i});

    if status_connect==0
        
        connected_ch=connected_ch+1; %increment connected channel
        
        C.ch_serial{connected_ch}=ch_serial; % Add channel Obj to the Channel Obj Array
        
        pourcentage=[sprintf('%0.2f',(i/(size(COM,1)*2))*100) ' %'];
        waitbar((i/(size(COM,1)*2)),progress,sprintf('%s',[COM{i} ' - ' pourcentage]));

    end
end

% LOOP FOR CHANNEL INFORMATION
j=0;
channel_status=false(connected_ch,1);

for i=1:connected_ch

    [ch_info,status_connect]=connect2(C.ch_serial{i});
    
    if status_connect==1 % Fail reading
        channel_status(i)=true;
        continue
    else
        j=j+1;
    end
        
    [~,v2]=strtok(ch_info.version,'.');
    
    if str2double(v2(2:end))<4015
        ch_info.BoardSN=QuickSendReceive(C.ch_serial{i},'version',10,'FPGAserialnumber:0x',',buildnumber:');
    end
    
    if str2double(ch_info.version)<4329
        h=errordlg('Firmware version 4329 or higher is required. Please go to Options and upgrade your box to the last available firmware.','ZenACQ');
        uiwait(h);
        connected_ch=0;
        break
    end
    
    if status_connect==0
        
        C.ch_info{j}=ch_info;
        
        pourcentage=[sprintf('%0.2f',((i+size(COM,1))/(size(COM,1)*2))*100) ' %'];
        waitbar(((i+size(COM,1))/(size(COM,1)*2)),progress,sprintf('%s',[COM{i} ' - ' pourcentage]));
    end
end

close(progress)

 if connected_ch==0
     status=1;
     return;
 end
 
 disp(['[ Box # ] : ' num2str(ch_info.BoxNb)]) ;
disp(['[ Firmware Version ] : ' ch_info.version]) ;
 
 % Update if Serials if Error in the header read.
 connected_ch=size(C.ch_info,2);
 C.ch_serial(:,channel_status) = [];
 
% Find CH1
check_nb_of_1_ch=0;
  for i=1:connected_ch
        if  C.ch_info{i}.ChNb==1
            CH1_index=i;
            check_nb_of_1_ch=check_nb_of_1_ch+1;
        end  
  end 

% Check number of channel 1 found.
if check_nb_of_1_ch>1
    status=1;
    msg=errordlg(['There is ' num2str(check_nb_of_1_ch) ...
    'There are more than one channel 1.'] ...
    ,'Channels 1 Error');
    waitfor(msg)
elseif check_nb_of_1_ch==0
    status=1;
    msg=errordlg('There is no channel 1.' ...
    ,'Channels 1 Error');
    waitfor(msg)
    return;
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

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);end

% Initiate Progress Bar
progress = waitbar(0,'Wait while loading Zen channels...','Name','Connect to Zen channels...' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

% LOOP FOR SERIAL PORT CONNECTIONS
connected_ch=0; % to allows to continue without breaking if one channel is not responding
for i=1:size(COM,1)
    [~,ch_serial,status_connect]=connect1(COM{i});

    if status_connect==0
        connected_ch=connected_ch+1;
        
        C.ch_serial{connected_ch}=ch_serial;
        
        % Update Progress Bar
        pourcentage=[sprintf('%0.2f',(i/(size(COM,1)*2))*100) ' %'];
        waitbar((i/(size(COM,1)*2)),progress,sprintf('%s',[COM{i} ' - ' pourcentage]));

    end
end

close(progress)

% START DEFAULT STATE INITIALIZATION
Zen_default( handles,C,connected_ch );

end

% HANDLES CHANNELS VARIABLES
handles.CHANNEL=C;

end

