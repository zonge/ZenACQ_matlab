function [nb_chn] = l_commit_set_meta( handles )
% SET METADATA INFORMATION BASED ON USER INFO.

progress = waitbar(0,handles.language.progress_str1,'Name',handles.language.progress_title1 ...
,'Position',[handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
handles.main.GUI.width_bar handles.main.GUI.height_bar]);   

% Clear metadata
for ch=1:size(handles.CHANNEL.ch_serial,2)
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},'metadata clear',10,'WroteNumMetaDataRecords(0x',')');
end

%% SET METADATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
survey_type=str2double(handles.setting.ZenACQ_mode);
job_operator_box=get(handles.job_operator_box,'String');
job_number_box=get(handles.job_number_box,'String');
job_name_box=get(handles.job_name_box,'String');
job_by_box=get(handles.job_by_box,'String');
job_for_box=get(handles.job_for_box,'String');
tbl_content=get(handles.geometry_table,'data');
ch_num=get(handles.geometry_table,'RowName');
Xstn_num=get(handles.Xstn_box,'String');
Ystn_num=get(handles.Ystn_box,'String');
Stn_num=[Xstn_num ':' Ystn_num];
Line_num=get(handles.line_box,'String');
offset_vs_stn_layout=get(handles.station_vs_offset,'Value');

LineName='';
if ~isempty(Line_num)
	LineName=['LINE.NAME,' Line_num '|'];
end
a_space=get(handles.a_space_box,'String');
s_space=get(handles.s_space_box,'String');
switch survey_type
    case 1
        survey_type_str='AMT';
    case 2
        survey_type_str='CR';
    case 3
        survey_type_str='TDIP'; 
end

Zpositive=get(handles.z_positive,'Value');
xazimuth = str2double(get(handles.SX_azimut_box,'String'));
if Zpositive==2 % zpositive==up
  yazimuth = xazimuth - 90;
else            % zpositive==down
  yazimuth = xazimuth + 90;
end
yazimuth = mod(yazimuth+2*360,360);


