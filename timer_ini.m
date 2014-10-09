function timer_ini(mTimer,~)
% CHECK COM PORT AND UPDATE GRAPHIC COMPONENTS

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
    msg_status=get(handles.msg_txt,'Value');
    if msg_status==0
        set(handles.msg_txt,'String','Start your ZEN')
    elseif msg_status==1
        set(handles.msg_txt,'String','Restart your ZEN')
    end
else
    if num2str(size(COM,1))>1
       channel_str=[channel_str 's']; 
    end
    if size(COM,1)==COM_temp{1,2}
        set(handles.Nb_Channel,'String',[channel_str ' : ' num2str(size(COM,1))],'BackgroundColor',[.941 .941 .941],'ForegroundColor',[0 0 0]);
        set(handles.receiver,'Enable','on')
        set(handles.data_transfert,'Enable','on')
        set(handles.calibration,'Enable','on')
        set(handles.option_box,'Enable','on')
    else
        set(handles.Nb_Channel,'String',[channel_str ' : ' num2str(size(COM,1))],'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1]);
    end
    set(handles.msg_txt,'String','','Value',0)
    
end

% UPDATE TIME
set(handles.clock_display,'String',datestr(now,'yyyy-mm-dd, HH:MM:SS')) % UPDATE TIME