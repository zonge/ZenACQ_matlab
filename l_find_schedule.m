function [ main_file ] = l_find_schedule( handles )

main_file=[];

if isempty(handles.SCH)
    return;
end

survey_type=str2double(handles.setting.ZenACQ_mode);
if survey_type==1
    EXT='MTsch';
elseif (survey_type==2 || survey_type==3) && handles.main.type==0
    EXT='IPsch';
elseif (survey_type==2 || survey_type==3) && handles.main.type==1
    EXT='TXsch';
end

file_dir=dir(['schedule' filesep '*.' EXT]);
if isempty(file_dir)
    set(handles.schedule_popup,'String','No schedule found')
    set(handles.edit_push,'Visible','off')
else
    
    Files=cell(size(file_dir,1),1);
    if strcmp(handles.SCH.last_schedule,'$Rx_schedule_selected')
        for i=1:size(file_dir,1)
            Files{i,1}=file_dir(i).name(1:end-6);
        end
        set(handles.edit_push,'Visible','on')
        set(handles.schedule_popup,'String',Files)  
    else
    
        for i=1:size(file_dir,1)
            File=file_dir(i).name(1:end-6);
            if strcmp(File,handles.SCH.last_schedule)
               index=i;
            end
        end
        if exist('index','var')        
        Files{1,1}=file_dir(index).name(1:end-6);
        j=1;
            for i=1:size(file_dir,1)
                if i~=index
                    j=j+1;
                    Files{j,1}=file_dir(i).name(1:end-6);
                end
            end
            set(handles.edit_push,'Visible','on')
            set(handles.schedule_popup,'String',Files,'Value',1)
        else
            for i=1:size(file_dir,1)
                Files{i,1}=file_dir(i).name(1:end-6);
            end
            set(handles.edit_push,'Visible','on')
            set(handles.schedule_popup,'String',Files)  
        end
            
    end
    
    main_file=['schedule' filesep Files{1,1} '.' EXT];

end

end

