function [ list ] = dir_fixed( LOCATION )
% Dir_fixed returns the list of files found in the defined LOCATION.
% It fixes issues that the intrinsec dir function has with files date
% 1980. It returns the same attributs than dir without crash for files of
% 1980. This function is SYSTEM dependant. This version is meant to work on
% a Windows machine.
%   Created by Marc Benoit on 8/1/2014

% PARAMETER
formatIn = 'mm/dd/yyyy HH:MM AM';                                          % Date Format

% FUNCTION
[~,fileinfo] = system(['dir "' LOCATION '"']);                             % CALL SYTEM DIR (GET FILE SIZE AND DATE)
if strfind(fileinfo,'The device is not ready.')                            % RETURN IF Device not ready
    list=[];return;
elseif strfind(fileinfo,'File Not Found')                                  % RETURN IF NO FILES
    list=[];return;
end

cell_out=textscan(fileinfo,'%s','delimiter','\n','HeaderLines',5);         % READ fileinfo

list=struct('name',1,'date',1,'bytes',1,'isdir',1,'datenum',1);            % ALLOCATE MEMORY FOR LIST STRUCTURE
for i=1:size(cell_out{1,1},1)-2
    
    line=cell_out{1,1}{i,1};
    line_info=textscan(line,'%s %s %s %s %s');
    list(i,1).name=line_info{1,5}{1,1}; 
    list(i,1).datenum=datenum([line_info{1,1}{1,1}...                      % DEFINE DATENUM INTO STRUCTURE
         ' ' line_info{1,2}{1,1} ...                                       % DEFINE DATENUM INTO STRUCTURE
         ' ' line_info{1,3}{1,1} ],formatIn); 
    list(i,1).date=datestr(list(i,1).datenum,'dd-mmm-yyyy HH:MM:SS');      % DEFINE DATE INTO STRUCTURE
     
    if strfind(line,'<DIR>') % IF DIRECTORY
       list(i,1).bytes=0;
       list(i,1).isdir=true;      
    else                     % IF FILE
       list(i,1).bytes=str2double(strrep(line_info{1,4}{1,1}, ',', ''));   % DEFINE BYTES INTO STRUCTURE
       list(i,1).isdir=false;    
    end
  
end
