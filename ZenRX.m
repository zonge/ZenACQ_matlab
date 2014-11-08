function varargout = ZenRX(varargin)
% ZENRX MATLAB code for zenrx.fig
%      ZENRX set the receiver and transmiter information
% and commit/transmit the action

% Last Modified by GUIDE v2.5 05-Nov-2014 12:24:14

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

% BOX
function job_name_box_Callback(~, ~, ~)
function job_number_box_Callback(~, ~, ~)
function job_by_box_Callback(~, ~, ~)
function job_for_box_Callback(~, ~, ~)
function job_operator_box_Callback(~, ~, ~)

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
% USER PARAMETERS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function Xstn_box_Callback(hObject, ~, handles)

set(handles.error_msg,'Visible','off');
Zen_stn=get(hObject,'String');

if isnan(str2double(Zen_stn))==1 || str2double(Zen_stn) ~= floor(str2double(Zen_stn))
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.input_err1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor','red')
    pause(0.1)
    set(handles.Xstn_box,'BackgroundColor',[1.0 0.949 0.867])  
    set(hObject,'String',[]);
    return;       
end

 geometry_tbl=get(handles.geometry_table,'data');

 
 for i=1:size(geometry_tbl,1)
      if isempty(geometry_tbl{i,1})
         geometry_tbl{i,1}='Off';
      end
 end

set(handles.geometry_table,'data',geometry_tbl)
set(handles.geometry_table,'Enable','on')
Ystn_box_str=get(handles.Ystn_box,'String');
if isempty(Ystn_box_str)
    set(handles.Ystn_box,'String','0')
end
set(handles.geometry_table,'Enable','on')
set(handles.line_box,'Enable','on')
set(handles.line_str,'Enable','on')
set(handles.SX_azimut_box,'Enable','on')
set(handles.SX_azimut_str,'Enable','on')
set(handles.a_space_str,'Enable','on')
set(handles.a_space_box,'Enable','on')
set(handles.s_space_str,'Enable','on')
set(handles.s_space_box,'Enable','on')
set(handles.save_push,'Enable','on')

if handles.main.type==0 % RX
set(handles.check_setup,'Enable','on')
set(handles.z_positive_str,'Enable','on')
set(handles.z_positive,'Enable','on')
end

function Ystn_box_Callback(hObject, ~, handles)
    
set(handles.error_msg,'Visible','off');
Zen_stn=get(hObject,'String');

if isnan(str2double(Zen_stn))==1 || str2double(Zen_stn) ~= floor(str2double(Zen_stn))
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.input_err1)
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor',[1.0 0.949 0.867])
    pause(0.1)
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor',[1.0 0.949 0.867])  
    set(hObject,'String',[]);
    return;       
end 
function line_box_Callback(hObject, ~, handles)

Line_num=get(hObject,'String');
if ~isempty(Line_num)
if size(Line_num,2)>16  % CHECK LINE.NUMBER <17
    beep
    set(handles.error_msg,'Visible','on','String',handles.language.input_err2)
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor','white')
    pause(0.1)
    set(hObject,'BackgroundColor','red')
    pause(0.2)
    set(hObject,'BackgroundColor','white')  
    set(hObject,'String',[]);
    return;       
end
end
function SX_azimut_box_Callback(hObject, ~, handles)

    
    SX_azimuth=str2double(get(hObject,'String'));
    if SX_azimuth<0 || SX_azimuth>360 || isnan(SX_azimuth)  % CHECK FOR VALUE OUT OF RANGE
        beep
        set(handles.error_msg,'Visible','on','String',handles.language.input_err3)
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        set(hObject,'String',0);
        return;
    end
    

    UTM_toggle=get(handles.utm_checkbox,'Value'); %returns toggle state of utm_checkbox
    DATA=get(handles.geometry_table,'Data');
    A_space=str2double(get(handles.a_space_box,'String')); 
    S_space=str2double(get(handles.s_space_box,'String')); 
    z_positive=get(handles.z_positive,'Value');
    ZenUTM.X=get(handles.utm_zone_str,'Value');
    ZenUTM.Y=get(handles.altitude_str,'Value');

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);
function a_space_box_Callback(hObject, ~, handles)

    
    set(handles.error_msg,'Visible','off')
    A_space=str2double(get(hObject,'String')); % CHECK FOR VALUE OUT OF RANGE
    if isnan(A_space)
        beep
        set(handles.error_msg,'Visible','on','String',handles.language.input_err4)
        set(hObject,'BackgroundColor','red')
        pause(0.1)
        set(hObject,'BackgroundColor',[0.941 0.941 0.941])
        pause(0.1)
        set(hObject,'BackgroundColor','red')
        pause(0.1)
        set(hObject,'BackgroundColor',[0.941 0.941 0.941])
        set(hObject,'String',[]);
    end
    
    
