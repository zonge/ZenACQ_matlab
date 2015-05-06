function [ ] = installARM(handles)
% INSTALL THE SELECTED ARM firmware to the connected COM port
%   Marc Benoit - 08/20/2014
%   Zonge International, Inc

% GET HEX FILE
[FileName,PathName] = uigetfile('*.hex','Find .Hex firmware');
if FileName==0;return;end  % exit if no file selected.
hex_path=[PathName FileName];
set(handles.upgrade_msg,'String',[FileName ' ' 'is being upgraded into your Zen... Do not close the dos windows' ]);
set(handles.upgrade_firmware,'Enable','off');
% GET AVAILABLE COM PORTS
COM=findCOM();

if strcmp(COM{1,1},'NONE')
    beep
    set(handles.upgrade_msg,'String','No Zen Ports found.');
    return;
end

if size(COM)>0
    
    fileID = fopen('COM.cfg','w');
    for row = 1:size(COM,1)
    fprintf(fileID,'%s\n',COM{row,:});
    end
    fclose(fileID);
    
% Write ZenARM.bat
fileID = fopen('ZenARM.bat','w');    
fprintf(fileID,'%s\n','@echo off');
fprintf(fileID,'%s\n','mode con: cols=70 lines=30');
fprintf(fileID,'%s\n','prompt $g');
fprintf(fileID,'%s\n','cls');
fprintf(fileID,'%s\n','echo Firmware HEX version : %1');
fprintf(fileID,'%s\n','setlocal EnableDelayedExpansion');
fprintf(fileID,'%s\n','set count=0');
fprintf(fileID,'%s\n','for /f %%a in (COM.cfg) do (');
fprintf(fileID,'%s\n','set /A count+=1');
fprintf(fileID,'%s\n','set val=%%a');
fprintf(fileID,'%s\n','set port[!count!]=%%a');
fprintf(fileID,'%s\n',')');
fprintf(fileID,'%s\n','del COM.cfg');
fprintf(fileID,'%s\n','for /L %%i in (1,1,%count%) do (');
fprintf(fileID,'%s\n','lpc21isp -control -controlswap -controlinv %1 !port[%%i]! 230400 14745');
fprintf(fileID,'%s\n',')');
fprintf(fileID,'%s\n','echo. 2>done.fir');
fprintf(fileID,'%s\n','exit');
fclose(fileID);
  
% Run ZenARM.bat
eval(['!ZenARM.bat ' hex_path ' &']);

a=0;
while a==0
   if exist('done.fir','file')==2
       [sync_sound,f]=audioread('sync_done.mp3');
       sound(sync_sound,f)
       pause(0.1)
       a=1;
       delete('done.fir')
        set(handles.upgrade_msg,'String','Firmware is upgraded');
        set(handles.upgrade_firmware,'Enable','on');
   end
   pause(1)
end

delete('ZenARM.bat')

%% Initiate box.

% CONNECTION
COM=findCOM;
if strcmp(COM,'NONE');msgbox('No Zen connected');return;end

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);end

progress = waitbar(0,'Wait while loading Zen channels...','Name','Initialize Zen channels...' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar],'WindowStyle','modal');

% LOOP FOR SERIAL PORT CONNECTIONS
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

close(progress);

if connected_ch~=size(COM,1)
    beep
    set(handles.upgrade_msg,'String','The firmware was not installed properly, Please try again.');
    beep
    return;
end

% Initialize
Zen_default( handles,C,connected_ch );

end

