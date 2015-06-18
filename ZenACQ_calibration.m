function [ handles ] = ZenACQ_calibration( handles )
% Calibrate the box
 
% Zonge International Inc.
% Created by Marc Benoit
% March 24, 2015
 
% CONFIRMATION
choice = questdlg({'You are about to start a calibration.';'';'Make sure all outputs are open !!';'';'Please select the type of calibration'} , ...
'System Calibration', ...
'Internal','External','Cancel','Internal');


if strcmp(choice,'Internal')
    cal_type='ff';
    cal_name='ISys';
elseif strcmp(choice,'External')
    cal_type='00';
    cal_name='ESys';
else
    return;
end

set(handles.msg_txt,'Visible','off')

%% CONNECT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ handles,CH1_index,status ] = connection_process( handles );

if status==0;handles.CH1_index=CH1_index;else return;end


%% GET VOLTAGE / TEMPERATURE
try
    [Voltage,Temperature]=volt_temp_process(handles,CH1_index);
catch
    Voltage='0';
    Temperature='0';
end

%% CLEAR METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

progress = waitbar(0,handles.language.progress_str1,'Name',handles.language.progress_title4 ...
,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

for ch=1:size(handles.CHANNEL.ch_serial,2)
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},'metadata clear',10,'WroteNumMetaDataRecords(0x',')'); 
end 

close(progress)


% WAIT FOR SYNC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progress = waitbar(0,handles.language.progress_str7,'Name',handles.language.progress_title4 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

sync=0;
error_val=0;
loop_status=true;
data=regexprep(char(num2str(ones(1,size(handles.CHANNEL.ch_serial,2)))),'[^\w'']',''); data=strrep(data, '1', '-');
while sync<1
    numsat=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'numsats',10,'Lastpacketshowed','sattelites.');
    for ch=1:size(handles.CHANNEL.ch_serial,2)
        [data_raw,status]=QuickSendReceive(handles.CHANNEL.ch_serial{ch},'sync',10,'Synced:',0);
        if status==2
            error_val=error_val+1;
            if error_val>3    
                errordlg(handles.language.sync_err1,handles.language.progress_title4);
                close(progress)
                loop_status=false;
                break;
            end
        end
            data_raw(end:end);
            data(handles.CHANNEL.ch_info{1,ch}.ChNb)=data_raw(end:end);
            
    end

    if isempty(strfind(data,'N'));sync=1; end
    waitbar(1,progress,[handles.language.sync_err2 ' : ' data ' | ' handles.language.sync_err3 ' : ' numsat]);
    pause(3)
end

close(progress);

if loop_status==false
    return;
end


% GET TIME FOR START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

define_process_time=15;
timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'gettime',10,'LastTime&DatefromGPSwas:','(');
time_GPS_dec=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS');  
time_GPS_dec=time_GPS_dec+define_process_time/86400;
start_time=datestr(time_GPS_dec,'yyyy-mm-dd,HH:MM:SS');

% SET CALIBRATOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%CAL voltage
QuickSendReceive(handles.CHANNEL.ch_serial{CH1_index},'calvoltage 0.5',10,'Voltageto:',';');
    
%CAL channel
QuickSendReceive(handles.CHANNEL.ch_serial{CH1_index},['calchannels 0x' cal_type],10,'maskiscurrentlysetto:0x','.');


%% COLLECT CALLIBRATION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 timerVal = tic;
 DUTY= 100;
 FREQ=  [0.5,1,2,4,8,1,2,4,8,16,32];
 SR=    [0,0,0,0,0,2,2,2,2,2,2];
 gain=  [0,0,0,0,0,0,0,0,0,0,0];
 cycle= [4,8,8,16,32,6,6,12,24,48,96];
 run_for=ceil((1./FREQ).*cycle+(1./FREQ)+6);
 time_between_files=3;
 letters={'_LCAL','_LCAL','_LCAL','_LCAL','_LCAL','_MCAL','_MCAL','_MCAL','_MCAL','_MCAL','_MCAL'}; 

 % RUN CALIBRATION ACQUISTION
 [run_in]=l_run_schedule(start_time,false,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,30);
 run_in=run_in+define_process_time-ceil(toc(timerVal))+2+50;
 
 %WAIT FOR END OF ACQUISITION
 progress = waitbar(0,handles.language.progress_title4,'Name',handles.language.progress_title4 ...
 ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
 handles.main.GUI.width_bar handles.main.GUI.height_bar]);   
 set(progress, 'WindowStyle','modal', 'CloseRequestFcn','');
    
 for i=1:run_in
    
    pause(1)
    pourcentage=[sprintf('%0.2f',(i/run_in)*100) ' %'];
    waitbar(i/run_in,progress,sprintf('%s',[handles.language.calibration_msg1 ' :' pourcentage]));

 end
 delete(progress)


