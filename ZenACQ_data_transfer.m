function [ handles ] = ZenACQ_data_transfer( handles )
% Transfer Zen data to the define path location.
%   Zonge International Inc.
%   Created by Marc Benoit
%   Oct 10, 2014

% Initialize
EXTENSION='*.Z3D';
import java.io.*; f=File('');r=f.listRoots; % Check number of drive before UMASS
NbD_b_UMASS=numel(r);
global list_Drive_Before
list_Drive_Before=cell(numel(r),1);for i=1:numel(r);list_Drive_Before{i,1}=char(r(i));end
COM_Nb=size(findCOM,1);
status_SD=false;


% Set Zen status msg invisble
set(handles.msg_txt,'Visible','off')

% CONFIRMATION MSG FROM THE USER
choice = questdlg([handles.language.data_transfer_msg1 ' : ' handles.setting.z3d_location], ...
                   handles.language.progress_str8, ...
                   handles.language.yes,handles.language.no,handles.language.no);
if ~strcmp(choice,handles.language.yes);return;end


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% COM --> SD CARDS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

pause(1);

%% CONNECT AND LOOP UNTIL ALL THE COM PORTS HAVE DISAPPEAR FROM THE WINDOWS COM PORT LIST
while status_SD~=true

[ handles,CH1_index,status ] = connection_process( handles );  % Connect to COM ports                                  
if status==0;handles.CH1_index=CH1_index;elseif status==1;break;end % Check if connection fail.

% Convert COM to SD cards and check if COM still available in the windows COM port list
status_SD=l_SDavailable1( handles,size(handles.CHANNEL.ch_serial,2)); 

%if it fails, try to reconnect to available COM ports again else exit loop

end


% RESTART TIMER IF STOPPED (Standalone GUI issue)
ACQ_timer=timerfind('Name','ACQ_timer');
if isempty(ACQ_timer)
    A.pass=handles;
    handles.timer_start = timer('TimerFcn',@timer_ini,'BusyMode','queue','UserData'...
           ,A,'ExecutionMode','fixedRate','Period',1.0,'Name','ACQ_timer');
    start(handles.timer_start);
end


%% CHECK THAT ALL SDs APPEAR IN WINDOWS REGISTRY
l_SDavailable2( handles,NbD_b_UMASS,COM_Nb );


%% CHECK IF THE COPY FUNCTION CAN SEE ALL SD
drive=0;clock=0;
h = waitbar(0,'Please wait...');steps = 5; % WAIT an extra 5 seconds 
for step = 1:steps;pause(1);waitbar(step / steps);end 
while drive<NbD_b_UMASS
    import java.io.*;f=File('');r=f.listRoots;drive=0;
    for i=1:numel(r)   
     list=dir_fixed([char(r(i)) EXTENSION]);  % Standard Matlab dir command fails with files dated in 1980 (with the old Zen ARM file library) 
     %list=dir([char(r(i)) EXTENSION])
     if ~isempty(list) && isempty(find(cellfun(@isempty,strfind(list_Drive_Before,char(r(i))))==0, 1))
        drive=drive+1;
     end
    end
    pause(1);
    clock=clock+1;
    if clock>3;break;end
end
close(h);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% COPY DATA +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

% define z3d location variable for data_transfer
handles.path_output=handles.setting.z3d_location;

%% Transfer Data
[~,~]=data_transfert( handles,EXTENSION,list_Drive_Before );

% Set Zen status msg invisble
set(handles.msg_txt,'Visible','on','Value',1)

end

