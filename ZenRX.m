function varargout = ZenRX(varargin)
% ZENRX MATLAB code for zenrx.fig
%      ZENRX set the receiver and transmiter information
% and commit/transmit the action

% Last Modified by GUIDE v2.5 27-Jan-2015 12:42:42

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
function job_name_box_Callback(hObject, ~, handles)
    
input=get(hObject,'String');
if ~isempty(input)
if size(input,2)>32  % CHECK LINE.NUMBER <32
    beep
    set(handles.error_msg,'Visible','on','String',[handles.language.job_name_str ' ' handles.language.error_msg_info_panel])
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor','white')
    pause(0.1)
    set(hObject,'BackgroundColor','red')
    pause(0.2)
    set(hObject,'BackgroundColor','white')  
    set(hObject,'String',input(1:32));
    return;       
end
end
function job_number_box_Callback(hObject, ~, handles)

input=get(hObject,'String');
if ~isempty(input)
if size(input,2)>32  % CHECK LINE.NUMBER <32
    beep
    set(handles.error_msg,'Visible','on','String',[handles.language.job_number_str ' ' handles.language.error_msg_info_panel])
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor','white')
    pause(0.1)
    set(hObject,'BackgroundColor','red')
    pause(0.2)
    set(hObject,'BackgroundColor','white')  
    set(hObject,'String',input(1:32));
    return;       
end
end
function job_by_box_Callback(hObject, ~, handles)

input=get(hObject,'String');
if ~isempty(input)
if size(input,2)>32  % CHECK LINE.NUMBER <32
    beep
    set(handles.error_msg,'Visible','on','String',[handles.language.job_by_str ' ' handles.language.error_msg_info_panel])
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor','white')
    pause(0.1)
    set(hObject,'BackgroundColor','red')
    pause(0.2)
    set(hObject,'BackgroundColor','white')  
    set(hObject,'String',input(1:32));
    return;       
end
end
function job_for_box_Callback(hObject, ~, handles)
    
input=get(hObject,'String');
if ~isempty(input)
if size(input,2)>32  % CHECK LINE.NUMBER <32
    beep
    set(handles.error_msg,'Visible','on','String',[handles.language.job_for_str ' ' handles.language.error_msg_info_panel])
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor','white')
    pause(0.1)
    set(hObject,'BackgroundColor','red')
    pause(0.2)
    set(hObject,'BackgroundColor','white')  
    set(hObject,'String',input(1:32));
    return;       
end
end 
function job_operator_box_Callback(hObject, ~, handles)

input=get(hObject,'String');
if ~isempty(input)
if size(input,2)>32  % CHECK LINE.NUMBER <32
    beep
    set(handles.error_msg,'Visible','on','String',[handles.language.operator_str ' ' handles.language.error_msg_info_panel])
    set(hObject,'BackgroundColor','red')
    pause(0.1)
    set(hObject,'BackgroundColor','white')
    pause(0.1)
    set(hObject,'BackgroundColor','red')
    pause(0.2)
    set(hObject,'BackgroundColor','white')  
    set(hObject,'String',input(1:32));
    return;       
end
end
    

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
set(handles.Xstn_box,'BackgroundColor','white')
set(handles.Ystn_box,'Enable','on')
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
set(handles.check_setup,'Enable','on')
set(handles.display_survey,'Enable','on')
set(handles.z_positive_str,'Enable','on')
set(handles.z_positive,'Enable','on')
set(handles.set_up,'Enable','on')
set(handles.design_popup,'Enable','on')

[ UTM_toggle,DATA,A_space,S_space,SX_azimuth,z_positive,ZenUTM] = get_survey_GUI_var( handles );
update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

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

[ UTM_toggle,DATA,A_space,S_space,SX_azimuth,z_positive,ZenUTM] = get_survey_GUI_var( handles );
update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

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

    set(handles.error_msg,'Visible','off')
    
    [UTM_toggle,DATA,A_space,S_space,~,z_positive,ZenUTM] = get_survey_GUI_var(handles);
    
    SX_azimuth=str2double(get(hObject,'String'));
    if isnan(SX_azimuth)  % CHECK FOR VALUE OUT OF RANGE
        beep
        set(handles.error_msg,'Visible','on','String',handles.language.input_err3)
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor','red')
        pause(0.1)
        set(handles.survey_panel,'BackgroundColor',[0.941 0.941 0.941])
        set(hObject,'String','');
        return;
    end
   
    set(hObject,'String',num2str(mod(SX_azimuth+2*360,360)));
    
    
    for i=1:size(DATA,1)
        handles.ant_raw_val{i,:}=[z_positive,SX_azimuth,DATA(i,7)];
    end
    
    
