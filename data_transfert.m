function [ handles,dir_path ] = data_transfert( handles,EXTENSION )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


        dir_path=copy_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
            handles.main.GUI.width_bar,handles.main.GUI.height_bar,handles.path_output,EXTENSION);
        if strcmp(dir_path,'empty')
            warndlg(handles.language.data_transfer_msg2,handles.language.progress_title5)
        else
            
            choice2 = questdlg(handles.language.data_transfer_msg3, ...
                handles.language.progress_title6, ...
                handles.language.yes,handles.language.no,handles.language.no);
            
            switch choice2
                case handles.language.yes
                    delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
                        handles.main.GUI.width_bar,handles.main.GUI.height_bar,EXTENSION)  
                case handles.language.no
                    return;
            end
            
        end
        delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
        handles.main.GUI.width_bar,handles.main.GUI.height_bar,'*.CSV')  

end

