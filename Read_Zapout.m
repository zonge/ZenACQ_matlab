function [ display_buffer ] = Read_Zapout( ch_serial,max_buf,gain,display_buffer,Week_time )

% Parameters
AVr=2.048;

% Initiate TS
TS=zeros(max_buf,2);

% CHECK AVAILABLE BYTES IN THE SERIAL BUFFER (% IF NO BYTES, WAIT FOR THEM)
LL=ch_serial.BytesAvailable; if LL==0; pause(0.05); return; end

% READ ALL AVAILABLE BYTES AS UINT8 IN THE BUFFER
buffer_uint8=uint8(fread(ch_serial,LL,'uint8'));


% READ ZAPOUT DATA
j=0;i=1;
while i<size(buffer_uint8,1)
    
    if buffer_uint8(i)==58 && i>size(buffer_uint8,1)-15
        i=size(buffer_uint8,1);
        disp('boundary')
        continue
    end
    
    if buffer_uint8(i)==58 && buffer_uint8(i+1)==45 && buffer_uint8(i+2)==79 && buffer_uint8(i+13)==59 && buffer_uint8(i+14)==45 && buffer_uint8(i+15)==41
       j=j+1;

       %date_time=double(typecast(uint8([buffer_uint8(i+12) buffer_uint8(i+11) buffer_uint8(i+10) buffer_uint8(i+9)]), 'uint32'))/1024*1000; 
       %TS(j,1)=addtodate(Week_time,round(round(date_time*1000)/1000), 'millisecond');
       
       date_time=double(typecast(uint8([buffer_uint8(i+12) buffer_uint8(i+11) buffer_uint8(i+10) buffer_uint8(i+9)]), 'uint32'))/1024*1000;
       TS(j,1)=addtodate(Week_time, round(date_time), 'millisecond');

       % adc count
       
       adc_count=double(typecast(uint8([buffer_uint8(i+8) buffer_uint8(i+7) buffer_uint8(i+6) buffer_uint8(i+5)]), 'int32'))*(AVr/(2^gain*2^31));
       if adc_count==0
           TS(j,2)=NaN;
       else
           TS(j,2)=adc_count;
       end
       i=i+15;   
   else
       i=i+1;
    end 

end

if j==0; return; end

% GENERATE DISPLAY BUFFER
if j<max_buf
    display_buffer(1:end-j,1:2)=display_buffer(j+1:end,1:2);
    display_buffer(end-j+1:end,1:2)=TS(1:j,1:2);
else
    display_buffer(1:end,1:2)=TS(end-max_buf+1:end,1:2);
end



end

