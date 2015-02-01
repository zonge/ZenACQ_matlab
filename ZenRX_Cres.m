function  handles = ZenRX_Cres( handles )
% Calculate and display CRES

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

msg=msgbox('This option is not yet available !');
waitfor(msg)

% progress = waitbar(0,'Retrieving CRES ...','Name','Contact Resistance' ...
%     ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
%     handles.main.GUI.width_bar handles.main.GUI.height_bar]);
% 
% tbl_content=get(handles.geometry_table,'data');
% ch_num=get(handles.geometry_table,'RowName');
% DATA=get(handles.geometry_table,'Data');
% 
% for i=1:size(handles.CHANNEL.ch_serial,2)   
%      index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,i}.ChNb));
%      QuickSendReceive(handles.CHANNEL.ch_serial{1,index},'CONTACTRESISTANCE',10,'atten mask:',0); 
% end
% 
% for i=1:size(handles.CHANNEL.ch_serial,2) 
%      index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,i}.ChNb));
%      Contact_res_content = waitln(handles.CHANNEL.ch_serial{1,index},'Brd339>','Read Contact Resistance',10);
%      Contact_RES_str=GetString(Contact_res_content,'CRES(ROut):','ContactResistanceCommand:Complete.');
%      if ~strcmp(DATA{i,1},'Off')
%         tbl_content{i,10}=round(str2double(Contact_RES_str));
%      else
%         tbl_content{i,10}=[];
%      end
%      handles.CRES_values{i}=tbl_content{i,10};
%       
%      pourcentage=[sprintf('%0.2f',(i/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
%      waitbar(i/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',pourcentage));      
% end
% 
% close(progress)
% set(handles.geometry_table,'data',tbl_content)

end