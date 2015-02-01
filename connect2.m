function [ c,status ] = connect2(SERIAL_obj)

status=0;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect header
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    header = waitln(SERIAL_obj,'Brd339>','Collect HEADER',8);
    if isempty(header.Query{1,1})
        msg=msgbox(['Error trying to Read the header off : ' SERIAL_obj.Port ' | Try again, it could be that the firmware is not installed properly on this channel. ' ]);
        waitfor(msg)
        status=1;
        c=0;
        return;
    end
    
try

c.ChNb=str2double(GetString(header,'ChannelNumvaluefoundinEEProm:','.'));
c.BoxNb=str2double(GetString(header,'ZenBoxNumbervaluefoundinEEProm:','.'));
c.LogData=str2double(GetString(header,'LogDataToFlashvaluefoundinEEProm:','.'));
c.LogTerminal=str2double(GetString(header,'LogTerminalInDatafilesvaluefoundinEEProm:','.'));
c.Datatype=str2double(GetString(header,'DatafileTypevaluefoundinEEProm:','.'));
version1=GetString(header,'Main.hexRevision:',';BuildNum:');
version2=GetString(header,';BuildNum:',';BuildDate:');
if str2double(version2)>4014
c.BoardSN=GetString(header,'Hello,welcometoGPSBrd339/Brd357','terminal');
end

version2_modif=num2str(str2double(version2)-1);

%c.version=[version1 '.' version2_modif]; % old
c.version=[version2_modif];

catch error_c
     msgbox(['Error trying to read the header | Error msg: ' error_c.message ])
end
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%