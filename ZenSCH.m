function varargout = ZenSCH(varargin)
% ZENSCH MATLAB code for ZenSCH.fig

% Last Modified by GUIDE v2.5 02-Mar-2015 06:48:21

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes just before ZenSCH is made visible --- %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZenSCH_OpeningFcn(hObject, ~, handles, varargin)


% Choose default command line output for ZenSCH
handles.output = hObject;

ZenACQ_vars=getappdata(0,'tunnel');  % GET VARIABLES FROM ZenACQ
handles.edit_file=getappdata(0,'tunnel2');  % GET VARIABLES FROM ZenACQ

handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;
handles.start_date=ZenACQ_vars.start_date;

% SURVEY TYPE
survey_type=str2double(handles.setting.ZenACQ_mode);
if survey_type==2 % IP RX
    set(handles.SR_popup,'String',{'Mid Band'},'Visible','off')
    set(handles.sample_rate_str,'Visible','off')
elseif survey_type==3 % IP TX
    set(handles.SR_popup,'String',{'Mid Band'},'Visible','off')
    set(handles.sample_rate_str,'Visible','off')
elseif survey_type==1 % MT
        set(handles.SR_popup,'String',{'High Band','Mid Band','Low Band','Break'},'Visible','on')
    set(handles.sample_rate_str,'Visible','on')
end

if handles.main.type==0  % RX
    set(handles.tx_freq_str,'Visible','off')
    set(handles.tx_freq_popup,'Visible','off')
    set(handles.nb_cycles_str,'Visible','off')
    set(handles.nb_cycles_popup,'Visible','off')
    
elseif handles.main.type==1 % TX
    set(handles.duration_str,'Visible','off')
    set(handles.day_box,'Visible','off')
    set(handles.day_str,'Visible','off')
    set(handles.hour_box,'Visible','off')
    set(handles.hours_str,'Visible','off')
    set(handles.min_box,'Visible','off')
    set(handles.min_str,'Visible','off')
    set(handles.sec_box,'Visible','off')
    set(handles.sec_str,'Visible','off')
    set(handles.sample_rate_str,'Visible','off')
    set(handles.SR_popup,'Visible','off')
    set(handles.tx_freq_str,'Position',[1.2 1.923 14.6 1.615])
    set(handles.tx_freq_popup,'Position',[15.8 1.615 22 2.154])
    set(handles.nb_cycles_str,'Position',[44.4 1.769 21.8 1.615])
    set(handles.nb_cycles_popup,'Position',[65.8 1.462 22 2.154])
end

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

% set info msg
set(handles.info_msg,'String',['Time between 2 schedule lines = ' num2str(handles.main.time_btw_sch) 's']);

% Update handles structure
guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% INPUTS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function schedule_name_box_Callback(~, ~, ~)
function day_box_Callback(~, ~, ~)
function hour_box_Callback(~, ~, ~)
function min_box_Callback(~, ~, ~)
function sec_box_Callback(~, ~, ~)
function SR_popup_Callback(~, ~, ~)
function gain_popup_Callback(~, ~, ~)
function tx_freq_popup_Callback(~, ~, ~)
function nb_cycles_popup_Callback(~, ~, ~)
    
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ADD +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function add_push_Callback(hObject, ~, handles)

handles=l_sch_add_line(handles);

guidata(hObject, handles);

function add_push_KeyPressFcn(hObject, eventdata, handles)

if strcmp(eventdata.Key,'return')
handles=l_sch_add_line(handles);
end

guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% DELETE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function delete_push_Callback(hObject, ~, handles)

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

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% UP ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function up_push_Callback(hObject, ~, handles)

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


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% DOWN ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function down_push_Callback(hObject, ~, handles)

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



% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% TABLE SELECTION +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function schedule_tbl_CellSelectionCallback(~, eventdata, handles)

% get indices of selected rows and make them available for other callbacks
index = eventdata.Indices;
if any(index)             %loop necessary to surpress unimportant errors.
    rows = index(:,1);
    set(handles.schedule_tbl,'UserData',rows);
end


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% DURATION KEY PRESS DOWN +++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function duration_KeyPressFcn(hObject, eventdata, handles)

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
    beep
    set(handles.error_display,'Visible','on','String',handles.language.ZenSCH_err4);
    set(hObject,'String','');
else
    set(handles.error_display,'Visible','off');
end

guidata(hObject, handles);


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% SAVE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function save_push_Callback(~, ~, handles)

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
survey_type=str2double(handles.setting.ZenACQ_mode);
if survey_type==1 && handles.main.type==0
    file_name=[folder filesep Sch_name '.MTsch'];
elseif (survey_type==2 || survey_type==3) && handles.main.type==0
    file_name=[folder filesep Sch_name '.IPsch'];
elseif (survey_type==2 || survey_type==3) && handles.main.type==1
    file_name=[folder filesep Sch_name '.TXsch'];
end


formatSpec='$schline%i = %i,%i,%i\n';
fid = fopen(file_name, 'w');
 
for i=1:handles.nb_schedule
    duration=handles.SCHEDULE(i).duration;  
    gain=handles.SCHEDULE(i).gain;

if handles.main.type==0
    sr=handles.SCHEDULE(i).sr;
    fprintf(fid,formatSpec,i,duration,sr,gain);
elseif handles.main.type==1
    TX_freq=handles.SCHEDULE(i).TX_freq;
    fprintf(fid,formatSpec,i,duration,TX_freq,gain);
    
end

end
fclose(fid);

% UPDATE config file

l_modif_file( handles.main.Setting_ext,'$Rx_schedule_selected',Sch_name )

handles.SCH.last_schedule=Sch_name;

setappdata(0,'tunnelback',handles.SCH);        % SET GLOBAL VARIABLE

global SCH_status
SCH_status=true;

close(ZenSCH);   % CLOSE ZenSCH


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% CHANGE DURATION 2 TIME ++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function time2duration_Callback(~, ~, handles)

l_sch_set_table( handles,handles.nb_schedule );  % UPDATE TABLE


% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ACTION WHEN GUI IS CLOSING ++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ZenSCH_CloseRequestFcn(hObject, ~, ~)
    

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
function varargout = ZenSCH_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
