function [ str ] = l_search_key( keyword,file_content,ext )
% Look for keyword in cells and returns corresponding strings. 
% INPUT : ,cell array, keyword
% OUTPUT : corresponding string.
%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initiate string value.
 str=keyword;
 
 if isempty(file_content)  % if file content is empty abord
     return;
 end
 
 keyword_loc = strfind(file_content,keyword);           % find keyword in array
 keyword_cell_i=find(~cellfun(@isempty,keyword_loc),1);   % find keyword in array
 
 if size(keyword_cell_i,1)>1  % Check if the keyword apear more than once
     warndlg([keyword ' appears ' num2str(size(keyword_cell_i,1)) ' times.' ],ext)
 elseif size(keyword_cell_i,1)==0 % Check if the keyword exist
     return;
 else
 
 equal_loc=strfind(file_content{keyword_cell_i,1},'=');
 if size(equal_loc,2)==0 || size(equal_loc,2)>1 % Check if = apears more than once or not
     warndlg([keyword ' appears with ' num2str(size(equal_loc,2)) ' "=" signs.' ],ext)
 elseif size(keyword_cell_i,1)==1  % Get the output
     str=strtrim(file_content{keyword_cell_i,1}(equal_loc+1:end));
 end
 end


end

