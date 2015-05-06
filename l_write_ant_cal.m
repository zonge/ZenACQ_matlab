function [] = l_write_ant_cal( handles )
%WRITE ANTENNA CAL TO EEPROM

    progress = waitbar(0,handles.language.progress_str3,'Name',handles.language.progress_title1 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

ch_num=get(handles.geometry_table,'RowName');
filepath=['calibrate\' handles.main.calibrate_file_name];
if exist(filepath,'file')==2 % CHECK IF CAL EXIST
    
    tbl_content=get(handles.geometry_table,'data');
    formatSpec='%g:%g:%g, ';
  
    for ch=1:size(tbl_content,1)
        index_ch=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
          
        if strcmp(tbl_content{index_ch,1}(1),'H');
            [ant,ant_list] = read_antenna_file( filepath ); % CHECK IF ANTENNA EXIST
            ant_exist=find(ant_list==tbl_content{index_ch,6}, 1);
            if ~isempty(ant_exist) % IF IT EXIST
               loaded_cal=ant(ant_exist).cal;
               
               % Calculate size of metada block
               tempcal=cell(size(loaded_cal,1),1);
               for i=1:size(loaded_cal,1)
                tempcal{i,1}=sprintf(formatSpec,loaded_cal(i,1),loaded_cal(i,2),loaded_cal(i,3));
               end
               length_tot=25;
               index=zeros(16,1);
               index(1)=1;
               j=1;
               for i=1:size(loaded_cal,1)
                length_cal=size(tempcal{i,1},2);
                length_tot=length_cal+length_tot;
                if length_tot>200
                    j=j+1;
                    length_tot=0;
                    index(j)=i-1;
                end
               end
               index(j+1)=size(loaded_cal,1);
               index(j+2:end)=[];
               
               % PRINT METADATA
               %first line
               a=index(1);
               b=index(1+1)-1;
               
               metacal_1=strtrim(['METADATA CAL.VER,025|CAL.ANT=' num2str(ant(ant_exist).sn) ', ' ...
                                                    sprintf(formatSpec,loaded_cal(a:b,1:3)')]);
               
               % SEND METADATA CAL
               QuickSendReceive(handles.CHANNEL.ch_serial{ch},metacal_1,10,'WroteNumMetaDataRecords(0x',')toEEProm');
               
               %next line
               for i=2:size(index,1)-1
                   a=index(i);
                   b=index(i+1)-1;
                   end_line=',';
                   if i==size(index,1)-1;b=index(i+1);end_line='|';end
                   metacal=strtrim(['METADATA ' sprintf(formatSpec,loaded_cal(a:b,1:3)')]);
                   
               % SEND METADATA CAL
               QuickSendReceive(handles.CHANNEL.ch_serial{ch},[metacal(1:end-1) end_line],10,'WroteNumMetaDataRecords(0x',')toEEProm');
               
               end
            end  
        end 
        
        pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
        waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str2 ' ' pourcentage]));

        
    end
    
end

close(progress)


end

