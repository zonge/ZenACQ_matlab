function varargout = ZenSCH(varargin)
% ZENSCH MATLAB code for ZenSCH.fig

% Last Modified by GUIDE v2.5 10-Sep-2014 15:34:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenSCH_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenSCH_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ZenSCH is made visible.
function ZenSCH_OpeningFcn(hObject, ~, handles, varargin)


% Choose default command line output for ZenSCH
handles.output = hObject;


ZenACQ_vars=getappdata(0,'tunnel');  % GET VARIABLES FROM ZenACQ
handles.edit_file=getappdata(0,'tunnel2');  % GET VARIABLES FROM ZenACQ

handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;

if handles.edit_file.status==true

% CREATE SCH OBJ
handles.SCHEDULE = m_get_sch_obj( handles.edit_file.file,handles,true );
handles.SCHEDULE=handles.SCHEDULE.OBJ;

% GET NUMBER OF SCHEDULE
handles.nb_schedule=size(handles.SCHEDULE,1);
 
% UPDATE TABLE
l_sch_set_table( handles,handles.nb_schedule ); 

% SET TITLE
[~,file_name,~] = fileparts(handles.edit_file.file);
set(handles.schedule_name_box,'String',file_name);

% SET TOTAL TIME
l_sch_total_time( handles,handles.nb_schedule ); 


else

% GET NUMBER OF SCHEDULE
handles.nb_schedule=0;

end

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = ZenSCH_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function schedule_name_box_Callback(~, ~, ~)
% hObject    handle to schedule_name_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of schedule_name_box as text
%        str2double(get(hObject,'String')) returns contents of schedule_name_box as a double


% --- Executes during object creation, after setting all properties.
function schedule_name_box_CreateFcn(hObject, ~, ~)
% hObject    handle to schedule_name_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function day_box_Callback(~, ~, ~)
% hObject    handle to day_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of day_box as text
%        str2double(get(hObject,'String')) returns contents of day_box as a double


% --- Executes during object creation, after setting all properties.
function day_box_CreateFcn(hObject, ~, ~)
% hObject    handle to day_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hour_box_Callback(~, ~, ~)
% hObject    handle to hour_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hour_box as text
%        str2double(get(hObject,'String')) returns contents of hour_box as a double


% --- Executes during object creation, after setting all properties.
function hour_box_CreateFcn(hObject, ~, ~)
% hObject    handle to hour_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_box_Callback(~, ~, ~)
% hObject    handle to min_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_box as text
%        str2double(get(hObject,'String')) returns contents of min_box as a double


% --- Executes during object creation, after setting all properties.
function min_box_CreateFcn(hObject, ~, ~)
% hObject    handle to min_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sec_box_Callback(~, ~, ~)
% hObject    handle to sec_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sec_box as text
%        str2double(get(hObject,'String')) returns contents of sec_box as a double


% --- Executes during object creation, after setting all properties.
function sec_box_CreateFcn(hObject, ~, ~)
% hObject    handle to sec_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SR_popup.
function SR_popup_Callback(~, ~, ~)
% hObject    handle to SR_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SR_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SR_popup


% --- Executes during object creation, after setting all properties.
function SR_popup_CreateFcn(hObject, ~, ~)
% hObject    handle to SR_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in gain_popup.
function gain_popup_Callback(~, ~, ~)
% hObject    handle to gain_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns gain_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from gain_popup


% --- Executes during object creation, after setting all properties.
function gain_popup_CreateFcn(hObject, ~, ~)
% hObject    handle to gain_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_push.
function save_push_Callback(~, ~, handles)
% hObject    handle to save_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc

Sch_name=get(handles.schedule_name_box,'String');
if isempty(Sch_name)
    beep
    set(handles.error_display,'Visible','on','String',handles.language.ZenSCH_err1)
    set(handles.schedule_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.schedule_name_box,'BackgroundColor','white')
    pause(0.1)
    set(handles.schedule_name_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.schedule_name_box,'BackgroundColor','white')
    return;
else
    set(handles.error_display,'Visible','off')
end

if handles.nb_schedule==0
    beep
    set(handles.error_display,'Visible','on','String',handles.language.ZenSCH_err2)
   return; 
end

folder='schedule';
if ~exist(folder,'dir');mkdir(folder);end
file_name=[folder filesep Sch_name '.sch'];
formatSpec='$schline%i = %i;%i;%i\n';
fid = fopen(file_name, 'w');
for i=1:handles.nb_schedule
    duration=handles.SCHEDULE(i).duration;  
    sr=handles.SCHEDULE(i).sr;
    gain=handles.SCHEDULE(i).gain;
    
    fprintf(fid,formatSpec,i,duration,sr,gain);

end
fclose(fid);

% UPDATE config file

l_modif_file( handles.main.Setting_ext,'$Rx_schedule_selected',Sch_name )

SCH.last_schedule=Sch_name;