%% COLLECT CALLIBRATION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'gettime',10,'LastTime&DatefromGPSwas:','(');
time_GPS_dec=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS');  
time_GPS_dec=time_GPS_dec+define_process_time/86400;
start_time=datestr(time_GPS_dec,'yyyy-mm-dd,HH:MM:SS');


timerVal = tic;
FREQ=[1,2,4,8,16,32,64,128];
DUTY=100;
SR=[4,4,4,4,4,4,4,4];
gain=[0,0,0,0,0,0,0,0];
cycle=[8,10,24,32,64,128,192,384];
run_for=ceil((1./FREQ).*cycle+(1./FREQ)+4);
time_between_files=3;
letters='_HCAL';

    
% RUN CALIBRATION ACQUISTION
[run_in]=l_run_schedule(start_time,false,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,25);
run_in=run_in+define_process_time-ceil(toc(timerVal))+2;


%% WAIT FOR END OF ACQUISITION

    progress = waitbar(0,handles.language.progress_title4,'Name',handles.language.progress_title4 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   
    set(progress, 'WindowStyle','modal', 'CloseRequestFcn','');
    
for i=1:run_in
    
    pause(1)
    pourcentage=[sprintf('%0.2f',(i/run_in)*100) ' %'];
    waitbar(i/run_in,progress,sprintf('%s',[handles.language.calibration_msg1 ' :' pourcentage]));

end
delete(progress)

%% STOP CALIBRATOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%CAL voltage
QuickSendReceive(handles.CHANNEL.ch_serial{CH1_index},'calvoltage 0',10,'Voltageto:',';');

%CAL channel
QuickSendReceive(handles.CHANNEL.ch_serial{CH1_index},'calchannels 0x00',10,'maskiscurrentlysetto:0x','.');


%% STREAM FILE
[ dir_path ] = stream_file( handles );
                    
% DELETE SERIAL OBJ
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);end

%% ANALYSE CALIBRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dir_path='C:\Users\Marc.Benoit\Documents\MATLAB\ZenACQ\calibrate\brd_temp\2015-05-29\11_37_Marc.Benoit_ZEN1';

error=false;
DATA=data_upload(dir_path,handles);
max_chn=size(DATA,2);
max_sch=size(DATA,1);

for sch=1:max_sch
    
    ADfreq=DATA(sch,1).ADfreq;
    Tx_freq=DATA(sch,1).period_divider;
    
    if ADfreq==256
            nb_stack=[1.5625E-2,2;3.1250E-2,2;6.2500E-2,2;0.125,4;0.25,3;
                0.5,3;1,6;2,6;4,10;8,20;16,16;32,32;64,32;];    
    elseif ADfreq==1024
            nb_stack=[1.5625E-2,2;3.1250E-2,2;6.2500E-2,2; 0.125,4;0.25,3;
                0.5,6;1,4;2,4;4,8;8,16;16,32;32,64]; 
    elseif ADfreq==4096
            nb_stack=[0.125,3;0.25,3;0.5,6;1,4;2,3;4,10;8,12;16,26;
                32,52;64,54;128,118];      
    end
    
    stacks=nb_stack(nb_stack(:,1)==Tx_freq,2);
    Tx_period=1/Tx_freq;
    pts_stack=ADfreq*Tx_period;

 
% CHECK SIZE OF TIMESERIE
offset=32;
min_length=(pts_stack)+(stacks*pts_stack)+offset;

disp(['Freq:' num2str(Tx_freq) ' , ADfreq:' num2str(ADfreq) ' | minLL:' num2str(min_length) ' | ' num2str(size(DATA(sch,1).ts_data,1))]);

 for chn=1:max_chn    
    if size(DATA(sch,chn).ts_data,1)<min_length
        disp(['TS is to short. Sch : ' num2str(sch)])
        error=true;
        break;
    end
 end
 
if error==true;
    %stacks=stacks-1;
    continue;
end

