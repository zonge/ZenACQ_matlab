function [ handles ] = ZenRX_save_layout( handles,geometry_tbl,survey)
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
formatSpec='$geometryline%i = %s,%f,%f,%f,%f,%f,%f\n';
fid = fopen(file_name, 'w+');
for i=1:size(geometry_tbl,1)
    cmp=geometry_tbl{i,1};
    s1x=geometry_tbl{i,2};
    s1y=geometry_tbl{i,3};
    s2x=geometry_tbl{i,4};
    s2y=geometry_tbl{i,5};
    Tx_ant=geometry_tbl{i,6};
    Azm=geometry_tbl{i,7};
    fprintf(fid,formatSpec,i,cmp,s1x,s1y,s2x,s2y,Tx_ant,Azm);
end

elseif handles.main.type==1  % TX
    
file_name=[folder filesep geo_name{1,1} '.TXgeo'];
formatSpec='$geometryline%i = %s,%f,%f,%f,%f,%f,%f\n';
fid = fopen(file_name, 'w+');
for i=1:size(geometry_tbl,1)
    cmp=geometry_tbl{i,1};
    s1x=geometry_tbl{i,2};
    s1y=geometry_tbl{i,3};
    s2x=geometry_tbl{i,4};
    s2y=geometry_tbl{i,5};
    Tx_ant=geometry_tbl{i,6};
    Azm=geometry_tbl{i,7};
    fprintf(fid,formatSpec,i,cmp,s1x,s1y,s2x,s2y,Tx_ant,Azm);

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
if handles.main.type==0 % MT
    l_modif_file(handles.main.Setting_ext,'$Rx_geometry_selected_MT',geo_name{1,1} )
elseif handles.main.type==0 && survey_type==2 % IP RX
    l_modif_file(handles.main.Setting_ext,'$Rx_geometry_selected_IP_RX',geo_name{1,1} )
elseif handles.main.type==1 && survey_type==2  % IP TX
    l_modif_file(handles.main.Setting_ext,'$Rx_geometry_selected_IP_TX',geo_name{1,1} )
end


handles.SCH.last_design=geo_name{1,1};

% FIND AND DISPLAY SELECTED DESIGN
l_find_design( handles );

end

