function [file_content] = l_read_fileAndError( ext,handles,display_msg )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% GET CONTENT
[file_content,status] = l_read_file(ext);

if nargin==3    %  DISPLAY ERROR MSG IN THE FOUND LANGUAGE

    % IF DISPLAY READING ERRORS = TRUE
    if display_msg==true   
    switch status
        case 2
            w=warndlg([handles.language.read_file_err1 ext ' ' handles.language.read_file_err2],'ZenACQ'); 
            uiwait(w);
        case 3
            w=warndlg([handles.language.read_file_err3 ' (' ext ') ' handles.language.read_file_err4],'ZenACQ');
            uiwait(w);
        case 4
            w=warndlg([handles.language.read_file_err5 ' ' ext ],ext);
            uiwait(w);
        case 5
            w=warndlg([ext ' ' handles.language.read_file_err6 ],ext);
            uiwait(w);
    end 
    end

else  %  DISPLAY ERROR MSG IN ENGLISH WHEN READING LANGUAGE FILE ONLY
    
    switch status
        case 2
            w=warndlg(['There are more than one ' ext ' file in the directory. Please delete unused'],'ZenACQ'); 
            uiwait(w);
        case 3
            generate_EN_LAN;
            [file_content,~] = l_read_file(ext);
        case 4
            w=warndlg(['Cannot open ' ext ],ext);
            uiwait(w);
        case 5
            w=warndlg([ext ' is empty' ],ext);
            uiwait(w);
    end

end