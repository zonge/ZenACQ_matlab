function timer_ZenACQ(mTimer,~)
% CHECK COM PORT AND UPDATE GRAPHIC COMPONENTS

try
    
A=mTimer.UserData;  % Get User Timer input data
handles=A.pass;    

channel_str=handles.language.channel_str;

% GET COM PORT NUMBER
COM=findCOM;
COM_temp=get(handles.Nb_Channel,'String');
COM_temp=textscan(COM_temp,'%s : %f');

% UPDATE COM PORT NUMBER
if strcmp('NONE',COM{1,1})
    set(handles.Nb_Channel,'String',[channel_str ' 0'],'BackgroundColor',[.941 .941 .941],'ForegroundColor',[0 0 0]);
    set(handles.receiver,'Enable','off')
    set(handles.data_transfert,'Enable','off')
    set(handles.calibration,'Enable','off')
    set(handles.option_box,'Enable','off')
    set(handles.transmitter,'Enable','off')
    set(handles.copy_sds,'Enable','off')
    set(handles.delete_sds,'Enable','off')
    msg_status=get(handles.msg_txt,'Value');
    if msg_status==0
        set(handles.msg_txt,'String',handles.language.ZenACQ_info_msg1)
        set(handles.data_transfert,'Value',0)
    elseif msg_status==1
        set(handles.msg_txt,'String',handles.language.ZenACQ_info_msg2)
        set(handles.data_transfert,'Value',1)
    end
else
    if num2str(size(COM,1))>1
       channel_str=[channel_str handles.language.channel_str_plurial]; 
    end
    if size(COM,1)==COM_temp{1,2}
        set(handles.data_transfert,'Value',0)
        set(handles.Nb_Channel,'String',[channel_str ' : ' num2str(size(COM,1))],'BackgroundColor',[.941 .941 .941],'ForegroundColor',[0 0 0]);
        set(handles.receiver,'Enable','on')
        set(handles.data_transfert,'Enable','on')
        set(handles.calibration,'Enable','on')
        set(handles.option_box,'Enable','on')
        set(handles.transmitter,'Enable','on')
        set(handles.copy_sds,'Enable','on')
        set(handles.delete_sds,'Enable','on')
    else
        set(handles.Nb_Channel,'String',[channel_str ' : ' num2str(size(COM,1))],'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1]);
    end
    set(handles.msg_txt,'String','','Value',0)
    
end

% UPDATE TIME
set(handles.clock_display,'String',datestr(now,'yyyy-mm-dd, HH:MM:SS')) % UPDATE TIME

% SHOW DELETE FILE BUTTON
data_transfert_status=get(handles.data_transfert,'Value');
if data_transfert_status==1
    set(handles.data_transfert,'Visible','off')
    set(handles.copy_sds,'Visible','on','Enable','on')
    set(handles.delete_sds,'Visible','on','Enable','on')
else
    set(handles.data_transfert,'Visible','on')
    set(handles.copy_sds,'Visible','off','Enable','off')
    set(handles.delete_sds,'Visible','off','Enable','off')
end

catch
end
