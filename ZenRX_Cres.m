function  handles = ZenRX_Cres( handles )
% Calculate and display CRES

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

progress = waitbar(0,'Retrieving CRES ...','Name','Contact Resistance' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

tbl_content=get(handles.geometry_table,'data');

for i=1:size(handles.CHANNEL.ch_serial,2)   
     QuickSendReceive(handles.CHANNEL.ch_serial{1,i},'CONTACTRESISTANCE',10,'atten mask:',0); 
end

for i=1:size(handles.CHANNEL.ch_serial,2) 
     Contact_res_content = waitln(handles.CHANNEL.ch_serial{1,i},'Brd339>','Read Contact Resistance',10);
     Contact_RES_str=GetString(Contact_res_content,'CRES(ROut):','ContactResistanceCommand:Complete.'); 
     tbl_content{i,4}=num2str(round(str2double(Contact_RES_str)));
      
     pourcentage=[sprintf('%0.2f',(i/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
     waitbar(i/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',pourcentage));      
end

close(progress)
set(handles.geometry_table,'data',tbl_content)

end