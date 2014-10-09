function [ files ] = data_findZ3D(topLevelFolder,handles)
%topLevelFolder is string with starting folder
%files is a cell array with complete path names to all files with the
%extension Z3D in the folder structure beneath topLevelFolder

% Create Cell array of all subdirectories
% Cut into strings, and find all files called *.z3d.

%clear all
%topLevelFolder='C:\Users\marc.benoit\Desktop\ZEN\ZenData\testCAL';

slash='/'; if ispc==1;slash='\'; end
dirdelimiter=':';if ispc==1;dirdelimiter=';'; end
sub_folder=genpath_fixed(topLevelFolder);
%sub_folder=genpath(topLevelFolder);
all_sub_cut=textscan(sub_folder,'%s','delimiter',dirdelimiter);
LL=length(all_sub_cut{1,1});

% SET PROGRESS BAR
progress = waitbar(0,'Please wait while processing...','Position',...
    [handles.main.GUI.left_bar handles.main.GUI.bottom_bar ...
         handles.main.GUI.width_bar handles.main.GUI.height_bar]);

%% Allocate memory (get size of folderspath)
k=0;
for i=1:LL

dir_info=dir_fixed([all_sub_cut{1,1}{i,1} slash '*.Z3D';]);
%dir_info=dir([all_sub_cut{1,1}{i,1} slash '*.Z3D';]);

for j=1:size(dir_info,1)
    if ~strcmp(dir_info(j,1).name,'ZDONE.Z3D')   % IGNORE ZDONE.Z3D
        k=k+1;
    end
end

% Progress bar
        pourcentage=[sprintf('%0.2f',(i/(LL*2))*100) ' %'];
        waitbar((i/(LL*2)),progress,sprintf('%s',pourcentage));

end
files=cell(k,1);


%% Find Z3Ds
k=0;
for i=1:LL
dir_info=dir_fixed([all_sub_cut{1,1}{i,1} slash '*.Z3D';]);
%dir_info=dir([all_sub_cut{1,1}{i,1} slash '*.Z3D';]);
for j=1:size(dir_info,1)
   if ~strcmp(dir_info(j,1).name,'ZDONE.Z3D')   % IGNORE ZDONE.Z3D
k=k+1;
files{k,1}=[all_sub_cut{1,1}{i,1} slash dir_info(j,1).name];
   end
end

% Progress bar
        pourcentage=[sprintf('%0.2f',((i+LL)/(LL*2))*100) ' %'];
        waitbar(((i+LL)/(LL*2)),progress,sprintf('%s',pourcentage));

end

close(progress)