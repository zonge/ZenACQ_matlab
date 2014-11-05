function [ handles ] = ZenRX_schedule( handles,edit_file )
%DEFINE THE SCHEDULE (CREATE / UPDATE SCHEDULE)

% Zonge International Inc.
% Created by Marc Benoit
% Oct 10, 2014

ZenACQ_vars.main=handles.main;
ZenACQ_vars.setting=handles.setting;
ZenACQ_vars.language=handles.language;
setappdata(0,'tunnel',ZenACQ_vars);                % SET GLOBAL VARIABLE
setappdata(0,'tunnel2',edit_file);                 % SET GLOBAL VARIABLE





 w=ZenSCH;

if exist('handles.jPanel','class'); handles.jPanel.setVisible(false);end
uiwait(w);

handles.SCH=getappdata(0,'tunnelback');

% FIND SCHEDULE
main_file=l_find_schedule( handles );

% CREATE SCH OBJ
if ~isempty(main_file)
handles.SCHEDULE = m_get_sch_obj( main_file,handles,true );
set(handles.quick_summary_str,'String',handles.SCHEDULE.SUMMARY);
set(handles.schedule_popup,'Value',1);
end

% UPDATE SCHEDULE FIELDS
handles=l_Rx_update_time( handles );


end

