function [ c,SERIAL_obj,status ] = connect1(COM)

status=0;
c=channel(COM);
SERIAL_obj = serial(c.COM,'Baudrate',c.Baudrate,'InputBufferSize',c.InputBufferSize,'Terminator','LF');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Connect to SERIAL PORT
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
fopen(SERIAL_obj);
catch
    msg=msgbox([COM ' is not responding. It must be used in another program.']);
    waitfor(msg)
    c=[];
    SERIAL_obj=[];
    status=1;
    return;
end

 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%