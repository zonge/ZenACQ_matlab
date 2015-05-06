function [ output_value,status,data ] = QuickSendReceive( SERIAL_obj,Command,CommandMaxWaitTime,ResultString,delim,pos1,pos2 )

    % FLUSH OUTPUT BUFFER
    LLL=SERIAL_obj.BytesAvailable;
    if LLL>0
    fread(SERIAL_obj,LLL);
    end

    % SEND COMMAND
    status=false;
    inc_send=0;
    while status~=true 
        inc_send=inc_send+1;
        pause(0.1);
        fprintf(SERIAL_obj,Command);                                                    % SEND COMMAND
    
        % CHECK FOR ANSWER
        [data,~,status] = waitln(SERIAL_obj,ResultString,Command,CommandMaxWaitTime);   % RECEIVE DATA
        
        
        % SEND ONCE AGAIN IF NO ANSWER
        if inc_send>1  % If no answer after 1 try, stop
            break;
        end 
    end  
    
    % FIND THE CORRESPONDING VALUE
    if nargin>4
        
        if nargin<=5;
            pos1=1; pos2=1;
        elseif nargin==6
            pos2=1;
        end
        output_value = GetString(data,ResultString,delim,pos1,pos2);                    % GET INTERESTED VALUE
        
        if strcmp(output_value,'NoReceivedData')
            status=false;
        end
            
    else
        
        output_value = [];
    
    end


end

