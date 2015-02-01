function  handles = channel_action( handles,hObject )

ch=get(hObject,'UserData');

if get(hObject,'Value')==1
    
    max=size(handles.selected_ch,2);
    handles.selected_ch(max+1)=ch;  

elseif get(hObject,'Value')==0
    
    index=handles.selected_ch==ch;
    handles.selected_ch(index)=[];

end

end

