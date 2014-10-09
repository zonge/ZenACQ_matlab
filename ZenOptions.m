function varargout = ZenOptions(varargin)
% ZENOPTIONS MATLAB code for ZenOptions.fig

% Last Modified by GUIDE v2.5 29-Sep-2014 01:33:02

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenOptions_OutputFcn, ...
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



% --- Executes just before ZenOptions is made visible.
function ZenOptions_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for ZenOptions
handles.output = hObject;

if exist('done.fir','file')==2
    delete('done.fir')
end

% GET PARAMETERS FROM ZenACQ
ZenACQ_vars=getappdata(0,'tunnel');
handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ZenOptions wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ZenOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Nb_fft_coef.
function Nb_fft_coef_Callback(hObject, eventdata, handles)
% hObject    handle to Nb_fft_coef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in SR_popup.
function SR_popup_Callback(hObject, eventdata, handles)
% hObject    handle to SR_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SR_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SR_popup


% --- Executes during object creation, after setting all properties.
function SR_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SR_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function day_box_Callback(hObject, eventdata, handles)
% hObject    handle to day_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of day_box as text
%        str2double(get(hObject,'String')) returns contents of day_box as a double


% --- Executes during object creation, after setting all properties.
function day_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to day_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hour_box_Callback(hObject, eventdata, handles)
% hObject    handle to hour_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hour_box as text
%        str2double(get(hObject,'String')) returns contents of hour_box as a double


% --- Executes during object creation, after setting all properties.
function hour_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hour_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_box_Callback(hObject, eventdata, handles)
% hObject    handle to min_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_box as text
%        str2double(get(hObject,'String')) returns contents of min_box as a double


% --- Executes during object creation, after setting all properties.
function min_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sec_box_Callback(hObject, eventdata, handles)
% hObject    handle to sec_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sec_box as text
%        str2double(get(hObject,'String')) returns contents of sec_box as a double


% --- Executes during object creation, after setting all properties.
function sec_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sec_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in upgrade_firmware.
function upgrade_firmware_Callback(hObject, eventdata, handles)
% hObject    handle to upgrade_firmware (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

installARM(handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

upgrade_msg=get(handles.upgrade_msg,'String');


if strcmp(upgrade_msg,'Firmware is upgraded')
        delete(hObject);
elseif isempty(upgrade_msg)
        delete(hObject);
else
    beep
    set(handles.upgrade_msg,'String','Wait for the upgrade to finish ...');
end