nb_chn=0;
for ch=1:size(handles.CHANNEL.ch_serial,2)
    index=strfind(ch_num',num2str(handles.CHANNEL.ch_info{1,ch}.ChNb));
    
        if offset_vs_stn_layout==true  % station
            x_negative=tbl_content{index,2}-str2double(Xstn_num);
            y_negative=tbl_content{index,3};
            x_positive=tbl_content{index,4}-str2double(Xstn_num);
            y_positive=tbl_content{index,5};
        elseif offset_vs_stn_layout==false  % offset
            x_negative=tbl_content{index,2};
            y_negative=tbl_content{index,3};
            x_positive=tbl_content{index,4};
            y_positive=tbl_content{index,5}; 
        end
    
    if strcmp(tbl_content{index,1},'Off'); continue;end

    nb_chn=nb_chn+1;
    
        % META 1
        meta_str1=['METADATA GDP.PROGVER=' [handles.main.ProgramName ',' handles.main.ProgramVersion] ...
                   '|GDP.OPERATOR=' job_operator_box ...
                   '|SURVEY.TYPE=' survey_type_str ...
                   '|Unit.Length=' 'm' ...
                   '|'];
    
        % META 2
        meta_str2=['METADATA JOB.NAME=' job_name_box ...
                   '|JOB.FOR=' job_for_box ...
                   '|JOB.BY=' job_by_box ...
                   '|JOB.NUMBER=' job_number_box ...
                   '|'];
    
        % META 3
        meta_str3=['METADATA ' LineName  ...
                   'RX.XYZ0=' Stn_num ...
                   '|RX.XAZIMUTH=' num2str(xazimuth)  ...
                   '|RX.YAZIMUTH=' num2str(yazimuth)  ...
                   '|RX.ASpace=' a_space ...
                   '|RX.SSpace=' s_space ...
                   '|'];
    
        % META 4
    if strcmp(tbl_content{index,1}(1),'E')
        
        meta_str4=['METADATA CH.CMP=' num2str(tbl_content{index,1}) ...
                   '|CH.NUMBER=' num2str(str2double(Xstn_num)+(x_negative+x_positive)/2) ...
                   '|CH.LENGTH=' num2str(tbl_content{index,6}) ... 
                   '|CH.AZIMUTH=' num2str(tbl_content{index,7}) ...
                   '|CH.XYZ1=' [num2str(x_negative) ':' num2str(y_negative)] ...
                   '|CH.XYZ2=' [num2str(x_positive) ':' num2str(y_positive)] ...
                   '|'];
              
    elseif strcmp(tbl_content{index,1}(1),'H')
        
        meta_str4=['METADATA CH.CMP=' num2str(tbl_content{index,1}) ...
                   '|CH.NUMBER=' num2str(tbl_content{index,6}) ...
                   '|CH.LENGTH=' '0' ...
                   '|CH.AZIMUTH=' num2str(tbl_content{index,7}) ...
                   '|CH.XYZ1=' [num2str(x_negative) ':' num2str(y_negative)] ...
                   '|CH.XYZ2=' [num2str(x_positive) ':' num2str(y_positive)] ...
                   '|'];
              
    elseif strcmp(tbl_content{index,1}(1:2),'TX')
    
        filepath =['calibrate' filesep handles.main.TX_cal_file_name];
        TX=read_tx_file( filepath );
    
        for tx_i=1:size(TX,1);if strcmp(TX(tx_i).Serial,tbl_content{index,6});break;end;end 
    
        TXsense=TX(tx_i).Sense; 
        TXtype=TX(tx_i).Type;
        TXSerial=TX(tx_i).Serial;
        CH_length_TX=num2str(sqrt((tbl_content{index,2}-tbl_content{index,4})^2+(tbl_content{index,3}-tbl_content{index,5})^2)...
            *(str2double(a_space)/str2double(s_space)));
        
        meta_str4=['METADATA CH.CMP=' 'Ref' ...
                   '|CH.NUMBER=' num2str(str2double(Xstn_num)+(x_negative+x_positive)/2) ...
                   '|CH.LENGTH=' CH_length_TX ...
                   '|CH.AZIMUTH=' num2str(tbl_content{index,7}) ...
                   '|CH.XYZ1=' [num2str(x_negative) ':' num2str(y_negative)] ...
                   '|CH.XYZ2=' [num2str(x_positive) ':' num2str(y_positive)] ...
                   '|TX.TYPE=' TXtype ...
                   '|TX.SENSE=' TXsense ...
                   '|TX.SN=' TXSerial ...
                   '|'];
              
    end
    
    CRES='';
    if ~isempty(tbl_content{index,10})
        CRES=['CH.CRES=' num2str(str2double(tbl_content{index,10}(59:end))*1000) '|'];
    end
    
    VOLTAGE_INFO='';
    if ~isempty(tbl_content{index,8})
        VOLTAGE_INFO=['CH.SP=' tbl_content{index,9}(59:end) '|CH.VMAX=' num2str(str2double(tbl_content{index,8}(59:end))/1000) '|'];
    end
    

    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str1,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str2,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str3,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str4,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    if ~isempty(tbl_content{index,10}) || ~isempty(tbl_content{index,8})
        meta_str5=['METADATA ' CRES VOLTAGE_INFO];
        QuickSendReceive(handles.CHANNEL.ch_serial{ch},meta_str5,10,'WroteNumMetaDataRecords(0x',')toEEProm');
    end

    
    pourcentage=[sprintf('%0.2f',(ch/size(handles.CHANNEL.ch_serial,2))*100) ' %'];
    waitbar(ch/size(handles.CHANNEL.ch_serial,2),progress,sprintf('%s',[handles.language.progress_str2 ' ' pourcentage]));
end

close(progress)

end

