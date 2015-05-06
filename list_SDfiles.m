function [ List_Files,Nb_of_Files,status ] = list_SDfiles( obj,ch_num )

if iscell(obj)
LL=size(obj,2);
else
LL=1;
end
List_Files=cell(1,LL);
Nb_of_Files=zeros(1,LL);
status=true;
for i=1:LL
    
    if iscell(obj)
        [~,~,data]=QuickSendReceive(obj{i},'listfiles',25,'ListFilesCommandCompleted',0);
    else
        [~,~,data]=QuickSendReceive(obj,'listfiles',25,'ListFilesCommandCompleted',0);
    end
    
    
    if ~isempty(data.Query{1,1})
        
            str = strjoin(data.Query');str(str==' ') = '';
            z_blank=textscan(str,'%s','delimiter','----');
            z_all=z_blank{1,1}(~cellfun('isempty',z_blank{1,1})); 
            NbofLines=find(~cellfun(@isempty,strfind(z_all,'(null)'))==1);
        
        % if no SD cards
        d=find(~cellfun(@isempty,strfind(z_all,'tinitialize,can'))==1, 1);
        if ~isempty(d);h=errordlg(['SD card not found on channel : ' num2str(ch_num)],'SD Error');uiwait(h);status=false;Nb_of_Files=NaN;return;end
            
            if isempty(NbofLines)
                z=[];
            else
            z=cell(size(NbofLines,1),1);
            for j=1:size(NbofLines,1)
                z{j,1}=z_all{NbofLines(j)};
            end
            end
        
    else
        z=[];
    end

    if ~isempty(z)
        
         for j=1:size(z,1)
            z_cut= textscan(z{j,1},'%s%f%s%s','delimiter',';');
            list.name{j,1}=z_cut{1,3}{1,1};
            list.size{j,1}=z_cut{1,2};
         end

         List_Files{i}=list;
         Nb_of_Files(i)=size(list.name,1);
        
    else
        
        List_Files{i}=[];
        Nb_of_Files=0;
        
    end
end

end

