function varargout = ZenSettings(varargin)
% ZENSETTINGS MATLAB code for zensettings.fig

% Last Modified by GUIDE v2.5 23-Jan-2015 15:28:12

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenSettings_OutputFcn, ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before zensettings is made visible --- %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZenSettings_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for zensettings
handles.output = 'Yes';

% GET PARAMETERS FROM ZenACQ
ZenACQ_vars=getappdata(0,'tunnel');
handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;

config_file_name = 'ZenACQ.cfg';
if exist(config_file_name,'file')==2
handles.setting = m_get_setting_key(config_file_name,handles,true);
set(handles.timezone_box,'String',handles.setting.time_zone);
set(handles.ZenACQ_mode_popup,'Value',str2double(handles.setting.ZenACQ_mode));
set(handles.storage_loc_box,'String',handles.setting.z3d_location);
end

% LANGUAGE
set(handles.zenACQ_mode_str,'String',handles.language.zenACQ_mode_str) 
set(handles.time_zone_str,'String',handles.language.time_zone_str) 
set(handles.example_str,'String',handles.language.example_str) 
set(handles.storage_location_str,'String',handles.language.storage_location_str) 
set(handles.get_folder_push,'String',handles.language.get_folder_push_str) 
set(handles.save_push,'String',handles.language.save_push_str) 

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes zensettings wait for user response (see UIRESUME)
uiwait(handles.ZenSettings);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% GET FOLDER LOCATION  ++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function get_folder_push_Callback(~, ~, handles)

folder_name = uigetdir(cd,'Zen data Storage Location');
set(handles.storage_loc_box,'String',folder_name)

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% TIME ZONE  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function timezone_box_Callback(~, ~, ~)

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ZenACQ mode  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ZenACQ_mode_popup_Callback(~, ~, ~)

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SAVE  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function save_push_Callback(hObject, ~, handles)

z3d_location=get(handles.storage_loc_box,'String');
time_zone=str2double(get(handles.timezone_box,'String'));
ZenACQ_mode_popup=get(handles.ZenACQ_mode_popup,'Value');
if isnan(time_zone)
    beep
    set(handles.timezone_box,'Visible','on','String','')
    set(handles.timezone_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.timezone_box,'BackgroundColor','white')
    pause(0.1)
    set(handles.timezone_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.timezone_box,'BackgroundColor','white')
    return;
end

l_modif_file( handles.main.Setting_ext,'$z3d_location',z3d_location);
l_modif_file( handles.main.Setting_ext,'$time_zone',num2str(time_zone));
l_modif_file( handles.main.Setting_ext,'$ZenACQ_mode',num2str(ZenACQ_mode_popup));

% Update handles structure
guidata(hObject, handles);

% Get the updated handles structure.
uiresume(handles.ZenSettings);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ACTION WHEN GUI IS CLOSING ++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ZenSettings_CloseRequestFcn(hObject, ~, ~)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ACTION WHEN A KEYPRESS ++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ZenSettings_KeyPressFcn(hObject, ~, handles)

% Check for "enter" or "escape"
if isequal(get(hObject,'CurrentKey'),'escape')
    % User said no by hitting escape
    handles.output = 'No';
    
    % Update handles structure
    guidata(hObject, handles);
    
    uiresume(handles.ZenSettings);
end    
    
if isequal(get(hObject,'CurrentKey'),'return')
    uiresume(handles.ZenSettings);
end    


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% GENERATE OUTPUT TO CMD ++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function varargout = ZenSettings_OutputFcn(~, ~, handles)
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.ZenSettings);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CREATE FUNCTION  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function storage_loc_box_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');end
function timezone_box_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');end
function ZenACQ_mode_popup_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');end
