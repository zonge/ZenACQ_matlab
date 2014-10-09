function [ file_content ] = l_get_file_content( ext,handles,display_msg )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GET CONTENT
if nargin == 1
    file_content = l_read_fileAndError( ext );  % FOR LANGUAGE
else
    file_content = l_read_fileAndError( ext,handles,display_msg );
end


end

