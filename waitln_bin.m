function [Query,status] = waitln_bin( SERIAL_obj,command_name )
% Get STREAMING File Binary
% Marc Benoit 3/17/2015
% Zonge International

% PARAMETER
status=true;
max_alloc_bytes=2^23;
Query=zeros(max_alloc_bytes,1);
% LOOP INITIALIZATION

loop_status=0;
start_query=1;
end_query=0;

% START LOOPING UNTIL FINDING STRING.
tic

while loop_status~=1
    
    LL=SERIAL_obj.BytesAvailable;            % GET SERIAL AVAILABLE BYTE

    if LL>0
        [query,count]=fread(SERIAL_obj,LL);   % READ AVAILABLE BYTES
        end_query=end_query+count;
        Query(start_query:end_query,1)=query; % DATA COLLECTED               
    end
    start_query=end_query+1;
    
    pause(0.1)
    
    LLL=SERIAL_obj.BytesAvailable;
    if LL==LLL && LL==0            % IF STRING MATCH QUERY
       loop_status=1;                       % STOP LOOP
    end


end

%Cut unused
Query(end_query+1:end)=[];

timing=toc;

if isempty(Query)
    Query={'EmptyQuery'};                   % NOTHING FIND, RETURN 'EmptyQuery' AS A STRING.
end

disp(['[ ' command_name ' ] command (' SERIAL_obj.Port ') :' num2str(timing) ' seconds'])

end