% ARRAY TSs
clear TS ts_t
TS=zeros(pts_stack,chn);
 for chn=1:max_chn
    MOD=Tx_period-mod(DATA(sch,chn).ts_time(1),Tx_period);
    ts=DATA(sch,chn).ts_data(MOD*ADfreq+1+offset:(MOD*ADfreq)+(stacks*pts_stack)+offset,1);
    
    % STACK, FOLDED, RECTIFIED
    TSs=zeros(pts_stack,1);
    for i=1:stacks
        TSs=TSs+double(ts(i*pts_stack-pts_stack+1:i*pts_stack));
    end
    TSs(1:pts_stack/2)=(TSs(1:pts_stack/2)-TSs(pts_stack/2+1:end))/stacks/2;
    TSs(pts_stack/2+1:end)=-TSs(1:pts_stack/2);
    
    %CREATE ARRAYS OF TSs
    TS(:,chn)=data_volts(TSs,DATA(sch,chn).gain);
    
 end 
   
 % CALCULATE MAG AND PHASE
  for chn=1:max_chn
 
    [MAG,f,~,PHASE]=func_fft(TS(:,chn),DATA(sch,chn).ADfreq);
    DATA(sch,chn).MAG_PHASE = find_at_freq( DATA(sch,chn).MAG_PHASE,...
                           DATA(sch,chn).period_divider,f,MAG,PHASE );
 
  end
 
  figure(sch)
  subplot(3,1,1)
  plot(TS) 
  ylabel('Voltage (V)')
  xlabel('Points')
  title(['ADC freq: ' num2str(ADfreq) ' | Tx freq :' num2str(Tx_freq)])
  subplot(3,1,2)
  semilogx(f,PHASE)
  ylabel('Phase (mrad)')
  xlabel('Freq (hz)')
  subplot(3,1,3)
  semilogx(f,MAG)
  ylabel('Voltage (V)')
  xlabel('Freq (hz)')
  
   % CHECK if MAG is in the right order of magnitude
   for chn=1:max_chn             
    if DATA(sch, chn).MAG_PHASE.mag(1,1)>1.1 || DATA(sch, chn).MAG_PHASE.mag(1,1)<0.8
          
    choice = questdlg(['Freq:' num2str(DATA(sch, chn).period_divider) ' Ch:' num2str(chn) ' - Magnitude value is not in the expected order. Make sure nothing is plug to the inputs, and try again. Ratio=' num2str(DATA(sch, chn).MAG_PHASE.mag(1,1)) '. It should be close to 1.'], ...
	'Warning Calibration', ...
	'Continue','Abord','Continue');

    if strcmp(choice,'Abord');return;end
    end
   end
  
  pause(1)
  saveas(figure(sch),[fileparts(dir_path) filesep 'cal' num2str(sch)], 'jpg')
  close(figure(sch))
end


%% SAVE CALIBRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time=now;
if ~exist('calibrate','dir');mkdir('calibrate');end
file_name=['calibrate/zen' num2str(DATA(1,1).Box_id) '.cal'];

fid = fopen(file_name,'w');

line1='$GDP.TYPE,Zen';
line2='$GDP.PROGVER,ZenACQ';
line3=['$GDP.DATE,' datestr(time,'mm/dd/yyyy')];
line4=['$GDP.TIME,' datestr(time,'HH:MM:SS')];
line5=['$GDP.BAT,' Voltage];
line6=['$GDP.TEMP,' Temperature];
line8=['$GDP.SIGSOURCE,' cal_name];
line9='$GDP.CALVOLTS,1.000';
line10='$CAL.VER,025';
line11='$CAL.LABEL,CARDSNX,HDWKEY,CALFREQ,ADFREQ,G0,ATTEN,MAG1,PHASE1,MAG3,PHASE3,MAG5,PHASE5,MAG7,PHASE7,MAG9,PHASE9';
line12='$CAL.HARMONICS,13579';

fprintf(fid,'%s\n',line1);
fprintf(fid,'%s\n',line2);
fprintf(fid,'%s\n',line3);
fprintf(fid,'%s\n',line4);
fprintf(fid,'%s\n',line5);
fprintf(fid,'%s\n',line6);
fprintf(fid,'%s\n',line8);
fprintf(fid,'%s\n',line9);
fprintf(fid,'%s\n',line10);
fprintf(fid,'%s\n',line11);
fprintf(fid,'%s\n',line12);

for freq=1:max_sch
    for chn=1:max_chn
        fprintf(fid,'%s ',DATA(freq,chn).Serial);
        if DATA(freq,chn).ADfreq==256
            fprintf(fid,'%s  ','00000000');
        elseif DATA(freq,chn).ADfreq==1024
            fprintf(fid,'%s  ','00000002');
        elseif DATA(freq,chn).ADfreq==4096
            fprintf(fid,'%s  ','00000004');
        end
        fprintf(fid,'%f\t',DATA(freq,chn).period_divider);
        fprintf(fid,'%f\t',DATA(freq,chn).ADfreq);
        fprintf(fid,'%d ',DATA(freq,chn).gain);
        fprintf(fid,'%d\t',0);
        for harmonic=1:size(DATA(freq,chn).MAG_PHASE.mag,1)
        fprintf(fid,'%f ',DATA(freq,chn).MAG_PHASE.mag(harmonic));
        fprintf(fid,'%f\t',DATA(freq,chn).MAG_PHASE.phase(harmonic));
        end
        fprintf(fid,'%s\n','');
        
    end

end

fclose(fid);

% keep a copy in the temp file
copyfile(file_name,fileparts(dir_path));


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.msg_txt,'Visible','on')

h = msgbox('Calibration Completed','Calibration');
uiwait(h);


end

