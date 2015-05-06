function [handles] = update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimut,z_positive,ZenUTM )

if isnan(SX_azimut)
    SX_azimut=0;
    set(handles.SX_azimut_box,'String',num2str(SX_azimut));
end

if isnan(S_space)
    S_space=1;
    set(handles.s_space_box,'String',num2str(S_space));
end

if isnan(A_space)
    A_space=100;
    set(handles.a_space_box,'String',num2str(A_space));
end


CMP={'Ex' 'Ey' 'Hx' 'Hy' 'Hz' 'Off'};
TX={'TX1' 'TX2' 'Ex' 'Ey' 'Hx' 'Hy' 'Hz' 'Off'};

if handles.main.type==1 % TX
	column1=TX;
    label_title='Tx#/Ant#/E-Length(m)';
elseif handles.main.type==0   % RX
	column1=CMP;
    label_title='Ant#/E-Length(m)';
end

ColumnWidth=get(handles.geometry_table,'ColumnWidth');

if UTM_toggle==1   
    
    ColumnWidth{1,6}=100;
    ColumnWidth{1,7}=100;
    ColumnWidth{1,8}=100;
    ColumnWidth{1,9}=100;
    ColumnName={'Cmp';'(-) x';'(-) y';'(+) x';'(+) y';'(-) North'; ...
        '(-) East';'(+) North';'(+) East'};
    ColumnEditable=[true,true,true,true,true,false,false,false,false];
    ColumnFormat = {column1,'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'};
    

    set(handles.voltage_info,'Visible','off');
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
    
    size(DATA,2)
    if size(DATA,2)>9
    DATA(:,10:11)=[];
    end
   
    
elseif UTM_toggle==0
    
    ColumnWidth{1,6}=105;
    ColumnWidth{1,7}=60;
    ColumnWidth{1,8}=60;
    ColumnWidth{1,9}=70;
    ColumnWidth{1,10}=80;
    ColumnWidth{1,11}=50;
    ColumnName={'Cmp';'(-) x';'(-) y';'(+) x';'(+) y';label_title;'Azm/Inc';'SP (mV)';'Max (mV)';'CRES (Kohm)';'Files'};
    ColumnEditable=[true,true,true,true,true,true,true,false,false,false,false];
    ColumnFormat = {column1,'numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric','numeric'};

    set(handles.voltage_info,'Visible','on');
    set(handles.check_setup,'Visible','on');
    set(handles.utm_zone_str,'Visible','off');
    set(handles.altitude_str,'Visible','off');
    

    
     for i=1:size(DATA,1)
         
              
       % E-Field
       if isempty(DATA{i,1});continue;end
           
       if strcmp(DATA{i,1}(1:2),'Ex')
           DATA{i,6}=sqrt((DATA{i,2}-DATA{i,4})^2+(DATA{i,3}-DATA{i,5})^2)*A_space/S_space; 
           DATA{i,7} = mod(180/pi*atan2(DATA{i,3}-DATA{i,5},DATA{i,2}-DATA{i,4})+SX_azimut+180,360);
           
       elseif strcmp(DATA{i,1}(1:2),'Ey')
           
          if z_positive~=handles.z_prev
           temp1=DATA{i,2};
           DATA{i,2}=DATA{i,4};
           DATA{i,4}=temp1;
           temp1=DATA{i,3};
           DATA{i,3}=DATA{i,5};
           DATA{i,5}=temp1;
          end
           
           DATA{i,6}=sqrt((DATA{i,2}-DATA{i,4})^2+(DATA{i,3}-DATA{i,5})^2)*A_space/S_space; 
           DATA{i,7} = mod(180/pi*atan2(DATA{i,3}-DATA{i,5},DATA{i,2}-DATA{i,4})+SX_azimut,360);
           

       end
       
       if strcmp(DATA{i,1}(1),'E') && DATA{i,2}==0 && DATA{i,3}==0 && DATA{i,4}==0 && DATA{i,5}==0
           DATA{i,7}=NaN;
       end
       
           
       % H-Field
       if strcmp(DATA{i,1}(1),'H')
           if ~isempty(handles.Ant)
                DATA{i,6}=handles.Ant.num{i};
                if strcmp(DATA{i,1}(1:2),'Hz')
                DATA{i,7}=handles.Ant.azm{i};    
                else
                DATA{i,7}=mod(handles.Ant.azm{i},360);
                end
           else
                DATA{i,6}=[];
                DATA{i,7}=[];  
           end
       end
       
       
       % TX
       if strcmp(DATA{i,1}(1:2),'TX')
           DATA{i,6}=handles.TX.sn{i};
           DATA{i,7} = mod(180/pi*atan2(DATA{i,3}-DATA{i,5},DATA{i,2}-DATA{i,4})+SX_azimut+180,360);
       end
       if strcmp(DATA{i,1}(1:2),'TX') && DATA{i,2}==0 && DATA{i,3}==0 && DATA{i,4}==0 && DATA{i,5}==0
           DATA{i,7}=NaN; 
       end
       
     % CRES
     if ~strcmp(DATA{i,1}(1:2),'Of')
        DATA{i,10}=handles.CRES_values{i};
     else
         DATA{i,10}='';
     end
     
     % SP
     if ~strcmp(DATA{i,1}(1:2),'Of')
        DATA{i,8}=handles.SP{i};
     else
         DATA{i,8}='';
     end
     
     % SP
     if ~strcmp(DATA{i,1}(1:2),'Of')
        DATA{i,9}=handles.MaxV{i};
     else
         DATA{i,9}='';
     end
     
     DATA{i,11}=handles.Nb_of_File{i};
     
       
     end

     
end

set(handles.geometry_table,'ColumnName',ColumnName,'ColumnEditable',ColumnEditable,'ColumnFormat',ColumnFormat,'ColumnWidth',ColumnWidth);
set(handles.geometry_table,'Data',DATA);


global tequila_status
if tequila_status==true
    display_layout( handles )
end

end

