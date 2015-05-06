function [ handles ] = ZenRX_layout_autofill( handles,eventdata )
% Update survey table when any change happens.
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data

% by Marc Benoit 
% on 28/10/2014 
% for Zonge International

UTM_toggle=get(handles.utm_checkbox,'Value');    %returns toggle state of utm_checkbox
A_space=str2double(get(handles.a_space_box,'String'));
S_space=str2double(get(handles.s_space_box,'String'));
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IF NOT UTM
if UTM_toggle==0
    
% DO something depending on COMPONENTS
Cmp=eventdata.Source.Data(eventdata.Indices(1));
if isempty(Cmp{1,1});return;end


% Inititate H-field
if eventdata.Indices(2)==1
if ~isempty(eventdata.PreviousData)
if strcmp(eventdata.NewData(1),'H') && strcmp(eventdata.PreviousData(1),'E') 
    for i=6:7
        eventdata.Source.Data{eventdata.Indices(1),i}=[];
    end
    %eventdata.NewData(1:2)
    set(handles.geometry_table,'Data',eventdata.Source.Data)
    %return;
end
end
end

% Initiate Hz
if eventdata.Indices(2)==1
if strcmp(eventdata.NewData(1:2),'Hz')
            
           if z_positive==1
            eventdata.Source.Data{eventdata.Indices(1),7}=abs(90);
           elseif z_positive==2
            eventdata.Source.Data{eventdata.Indices(1),7}=-abs(90);
           end
end
end

if strcmp(Cmp{1,1},'TX1') 
    for n=1:size(eventdata.Source.Data,1)
       if strcmp(eventdata.Source.Data{n,1},'TX1') && strcmp(eventdata.PreviousData,'Off')
           eventdata.Source.Data{eventdata.Indices(1),2}=eventdata.Source.Data{n,2};
           eventdata.Source.Data{eventdata.Indices(1),3}=eventdata.Source.Data{n,3};
           eventdata.Source.Data{eventdata.Indices(1),4}=eventdata.Source.Data{n,4};
           eventdata.Source.Data{eventdata.Indices(1),5}=eventdata.Source.Data{n,5};
           eventdata.Source.Data{eventdata.Indices(1),6}=eventdata.Source.Data{n,6};
       end
       if strcmp(eventdata.Source.Data{n,1},'TX1')
            eventdata.Source.Data{n,2}=eventdata.Source.Data{eventdata.Indices(1),2};
            eventdata.Source.Data{n,3}=eventdata.Source.Data{eventdata.Indices(1),3};
            eventdata.Source.Data{n,4}=eventdata.Source.Data{eventdata.Indices(1),4};
            eventdata.Source.Data{n,5}=eventdata.Source.Data{eventdata.Indices(1),5};
            eventdata.Source.Data{n,6}=eventdata.Source.Data{eventdata.Indices(1),6};
       end
    end
end

if strcmp(Cmp{1,1},'TX2') 
    for n=1:size(eventdata.Source.Data,1)
       if strcmp(eventdata.Source.Data{n,1},'TX2') && strcmp(eventdata.PreviousData,'Off')
           eventdata.Source.Data{eventdata.Indices(1),2}=eventdata.Source.Data{n,2};
           eventdata.Source.Data{eventdata.Indices(1),3}=eventdata.Source.Data{n,3};
           eventdata.Source.Data{eventdata.Indices(1),4}=eventdata.Source.Data{n,4};
           eventdata.Source.Data{eventdata.Indices(1),5}=eventdata.Source.Data{n,5};
           eventdata.Source.Data{eventdata.Indices(1),6}=eventdata.Source.Data{n,6};
       end
       if strcmp(eventdata.Source.Data{n,1},'TX2')
            eventdata.Source.Data{n,2}=eventdata.Source.Data{eventdata.Indices(1),2};
            eventdata.Source.Data{n,3}=eventdata.Source.Data{eventdata.Indices(1),3};
            eventdata.Source.Data{n,4}=eventdata.Source.Data{eventdata.Indices(1),4};
            eventdata.Source.Data{n,5}=eventdata.Source.Data{eventdata.Indices(1),5};
            eventdata.Source.Data{n,6}=eventdata.Source.Data{eventdata.Indices(1),6};
       end
    end
