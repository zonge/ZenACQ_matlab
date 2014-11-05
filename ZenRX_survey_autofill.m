function [ handles ] = ZenRX_survey_autofill( handles,eventdata )
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
update=false;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% IF NOT UTM
if UTM_toggle==0
   
    % SAVE H-FIELD ANT#, AZM and SAVE TX info
    for i=1:size(eventdata.Source.Data,1)
       if isempty(eventdata.Source.Data{i,1});continue;end
       if strcmp(eventdata.Source.Data{i,1}(1),'H')
            handles.Ant.num{i}=eventdata.Source.Data{i,6};
            handles.Ant.azm{i}=eventdata.Source.Data{i,7};
       end
       if strcmp(eventdata.Source.Data{i,1}(1),'T')
            handles.TX.type{i}=eventdata.Source.Data{i,8};
            handles.TX.sn{i}=eventdata.Source.Data{i,9};
       end
    end

    
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
    set(handles.geometry_table,'Data',eventdata.Source.Data)
    return;
end
end
end

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

% E-FIELD autofill
if eventdata.Indices(2)<8 && eventdata.Indices(2)>5
    % UPDATE stn location if H-field
    if strcmp(Cmp{1,1}(1),'E')
            eventdata.Source.Data{eventdata.Indices(1),eventdata.Indices(2)}=eventdata.PreviousData;
            beep
            set(handles.error_msg,'Visible','on','String','Length and Azimut for E cmp cannot be changed !')
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

DATA=eventdata.Source.Data;
handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM,update );

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
handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM,update );

end



end

