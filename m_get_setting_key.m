function [ keys ] = m_get_setting_key( ext,handles,display_msg)
% DEFINES VALUE FOR THE ASSOCIATED KEYWORDS
% INPUT  : file_content (cell array)
% OUTPUT : lan (structure)

%  Created by Marc Benoit for Zonge International on Aug/31/2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keys=[];

% GET CONTENT
file_content=l_get_file_content( ext,handles,display_msg );

%if ~isempty(file_content)
    
    % DEFINE KEY WORDS !
    keys.z3d_location=l_search_key('$z3d_location',file_content);
    keys.Rx_geometry_selected_MT=l_search_key('$Rx_geometry_selected_MT',file_content,ext);
    keys.Rx_geometry_selected_IP_RX=l_search_key('$Rx_geometry_selected_IP_RX',file_content,ext);
    keys.Rx_geometry_selected_IP_TX=l_search_key('$Rx_geometry_selected_IP_TX',file_content,ext);
    keys.Rx_schedule_selected=l_search_key('$Rx_schedule_selected',file_content,ext);
    keys.time_zone=l_search_key('$time_zone',file_content,ext);
    keys.ZenACQ_mode=l_search_key('$ZenACQ_mode',file_content,ext);
    
    
    
    
%end

end

