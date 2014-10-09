function delete_files(left_bar,bottom_bar,width_bar,height_bar)
%Copy Z3D files from SD cards to an OUTPUT define path

% PARAMETER
EXTENSION='*.Z3D';  % Extension

% get the list of current drives
import java.io.*;
f=File('');
r=f.listRoots;

% INTIATE PROGRESS BAR
progress = waitbar(0,'DELETE Z3DS...','Name','Delete Z3Ds' ...
    ,'Position',[left_bar bottom_bar width_bar height_bar]);


% FIND TOTAL NUMBER OF FILE TO DELETE (FOR PROGRESS BAR)
total_files=0;
for i=1:numel(r)   
     list=dir_fixed([char(r(i)) EXTENSION]);  
     if ~isempty(list) && ~strcmp(char(r(i)),'C:\') && ~strcmp(char(r(i)),'D:\')
         for j=1:size(list,1)
              total_files=total_files+1;
         end
     end
end

if total_files==0
    msgbox('No Z3D file found', 'DELETE Z3Ds ');
end

% MAIN LOOP
file_nb=0;
for i=1:numel(r)
     
     list=dir_fixed([char(r(i)) EXTENSION]);  
     if ~isempty(list) && ~strcmp(char(r(i)),'C:\') && ~strcmp(char(r(i)),'D:\')
         for j=1:size(list,1)
              file_nb=file_nb+1;
              
              % SOURCE
              source=([char(r(i)) list(j).name]);
              disp(['DELETE : ' source])
              
              delete(source) 
             
              pourcentage=[sprintf('%0.2f',(file_nb/total_files)*100) ' %'];
              waitbar(file_nb/total_files,progress,sprintf('%s',pourcentage));
              
          end
         
     end
end

close(progress);
