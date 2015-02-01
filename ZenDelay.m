function varargout = ZenDelay(varargin)
% ZENDELAY MATLAB code for ZenDelay.fig
%      ZENDELAY, by itself, creates a new ZENDELAY or raises the existing
%      singleton*.
%
%      H = ZENDELAY returns the handle to a new ZENDELAY or the handle to
%      the existing singleton*.
%
%      ZENDELAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZENDELAY.M with the given input arguments.
%
%      ZENDELAY('Property','Value',...) creates a new ZENDELAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ZenDelay_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ZenDelay_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ZenDelay

% Last Modified by GUIDE v2.5 13-Jan-2015 12:29:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenDelay_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenDelay_OutputFcn, ...
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


% --- Executes just before ZenDelay is made visible.
function ZenDelay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ZenDelay (see VARARGIN)

% Choose default command line output for ZenDelay
handles.output = hObject;

% INI
ZenACQ_vars=getappdata(0,'tunnel');  % GET VARIABLES FROM ZenACQ

handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;
handles.SCHEDULE=ZenACQ_vars.SCHEDULE;
handles.late=ZenACQ_vars.late;
handles.prev_start_time=ZenACQ_vars.start_time;



if handles.late==true
    set(handles.unlock,'Visible','on');
    date_now=datestr(ZenACQ_vars.official_start_time,'dd mmm yyyy');
    hour_now=str2double(datestr(ZenACQ_vars.official_start_time,'HH'));
    min_now=str2double(datestr(ZenACQ_vars.official_start_time,'MM'));
    
elseif handles.late==false
    set(handles.unlock,'Visible','off');
    date_now_val= addtodate(now, handles.main.extra_time, 'second');
    date_now=datestr(date_now_val,'dd mmm yyyy');
    hour_now=0;
    min_now=0;
end

    set(handles.date_push,'String',date_now);
    set(handles.hour_popup,'Value',hour_now+1);
    set(handles.min_popup,'Value',min_now+1);

handles.late=false;

% UPDATE GUI
handles=l_Rx_update_time( handles );

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ZenDelay wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ZenDelay_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function hour_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hour_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function min_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE START TIME (DATE) ++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function date_push_Callback(hObject, ~, handles)

set(handles.error_msg,'Visible','on','String','');

% Initialize JIDE's usage within Matlab
com.mathworks.mwswing.MJUtilities.initJIDE;
 
% Display a DateChooserPanel
jPanel = com.jidesoft.combobox.DateChooserPanel;
jPanel.setShowWeekNumbers(false);
[hPanel,hContainer] = javacomponent(jPanel,[10,18,650,370],gcf);
set(hPanel,'ShowTodayButton',false);
set(hPanel,'ShowNoneButton',false);
handles.jPanel=jPanel;
hModel = handle(hPanel.getSelectionModel, 'CallbackProperties');

set(hPanel, 'ItemStateChangedCallback', {@myCallbackFunction,hObject,handles,jPanel,hModel,hContainer});

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE START TIME (MIN) +++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function min_popup_Callback(hObject, ~, handles)

set(handles.error_msg,'Visible','on','String','');

% UPDATE GUI
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE START TIME (HOUR) ++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function hour_popup_Callback(hObject, ~, handles)

set(handles.error_msg,'Visible','on','String','');

% UPDATE GUI    
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CALANDER CALLBACK +++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function myCallbackFunction(~, ~,hObject,handles,jPanel,hModel,hContainer)

selectedDate = hModel.getSelectedDate();
dayNumber  = get(selectedDate, 'Date');
monthVal   = get(selectedDate, 'Month');
yearVal    = get(selectedDate, 'Year');
DateVector = [num2str(1900+yearVal) '-' num2str(monthVal+1) '-' num2str(dayNumber)];
date_str= datestr(datenum(DateVector,'yyyy-mm-dd'),'dd mmm yyyy');
set(handles.date_push,'String',date_str);
jPanel.setVisible(false);
delete(hContainer)

% UPDATE GUI
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% --- Executes on button press in apply_action.
function apply_action_Callback(hObject, eventdata, handles)
% hObject    handle to apply_action (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dif0=handles.prev_start_time-now;
if dif0<0
    msg='The start time (ZenACQ window) cannot be anterior to the actual time (now).'; 
    set(handles.error_msg,'Visible','on','String',msg)
    return;
end

dif=handles.prev_start_time-handles.start_time;

if dif<0
    msg='Date and time of the orginal start time must be anterior to the late start time';
    beep
    set(handles.error_msg,'Visible','on','String',msg)
    set(handles.hour_popup,'BackgroundColor','red')
    set(handles.min_popup,'BackgroundColor','red')
    set(handles.date_push,'BackgroundColor','red')
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.min_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.date_push,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor','red')
    set(handles.min_popup,'BackgroundColor','red')
    set(handles.date_push,'BackgroundColor','red')
    pause(0.1)
    set(handles.hour_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.min_popup,'BackgroundColor',[1.0 0.949 0.867])
    set(handles.date_push,'BackgroundColor',[1.0 0.949 0.867])
    return;
    
end


ZenACQ_vars.SCHEDULE=handles.SCHEDULE;
ZenACQ_vars.LATE=true;
ZenACQ_vars.start_time=handles.start_time;
ZenACQ_vars.NEW_END_TIME=get(handles.end_time_str,'String');
setappdata(0,'tunnelback_ZenDelay',ZenACQ_vars);                % SET GLOBAL VARIABLE

close(ZenDelay);


% --- Executes on button press in unlock.
function unlock_Callback(hObject, eventdata, handles)
% hObject    handle to unlock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ZenACQ_vars.SCHEDULE=handles.SCHEDULE;
ZenACQ_vars.LATE=false;
setappdata(0,'tunnelback_ZenDelay',ZenACQ_vars);                % SET GLOBAL VARIABLE

close(ZenDelay);
