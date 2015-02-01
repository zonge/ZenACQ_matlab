function [handles] = m_get_design( main_file,handles,display_msg )
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Sep/7/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % FIND KEY WORDS AND DEFINE OBJECT !
    max_rows=size(handles.CHANNEL.ch_info,2);
    tbl_content=cell(max_rows,9);
    
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
        if handles.main.type==1 % TX
            geo=textscan(key_sch,'%s%s%s%s%s%s%s%s%s','delimiter','|');
        elseif handles.main.type==0 % RX
            geo=textscan(key_sch,'%s%s%s%s%s%s%s','delimiter','|');
        end
        for j=1:7
            if isempty(geo{1,j})
                geo{1,j}{1,1}='';
            end
        end       
        tbl_content{i,1}=geo{1,1}{1,1};
        if ~strcmp(geo{1,1}{1,1},'Off') && ~strcmp(geo{1,1}{1,1},'')
        tbl_content{i,2}=str2double(geo{1,2}{1,1});
        tbl_content{i,3}=str2double(geo{1,3}{1,1});
        tbl_content{i,4}=str2double(geo{1,4}{1,1});
        tbl_content{i,5}=str2double(geo{1,5}{1,1});
        tbl_content{i,6}=str2double(geo{1,6}{1,1});
        tbl_content{i,7}=str2double(geo{1,7}{1,1});
        end
        handles.Ant.num{i}=str2double(geo{1,6}{1,1});
        handles.Ant.azm{i}=str2double(geo{1,7}{1,1});
        if handles.main.type==1
        handles.TX.type{i}=geo{1,8}{1,1};
        handles.TX.sn{i}=geo{1,9}{1,1};
        end
    end
    
    
    key_Line=l_search_key('$geometryXstn',file_content,main_file);
    if strcmp(key_Line,'$geometryXstn')
        set(handles.Xstn_box,'String','')    
    else
        % set(handles.Xstn_box,'String',key_Line) WE want the user to be
        % force to enter a station every time
        set(handles.Xstn_box,'String','')
    end

    key_Line=l_search_key('$geometryYstn',file_content,main_file);
    if strcmp(key_Line,'$geometryYstn')
        set(handles.Ystn_box,'String','')    
    else
        set(handles.Ystn_box,'String',key_Line)
    end
    
    key_Line=l_search_key('$geometryLineName',file_content,main_file);
    if strcmp(key_Line,'$geometryLineName')
        set(handles.line_box,'String','')    
    else
        set(handles.line_box,'String',key_Line)
    end
    
    key_Line=l_search_key('$geometryLineAzimuth',file_content,main_file);
    if strcmp(key_Line,'$geometryLineAzimuth')
        set(handles.SX_azimut_box,'String','')    
    else
        set(handles.SX_azimut_box,'String',key_Line)
    end

    key_Line=l_search_key('$geometryAspace',file_content,main_file);
    if strcmp(key_Line,'$geometryAspace')
        set(handles.a_space_box,'String','')    
    else
        set(handles.a_space_box,'String',key_Line)
    end
    
    key_Line=l_search_key('$geometrySspace',file_content,main_file);
    if strcmp(key_Line,'$geometrySspace')
        set(handles.s_space_box,'String','')    
    else
        set(handles.s_space_box,'String',key_Line)
    end
    
    key_Line=l_search_key('$geometryZpositive',file_content,main_file);
    if strcmp(key_Line,'$geometryZpositive')
        set(handles.z_positive,'Value',1)    
    else
        set(handles.z_positive,'Value',str2double(key_Line))
    end
    
end
    
    set(handles.geometry_table,'data',tbl_content,'RowName',ch_num)

end