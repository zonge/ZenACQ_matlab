function [file_content] = l_read_fileAndError( ext,handles,display_msg )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% GET CONTENT
[file_content,status] = l_read_file(ext);

if nargin>1   % IF MORE THAN EXTENSION ARGUMENTS
    
if nargin==3 && display_msg==true    % IF DISPLAY ERROR MESSAGE TRUE

if isempty(handles.language)   % IF LANGUAGE IS NOT AVAILABLE

    % DISPLAY READING ERRORS
    switch status
        case 2
            warndlg(['There are more than one ' ext ' file in the directory. Please delete unused'],'ZenACQ'); 
        case 3
            %warndlg(['No file (' ext ') found in the directory.'],'ZenACQ');  
        case 4
            warndlg(['Cannot open ' ext ],ext)
        case 5
            warndlg([ext ' is empty' ],ext)
    end

else                        % IF LANGUAGE IS AVAILABLE

    % DISPLAY READING ERRORS    
    switch status
        case 2
            warndlg([handles.language.read_file_err1 ext ' ' handles.language.read_file_err2],'ZenACQ'); 
        case 3
            %warndlg([handles.language.read_file_err3 ' (' ext ') ' handles.language.read_file_err4],'ZenACQ');  
        case 4
            warndlg([handles.language.read_file_err5 ' ' ext ],ext)
        case 5
            warndlg([ext ' ' handles.language.read_file_err6 ],ext)
    end
      
end
end

else
    
    % DISPLAY READING ERRORS
    switch status
        case 2
            warndlg(['There are more than one ' ext ' file in the directory. Please delete unused'],'ZenACQ'); 
        case 3
            warndlg(['No file (' ext ') found in the directory.'],'ZenACQ');  
        case 4
            warndlg(['Cannot open ' ext ],ext)
        case 5
            warndlg([ext ' is empty' ],ext)
    end

end