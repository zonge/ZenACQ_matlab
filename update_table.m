function [handles] = update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimut,z_positive,ZenUTM,update )

if nargin==8
    update=true;
end

if isnan(SX_azimut)
    SX_azimut=0;
    set(handles.SX_azimut_box,'String',num2str(SX_azimut));
end

if isnan(S_space)
    S_space=1;
    set(handles.s_space_box,'String',num2str(S_space))
end

if isnan(A_space)
    A_space=100;
    set(handles.a_space_box,'String',num2str(A_space))
end

if z_positive==2
    degree_offset=-180;
elseif z_positive==1
    degree_offset=0;
end
CMP={'Ex' 'Ey' 'Hx' 'Hy' 'Hz' 'Off'};
TX={'TX1' 'TX2' 'TX3' 'TX4' 'Off'};
ZongeTX={'GGT-30' 'GGT-10' 'GGT-3' 'ZT-30' 'NT-20'};

if UTM_toggle==1   
    
        if handles.main.type==1 % TX
    ColumnName={'TX';'(-) x';'(-) y';'(+) x';'(+) y';'(-) North'; ...
        '(-) East';'(+) North';'(+) East'};
    ColumnWidth={50,52,52,52,52,86,85,86,85};
    ColumnEditable=[true,true,true,true,true,false,false,false,false];
    column1=TX;
    ColumnFormat = {column1,'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'};
        
        elseif handles.main.type==0 % RX
    
    ColumnName={'Cmp';'(-) x';'(-) y';'(+) x';'(+) y';'(-) North'; ...
        '(-) East';'(+) North';'(+) East'};   
    ColumnWidth={50,52,52,52,52,86,85,86,85};
    ColumnEditable=[true,true,true,true,true,false,false,false,false];
    column1=CMP;
    ColumnFormat = {column1,'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'};
        end
    set(handles.check_setup,'Visible','off');
    set(handles.utm_zone_str,'Visible','on')
    set(handles.altitude_str,'Visible','on')
    for i=1:size(DATA,1)

       if isempty(DATA{i,1});continue;end
        
       if strcmp(DATA{i,1}(1),'H') || strcmp(DATA{i,1}(1),'E') || strcmp(DATA{i,1}(1),'T')
          DATA{i,6}=ZenUTM.X+DATA{i,2}*A_space/S_space;
          DATA{i,7}=ZenUTM.Y+DATA{i,3}*A_space/S_space;
          DATA{i,8}=ZenUTM.X+DATA{i,4}*A_space/S_space;
          DATA{i,9}=ZenUTM.Y+DATA{i,5}*A_space/S_space;
       end      
     
    end
    
    if size(DATA,2)>9
    DATA(:,10)=[];
    end
    
elseif UTM_toggle==0

    if handles.main.type==1 % TX
    ColumnName={'TX';'(-) x';'(-) y';'(+) x';'(+) y';'E-Length(m)'; ...
        'Azm';'TX type';'TX Serial #'};
    ColumnWidth={50,52,52,52,52,86,85,86,85};
    ColumnEditable=[true,true,true,true,true,false,false,true,true];
    column1=TX;
    ColumnFormat = {column1,'numeric','numeric','numeric','numeric','numeric','numeric',ZongeTX,'char'};
    for i=1:size(DATA,1)
    if isempty(DATA{i,1});continue;end
    if strcmp(DATA{i,1}(1:2),'TX')
           DATA{i,6}=sqrt((DATA{i,2}-DATA{i,4})^2+(DATA{i,3}-DATA{i,5})^2)*A_space/S_space;
           DATA{i,7}=mod(asin((DATA{i,2}-DATA{i,4})*(A_space/S_space)/DATA{i,6})*180/pi+90+SX_azimut,360); 
           if ~isempty(handles.TX)
           DATA{i,8}=handles.TX.type{i};
           DATA{i,9}=handles.TX.sn{i}; 
           end
           
    end
    end
    if size(DATA,2)>9
        DATA(:,10)=[];
    end
    

    
    elseif handles.main.type==0   % RX
    ColumnName={'Cmp';'(-) x';'(-) y';'(+) x';'(+) y';'Ant#/E-Length(m)'; ...
        'Azm/Inc(°)';'AC Voltage';'SP';'CRES'};
    ColumnWidth={50,52,52,52,52,102,65,70,53,52};
    ColumnEditable=[true,true,true,true,true,true,true,false,false,false];
    column1=CMP;
    ColumnFormat = {column1,'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'};

    set(handles.check_setup,'Visible','on');
    set(handles.utm_zone_str,'Visible','off')
    set(handles.altitude_str,'Visible','off')
    for i=1:size(DATA,1)
           % CHECK SETUP
           if handles.CRES_values{i}~=0
               DATA{i,8}=[];
               DATA{i,9}=[];
               DATA{i,10}=handles.CRES_values{i};
           else
               DATA{i,8}=[];
               DATA{i,9}=[];
               DATA{i,10}=[];
           end
           
       % E-lenght and Azimuth
       if isempty(DATA{i,1});continue;end
       
       if strcmp(DATA{i,1}(1),'E')
           DATA{i,6}=sqrt((DATA{i,2}-DATA{i,4})^2+(DATA{i,3}-DATA{i,5})^2)*A_space/S_space;
           DATA{i,7}=mod(asin((DATA{i,2}-DATA{i,4})*(A_space/S_space)/DATA{i,6})*180/pi+90+SX_azimut,360);      
       end
       
       
       if strcmp(DATA{i,1}(1),'H')
           if ~isempty(handles.Ant)
                DATA{i,6}=handles.Ant.num{i};
                DATA{i,7}=mod(handles.Ant.azm{i},360); 
           else
                DATA{i,6}=[];
                DATA{i,7}=[];  
           end
       end

      if update==true
      if strcmp(DATA{i,1},'Ey') || strcmp(DATA{i,1},'Hy')
         DATA{i,7}=DATA{i,7}+degree_offset;      
      end
        
      if strcmp(DATA{i,1},'Hy')
         DATA{i,7} = DATA{i,7}+SX_azimut;
      end
      end
       
    end
    end
end

set(handles.geometry_table,'ColumnName',ColumnName,'ColumnWidth',ColumnWidth,'ColumnEditable',ColumnEditable,'ColumnFormat',ColumnFormat)

set(handles.geometry_table,'Data',DATA)


end

