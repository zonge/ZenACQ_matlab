function [ main_file ] = l_find_design( handles )

main_file=[];

if handles.main.type==1 % TX
file_dir=dir(['design' filesep '*.TXgeo']);    
elseif handles.main.type==0 % RX
file_dir=dir(['design' filesep '*.RXgeo']);
end
if isempty(file_dir)
    set(handles.design_popup,'String','No Survey Design found')
else
    Files=cell(size(file_dir,1),1);
    if strcmp(handles.SCH.last_design,'$Rx_geometry_selected')
        for i=1:size(file_dir,1)
            Files{i,1}=file_dir(i).name(1:end-6);
        end
        set(handles.design_popup,'String',Files)  
    else
    
        for i=1:size(file_dir,1)
            File=file_dir(i).name(1:end-6);
            if strcmp(File,handles.SCH.last_design)
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
            set(handles.design_popup,'String',Files)
        else
            for i=1:size(file_dir,1)
                Files{i,1}=file_dir(i).name(1:end-6);
            end
            set(handles.design_popup,'String',Files)  
        end          
    end  
    if handles.main.type==1 % TX
        main_file=['design' filesep Files{1,1} '.TXgeo'];   
    elseif handles.main.type==0 % RX
        main_file=['design' filesep Files{1,1} '.RXgeo'];
    end
    
end




