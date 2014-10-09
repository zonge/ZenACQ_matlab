function [ handles ] = data_transfert( handles,EXTENSION )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


        dir_path=copy_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
            handles.main.GUI.width_bar,handles.main.GUI.height_bar,handles.path_output,EXTENSION);
        if strcmp(dir_path,'empty')
            warndlg('No z3D files found','Copy Z3Ds')
        else
            
            choice2 = questdlg('Do you want to erase SD cards ?', ...
                'Delete Z3Ds', ...
                'YES','NO','NO');
            
            switch choice2
                case 'YES'
                    delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
                        handles.main.GUI.width_bar,handles.main.GUI.height_bar)  
                case 'NO'
                    return;
            end
            
        end

end

