function [status] = l_commit_save_survey( handles )
% CHECK AND SAVE SURVEY INFORMATION

status=true;

%Get GUI information
job_operator_box=get(handles.job_operator_box,'String');
job_number_box=get(handles.job_number_box,'String');
job_name_box=get(handles.job_name_box,'String');
job_by_box=get(handles.job_by_box,'String');
job_for_box=get(handles.job_for_box,'String');

% CHECK SURVEY Value
if size(job_operator_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_operator_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_operator_box,'BackgroundColor',[1 1 1])
    status=false;
    return;
    
elseif size(job_number_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_number_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_number_box,'BackgroundColor',[1 1 1])
    status=false;
    return;
    
elseif size(job_name_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_name_box,'BackgroundColor',[1 1 1])
    status=false;
    return;
        
elseif size(job_by_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_by_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_by_box,'BackgroundColor',[1 1 1])
    status=false;
    return;
    
elseif size(job_for_box,2)>32
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.commit_msg7)
    set(handles.job_for_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_for_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.job_for_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.job_for_box,'BackgroundColor',[1 1 1])
    status=false;
    return;
    
end

    % Maybe need to Make sure file is not open before.

fid = fopen('survey.zen','w+');

fprintf(fid,'$job_operator_box = %s\n',job_operator_box);
fprintf(fid,'$job_number_box = %s\n',job_number_box);
fprintf(fid,'$job_name_box = %s\n',job_name_box);
fprintf(fid,'$job_by_box = %s\n',job_by_box);
fprintf(fid,'$job_for_box = %s',job_for_box);

fclose(fid);

end

