function [ main_file ] = l_find_schedule( handles )

main_file=[];

if isempty(handles.SCH)
    return;
end

file_dir=dir(['schedule' filesep '*.sch']);
if isempty(file_dir)
    set(handles.schedule_popup,'String','No schedule found')
    set(handles.edit_push,'Visible','off')
else
    
    Files=cell(size(file_dir,1),1);
    if strcmp(handles.SCH.last_schedule,'$Rx_schedule_selected')
    	
        for i=1:size(file_dir,1)
            Files{i,1}=file_dir(i).name(1:end-4);
        end
        set(handles.edit_push,'Visible','on')
        set(handles.schedule_popup,'String',Files)  
    else
    
        for i=1:size(file_dir,1)
            File=file_dir(i).name(1:end-4);
            if strcmp(File,handles.SCH.last_schedule)
               index=i;
            end
        end
        if exist('index','var')        
        Files{1,1}=file_dir(index).name(1:end-4);
        j=1;
            for i=1:size(file_dir,1)
                if i~=index
                    j=j+1;
                    Files{j,1}=file_dir(i).name(1:end-4);
                end
            end
            set(handles.edit_push,'Visible','on')
            set(handles.schedule_popup,'String',Files)
        else

            set(handles.schedule_popup,'String','No schedule found')
            set(handles.edit_push,'Visible','off')
            
        end
            
    end
    
    main_file=['schedule' filesep Files{1,1} '.sch'];

end


end