setappdata(0,'tunnelback',SCH);        % SET GLOBAL VARIABLE

close(ZenSCH);   % CLOSE ZenSCH



% --- Executes on button press in delete_push.
function delete_push_Callback(hObject, ~, handles)
% hObject    handle to delete_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get data
data = get(handles.schedule_tbl,'Data');
if isempty(data)
    return;
end
% get indices of selected rows
rows = get(handles.schedule_tbl,'UserData');
if isempty(rows)
    rows=handles.nb_schedule;
end

if rows~=0
% create mask containing rows to keep
mask = (1:size(data,1))';
mask(rows) = [];
% delete selected rows and re-write data
data = data(mask,:);
set(handles.schedule_tbl,'Data',data);

handles.SCHEDULE(rows)=[];

handles.nb_schedule=handles.nb_schedule-size(rows,1);

set(handles.schedule_tbl,'UserData',[]);

l_sch_total_time( handles,handles.nb_schedule );

end

guidata(hObject, handles);

% --- Executes on button press in up_push.
function up_push_Callback(hObject, ~, handles)
% hObject    handle to up_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get data
data = get(handles.schedule_tbl,'Data');
if isempty(data)
    return;
end
% get indices of selected rows
rows = get(handles.schedule_tbl,'UserData');
if isempty(rows)
    return;
elseif size(rows,1)>1
    beep
    set(handles.error_display,'Visible','on','String',handles.language.ZenSCH_err3);
    return;
elseif rows==1
    return;
end
set(handles.error_display,'Visible','off');
mask=data(rows-1,:);
data(rows-1,:)=data(rows,:);
data(rows,:)=mask;

mask_obj=handles.SCHEDULE(rows-1);
handles.SCHEDULE(rows-1)=handles.SCHEDULE(rows);
handles.SCHEDULE(rows)=mask_obj;

set(handles.schedule_tbl,'Data',data);

set(handles.schedule_tbl,'UserData',[]);

guidata(hObject, handles);


% --- Executes on button press in down_push.
function down_push_Callback(hObject, ~, handles)
% hObject    handle to down_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get data
data = get(handles.schedule_tbl,'Data');
if isempty(data)
    return;
end
% get indices of selected rows
rows = get(handles.schedule_tbl,'UserData');
if isempty(rows)
    return;
elseif size(rows,1)>1
    beep
    set(handles.error_display,'Visible','on','String',handles.language.ZenSCH_err3);
    return;
elseif rows==handles.nb_schedule
    return;
end
set(handles.error_display,'Visible','off')
mask=data(rows+1,:);
data(rows+1,:)=data(rows,:);
data(rows,:)=mask;

mask_obj=handles.SCHEDULE(rows+1);
handles.SCHEDULE(rows+1)=handles.SCHEDULE(rows);
handles.SCHEDULE(rows)=mask_obj;

set(handles.schedule_tbl,'Data',data);

set(handles.schedule_tbl,'UserData',[]);

guidata(hObject, handles);


% --- Executes on button press in add_push.
function add_push_Callback(hObject, ~, handles)
% hObject    handle to add_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=l_sch_add_line(handles);

guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in schedule_tbl.
function schedule_tbl_CellSelectionCallback(~, eventdata, handles)
% hObject    handle to schedule_tbl (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% get indices of selected rows and make them available for other callbacks
index = eventdata.Indices;
if any(index)             %loop necessary to surpress unimportant errors.
    rows = index(:,1);
    set(handles.schedule_tbl,'UserData',rows);
end


% --- Executes on key press with focus on day_box and none of its controls.
function duration_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to day_box (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

typee = eventdata.Key;
if size(typee,2)>5
if strcmp(typee(1:6),'numpad')
    typee=typee(7:end);
end
end

if strcmp(typee,'backspace') || strcmp(typee,'return') || strcmp(typee,'shift') || strcmp(typee,'shift') ...
        || strcmp(typee,'control') || strcmp(typee,'capslock') || strcmp(typee,'leftarrow') ...
        || strcmp(typee,'uparrow') || strcmp(typee,'downarrow') || strcmp(typee,'rightarrow') ...
        || strcmp(typee,'alt')
    return;
end
if ~ismember(typee, '1234567890')
    %warndlg('Not a number')
    beep
    set(handles.error_display,'Visible','on','String',handles.language.ZenSCH_err4);
    set(hObject,'String','');
else
    set(handles.error_display,'Visible','off');
end

guidata(hObject, handles);


% --- Executes on key press with focus on add_push and none of its controls.
function add_push_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to add_push (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if strcmp(eventdata.Key,'return')
handles=l_sch_add_line(handles);
end

guidata(hObject, handles);


% --- Executes when user attempts to close ZenSCH.
function ZenSCH_CloseRequestFcn(hObject, ~, ~)
% hObject    handle to ZenSCH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: delete(hObject) closes the figure
delete(hObject);
