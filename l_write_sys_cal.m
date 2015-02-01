function [] = l_write_sys_cal( handles )
%WRITE SYSTEM CAL TO EEPROM

tbl_content=get(handles.geometry_table,'data');
zen_box=str2double(get(handles.box_str_val,'String'));
filename=['calibrate/ZEN' num2str(zen_box) '.cal'];
ch_num=get(handles.geometry_table,'RowName');

if exist(filename,'file')==2
    
     % READ BOARD CAL
     formatSpec = '%s %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %[^\n\r]';
     fileID = fopen(filename,'r');
     dataArray = textscan(fileID, formatSpec, 'HeaderLines' ,11, 'ReturnOnError', false);
     fclose(fileID);

    progress = waitbar(0,handles.language.progress_str3,'Name',handles.language.progress_title1 ...
    ,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
    handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

for ch=1:size(handles.CHANNEL.ch_serial,2)
    
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
    
    if strcmp(tbl_content{index,1},'Off'); continue;end
     AA='';AA1='';AA2='';
     for i=1:size(dataArray{1,1},1)
         if dataArray{1,4}(i,1)==256
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,3}(i,1)) ':' dataArray{1,2}{i,1} ':' num2str(dataArray{1,7}(i,1)) ':' num2str(dataArray{1,8}(i,1)) ', ' ];
                AA=[AA  str];
            end
         end
         if dataArray{1,4}(i,1)==4096
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,3}(i,1)) ':' dataArray{1,2}{i,1} ':' num2str(dataArray{1,7}(i,1)) ':' num2str(dataArray{1,8}(i,1)) ', ' ];
                AA1=[AA1  str];
            end
         end
         if dataArray{1,4}(i,1)==1024
            if strcmp(dataArray{1,1}{i,1},handles.CHANNEL.ch_info{1,ch}.BoardSN)
                str=[num2str(dataArray{1,3}(i,1)) ':' dataArray{1,2}{i,1} ':' num2str(dataArray{1,7}(i,1)) ':' num2str(dataArray{1,8}(i,1)) ', ' ];
                AA2=[AA2  str];
            end
         end
     end

    survey_type=str2double(handles.setting.ZenACQ_mode);
    
    if survey_type==1 % MT
            
        %end_first_block=strfind(AA,', 1:')-1;
        end_second_block=strfind(AA1,', 16:')-1;
    
        %meta_str1=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
        %           ',     ' AA(1:end_first_block) '|'];
        %meta_str2=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
        %           ',     ' AA(end_first_block+3:end-2) '|'];
        meta_str2=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
                   ',     ' AA(1:end-2) '|'];
        meta_str3=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
                   ',     ' AA1(1:end_second_block) '|'];
        meta_str4=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ...
                   ',     ' AA1(end_second_block+3:end-2) '|'];

        %QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str1,10,'WroteNumMetaDataRecords(0x',')toEEProm');
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str2,10,'WroteNumMetaDataRecords(0x',')toEEProm');
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str3,10,'WroteNumMetaDataRecords(0x',')toEEProm');
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str4,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    
    elseif (survey_type==2 || survey_type==3) % IP
        
        meta_str=['METADATA CAL.BRD,' handles.CHANNEL.ch_info{1,ch}.BoardSN ',     ' AA2 '|'];
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str,10,'WroteNumMetaDataRecords(0x',')toEEProm');
        
    end

    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str2 ' ' pourcentage]));
end

close(progress)
end


end

