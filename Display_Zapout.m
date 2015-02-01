function [] = Display_Zapout( handles,selected_ch,Week_time )

% Clear figure content


% PARAMETER
max_buf=handles.max_buf;
ch_serial=handles.CHANNEL.ch_serial;
nb_of_channel=size(selected_ch,2);


% GET CH number.
ChNb=zeros(1,size(handles.CHANNEL.ch_info,2));
for i=1:size(handles.CHANNEL.ch_info,2)
     ChNb(i)=handles.CHANNEL.ch_info{1,i}.ChNb;
end

% MEMORY ALLOCATION & PLOT INITIALIZATION
TS_buffer=zeros(max_buf,2,nb_of_channel);

% FFT
f = 256/2*linspace(0,1,max_buf/2+1)';
axes(handles.FFT_plot);
cla;
FFT_buffer=zeros(max_buf/2+1,1,nb_of_channel);
for ch=1:nb_of_channel
    index=ChNb==selected_ch(ch);
    FFTh(ch)=loglog(f,FFT_buffer(:,1,ch),'-.','Color',handles.color(ChNb(index),:));
    hold on
end
xlabel('Frequency (Hz)')
ylabel('Voltage (V)')
grid on
grid minor
ylim([10^-8  2])

% TS
axes(handles.TS_plot);
cla;
for ch=1:nb_of_channel
    index=ChNb==selected_ch(ch);
    TSh(ch)=plot(TS_buffer(:,2,ch),TS_buffer(:,1,ch),'-','Color',handles.color(ChNb(index),:));
    hold on
end
xlabel('Time (s)')
ylabel('Voltage (V)')
grid on
grid minor



% CLEAR BUFFER
for ch=1:nb_of_channel
serial=ChNb==selected_ch(ch); 
LL=ch_serial{serial}.BytesAvailable;
if LL>0
fread(ch_serial{serial},LL,'int8');   % READ AVAILABLE BYTES
end
end

% REFRESH CHANNEL DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while (get(handles.togglebutton,'value'))% WHILE STOP BY USER
    pause(0.1)
% READ ZEN BUFFER
    for ch=1:nb_of_channel
        serial=ChNb==selected_ch(ch); 
        % TS
        TS_buffer(:,:,ch) = Read_Zapout( ch_serial{serial},max_buf,0,TS_buffer(:,:,ch),Week_time);
        
        % FFT
        FFT_buffer(:,1,ch) = func_fft_quick(TS_buffer(:,2,ch),f);
        
        % DISPLAY 
        try
            min_val=find(TS_buffer(:,1,ch)==0); if isempty(min_val); min_val=1; end
        
            % REFRESH AXIS
            set(FFTh(ch),'XData',f(1:end),'YData',FFT_buffer(1:end,1,ch));
            set(TSh(ch),'XData',TS_buffer(min_val(end)+1:end,1,ch),'YData',TS_buffer(min_val(end)+1:end,2,ch));
            datetick(handles.TS_plot,'x','HH:MM:SS');
        catch 
            
        end
        

    end
    
    

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end

