function varargout = ZenRX(varargin)
% ZENRX MATLAB code for zenrx.fig
%      ZENRX set the receiver information and commit the action

% Last Modified by GUIDE v2.5 09-Oct-2014 06:10:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenRX_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenRX_OutputFcn, ...
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
% --- Executes just before ZenRX is made visible --- %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZenRX_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for zenrx
handles.output = hObject;

% INITIALIZATION OF THE GUI
handles = ZenRX_ini(handles);

% Update handles structure
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  1 GENERAL INFORMATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function stn_box_Callback(~, ~, handles)
set(handles.error_msg,'String','');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  2. SURVEY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SURVEY SELECTION ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function design_popup_Callback(hObject, ~, handles)

contents = cellstr(get(hObject,'String'));
main_file=['design' filesep contents{get(hObject,'Value')} '.geo'];

% UPDATE TABLE
m_get_design( main_file,handles,false )


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SAVE SURVEY +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function save_push_Callback(hObject, ~, handles)

geometry_tbl=get(handles.geometry_table,'data');

% SAVE SURVEY
handles = ZenRX_save_survey( handles,geometry_tbl );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CRES ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function get_cres_Callback(~, ~, handles)

% STOP TIMER
stop(handles.timer_RX);

% CALCULATE AND DISPLAY CRES
handles = ZenRX_Cres( handles );

% START TIMER
start(handles.timer_RX);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  3. SCHEDULE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% NEW SCHEDULE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function new_push_Callback(hObject, ~, handles)

edit_file.status=false;

% create new schedule and update GUI
handles = ZenRX_schedule( handles,edit_file );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% EDIT SCHEDULE +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function edit_push_Callback(hObject, ~, handles)

contents = cellstr(get(handles.schedule_popup,'String'));
file_name=contents{get(handles.schedule_popup,'Value')};

edit_file.file=['schedule' filesep file_name '.sch'];
edit_file.status=true;

% edit schedule and update GUI
handles = ZenRX_schedule( handles,edit_file );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SCHEDULE SELECTION ++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function schedule_popup_Callback(hObject, ~, handles)

contents = cellstr(get(hObject,'String'));
main_file=['schedule' filesep contents{get(hObject,'Value')} '.sch'];

% CREATE SCH OBJ
handles.SCHEDULE = m_get_sch_obj( main_file,handles,true );
set(handles.quick_summary_str,'String',handles.SCHEDULE.SUMMARY);
 
% UPDATE GUI
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE START TIME (DATE) ++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function date_push_Callback(hObject, ~, handles)

% Initialize JIDE's usage within Matlab
com.mathworks.mwswing.MJUtilities.initJIDE;
 
% Display a DateChooserPanel
jPanel = com.jidesoft.combobox.DateChooserPanel;
jPanel.setShowWeekNumbers(false);
[hPanel,hContainer] = javacomponent(jPanel,[10,250,730,350],gcf);
set(hPanel,'ShowTodayButton',false);
set(hPanel,'ShowNoneButton',false);
handles.jPanel=jPanel;
hModel = handle(hPanel.getSelectionModel, 'CallbackProperties');

set(hPanel, 'ItemStateChangedCallback', {@myCallbackFunction,handles,jPanel,hModel,hContainer});

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE START TIME (MIN) +++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function min_popup_Callback(hObject, ~, handles)

% UPDATE GUI
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE START TIME (HOUR) ++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function hour_popup_Callback(hObject, ~, handles)

% UPDATE GUI    
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CALANDER CALLBACK +++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function myCallbackFunction(~, ~,handles,jPanel,hModel,hContainer)

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
l_Rx_update_time( handles );



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  3. OTHERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% COMMIT ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function set_up_Callback(hObject, ~, handles)

% STOP TIMER
stop(handles.timer_RX);

% COMMIT ACTION
handles = ZenRX_commit( handles );

% START TIMER
start(handles.timer_RX);

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ACTION WHEN GUI IS CLOSING ++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ZenRX_CloseRequestFcn(hObject, ~, ~)

% DELETE EXISTING TIMER
Rx_timer=timerfind('Name','Rx_timer');
if ~isempty(Rx_timer)
    stop(Rx_timer);
    Rx_timer_status=Rx_timer.Running;
    while strcmp(Rx_timer_status,'on')
        Rx_timer_status=Rx_timer.Running;
    end
    delete(Rx_timer);
end

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

% Close figure
 delete(hObject);
 

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% GENERAL CREATE FUNCTION +++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 function general_CreateFcn(hObject, ~, ~)
 if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');end
 

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% GENERATE OUTPUT TO CMD ++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function varargout = ZenRX_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