end

% IF OFF
if strcmp(Cmp{1,1},'Off')
    for i=2:10
    eventdata.Source.Data{eventdata.Indices(1),i}=[];
    end
    set(handles.geometry_table,'Data',eventdata.Source.Data)
    return
elseif strcmp(Cmp{1,1}(1),'E') || strcmp(Cmp{1,1}(1),'H') || strcmp(Cmp{1,1}(1),'T')
    for i=2:5
        if isempty( eventdata.Source.Data{eventdata.Indices(1),i})
            eventdata.Source.Data{eventdata.Indices(1),i}=0;
        end
    end
end


% H-field autofill the X(-),Y(-),X(+),Y(+)
if eventdata.Indices(2)==2 || eventdata.Indices(2)==4
    if eventdata.Indices(2)==1; return;end
    if strcmp(Cmp{1,1}(1),'H')
        eventdata.Source.Data{eventdata.Indices(1),2}=eventdata.NewData;
        eventdata.Source.Data{eventdata.Indices(1),4}=eventdata.NewData;
    end
elseif eventdata.Indices(2)==3 || eventdata.Indices(2)==5
    if eventdata.Indices(2)==1; return;end
    if strcmp(Cmp{1,1}(1),'H')
        eventdata.Source.Data{eventdata.Indices(1),3}=eventdata.NewData;
        eventdata.Source.Data{eventdata.Indices(1),5}=eventdata.NewData;
    end
end

% H-Field Check Antenna
if eventdata.Indices(2)==6
    if strcmp(Cmp{1,1}(1),'H')

        filepath =['calibrate\' handles.main.calibrate_file_name];        
        if exist(filepath,'file')==2 % CHECK IF FILE EXIST
        [~,ant_list] = read_antenna_file( filepath ); % CHECK IF ANTENNA EXIST
        ant_exist=find(ant_list==eventdata.NewData, 1);
        if isempty(ant_exist) % IF IT DOESN"T EXIST BEEP AND MESSAGE
           beep

           %msgbox(['#' num2str(eventdata.NewData) ' is not found in ' handles.main.calibrate_file_name '.' ]);
           choice = listdlg('PromptString','Available Antenna Cal:',...
                'SelectionMode','single',...
                'Name','Antenna list',...
                'ListString',cellfun(@num2str,num2cell(ant_list),'UniformOutput',false));
            if isempty(choice)
                eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=str2double('');
            else
                eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=ant_list(choice);
            end
        end
        else
           beep
           msgbox('No Antenna file found'); 
        end
    end
end


% TX Check TX
if eventdata.Indices(2)==6
    if strcmp(Cmp{1,1}(1:2),'TX')

        filepath =['calibrate\' handles.main.TX_cal_file_name];        
        if exist(filepath,'file')==2 % CHECK IF FILE EXIST
        [TX,tx_list]=read_tx_file( filepath );
        tx_exist=find(cellfun(@isempty,strfind(tx_list,num2str(eventdata.NewData)))==0, 1);
        if isempty(tx_exist) % IF IT DOESN"T EXIST BEEP AND MESSAGE
           beep
           choice = listdlg('PromptString','Available TX:',...
                'SelectionMode','single',...
                'Name','TX list',...
                'ListString',tx_list);
            if isempty(choice)
                eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=NaN;
            else
                for i=1:size(TX,1);if strcmp(TX(i).Serial,tx_list{choice});break;end;end         
                helpdlg({['Chosen TX # : '  TX(i).Serial];['Type : ' TX(i).Type];['Sense : ' TX(i).Sense]},'Selected TX');
                eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=str2double(tx_list{choice});
            end
            
        else % IF TX VALUE IS FOUND IN TX.CAL
            for i=1:size(TX,1);if strcmp(TX(i).Serial,num2str(eventdata.NewData));break;end;end         
            helpdlg({['Chosen TX # : '  TX(i).Serial];['Type : ' TX(i).Type];['Sense : ' TX(i).Sense]},'Selected TX');
        end
        
        else % IF NO TX FILE
            msgbox('No TX file found'); 
            eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=NaN;
        end
    end
end


% E-FIELD autofill
if eventdata.Indices(2)<8 && eventdata.Indices(2)>5
    % UPDATE stn location if H-field
    if strcmp(Cmp{1,1}(1),'E')
            eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.PreviousData;
            beep
            set(handles.error_msg,'Visible','on','String','Length and Azimuth cannot be changed for E cmp !')
    else
            set(handles.error_msg,'Visible','on','String','')
    end
end

if eventdata.Indices(2)<5 && eventdata.Indices(2)>1
    if strcmp(Cmp{1,1}(1),'H') || strcmp(Cmp{1,1}(1),'E') 
        if isnan(eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)})
        eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=0;
        end
        set(handles.error_msg,'Visible','on','String','')
    end
