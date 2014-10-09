function [ DATA ] = data_upload(path_main,handles)


TS_start=4;    % 4 : start second from the start (start = +1 )
TS_end=0;      % 2 : second from the end (end = 0)

% CLOCK
ticID=tic;

%% Get all files in subdirectories %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test=-2;
while test~=0

[files,paths,names,test,nbfiles]=data_valid(path_main,TS_start,handles); %% Call data_valid function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% STOP if files are too small (test>0)
if test==-1
    DATA=signal('reload','reload', ...
      0,0, ... 
      0,0,0,[],[],0,0,0,0,1,0,0,0, ...
      0,0,0,0,0,0, ...
      0,0,0,0,0,0,0,0,[]);
    return
end
end

[sches, chans]=size(files);
    
%%%%%% Bar process 1/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        progress = waitbar(0,'Please wait while processing...', ...
        'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
         handles.main.GUI.width_bar handles.main.GUI.height_bar]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GET Time series and load them into object %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=0;
chan_test=chans;
for sche_num=1:sches

%%%%%%%%%%%%%%%%%%% Check number of files per schedule %%%%%%%%%%%%%%
    chan_verif=0;
    for chan_num=1:chan_test
       if ~isempty(files{sche_num,chan_num})
           chan_verif=chan_verif+1;
       end
    end 
    chans=chan_verif;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
k=0;
for chan_num=1:chans
    j=j+1;
     
    disp(files{sche_num,chan_num});

    [TS_data,TS_time,build_software,build_hardware,Serial,channel,GPS,err,err_t,ADfreq, ...
    gain,period_divider,duty_divider,latitude,longitude,altitude,  ...
    Nbsat,GPSweek,TX,RX,CMP,STN_ANT,A_spacing,err_minus,databytes,L_TS,Box_id,CAL,error_status] ... 
    =data_readZ3D(files{sche_num,chan_num},TS_start,TS_end);

    if error_status==0
    k=k+1;
    DATA(sche_num,k)=signal(names{sche_num,chan_num},paths{sche_num,chan_num}, ...
      TS_data(1:L_TS),TS_time, ... 
      TS_time(1),TS_time(end),GPS(:,2),err,err_t,ADfreq,gain,0,0,channel,GPSweek,Nbsat,latitude, ...
      longitude,altitude,period_divider,duty_divider,databytes,GPS(:,1), ...
      build_software,build_hardware,Serial,TX,RX,CMP,STN_ANT,A_spacing,err_minus,Box_id,CAL);
  
    clear TS_data TS_time GPS;
        
    end
   
%%%%%%% Bar process 2/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        pourcentage=[sprintf('%0.2f',(j/nbfiles)*100) ' %'];
        waitbar((j/(nbfiles)),progress,sprintf('%s',pourcentage));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% Bar process 3/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close(progress);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% CLOCK
toc(ticID);

end