function [] = l_modif_file( file_name,keyword,key_value )
%CHANGE KEYWORD VALUE in a file
% Input : - name of the file
%         - keyword to change
%         - new key_value 

%  Created by Marc Benoit for Zonge International on Sep/07/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% READ FILE
[ file_content,~ ] = l_read_file(file_name);
if isempty(file_content); return; end % if file content is empty abord
 
% CHANGE VALUE OF THE KEYWORD
keyword_loc = strfind(file_content,keyword);                          % find keyword in array
keyword_cell_i=find(~cellfun(@isempty,keyword_loc),1);                % find keyword in array
if isempty(keyword_cell_i);keyword_cell_i=size(file_content,1)+1;end  % if empty create a new line
file_content{keyword_cell_i,1}=[keyword ' = ' key_value]; % Change value

% RE-WRITE FILE
fid = fopen(file_name,'w');
for i=1:size(file_content,1)
    fprintf(fid,'%s\n',file_content{i,1});
end
fclose(fid);

end

