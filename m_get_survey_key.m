function [ keys ] = m_get_survey_key( ext,handles,display_msg )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keys=[];

% GET CONTENT
file_content=l_get_file_content( ext,handles,display_msg );

%if ~isempty(file_content)

    % DEFINE KEY WORDS !
    keys.job_operator=l_search_key('$job_operator',file_content,ext);
    keys.job_number=l_search_key('$job_number',file_content,ext);
    keys.job_name=l_search_key('$job_name',file_content,ext);
    keys.job_by=l_search_key('$job_by',file_content,ext);
    keys.job_for=l_search_key('$job_for',file_content,ext);

%end

end