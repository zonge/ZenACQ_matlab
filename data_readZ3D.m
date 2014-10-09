function [TS_data,TS_time,build_software,build_hardware,Serial,channel,GPS,err,err_t,ADfreq, ...
   gain,period_divider,duty_divider,latitude,longitude,altitude,  ...
   Nbsat,GPSweek,TX,RX,CMP,STN_ANT,A_spacing,err_minus,databytes,L_TS,Box_Nb,CAL,error_status] ...
   = data_readZ3D(file,TS_start,TS_end)

%  clear all
%   clc
% % file='C140_1Z.Z3D';
% %  %file='/Users/marc/Desktop/Scripps_ZEN_#50/dataNEW/Ch5.Z3D';
%  file='C:\ZenMT\calibrate\temp\2014-09-19\02_36_marc.benoit_ZEN1\ZenRawData\ZEN1_CH4\CAL_01.Z3D';
%  TS_start=4;
%  TS_end=0;


% CLOCK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error_status=0;
Flag0=-1;
Flag1= 2147483647;                                                          %@
Flag2=-2147483648;                                                          %@
databytes=0; %maybe it need to be replace by 1536;
ADC_freq=2097152; %ADC speed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALISATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TS_data=[];
% TS_time=[];
% build_software=[];
% build_hardware=[];
% Serial=[];
% channel=[];
% GPS=[];
 err=[];
 err_t=[];
 err_minus=[];
% ADfreq=[];
% gain=[];
% period_divider=[];
% duty_divider=[];
% latitude=[];
% longitude=[];
% altitude=[];
% Nbsat=[];
% GPSweek=[];
% TX=[];
% RX=[];
% CMP=[];
% STN_ANT=[];
% A_spacing=[];

% databytes=[];
 L_TS=[];
% Box_Nb=[];
% CAL=[];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ Z3D FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Open file
fid = fopen(file);

try
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HEADER (512 bytes) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    header = fscanf(fid,'%c',512);
    HEADER=textscan(header,'%s','delimiter','\n;,&');

    build_software=str2double(parsing(HEADER{1,1},'Main.hex',':=',2));
    build_hardware=str2double(parsing(HEADER{1,1},'fpga',':=',2));
    Serial=parsing(HEADER{1,1},'ChannelSerial',':=',2);
    channel=str2double(parsing(HEADER{1,1},'channel ',':=',2));
    ADfreq=str2double(parsing(HEADER{1,1},'rate',':=',2));
    gain=log2(str2double(parsing(HEADER{1,1},'gain',':=',2)));
    period=str2double(parsing(HEADER{1,1},'period',':=',2));
    duty=str2double(parsing(HEADER{1,1},'duty',':=',2));
    latitude=str2double(parsing(HEADER{1,1},'lat',':=',2));
    longitude=str2double(parsing(HEADER{1,1},'long',':=',2));
    altitude=str2double(parsing(HEADER{1,1},'alt',':=',2));
    Nbsat=str2double(parsing(HEADER{1,1},'NumSats',':=',2));
    GPSweek=str2double(parsing(HEADER{1,1},'gpsweek',':=',2));
    Box_Nb=str2double(parsing(HEADER{1,1},'box number',':=',2));
    
    % Check if old Header version %%
    if isnan(channel)
        channel=str2double(parsing(HEADER{1,1},'channel',':=',2));
    end
    if isempty(Serial)
        Serial=parsing(HEADER{1,1},'Serial',':=',2);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    period_divider=ADC_freq/(period+1);
    duty_divider=(duty+1)*period_divider/ADC_freq*100;
    Serial=Serial(3:end);


    
    if duty_divider>100; duty_divider=100; end   % Make sure duty is don't go higher than 100 % duty
    
% CACULATE THE CALIBRATION KEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    attenuator=0;
    freq_set=0;  % Fundamental frequency
    switch ADfreq;case 256;SR=0;case 512;SR=1;case 1024;SR=2;case 2048;SR=3;case 4096;SR=4;end
    hwklookup=uint64(0);
    hwklookup=bitor(hwklookup,SR);
    hwklookup=bitor(hwklookup,bitshift(attenuator,9));
    hwklookup=bitor(hwklookup,bitshift(freq_set,18));
    hwklookup=bitor(hwklookup,bitshift(gain,22));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% METADATA & CALIBRATION (512 bytes) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 startbytes=0;  
 fseek(fid,startbytes, 'bof');
 meta = fscanf(fid,'%c',8192);
 Frec=strfind(meta, 'GPS Brd339/Brd357 Metadata Record');
 if ~isempty(Frec)
     %if METADATA
 META='';
 for i=1:length(Frec)
    content=deblank(meta(Frec(i)+34:Frec(i)+507));
    META=strcat(META, content);
 end
    
    meta2=textscan(META,'%s','delimiter','|');
    CMP = parsing(meta2{1,1},'CH.CMP',',',2);
    TX = parsing(meta2{1,1},'TX.ID',',',2);
    RX = parsing(meta2{1,1},'RX.STN',',',2);
    STN_ANT = str2double(parsing(meta2{1,1},'CH.NUMBER',',',2));
    A_spacing = str2double(parsing(meta2{1,1},'CH.VARASP',',',2));
    
% CAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

  CAL_BOARD=parsing(meta2{1,1},'CAL.SYS',',',2);
  AA=~cellfun('isempty',strfind(lower(meta2{1,1}),lower('CAL.SYS')));
  if sum(AA)~=0
    AAA=meta2{1,1}{AA,1};
    Z=textscan(AAA,'%s','delimiter',',');
    
    Z4=zeros(size(Z{1,1},1)-2,4);
        for i=3:size(Z{1,1},1)
            Z3=textscan(Z{1,1}{i,1},'%f %s %f %f','delimiter',':');
            STRING=Z3{1,2}{1,1};
            STRING1=STRING(9:16);
            STRING2=STRING(1:9);
            ID1=uint64(hex2dec(STRING1));
            Z4(i-2,1)=ID1;
            Z4(i-2,2)=Z3{1,1};
            Z4(i-2,3)=Z3{1,3};
            Z4(i-2,4)=(pi/180).*Z3{1,4}.*1000;  % phase degree --> milliradian
        end

        LOC_CAL= Z4(:,1)==hwklookup;
        CAL_TABLE=Z4(LOC_CAL,2:4);
        formatSpec = ' %f:%d:%d,';
        str = sprintf(formatSpec,CAL_TABLE(:,:)');
        CAL=['CAL.SYS,' CAL_BOARD ',' str(1:end-1)];
  else
  CAL=['CAL.SYS,' Serial ',1,0'];
  end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 else
     
 %if NO METADATA
 TX='';
 RX='';
 STN_ANT=1;
 CMP='Ex';
 A_spacing=1;
 CAL=['CAL.SYS,' Serial ',1,0'];
 
 end
 
 catch error
    msg=['data_readZ3D Could not read (error in HEADER) :' file];
    disp(error)
    errordlg(msg,'File Error');
    error_status=1;
    toc
    return
end



%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GET OPTIMAL BUFFER SIZE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic

% Get number of bytes of the file and length of the data reccord.
java_call = java.io.File(file);
bytes_size = length(java_call);
offset=mod(bytes_size,4);
LL=((bytes_size-databytes)-offset)/4;


power_size = nextpow2(LL+1)-1;

if power_size < 15
   data_block=2^12;  % 4096 bytes 
elseif power_size >= 15 && power_size < 17  
    data_block=2^13; % 8182 bytes  
elseif power_size >= 17 && power_size < 20 
   data_block=2^15;  % 32768 bytes  
elseif power_size >= 20          
   data_block=2^16;  % 65536 bytes   
end  

% Define Nb of Buffer and size of the last buffer
block_number=floor(LL/data_block);       % number of block
residual=LL-block_number*data_block;     % residual bytes
residualbytes=databytes+(LL-residual)*4; % residual bytes location

% READ DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%try

% Read buffer of data
fseek(fid,databytes+offset,'bof');
TS_data=int32(zeros(LL,1));
for i=1:block_number
    TS_data(data_block*(i-1)+1:data_block*(i),1)=fread ...
           (fid,data_block,'int32');    
end

% Read residual
fseek(fid,residualbytes+offset,'bof');
TS_data(LL-residual+1:LL,1)=fread(fid,residual,'int32');

L_TS_data=size(TS_data,1);

% Close file
fclose(fid);

% Display status %
File_clock=toc;
disp(['File loaded : ' num2str(File_clock) ' s']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ORGANIZE DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Get GPS informations  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic 
  i=0;
  
  if build_software>=2828
  
    GPS=uint32(zeros(ceil(L_TS_data/ADfreq)+16,2));
    for j=1:L_TS_data-2                                                         %@
        if TS_data(j)==Flag1 && TS_data(j+1)==Flag2                             %@
            i=i+1;                 % index increment
            GPS(i,2)=TS_data(j+2); % GPS time                                   %@
            GPS(i,1)=j;            % Flag location (FF FF FF FF)
        end  
    end
    % Get GPS size
    GPS=GPS(TS_start:i-TS_end,:);
    L_GPS=size(GPS,1);

    % Generate GPS(:,3) = GPS(i+1,1)-GPS(i,1) (points between two GPS stamps)
    GPS(1:end-1,3)=GPS(2:end,1)-GPS(1:end-1,1)-17;                              %@
    
  else
      
    GPS=uint32(zeros(ceil(L_TS_data/ADfreq)+9,2));
    for j=1:L_TS_data-1
        if TS_data(j)==Flag0
            i=i+1;                 % index increment
            GPS(i,2)=TS_data(j+1); % GPS time
            GPS(i,1)=j;            % Flag location (FF FF FF FF)
        end  
    end
  
    % Get GPS size
    GPS=GPS(TS_start:i-TS_end,:);
    L_GPS=size(GPS,1);

    % Generate GPS(:,3) = GPS(i+1,1)-GPS(i,1) (points between two GPS stamps)
    GPS(1:end-1,3)=GPS(2:end,1)-GPS(1:end-1,1)-10;

      
  end

GPS(end,3)=L_TS_data-GPS(end,1);

% Display status %
GPS_infos_clock=toc;
disp(['GPS analysed : ' num2str(GPS_infos_clock) ' s']);

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get TS (TS_time, TS_data) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
ts_clock=tic;
 
  pos=0; coef=0; week=0;
  TS_time=double(zeros(sum(GPS(1:L_GPS-1,3)+1),1));
  for i=1:L_GPS-1
    pos=pos+1;
    
    % Get GPS seconds
    GPStime_v=GPS(i,2)./1024;
    frac=(GPS(i,2)./1024-floor(GPS(i,2)./1024))*(1024/1000);
     
    % CONDITION IF WEEK CHANGE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    % If GPS second == 604800 (second in a week) then increment week
    if round(GPStime_v)==604800
    GPStime_v=0;
    week=week+1;
    coef=week*604800;
    end
   
    % If GPS second value is > 604800
    if round(GPStime_v)>604800
    GPStime_v=GPStime_v-604800;
    end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
  % Get GPS seconds
    GPS(i,2)=(floor(GPStime_v)+frac)+coef;
    
%   % Clean 0/2 second timestamp issue.  
%       if i>1 
%       if GPS(i,2)~=GPS(i-1,2)+1
%          GPS(i,2)=GPS(i-1,2)+1;
%       end
%       end
   
    % GENERATE TS_data & %  TS_time
    if build_software>=2828
        TS_data(pos:pos+GPS(i,3),1)=TS_data(GPS(i,1)+16:GPS(i+1,1)-1);          %@    
    else
        TS_data(pos:pos+GPS(i,3),1)=TS_data(GPS(i,1)+9:GPS(i+1,1)-1);   
    end

    TS_time(pos:pos+GPS(i,3),1)=double(GPS(i,2))+(1/ADfreq)* ...
                                double((0:GPS(i,3))');              
    pos=pos+GPS(i,3);
  end

    % GPS
    GPS=GPS(1:L_GPS-1,:);
    L_TS=pos;
  
% Display status %  
ts_clock=toc(ts_clock);
disp(['TS generated : ' num2str(ts_clock) ' s']);

% catch error
%     msg=['data_readZ3D Could not read (error in DATA) :' file];
%     disp(error)
%     errordlg(msg,'File Error');
%     error_status=1;
%     toc
%     return
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ERROR SUMMARY  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
try
% POINT(S) ERROR

err1=find(GPS(TS_start+1:end-TS_end,3)~=ADfreq-1);  %% Block Error (sec.)

if ~isempty(err1)
err1(:,2)=GPS(err1(:,1),2)-floor(GPS(1,2)); %% Time from start
err1(:,3)=GPS(err1(:,1),2);      %% Time (GPS)
err1(:,4)=GPS(err1(:,1),3);      %% Number(s) of points in the Error block
err1(:,5)=-((ADfreq)-err1(:,4)); %% Less/Extra points
err1(:,6)=databytes+GPS(err1(:,1),1)*4+4;
b=err1(:,5)~=-1;
err=err1(b,:);
a=(err1(:,5)==-1);               %% Add the second part if +1 is needed.
err_minus=err1(a,:);
else
err=[];
err_minus=[];
end


% TIMESTAMP ERROR

% Gps time check
delta=zeros((length(GPS)-1),1);
for i=1:length(GPS)-1
    delta(i,1)=GPS(i+1,2)-GPS(i,2);
end

% find where there is not a second between 2 bloc
% and where timestamp value is twice the same.
err_t(:,1)=unique([find(delta~=1);find(round(GPS(:,2))~=GPS(:,2),2)]);
err_t(:,2)=GPS(err_t(:,1),2);
err_t(1:end-1,3)=GPS(err_t(1:end-1,1)+1,2);
if isempty(err_t)==0
if GPS(end,2)-GPS(err_t(end,1),2)==0
err_t(end,3)=NaN;
else
err_t(end,3)=GPS(err_t(end,1)+1,2);
end
end
err_t(:,4)=err_t(:,3)-err_t(:,2);
err_t(:,5)=(err_t(:,4)-1);
err_t(:,7)=err_t(:,5)./(1/ADfreq);
err_t(:,6)=databytes+GPS(err_t(:,1),1)*4+4;

catch error
    msg=['data_readZ3D Could not read (error in ERROR ANALYSIS) :' file];
    disp(error)
    errordlg(msg,'File Error');
    error_status=1;
    toc
    return
end

% CLOCK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  total_time=toc;
  disp('------------------------');
  disp(['Elapsed total time : ' num2str(total_time) ' seconds']);
  disp('------------------------');

