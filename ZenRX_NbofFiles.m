function  handles = ZenRX_NbofFiles( handles )
% Display the number of files

% Zonge International Inc.
% Created by Marc Benoit
% March 23, 2015


progress = waitbar(0,'Retriving Informations','Name','List of Files' ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);

tbl_content=get(handles.geometry_table,'data');
ch_num=get(handles.geometry_table,'RowName');


%Nb of File
for i=1:size(handles.CHANNEL.ch_serial,2)
    fprintf(handles.CHANNEL.ch_serial{i},'listfiles');
end

for i=1:size(handles.CHANNEL.ch_serial,2)
    
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,i}.ChNb));
     
    [~,c.Nb_of_Files] = list_SDfiles_start(handles.CHANNEL.ch_serial{i},handles.CHANNEL.ch_info{1,i}.ChNb);
    
    
     if c.Nb_of_Files==0
        nb_of_file_formatted=['<html><body text="#00CC00" align="center" width="40px"><b>' num2str(c.Nb_of_Files)];
     else
        nb_of_file_formatted=['<html><body text="#000000" align="center" width="40px"><b>' num2str(c.Nb_of_Files)];
     end
     
     
     tbl_content{index,11}=nb_of_file_formatted;
     
     handles.Nb_of_File{index}=tbl_content{index,11};
     
     pourcentage=[sprintf('%0.2f',(i/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
     waitbar(i/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',pourcentage));
end


close(progress);
set(handles.geometry_table,'data',tbl_content)

end