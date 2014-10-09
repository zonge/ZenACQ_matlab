function [ c,status ] = connect2(SERIAL_obj)

status=0;

try
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Collect header
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
header = waitln(SERIAL_obj,'Brd339>','Read HEADER',10);

c.ChNb=str2double(GetString(header,'ChannelNumvaluefoundinEEProm:','.'));
c.BoxNb=str2double(GetString(header,'ZenBoxNumbervaluefoundinEEProm:','.'));
version1=GetString(header,'Main.hexRevision:',';BuildNum:');
version2=GetString(header,';BuildNum:',';BuildDate:');

c.version=[version1 '.' version2];

 catch error_c
     msgbox(['Error trying to read the header | Error msg: ' error_c.message ])
end
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%