function [ handles ] = ZenRX_save_survey( handles,geometry_tbl )
% SAVE displayed survey to a file

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

name_geo=get(handles.design_popup,'String');
if strcmp(name_geo,'No Survey design found')
    default_ans{1,1}='';
else
    default_ans{1,1}=name_geo{1,1};
end

geo_name = inputdlg('Survey Design name :','Survey Design',1,default_ans);
if isempty(geo_name);return;end
folder='design';
if ~exist(folder,'dir');mkdir(folder);end
file_name=[folder filesep geo_name{1,1} '.geo'];
formatSpec='$geometryline%i = %s|%s|%s\n';
fid = fopen(file_name, 'w');
for i=1:size(geometry_tbl,1)
    cmp=geometry_tbl{i,1};
    elec1=geometry_tbl{i,2};
    elec2=geometry_tbl{i,3};
    fprintf(fid,formatSpec,i,cmp,elec1,elec2);
 end
fclose(fid);
 
l_modif_file(handles.main.Setting_ext,'$Rx_geometry_selected',geo_name{1,1} )

handles.SCH.last_design=geo_name{1,1};

% FIND AND DISPLAY SELECTED DESIGN
l_find_design( handles );

end