UTM_toggle=get(handles.utm_checkbox,'Value'); %returns toggle state of utm_checkbox
DATA=get(handles.geometry_table,'Data');
S_space=str2double(get(handles.s_space_box,'String'));   
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);
function s_space_box_Callback(hObject, ~, handles)


    % CHECK FOR VALUE OUT OF RANGE
    set(handles.error_msg,'Visible','off')
    S_space=str2double(get(hObject,'String'));
    if isnan(S_space)
        beep
        set(handles.error_msg,'Visible','on','String','Must be an number !')
        set(hObject,'BackgroundColor','red')
        pause(0.1)
        set(hObject,'BackgroundColor',[0.941 0.941 0.941])
        pause(0.1)
        set(hObject,'BackgroundColor','red')
        pause(0.1)
        set(hObject,'BackgroundColor',[0.941 0.941 0.941])
        set(hObject,'String',num2str(1));
    end
    

UTM_toggle=get(handles.utm_checkbox,'Value'); %returns toggle state of utm_checkbox
DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String'));   
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);
function z_positive_Callback(hObject, ~, handles)

z_positive=get(hObject,'Value');

UTM_toggle=get(handles.utm_checkbox,'Value'); %returns toggle state of utm_checkbox
DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String')); 
S_space=str2double(get(handles.s_space_box,'String')); 
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);
function utm_checkbox_Callback(hObject, ~, handles)

UTM_toggle=get(hObject,'Value'); %returns toggle state of utm_checkbox

DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String'));
S_space=str2double(get(handles.s_space_box,'String'));   
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SURVEY SELECTION ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function design_popup_Callback(hObject, ~, handles)

contents = cellstr(get(hObject,'String'));
if handles.main.type==0 % RX
main_file=['design' filesep contents{get(hObject,'Value')} '.RXgeo'];
elseif handles.main.type==1 % TX
main_file=['design' filesep contents{get(hObject,'Value')} '.TXgeo'];
end
% UPDATE TABLE
handles=m_get_design( main_file,handles,false );

UTM_toggle=get(handles.utm_checkbox,'Value'); %returns toggle state of utm_checkbox
DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String'));
S_space=str2double(get(handles.s_space_box,'String'));  
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SAVE SURVEY +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function save_push_Callback(hObject, ~, handles)

geometry_tbl=get(handles.geometry_table,'data');
survey.Xstn_box=get(handles.Xstn_box,'String');
survey.Ystn_box=get(handles.Ystn_box,'String');
survey.line_name=get(handles.line_box,'String');
survey.SX_azimut_box=get(handles.SX_azimut_box,'String');
survey.a_space_box=get(handles.a_space_box,'String');
survey.s_space_box=get(handles.s_space_box,'String');
survey.z_positive=get(handles.z_positive,'Value');


% SAVE SURVEY
handles = ZenRX_save_survey( handles,geometry_tbl,survey );

% SAVE HANDLES and HObjects
guidata(hObject, handles);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SURVEY TABLE AUTO-FILL ++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function geometry_table_CellEditCallback(hObject, eventdata, handles)
 
handles = ZenRX_survey_autofill( handles,eventdata );

% SAVE HANDLES and HObjects
guidata(hObject, handles);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CHECK SETUP +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function check_setup_Callback(hObject, ~, handles)

% STOP TIMER
stop(handles.timer_RX);

% CALCULATE AND DISPLAY CRES
handles = ZenRX_Cres( handles );

% START TIMER
start(handles.timer_RX);

% SAVE HANDLES and HObjects
guidata(hObject, handles);


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

survey_type=str2double(handles.setting.ZenACQ_mode);
if handles.main.type==0 && survey_type==1
    EXT='MTsch';
elseif handles.main.type==0 && survey_type==2
    EXT='IPsch';
elseif handles.main.type==1 && survey_type==2
    EXT='TXsch';
end
edit_file.file=['schedule' filesep file_name '.' EXT];
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
survey_type=str2double(handles.setting.ZenACQ_mode);
if handles.main.type==0 && survey_type==1
    EXT='MTsch';
elseif handles.main.type==0 && survey_type==2
    EXT='IPsch';
elseif handles.main.type==1 && survey_type==2
    EXT='TXsch';
end
main_file=['schedule' filesep contents{get(hObject,'Value')} '.' EXT];

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

UTM_toggle=0;
set(handles.utm_checkbox,'Value',UTM_toggle);
DATA=get(handles.geometry_table,'Data');
A_space=str2double(get(handles.a_space_box,'String'));
S_space=str2double(get(handles.s_space_box,'String'));  
SX_azimuth=str2double(get(handles.SX_azimut_box,'String'));
z_positive=get(handles.z_positive,'Value');
ZenUTM.X=get(handles.utm_zone_str,'Value');
ZenUTM.Y=get(handles.altitude_str,'Value');

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

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
