function [Voltage_f,Temperature_f] = volt_temp_process( handles,CH1_index )

Command='TestPwrAdcs';
Command2='TEMPERATURE';
CHANNEL=handles.CHANNEL;

% Voltage
maxitineration=6;
progress = waitbar(0,'Please wait while measuring Voltage & Temperature...','Name','Voltage / Temperature measurement...',...
    'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);
Voltage=zeros(maxitineration,1);
Temperature=zeros(maxitineration,1);
for i=1:maxitineration

fprintf(CHANNEL.ch_serial{1,CH1_index},Command);
fprintf(CHANNEL.ch_serial{1,CH1_index},Command2);

[data,~,~] = waitln(CHANNEL.ch_serial{1,CH1_index},'W.',Command,10);
[data2,~,~] = waitln(CHANNEL.ch_serial{1,CH1_index},'oC(',Command2,10);

    % JOINING STRING TOGETHER
     d=data.Query;
     if ~isempty(d{1,1})
     s=strjoin(d');
     s(s==' ')=[];
     log = s;
     end
     i1=strfind(log,'TestPwrAdcs:')+12;
     i2=strfind(log,'Vx')-1;
     Voltage(i,1)=str2double(log(i1:i2));
     
     % JOINING STRING TOGETHER 2
     d2=data2.Query;
     if ~isempty(d2{1,1})
     s2=strjoin(d2');
     s2(s2==' ')=[];
     log2 = s2;
     end
     i1_2=strfind(log2,'Temperature:currently')+21;
     i2_2=strfind(log2,'oC')-1;
     Temperature(i,1)=str2double(log2(i1_2:i2_2));
     
        pourcentage=[sprintf('%0.2f',(i/maxitineration)*100) ' %'];
        waitbar((i/maxitineration),progress,sprintf('%s',pourcentage));
end
close(progress)

c.Voltage=mean(Voltage);
c.Temperature=mean(Temperature);
a=[0,0.25,0.5,0.75,1];frac = mod(c.Voltage,1);[~,I] = min(abs(frac-a));frac = a(I);
Voltage_f=num2str(floor(c.Voltage)+frac);
frac2 = mod(c.Temperature,1);[~,I2] = min(abs(frac2-a));frac2 = a(I2);
Temperature_f=num2str(floor(c.Temperature)+frac2);


end

