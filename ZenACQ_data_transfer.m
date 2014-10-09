function [ handles ] = ZenACQ_data_transfer( handles )
% Transfer Zen data to the define path location.

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014


set(handles.msg_txt,'Visible','off')

warn=warndlg(['The data will copied into : ' handles.setting.z3d_location],'Data transfert');

waitfor(warn)


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


%% COPY DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.path_output=handles.setting.z3d_location;
data_transfert( handles,'*.Z3D' );

set(handles.msg_txt,'Visible','on')


end

