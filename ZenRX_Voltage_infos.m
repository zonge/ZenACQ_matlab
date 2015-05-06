function  handles = ZenRX_Voltage_infos( handles )
% Calculate and display Max Voltage and SP.

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014


progress = waitbar(0,'Retrieving CRES ...','Name','Contact Resistance' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

tbl_content=get(handles.geometry_table,'data');
DATA=get(handles.geometry_table,'Data');
ch_num=get(handles.geometry_table,'RowName');

% Find number of channel used.
inc=0;
for i=1:size(handles.CHANNEL.ch_serial,2)   
     if ~strcmp(DATA{i,1},'Off')
        inc=inc+1;
     end
end


% Voltage infos
j=0;
for i=1:size(handles.CHANNEL.ch_serial,2)
    
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,i}.ChNb));
     
     if strcmp(DATA{index,1},'Off')
        tbl_content{index,8}='';
        tbl_content{index,9}='';
        continue;
     else
         j=j+1;
     end
     
     
     %SP & Max Voltage
     sp_maxV.Query=QuickSendReceive(handles.CHANNEL.ch_serial{i},'selfpotentialandmax',10,'SelfPotentialAndMax:Last',0);
     sp = str2double(GetString(sp_maxV,'LastSP:','V('));
     max_volt= str2double(GetString(sp_maxV,'Maxreading:','V('));
                    
     sp_formatted=['<html><body text="#000000" align="center" width="50px"><b>' sprintf('%0.0f',sp*1000)];
     max_volt_formatted=['<html><body text="#000000" align="center" width="60px"><b>' sprintf('%0.0f',max_volt*1000)];
     
     tbl_content{index,8}=sp_formatted;
     tbl_content{index,9}=max_volt_formatted;
     
     handles.SP{index}=tbl_content{index,8};
     handles.MaxV{index}=tbl_content{index,9};

     
     pourcentage=[sprintf('%0.2f',(j/inc)*100) ' %'];
     waitbar(j/inc,progress,sprintf('%s',pourcentage)); 
end


close(progress);
set(handles.geometry_table,'data',tbl_content)

end