for i=1:size(DATA,1)

    
    if strcmp(DATA{i,1}(1:2),'Hx') || strcmp(DATA{i,1}(1:2),'Hy')        
            handles.ant_raw_val{i,:}{1,3}=handles.ant_raw_val{i,:}{1,3}+(SX_azimuth-handles.prev_SX_azimuth);
            handles.Ant.azm{i}=handles.ant_raw_val{i,:}{1,3};
    end 
end
handles.prev_SX_azimuth=SX_azimuth; 

%handles.z_changed=false;


handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);

function a_space_box_Callback(hObject, ~, handles)

    set(handles.error_msg,'Visible','off')
    
    [ UTM_toggle,DATA,~,S_space,SX_azimuth,z_positive,ZenUTM] = get_survey_GUI_var( handles );
    
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

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);

function s_space_box_Callback(hObject, ~, handles)

    set(handles.error_msg,'Visible','off')
    
    [ UTM_toggle,DATA,A_space,~,SX_azimuth,z_positive,ZenUTM] = get_survey_GUI_var( handles );
    
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
    
handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);

function z_positive_Callback(hObject, ~, handles)

[ UTM_toggle,DATA,A_space,S_space,SX_azimuth,~,ZenUTM] = get_survey_GUI_var( handles );

z_positive=get(hObject,'Value');
for i=1:size(DATA,1)
       if strcmp(DATA{i,1}(1:2),'Hy')
             if z_positive==handles.ant_raw_val{i,:}{1,1} % if it's the same do nothing
                 handles.Ant.azm{i}=handles.ant_raw_val{i,:}{1,3};
             else
                 handles.Ant.azm{i}=handles.ant_raw_val{i,:}{1,3}+180;
             end  
       end 
       if strcmp(DATA{i,1}(1:2),'Hz')
           if z_positive==1
            handles.Ant.azm{i}=abs(handles.Ant.azm{i});
           elseif z_positive==2
            handles.Ant.azm{i}=-abs(handles.Ant.azm{i});
           end
       end
end

handles.z_prev=z_positive;

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% SAVE HANDLES and HObjects
guidata(hObject, handles);

function utm_checkbox_Callback(hObject, ~, handles)

[~,DATA,A_space,S_space,SX_azimuth,z_positive,ZenUTM] = get_survey_GUI_var(handles);

UTM_toggle=get(hObject,'Value');

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

% STAR_1 TIMER
start(handles.timer_RX);

% SAVE HANDLES and HObjects
guidata(hObject, handles);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% DISPLAY SETUP +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function display_survey_Callback(~, ~, handles)

display_layout( handles )


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% DISPLAY TS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function display_real_time_Callback(~, ~, handles)

ZenACQ_vars.main=handles.main;
ZenACQ_vars.setting=handles.setting;
ZenACQ_vars.language=handles.language;
ZenACQ_vars.CHANNEL=handles.CHANNEL;
setappdata(0,'tunnel',ZenACQ_vars);                % SET GLOBAL VARIABLE

try
stop(handles.timer_RX);
catch
end

w=ZenRealTime;
uiwait(w);

try
start(handles.timer_RX);
catch
end

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
elseif handles.main.type==0 && (survey_type==2 || survey_type==3)
    EXT='IPsch';
elseif handles.main.type==1 && (survey_type==2 || survey_type==3)
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
set(handles.quick_summary_str,'Value',handles.SCHEDULE.TOTAL_TIME);
 
% UPDATE GUI
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE STAR_1 TIME (DATE) ++++++++++++++++++++++++++++++++++++++++++++++++
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
% UPDATE STAR_1 TIME (MIN) +++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function min_popup_Callback(hObject, ~, handles)

% UPDATE GUI
handles=l_Rx_update_time( handles );

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UPDATE STAR_1 TIME (HOUR) ++++++++++++++++++++++++++++++++++++++++++++++++
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


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% LATE STAR_1 CALLBACK +++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function late_option_Callback(hObject, ~, handles)


handles = l_Rx_update_time( handles ); % update start and end time
    
ZenACQ_vars.main=handles.main;
ZenACQ_vars.setting=handles.setting;
ZenACQ_vars.language=handles.language;
ZenACQ_vars.SCHEDULE=handles.SCHEDULE;
ZenACQ_vars.late=handles.late;
ZenACQ_vars.start_time=handles.start_time;
ZenACQ_vars.official_start_time=handles.official_start_time;
setappdata(0,'tunnel',ZenACQ_vars); % SET GLOBAL VARIABLE

w=ZenDelay;

uiwait(w);

ZenACQ_vars_ZenDelay=getappdata(0,'tunnelback_ZenDelay');
if isempty(ZenACQ_vars_ZenDelay); return; end

