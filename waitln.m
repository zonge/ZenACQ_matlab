function [data,query,status] = waitln( SERIAL_obj,string,command_name,max_user_time )
% Wait for the string to be read from the SERIAL Device and return the last
% line and every other lines before.
% Marc Benoit 8/17/2014
% Zonge International

% PARAMETER
max_time_default=60;
status=true;

% FUNCTION PARAMETER
if nargin<4; max_user_time=max_time_default; end

% LOOP INITIALIZATION
query='';
data.Query=cell(1,1);
inc=0; loop_status=0;
string(string==' ')=[];

% START LOOPING UNTIL FINDING STRING.
tic
while loop_status~=1
    
    LL=SERIAL_obj.BytesAvailable;            % GET SERIAL AVAILABLE BYTE

    if LL>0
        inc=inc+1;                            % INCREMENT ARRAY
        query=fscanf(SERIAL_obj,'%c\n',LL);   % READ AVAILABLE BYTES
        data.Query{inc,1}=query;              % DATA COLLECTED   
    end

    if strfind(query,string)>=1             % IF STRING MATCH QUERY
       loop_status=1;                       % STOP LOOP
    end
    
    if toc>max_user_time
        status=false;
        msg=msgbox(['TIMEOUT: ' command_name ' did not successed after ' ...
           num2str(max_user_time) ' seconds']);
        waitfor(msg)
        break;                              % IF THE READ TAKE MORE TIME THAN DEFINED STOP
    elseif toc>max_time_default
        status=false;
        msg=msgbox(['TIMEOUT: ' command_name ' did not successed after ' ...
           num2str(max_time_default) ' seconds']);
        waitfor(msg)
        break;                              % IF THE READ TAKE MORE TIME THAN DEFINED STOP
    end

end

% WAIT 0.02 second to get last bit on the line in case (EXTRA TIME FOR PRECAUTION)
    pause(0.02)
    LL=SERIAL_obj.BytesAvailable;            % GET SERIAL AVAILABLE BYTE

    if LL>0
        inc=inc+1;                            % INCREMENT ARRAY
        query=fscanf(SERIAL_obj,'%c\n',LL);   % READ AVAILABLE BYTES
        data.Query{inc,1}=query;              % DATA COLLECTED   
    end
    
timing=toc;

if isempty(data.Query)
    data.Query={'EmptyQuery'};                   % NOTHING FIND, RETURN 'EmptyQuery' AS A STRING.
end

if ~strcmp(command_name,'Flush') && ~strcmp(command_name,'gettime') ...
        && ~strcmp(command_name,'sync') && ~strcmp(command_name,'numsats') ...
        && ~strcmp(command_name,'TESTPWRADCS') && ~strcmp(command_name,'GETLLA')
disp(['[ ' command_name ' ] command (' SERIAL_obj.Port ') :' num2str(timing) ' seconds'])
%disp(data.Query)               % DISPLAY TERMINAL
end

end

