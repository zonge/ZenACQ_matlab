function [] = m_get_design( main_file,handles,display_msg )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Sep/7/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % FIND KEY WORDS AND DEFINE OBJECT !
    max_rows=size(handles.CHANNEL.ch_info,2);
        tbl_content=cell(max_rows,4);
    % initialized tbl_content
    for i=1:max_rows
        for j=1:4
           tbl_content{i,j}='';
        end
    end
    
     % FIND CHANNEL #
     ch_num=zeros(max_rows,1);
     for i=1:size(handles.CHANNEL.ch_info,2)
         ch_num(i,1)=handles.CHANNEL.ch_info{1,i}.ChNb;
     end
     ch_num=sort(ch_num);

% GET CONTENT
if ~isempty(main_file)
file_content=l_get_file_content( main_file,handles,display_msg );

    
    % CHECK HOW MANY LINE OF THE FILE TO READ BASED ON THE NUMBER OF CHANNELS PRESENT
    if max_rows<size(file_content,1)
        nb_of_file_line=max_rows;
    else
        nb_of_file_line=size(file_content,1);
    end
    
    % CREATE TABLE TO DISPLAY
    for i=1:nb_of_file_line
        key_sch=l_search_key(['$geometryline' num2str(i)],file_content,main_file);
        geo=textscan(key_sch,'%s%s%s%s','delimiter','|');
        for j=1:4
            if isempty(geo{1,j})
                geo{1,j}{1,1}='';
            end
        end       
        tbl_content{i,1}=geo{1,1}{1,1};
        tbl_content{i,2}=geo{1,2}{1,1};
        tbl_content{i,3}=geo{1,3}{1,1};
        tbl_content{i,4}=geo{1,4}{1,1};

    end

end
    
    set(handles.geometry_table,'data',tbl_content,'RowName',ch_num)

end