end

% Force Hz to be between 0 and 90.
if eventdata.Indices(2)==7
    if strcmp(Cmp{1,1}(1:2),'Hz')
        if abs(eventdata.NewData)>90 || abs(eventdata.NewData)<0
            beep
            eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.PreviousData;
            set(handles.error_msg,'Visible','on','String','Inclinaison is between 0 and 90 degrees')
        else
           if z_positive==1
            eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=abs(eventdata.NewData);
           elseif z_positive==2
            eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=-abs(eventdata.NewData);
           end
            set(handles.error_msg,'Visible','on','String','')
        end
    end
end



    % SAVE H-FIELD ANT#, AZM and SAVE TX info
    for i=1:size(eventdata.Source.Data,1)
       if isempty(eventdata.Source.Data{i,1});continue;end
       if strcmp(eventdata.Source.Data{i,1}(1),'H')
            handles.Ant.num{i}=eventdata.Source.Data{i,6};
            handles.Ant.azm{i}=eventdata.Source.Data{i,7};
       end
       if strcmp(eventdata.Source.Data{i,1}(1),'T')
            handles.TX.sn{i}=eventdata.Source.Data{i,6};
       end
    end
    
    % Save entered value if X azimuth or Z changes
    if eventdata.Indices(2)==7
        handles.ant_raw_val{eventdata.Indices(1),1}{1,1}=z_positive;
        handles.ant_raw_val{eventdata.Indices(1),1}{1,2}=SX_azimuth;
        handles.ant_raw_val{eventdata.Indices(1),1}{1,3}=eventdata.NewData;
    end

DATA=eventdata.Source.Data;
handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

set(handles.geometry_table,'Data',eventdata.Source.Data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif UTM_toggle==1  % IF UTM Toggle activated.
    
% DO something depending on COMPONENTS
Cmp=eventdata.Source.Data(eventdata.Indices(1));
if isempty(Cmp{1,1});return;end
    
% IF OFF
if strcmp(Cmp{1,1},'Off')
    for i=2:9
    eventdata.Source.Data{eventdata.Indices(1),i}=[];
    end
    set(handles.geometry_table,'Data',eventdata.Source.Data)
    return
elseif strcmp(Cmp{1,1}(1),'E') || strcmp(Cmp{1,1}(1),'H') || strcmp(Cmp{1,1}(1),'T')
    for i=2:5
        if isempty( eventdata.Source.Data{eventdata.Indices(1),i})
            eventdata.Source.Data{eventdata.Indices(1),i}=0;
        end
    end
end


% H-field autofill
if eventdata.Indices(2)==2 || eventdata.Indices(2)==4
    if eventdata.Indices(2)==1; return;end
    if strcmp(Cmp{1,1}(1),'H')
        eventdata.Source.Data{eventdata.Indices(1),2}=eventdata.NewData;
        eventdata.Source.Data{eventdata.Indices(1),4}=eventdata.NewData;
    end
elseif eventdata.Indices(2)==3 || eventdata.Indices(2)==5
    if eventdata.Indices(2)==1; return;end
    if strcmp(Cmp{1,1}(1),'H')
        eventdata.Source.Data{eventdata.Indices(1),3}=eventdata.NewData;
        eventdata.Source.Data{eventdata.Indices(1),5}=eventdata.NewData;
    end
end

    if eventdata.Indices(2)<5 && eventdata.Indices(2)>1
    if strcmp(Cmp{1,1}(1),'H') || strcmp(Cmp{1,1}(1),'E') 
        if isnan(eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)})
        eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.NewData;
        end
    end
    end

    
DATA=eventdata.Source.Data;
handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

end



end

