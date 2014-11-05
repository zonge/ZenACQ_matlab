function varargout = ZenOptions(varargin)
% ZENOPTIONS MATLAB code for ZenOptions.fig

% Last Modified by GUIDE v2.5 13-Oct-2014 12:54:11

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

tabgp = uitabgroup('Position',[0.11 0.105 0.756 0.377]);
tab1 = uitab(tabgp,'Title','MTFT estimates');
tab2 = uitab(tabgp,'Title','ECR limits');

uicontrol(tab1,'Style',...
                  'pushbutton',...
                  'String','Calculate',...
                  'Position',[150 60 120 40],...
                  'FontSize',12,...
                  'Units','normalized',...
                  'HandleVisibility','off',...
                  'Callback',@(hObject,eventdata)ZenOptions('MTestimates_button_Callback',hObject,eventdata,guidata(hObject)));


uicontrol(tab2,'Style',...
                  'pushbutton',...
                  'String','Calculate',...
                  'Position',[285 70 120 40],...
                  'FontSize',12,...
                  'Units','normalized',...
                  'HandleVisibility','off',...
                  'Callback',@(hObject,eventdata)ZenOptions('CRES_max_Callback',hObject,eventdata,guidata(hObject)));

handles.E_lenght=uicontrol(tab2,'Style',...
                  'edit',...
                  'Tag','E_lenght',...
                  'Position',[10 70 100 40],...
                  'FontSize',12,...
                  'Units','normalized',...
                  'HandleVisibility','off');
              
handles.Freq=uicontrol(tab2,'Style',...
                  'popupmenu',...
                  'Tag','Freq',...
                  'String',num2cell(2.^(-5:10)),...
                  'Position',[150 67 100 40],...
                  'FontSize',12,...
                  'Units','normalized',...
                  'HandleVisibility','off');
              
handles.Freq_str=uicontrol(tab2,'Style',...
                  'text',...
                  'String','TX Freq (Hz)',...
                  'Position',[140 115 120 20],...
                  'HorizontalAlignment','center',...
                  'FontSize',10,...
                  'Units','normalized',...
                  'HandleVisibility','off');

handles.dipole_str=uicontrol(tab2,'Style',...
                  'text',...
                  'String','Dipole Length (m)',...
                  'Position',[3 115 120 20],...
                  'HorizontalAlignment','center',...
                  'FontSize',10,...
                  'Units','normalized',...
                  'HandleVisibility','off');
              
handles.Result_CRES=uicontrol(tab2,'Style',...
                  'text',...
                  'Tag','Result_CRES',...
                  'Position',[10 10 400 40],...
                  'HorizontalAlignment','center',...
                  'FontSize',12,...
                  'Units','normalized',...
                  'HandleVisibility','off');
                  

              
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


% --- Executes on button press in MTestimates_button.
function MTestimates_button_Callback(hObject, eventdata, handles)
% hObject    handle to MTestimates_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% SET VARIABLE to the other windows
ZenAQC_vars.main=handles.main;
ZenAQC_vars.setting=handles.setting;
ZenAQC_vars.language=handles.language;
setappdata(0,'tunnel',ZenAQC_vars);

% RUN ZenOptions
ZenMTestimates


% --- Executes on button press in CRES_max.
function CRES_max_Callback(hObject, eventdata, handles)
% hObject    handle to CRES_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

E_lenght=get(handles.E_lenght,'String');  % in meter

if isnan(str2double(E_lenght)) ||  isempty(E_lenght)
    beep
    set(handles.E_lenght,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.E_lenght,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.E_lenght,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.E_lenght,'BackgroundColor',[1 1 1])
    pause(0.1)
    return ;
end

Freq_Strs=get(handles.Freq,'String');
Freq=str2double(Freq_Strs(get(handles.Freq,'Value')));

Max_Cres=2/(Freq*(str2double(E_lenght)/1000));

set(handles.Result_CRES,'String',['Max CRES : ' num2str(Max_Cres) ' kohm'],...
                'ForegroundColor','red','FontWeight','bold');