handles.SCHEDULE=ZenACQ_vars_ZenDelay.SCHEDULE;
handles.late=ZenACQ_vars_ZenDelay.LATE;

% UPDATE GUI
handles=l_Rx_update_time( handles );

if handles.late==true
    handles.official_start_time=ZenACQ_vars_ZenDelay.start_time;
    set(handles.end_time_str,'String',ZenACQ_vars_ZenDelay.NEW_END_TIME)
    set(handles.late_option,'BackGroundColor','red','ForeGroundColor',...
        'yellow','String','Lock')
elseif handles.late==false
    handles.official_start_time=0;
    set(handles.late_option,'BackGroundColor',[0.94 0.94 0.94],...
        'ForeGroundColor',[0 0 0],'String','Late ?')
end

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

[~,DATA,A_space,S_space,SX_azimuth,z_positive,ZenUTM] = get_survey_GUI_var(handles);

handles=update_table( handles,DATA,UTM_toggle,A_space,S_space,SX_azimuth,z_positive,ZenUTM );

% COMMIT ACTION
handles = ZenRX_commit( handles );

% STAR_1 TIMER
start(handles.timer_RX);

% SAVE HANDLES and HObjects
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ACTION WHEN GUI IS CLOSING ++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ZenRX_CloseRequestFcn(hObject, ~, ~)

% DELETE EXISTING TIMER
try
Rx_timer=timerfind('Name','Rx_timer');
if ~isempty(Rx_timer)
    stop(Rx_timer);
    Rx_timer_status=Rx_timer.Running;
    while strcmp(Rx_timer_status,'on')
        Rx_timer_status=Rx_timer.Running;
    end
    pause(0.25);
    delete(Rx_timer);
end
catch
end

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

% Close figure
 delete(hObject);
 
 ZenACQ
 

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



% --- Executes on button press in antenna_cal_str.
function antenna_cal_str_Callback(~, ~, handles)
% hObject    handle to antenna_cal_str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
{  '*.cal',  'Antenna Files (*.cal)'}, ...
   ['Select an Antenna Calibration file (ex: ' handles.main.calibrate_file_name ')']);

if filename==0;return;end

[ ~,~,status ] = read_antenna_file( [pathname filename] );
if status==false;warndlg('Wrong Antenna File Format');return;end

% COPY TO CALIBRATE FOLDER
if ~strcmpi([pathname filename],[cd filesep 'calibrate' filesep handles.main.calibrate_file_name])
    if ~exist('calibrate','dir'); mkdir('calibrate') ; end
    copyfile([pathname filename],['calibrate' filesep handles.main.calibrate_file_name]);
end

% CHECK ANTENNA CAL / AND UPDATE GUI
filename =['calibrate\' handles.main.calibrate_file_name];        
if exist(filename,'file')~=2 % IF FILE DOESNT EXIST
    set(handles.antenna_cal_status,'ForegroundColor','red','TooltipString',['Not found :' filename])
    set(handles.antenna_cal_str,'TooltipString',['Not found :' filename])
else % IF FILE EXIST
    set(handles.antenna_cal_status,'ForegroundColor','green','TooltipString',['Found :' filename])
    set(handles.antenna_cal_str,'TooltipString',['Found :' filename])
end


% --- Executes on button press in tx_cal_str.
function tx_cal_str_Callback(~, ~, handles)
% hObject    handle to tx_cal_str (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uigetfile( ...
{  '*.cal',  'TX Files (*.cal)'}, ...
   ['Select a TX file (ex: ' handles.main.TX_cal_file_name ')']);

if filename==0;return;end

[ ~,~,status ] = read_tx_file( [pathname filename] );
if status==false;warndlg('Wrong TX File Format');return;end

% COPY TO CALIBRATE FOLDER
if ~strcmpi([pathname filename],[cd filesep 'calibrate' filesep handles.main.TX_cal_file_name])
    if ~exist('calibrate','dir'); mkdir('calibrate') ; end
    copyfile([pathname filename],['calibrate' filesep handles.main.TX_cal_file_name]);
end

% CHECK TX CAL/ AND UPDATE GUI
if handles.main.type==1 % TX
    filename =['calibrate\' handles.main.TX_cal_file_name];        
if exist(filename,'file')~=2 % IF FILE DOESNT EXIST
    set(handles.tx_cal_status,'ForegroundColor','red','TooltipString',['Not found :' filename])
    set(handles.tx_cal_str,'TooltipString',['Not found :' filename])
else % IF FILE EXIST
    set(handles.tx_cal_status,'ForegroundColor','green','TooltipString',['Found :' filename])
    set(handles.tx_cal_str,'TooltipString',['Found :' filename])
end
end
