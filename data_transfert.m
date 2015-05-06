function [ handles,dir_path ] = data_transfert( handles,EXTENSION,list_Drive_Before )
% Copy and/or delete Zen DATA

        % COPY FILES
        dir_path=copy_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
            handles.main.GUI.width_bar,handles.main.GUI.height_bar,handles.path_output,EXTENSION,list_Drive_Before);
        
        
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
            
            if  strcmp(DoYouWantToDeleteFiles,handles.language.yes) % IF YES : DELETION
                    delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
                    handles.main.GUI.width_bar,handles.main.GUI.height_bar,EXTENSION,list_Drive_Before)
                    
                    % DELETE ALL .CSV FILES
                    delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
                    handles.main.GUI.width_bar,handles.main.GUI.height_bar,'*.CSV',list_Drive_Before)  
                    
            end
            

        end


end

