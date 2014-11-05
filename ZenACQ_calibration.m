function [ handles ] = ZenACQ_calibration( handles )
% Calibrate the box

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

set(handles.msg_txt,'Visible','off')

%% CONNECT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ handles,CH1_index,status ] = connection_process( handles );

if status==0;handles.CH1_index=CH1_index;else return;end

%% SET MUX | CLEAR METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

progress = waitbar(0,handles.language.progress_str1,'Name',handles.language.progress_title4 ...
,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

for ch=1:size(handles.CHANNEL.ch_serial,2)
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},'metadata clear',10,'WroteNumMetaDataRecords(0x',')');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},['adcmux ' num2str(1)],10,'MuxRegisteriscurrently:0x',0);  
end 

close(progress)

%% WAIT FOR SYNC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    progress = waitbar(0,handles.language.progress_str7,'Name',handles.language.progress_title4 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

sync=0;
error_val=0;
loop_status=true;
data=char(zeros(1,size(handles.CHANNEL.ch_serial,2)));
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
            data(ch)=data_raw(end:end);
    end

    if isempty(strfind(data,'N'));sync=1; end
    waitbar(1,progress,sprintf('%s',[handles.language.sync_err2 ' : ' data ' | ' handles.language.sync_err3 ' : ' numsat]));
    pause(3)
end

close(progress);

if loop_status==false
    return;
end


%% GET TIME FOR START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

define_process_time=15;
timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'gettime',10,'LastTime&DatefromGPSwas:','(');
time_GPS_dec=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS');  
time_GPS_dec=time_GPS_dec+define_process_time/86400;
start_time=datestr(time_GPS_dec,'yyyy-mm-dd,HH:MM:SS');

%% SET CALIBRATOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CAL voltage
QuickSendReceive(handles.CHANNEL.ch_serial{CH1_index},'calvoltage 0.5',10,'Voltageto:',';');
    
% CAL channel
QuickSendReceive(handles.CHANNEL.ch_serial{CH1_index},'calchannels 0xff',10,'maskiscurrentlysetto:0x','.');


%% COLLECT CALLIBRATION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timerVal = tic;
%FREQ=[1.5625E-2,3.1250E-2,6.2500E-2,0.125,0.25,0.5,1,2,4,8,16,32,64];
FREQ=[0.5,1,2,4,8];
DUTY=100;
SR=[0,0,0,0,0];
gain=[0,0,0,0,0];
%cycle=[2,2,2,4,4,8,8,16,32,64,128,256,512];
cycle=[4,8,8,16,32];
run_for=ceil((1./FREQ).*cycle+(1./FREQ)+6);
time_between_files=3;
letters='_LCAL';

% RUN CALIBRATION ACQUISTION
[run_in]=l_run_schedule(start_time,false,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,0);
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

%% GET TIME FOR START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'gettime',10,'LastTime&DatefromGPSwas:','(');
time_GPS_dec=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS');  
time_GPS_dec=time_GPS_dec+define_process_time/86400;
start_time=datestr(time_GPS_dec,'yyyy-mm-dd,HH:MM:SS');

%% COLLECT CALLIBRATION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timerVal = tic;
FREQ=[1,2,4,8,16,32];
DUTY=100;
SR=[2,2,2,2,2,2];
gain=[0,0,0,0,0,0];
cycle=[8,8,16,32,64,128];
run_for=ceil((1./FREQ).*cycle+(1./FREQ)+6);
time_between_files=3;
letters='_MCAL';
    
% RUN CALIBRATION ACQUISTION
[run_in]=l_run_schedule(start_time,false,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,0);
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

%% GET TIME FOR START %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


timeGPS=QuickSendReceive(handles.CHANNEL.ch_serial{1,1},'gettime',10,'LastTime&DatefromGPSwas:','(');
time_GPS_dec=datenum(timeGPS,'yyyy-mm-dd,HH:MM:SS');  
time_GPS_dec=time_GPS_dec+define_process_time/86400;
start_time=datestr(time_GPS_dec,'yyyy-mm-dd,HH:MM:SS');


%% COLLECT CALLIBRATION 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timerVal = tic;
FREQ=[1,2,4,8,16,32,64,128];
DUTY=100;
SR=[4,4,4,4,4,4,4,4];
gain=[0,0,0,0,0,0,0,0];
cycle=[8,16,32,64,64,128,256,512];
run_for=ceil((1./FREQ).*cycle+(1./FREQ)+4);
time_between_files=3;
letters='_HCAL';

    
% RUN CALIBRATION ACQUISTION
[run_in]=l_run_schedule(start_time,false,letters,handles,FREQ,DUTY,SR,gain,run_for,time_between_files,0);
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

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);end
pause(3)

%% SAVE DATA

% TURN COM PORTS into SD cards


%% CONNECT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check number of drive before UMASS
import java.io.*;
f=File('');
r=f.listRoots;
NbD_b_UMASS=numel(r);
pause(1)
COM_Nb=size(findCOM,1);
status_SD=false;

while status_SD~=true

[ handles,CH1_index,status ] = connection_process( handles );
if status==1;break;end
if status==0;handles.CH1_index=CH1_index;else return;end

