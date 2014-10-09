function [ keys ] = m_get_language_key( ext )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keys=[];

% GET CONTENT
file_content=l_get_file_content( ext );

%if ~isempty(file_content)
    

    keys.delete_file=l_search_key('$delete_file',file_content,ext);
    keys.copy_file=l_search_key('$copy_file',file_content,ext);
    keys.data_look=l_search_key('$data_look',file_content,ext);
    keys.channel_str=l_search_key('$channel_str',file_content,ext);
    
    % READ FILES
    keys.read_file_err1=l_search_key('$read_file_err1',file_content,ext);
    keys.read_file_err2=l_search_key('$read_file_err2',file_content,ext);
    keys.read_file_err3=l_search_key('$read_file_err3',file_content,ext);
    keys.read_file_err4=l_search_key('$read_file_err4',file_content,ext);
    keys.read_file_err5=l_search_key('$read_file_err5',file_content,ext);
    keys.read_file_err6=l_search_key('$read_file_err6',file_content,ext);
    
    %% SCHEDULE
    keys.ZenSCH_err1=l_search_key('$ZenSCH_err1',file_content,ext);
    keys.ZenSCH_err2=l_search_key('$ZenSCH_err2',file_content,ext);
    keys.ZenSCH_err3=l_search_key('$ZenSCH_err3',file_content,ext);
    keys.ZenSCH_err4=l_search_key('$ZenSCH_err4',file_content,ext);
    keys.ZenSCH_err5=l_search_key('$ZenSCH_err5',file_content,ext);
    keys.ZenSCH_err6=l_search_key('$ZenSCH_err6',file_content,ext);
    keys.ZenSCH_err7=l_search_key('$ZenSCH_err7',file_content,ext);
    keys.ZenSCH_err8=l_search_key('$ZenSCH_err8',file_content,ext);
    


%end

end