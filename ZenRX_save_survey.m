function [ handles ] = ZenRX_save_survey( handles,geometry_tbl,survey)
% SAVE displayed survey to a file

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

name_geo=get(handles.design_popup,'String');
if strcmp(name_geo,'No Survey Layout found')
    default_ans{1,1}='';
else
    default_ans{1,1}=name_geo{1,1};
end

geo_name = inputdlg('Survey Design name :','Survey Design',1,default_ans);
if isempty(geo_name);return;end
folder=handles.main.layout_folder;
if ~exist(folder,'dir');mkdir(folder);end

if handles.main.type==0 % RX

file_name=[folder filesep geo_name{1,1} '.RXgeo'];
formatSpec='$geometryline%i = %s|%f|%f|%f|%f|%f|%f|\n';
fid = fopen(file_name, 'w');
for i=1:size(geometry_tbl,1)
    cmp=geometry_tbl{i,1};
    s1x=geometry_tbl{i,2};
    s1y=geometry_tbl{i,3};
    s2x=geometry_tbl{i,4};
    s2y=geometry_tbl{i,5};
    if ~isempty(handles.Ant)
    if i>size(handles.Ant.num,2)
        length_ant='';
        azimut='';
    else
        length_ant=handles.Ant.num{1,i};
        azimut=handles.Ant.azm{1,i};
    end
    else
        length_ant='';
        azimut='';
    end
    fprintf(fid,formatSpec,i,cmp,s1x,s1y,s2x,s2y,length_ant,azimut);
end

elseif handles.main.type==1  % TX
    
    file_name=[folder filesep geo_name{1,1} '.TXgeo'];
formatSpec='$geometryline%i = %s|%f|%f|%f|%f|%f|%f|%s|%s|\n';
fid = fopen(file_name, 'w');
for i=1:size(geometry_tbl,1)
    cmp=geometry_tbl{i,1};
    s1x=geometry_tbl{i,2};
    s1y=geometry_tbl{i,3};
    s2x=geometry_tbl{i,4};
    s2y=geometry_tbl{i,5};
    length_ant=geometry_tbl{i,6};
    azimut=geometry_tbl{i,7};
    if ~isempty(handles.TX)
     if i>size(handles.TX.type,2)
         TX_type='';
         TX_serial='';
     else
        TX_type=handles.TX.type{1,i};
        TX_serial=handles.TX.sn{1,i};
     end
    else
        TX_type='';
        TX_serial='';
    end
    fprintf(fid,formatSpec,i,cmp,s1x,s1y,s2x,s2y,length_ant,azimut,TX_type,TX_serial);
end
    
    
end

if ~isempty(survey.Xstn_box)
    fprintf(fid,'$geometryXstn = %s\n',survey.Xstn_box);
end

if ~isempty(survey.Ystn_box)
    fprintf(fid,'$geometryYstn = %s\n',survey.Ystn_box);
end

if ~isempty(survey.line_name)
    fprintf(fid,'$geometryLineName = %s\n',survey.line_name);
end

if ~isempty(survey.SX_azimut_box)
    fprintf(fid,'$geometryLineAzimuth = %s\n',survey.SX_azimut_box);
end

if ~isempty(survey.a_space_box)
    fprintf(fid,'$geometryAspace = %s\n',survey.a_space_box);
end

if ~isempty(survey.s_space_box)
    fprintf(fid,'$geometrySspace = %s\n',survey.s_space_box);
end

fprintf(fid,'$geometryZpositive = %u\n',survey.z_positive);

fclose(fid);
 
survey_type=str2double(handles.setting.ZenACQ_mode);
if handles.main.type==0
    l_modif_file(handles.main.Setting_ext,'$Rx_geometry_selected_MT',geo_name{1,1} )
elseif handles.main.type==0 && survey_type==2
    l_modif_file(handles.main.Setting_ext,'$Rx_geometry_selected_IP_RX',geo_name{1,1} )
elseif handles.main.type==1 && survey_type==2
    l_modif_file(handles.main.Setting_ext,'$Rx_geometry_selected_IP_TX',geo_name{1,1} )
end


handles.SCH.last_design=geo_name{1,1};

% FIND AND DISPLAY SELECTED DESIGN
l_find_design( handles );

end

