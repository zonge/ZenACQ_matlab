function  handles = ZenRX_Cres( handles )
% Calculate and display CRES

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

open_CRES=130000;  % ohm
Good_CRES=20000;  % ohm

progress = waitbar(0,'Retrieving CRES ...','Name','Contact Resistance' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

tbl_content=get(handles.geometry_table,'data');
DATA=get(handles.geometry_table,'Data');

% Find number of channel used.
inc=0;
for i=1:size(handles.CHANNEL.ch_serial,2)   
     if ~strcmp(DATA{i,1},'Off')
        inc=inc+1;
     end
end

% CRES
j=0;
for i=1:size(handles.CHANNEL.ch_serial,2)

     if strcmp(DATA{i,1},'Off')
        tbl_content{i,10}='';
        continue;
     else
         j=j+1;
     end
     
     switch i
         case 1
             channel_hex='01';
         case 2
             channel_hex='02';
         case 3
             channel_hex='04';
         case 4
             channel_hex='08';
         case 5
             channel_hex='10';
         case 6
             channel_hex='20';
     end

     
     % CRES channel
     QuickSendReceive(handles.CHANNEL.ch_serial{handles.CH1_index},['calchannels 0x' channel_hex],10,'maskiscurrentlysetto:0x','.');
     

     % CONTACT RESISTANCE
     Contact_RES_str=QuickSendReceive(handles.CHANNEL.ch_serial{handles.CH1_index},'CONTACTRESISTANCE',10,'CRES(ROut):',0);

     CRES_value=round(str2double(Contact_RES_str(12:end)));
     
     if CRES_value>open_CRES
        tbl_content{i,10}=['<html><body text="#FF0000" align="center" width="60px"><b>' sprintf('%0.2f',CRES_value/1000)];
     elseif CRES_value<Good_CRES
        tbl_content{i,10}=['<html><body text="#00CC00" align="center" width="60px"><b>' sprintf('%0.2f',CRES_value/1000)];
     else
        tbl_content{i,10}=['<html><body text="#FF9933" align="center" width="60px"><b>' sprintf('%0.2f',CRES_value/1000)];
     end
   
     handles.CRES_values{i}=tbl_content{i,10};

     pourcentage=[sprintf('%0.2f',(j/inc)*100) ' %'];
     waitbar(j/inc,progress,sprintf('%s',pourcentage)); 
end


close(progress);
set(handles.geometry_table,'data',tbl_content)

end