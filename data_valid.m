function [ Files , Paths, Names,test,j] = data_valid( path, TS_start,handles )
%  clear all
%  path='R:\Dev_Field_Testing\Marc_RD\ZQC\DATA\2014-05-27\08_36_marc.benoit_ZEN1\ZenRawData';
%  TS_start=4;

%Format of Date & Time
formatIn = 'yyyy-mm-dd HH:MM:SS';
slash='/'; if ispc==1;slash='\'; end
%% Look for subdirtories

[files] = data_findZ3D(path,handles);

all_Files=cell(size(files,2),7);

%% Detect all files
test=0;
j=0;
for k=1:size(files,1)
    j=j+1;

    % Check start time
    [pathstr, file_name, ext] = fileparts(files{k,1});
    fid = fopen(files{k,1});
    header = fscanf(fid,'%c',512);
    HEADER=textscan(header,'%s','delimiter',',');
    fclose(fid);

    build_software=str2double(parsing(HEADER{1,1},'Main.hex',':=',2));
    channel=str2double(parsing(HEADER{1,1},'channel',':=',2));
    
    if build_software>=2672 && build_software<2680
       
       date_time{1,1}{1,1}=parsing(HEADER{1,1},'Schedule.Date','=',2);
       time_separate=textscan(parsing(HEADER{1,1},'Schedule.Time','=',2),'%s','delimiter',':');
 
    elseif build_software>=2680
       
       fid = fopen(files{k,1});
       header = fscanf(fid,'%c',1024);
       HEADER=textscan(header,'%s','delimiter',';');
       fclose(fid);
       
       date_time{1,1}{1,1}=parsing(HEADER{1,1},'Schedule.Date','=',2);
       time_separate=textscan(parsing(HEADER{1,1},'Schedule.Time','=',2),'%s','delimiter',':');
 
    else % build_software<2672
       date_time{1,1}{1,1}=parsing(HEADER{1,1},'Schedule',':',2);
       time_separate=textscan(HEADER{1,1}{19,1},'%s','delimiter',':');
    end
    
    
       date_time{1,1}{2,1}=time_separate{1,1}{1,1};
       date_time{1,1}{3,1}=time_separate{1,1}{2,1};
       date_time{1,1}{4,1}=time_separate{1,1}{3,1};
    

    all_Files{j,1}=[files{k,1}];
    java_call = java.io.File(all_Files{j,1});
    bytes_size = length(java_call);
    all_Files{j,2}=[file_name ext];
    all_Files{j,3}=[pathstr '/'];
    all_Files{j,4}=bytes_size;
    all_Files{j,5}=datenum([date_time{1,1}{1,1} ' ' date_time{1,1}{2,1} ':' date_time{1,1}{3,1} ':' date_time{1,1}{4,1} ],formatIn);
    all_Files{j,6}=file_name;
    all_Files{j,7}=channel ;
    
    adSR=str2double(parsing(HEADER{1,1},'rate',':=',2));
    
    
    %%Stop if files are smaller than ... bytes
    min_value=(TS_start*4*adSR)+4096;
    
    if (all_Files{j,4}<min_value)
        test=test+1;
        name.small{test}=all_Files{j,1};
    end

end

all_Files=sortrows(all_Files,5);

%% Allocate cell memory
schedule=all_Files(1,5);
inc=1;
n=0;
n_max=0;
for m=1:j
   if all_Files{m,5}~=schedule{1,1}
      schedule{1,1}=all_Files{m,5};
      inc=inc+1;
      n=0;
   end
   n=n+1;
   if n>n_max
       n_max=n;
   end
   title.cnames{n} =['File(s):' num2str(n)] ;
   title.rnames{inc} =['sch : ' num2str(inc)] ;
end

%% Restructure matrice 
Files=cell(inc,n_max);
Names=cell(inc,n_max);
Names_short=cell(inc,n_max);
Paths=cell(inc,n_max);
Bytes=cell(inc,n_max);
schedule=all_Files(1,5);
inc=1;
n=0;
for m=1:j
   if all_Files{m,5}~=schedule{1,1}
      schedule{1,1}=all_Files{m,5};
      inc=inc+1;
      n=0;
   end
   n=n+1;
   
   Files{inc,n}=all_Files{m,1}; 
   Names{inc,n}=all_Files{m,2}; 
   Paths{inc,n}=all_Files{m,3};
   Bytes{inc,n}=all_Files{m,4}; 
   Names_short{inc,n}=all_Files{m,6}; 
end

%% Check missing files
missing_files_pos=find(cellfun(@isempty,Bytes)==1);
for i=1:length(missing_files_pos)
    Bytes{missing_files_pos(i)}=0;
end

%%

data1=check_unity(cell2mat(Bytes),0.05,'%'); % Files size differences

f = figure('Position',[300 100 650 700],'Name','Files/Size(bytes)','MenuBar','none');
uitable('Parent',f,'Data',Names_short,'ColumnName',title.cnames,... 
            'RowName',title.rnames,'Position',[20 350 600 300]);
        
uitable('Parent',f,'Data',data1,'ColumnName',title.cnames,... 
            'RowName',title.rnames,'Position',[20 40 600 300]);
        
uicontrol('Parent',f,'String','Next ...',...
              'Position',[280 2 72 36],'Callback', 'close');
          
print(f,'-djpeg','-r400',[path slash 'file_summary'])

if test~=0

    choice2 = questdlg(['Some file(s) are too small and will not be readable,Please delete then :' name.small ], ...
	'Warning !!','Delete','Stop','Delete');

       if strcmp(choice2,'Stop')
           test=-1;
           close('Files/Size(bytes)')
       else
           test=-2;
           for i=1:size(name.small,2)
               copyfile(name.small{i},[name.small{i}(1:end-3) '$Z3D'])
               delete(name.small{i})
           end
               Files=[];
               Paths=[];
               Names=[];
               j=[];
               close('Files/Size(bytes)')
               return
       end
end

waitfor(f);
