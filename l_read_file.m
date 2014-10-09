function [ file_content,status ] = l_read_file(EXTENSION)
% GET THE CONTENT OF THE FILE
%   INPUT  : File Name
%   OUTPUT : File content (cell array)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file_content=[];
status=1;

[pathstr,name,ext] = fileparts(EXTENSION);

% IF in a different folder
temp_path=cd;
if ~isempty(pathstr)
cd(pathstr);
EXTENSION=[name ext];
end

% FIND FILE
file_dir=dir(EXTENSION);
cd(temp_path);
if size(file_dir,1)>1                % more than one file
    status=2;return;
elseif size(file_dir,1)==0           % No file
    status=3;return;
end

% IF in a different folder
if ~isempty(pathstr)
    ext_file=[pathstr filesep file_dir.name];
else
    ext_file=file_dir.name;
end

% OPEN FILE
fileID = fopen(ext_file);
if fileID==-1
    status=4;return;
end

% READ FILE AND CLOSE
file_content=textscan(fileID,'%s','delimiter','\n');
file_content=file_content{1,1};
fclose(fileID);

% CHECK IF THERE IS FILE CONTENT
 if isempty(file_content)                          % is the file empty ?   
    status=5;return;
 end

% DISREGARDS COMMENTS
 nb_comment = strfind(file_content,'//');
 nb_comment_cell_i=find(~cellfun(@isempty,nb_comment));
 for i=1:size(nb_comment_cell_i,1)
    index=nb_comment_cell_i(i,1);
    file_content{index,1}(nb_comment{index,1}:end) = '';   % Blank comments
 end
 
 % DELETE EMPTY CELL
 file_content=file_content(~cellfun('isempty',file_content));
 
 
end