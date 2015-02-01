function [ handles,dir_path ] = data_transfert( handles,EXTENSION )
% Copy and/or delete Zen DATA

        % COPY FILES
        dir_path=copy_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
            handles.main.GUI.width_bar,handles.main.GUI.height_bar,handles.path_output,EXTENSION);
        
        
        if strcmp(dir_path,'empty') 
            % IF NO FILES
            w=warndlg(handles.language.data_transfer_msg2,handles.language.progress_title5);
            waitfor(w);
        else
            
            % IF FILES COPIED
            
            % Open the folder containing data
            winopen(fileparts(dir_path))

            % Ask to delete files
            DoYouWantToDeleteFiles = questdlg(handles.language.data_transfer_msg3, ...
                handles.language.progress_title6, ...
                handles.language.yes,handles.language.no,handles.language.no);
            
            waitfor(DoYouWantToDeleteFiles)
            
            switch DoYouWantToDeleteFiles
                case handles.language.yes % IF YES FOR Z3D DELETION
                    delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
                        handles.main.GUI.width_bar,handles.main.GUI.height_bar,EXTENSION)  
                case handles.language.no  % IF NO FOR Z3D DELETION
                    return;
            end
            
            % DELETE ALL .CSV FILES
            delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
            handles.main.GUI.width_bar,handles.main.GUI.height_bar,'*.CSV')  
        end


end