% TURN COM PORTS into SD cards
status_SD=l_SDavailable1( handles,size(handles.CHANNEL.ch_serial,2) );

end

% Restart timer if stop (GUI issue)
ACQ_timer=timerfind('Name','ACQ_timer');
if isempty(ACQ_timer)
    A.pass=handles;
    handles.timer_start = timer('TimerFcn',@timer_ini,'BusyMode','queue','UserData'...
                                  ,A,'ExecutionMode','fixedRate','Period',1.0,'Name','ACQ_timer');
    start(handles.timer_start);
end

% CHECK THAT ALL SDs APPEARED
l_SDavailable2( handles,NbD_b_UMASS,COM_Nb );

pause(2)
%% Copy files
        EXT='*CAL.Z3D';
        folder=['calibrate' filesep 'temp'];
        if ~exist(folder,'dir');mkdir(folder);end
        dir_path=copy_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
            handles.main.GUI.width_bar,handles.main.GUI.height_bar,folder,EXT);
        if strcmp(dir_path,'empty')
            warndlg('No z3D files found','Copy Z3Ds')
            return;
        end
        
% Delete file
         delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
                        handles.main.GUI.width_bar,handles.main.GUI.height_bar,'*.Z3D')   

%% DELETE SERIAL OBJ
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);end

%% ANALYSE CALIBRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dir_path='C:\ZenACQ_matlab\calibrate\temp\2014-11-02\14_05_marc.benoit_ZEN1\ZenRawData';

error=false;
DATA=data_upload(dir_path,handles);
max_chn=size(DATA,2);
max_sch=size(DATA,1);

for sch=1:max_sch
    
    
    ADfreq=DATA(sch,1).ADfreq;
    Tx_freq=DATA(sch,1).period_divider;
    
    if ADfreq==256
        switch Tx_freq
            case 1.5625E-2
                stacks=2;
            case 3.1250E-2
                stacks=2;
            case 6.2500E-2
                stacks=2;
            case 0.125
                stacks=4;
            case 0.25
                stacks=3;
            case 0.5
                stacks=3;
            case 1
                stacks=6;
            case 2
                stacks=6;
            case 4
                stacks=6;
            case 8
                stacks=16;      
            case 16
                stacks=16;   
            case 32
                stacks=32;      
            case 64
                stacks=32;
        end
        
    elseif ADfreq==1024
        switch Tx_freq
            case 1.5625E-2
                stacks=2;
            case 3.1250E-2
                stacks=2;
            case 6.2500E-2
                stacks=2;
            case 0.125
                stacks=4;
            case 0.25
                stacks=3;
            case 0.5
                stacks=6;
            case 1
                stacks=6;
            case 2
                stacks=6;
            case 4
                stacks=14;
            case 8
                stacks=16;      
            case 16
                stacks=16;   
            case 32
                stacks=16;      
            case 64
                stacks=16;
        end
        
    elseif ADfreq==4096
        switch Tx_freq
            case 0.125
                stacks=3;
            case 0.25
                stacks=3;
            case 0.5
                stacks=6;
            case 1
                stacks=2;
            case 2
                stacks=8;
            case 4
                stacks=16;
            case 8
                stacks=16;      
            case 16
                stacks=16;   
            case 32
                stacks=16;      
            case 64
                stacks=16;
            case 128
                stacks=128;
            case 256
                stacks=128;
            case 512
                stacks=512;
            case 1024
                stacks=1024;
        end        
        
    end
    
    Tx_period=1/Tx_freq;
    pts_stack=ADfreq*Tx_period;
    
 
% CHECK SIZE OF TIMESERIE
%offset=3/4*pts_stack+32;
offset=32;
min_length=(Tx_period*ADfreq)+(stacks*pts_stack)+offset;

 for chn=1:max_chn    
    if size(DATA(sch,chn).ts_data,1)<min_length
        disp(['TS is to short. Sch : ' num2str(sch)])
        error=true;
        break;
    end
 end
 
if error==true;
    stacks=stacks-1;
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
 
  figure(5+sch)
  subplot(3,1,1)
  plot(TS)  
  title(['ADC freq: ' num2str(ADfreq) ' | Tx freq :' num2str(Tx_freq)])
  subplot(3,1,2)
  semilogx(f,PHASE)
  subplot(3,1,3)
  semilogx(f,MAG)
  pause(0.8)
  saveas(figure(5+sch),['calibrate/fig' num2str(5+sch)], 'jpg')
  close(figure(5+sch))
end


% % %% SAVE CALIBRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %load('DATA.mat')
time=now;
if ~exist('calibrate','dir');mkdir('calibrate');end
file_name=['calibrate/ZEN' num2str(DATA(1,1).Box_id) '.cal'];
fid = fopen(file_name,'w');



line1='$GDP.TYPE,Zen';
line2='$GDP.PROGVER,ZenACQ';
line3=['$GDP.DATE,' datestr(time,'mm/dd/yyyy')];
line4=['$GDP.TIME,' datestr(time,'HH:MM:SS')];
line5='$GDP.BAT,12.6';
line6='$GDP.TEMP,33.25';
line8='$GDP.SIGSOURCE,ISys';
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


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.msg_txt,'Visible','on')


end

