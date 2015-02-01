function [ UTM_toggle,DATA,A_space,S_space,SX_azimuth,z_positive,ZenUTM] = get_survey_GUI_var( handles )
% return Survey user defined parameters.
% 11/18/2014 by Marc Benoit 
% for Zonge International

UTM_toggle=get(handles.utm_checkbox,'Value');
DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String')); 
S_space=str2double(get(handles.s_space_box,'String')); 
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

end

