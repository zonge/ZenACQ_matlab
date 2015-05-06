function varargout = ZenACQ(varargin)
% ZENACQ MATLAB code for ZenACQ.fig
%      ZENACQ, Acquisition Interface for ZenBox

% Last Modified by GUIDE v2.5 21-Jan-2015 12:37:00

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenACQ_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenACQ_OutputFcn, ...
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
% --- Executes just before ZenACQ is made visible --- %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZenACQ_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for ZenACQ
handles.output = hObject;

% Initialization
handles = ZenACQ_ini(handles);

% Update handles structure
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  1. RECEIVER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function receiver_Callback(~, ~, handles)

% MAKE ZenACQ invisible
set(handles.ZenACQ,'Visible', 'off');

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

% SET VARIABLE to the other windows
handles.main.type=0; %Receiver

ZenAQC_vars.main=handles.main;
ZenAQC_vars.setting=m_get_setting_key(handles.main.Setting_ext,handles,true);
ZenAQC_vars.language=handles.language;
setappdata(0,'tunnel',ZenAQC_vars);

% UPDATE COM AVAILABLE
COM=findCOM;
if ~strcmp('NONE',COM{1,1})
    ZenRX;
else
    warndlg(handles.language.ZenACQ_err1,'ZenACQ');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  2. TRANSMITER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function transmitter_Callback(~, ~, handles)

% MAKE ZenACQ invisible
set(handles.ZenACQ,'Visible', 'off');

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

% SET VARIABLE to the other windows
handles.main.type=1; %Transmiter

ZenAQC_vars.main=handles.main;
ZenAQC_vars.setting=m_get_setting_key(handles.main.Setting_ext,handles,true);
ZenAQC_vars.language=handles.language;
setappdata(0,'tunnel',ZenAQC_vars);

% UPDATE COM AVAILABLE
COM=findCOM;
if ~strcmp('NONE',COM{1,1})
    ZenRX;
else
    warndlg(handles.language.ZenACQ_err1,'ZenACQ');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  3. CALIBRATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calibration_Callback(~, ~, handles)

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

ZenACQ_calibration( handles );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  4. ZENACQSETTING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ZenACQsetting_Callback(hObject, ~, handles)

% SET VARIABLE to the other windows
ZenAQC_vars.main=handles.main;
ZenAQC_vars.setting=m_get_setting_key(handles.main.Setting_ext,handles,true);
ZenAQC_vars.language=handles.language;
setappdata(0,'tunnel',ZenAQC_vars);

% RUN ZEN PREF
ZenSettings

% UPDATE GUI AND PARAMETERS
handles.setting = m_get_setting_key(handles.main.Setting_ext,handles,true);

if str2double(handles.setting.ZenACQ_mode)==1   % IF RX MODE
    set(handles.receiver,'Position',[5.6 21 44.4 9.231]);
    set(handles.transmitter,'Visible','off','Position',[5.6 19 44.4 2.538])
else                                            % IF TX MODE
    set(handles.receiver,'Position',[5.6 26 44.4 5.692]);
    set(handles.transmitter,'Visible','on','Position',[5.6 19.5 44.4 5.692])
    
    % SET DUTY
    if str2double(handles.setting.ZenACQ_mode)==2
        handles.main.duty_cycle=100;
    elseif str2double(handles.setting.ZenACQ_mode)==3
        handles.main.duty_cycle=50;
    end
    
end

% Update handles structure
guidata(hObject, handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  5. DATA TRANSFER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data_transfert_Callback(hObject, ~, handles)

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

ZenACQ_data_transfer( handles );

% UPDATE PARAMETERS
handles.ZenACQsetting = m_get_setting_key(handles.main.Setting_ext,handles,true); 

% Update handles structure
guidata(hObject, handles);


function copy_sds_Callback(~, ~, handles)

global list_Drive_Before
EXTENSION='*.Z3D';
handles.path_output=handles.setting.z3d_location;
data_transfert( handles,EXTENSION,list_Drive_Before );



function delete_sds_Callback(~, ~, handles)

global list_Drive_Before
EXTENSION='*.Z3D';

choice2 = questdlg(handles.language.data_transfer_msg3, ...
                handles.language.progress_title6, ...
                handles.language.yes,handles.language.no,handles.language.no);
            
waitfor(choice2)
            
if strcmp(choice2,handles.language.yes)
        delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
        handles.main.GUI.width_bar,handles.main.GUI.height_bar,EXTENSION,list_Drive_Before)
end
delete_files(handles.main.GUI.left_bar,handles.main.GUI.bottom_bar, ...
handles.main.GUI.width_bar,handles.main.GUI.height_bar,'*.CSV',list_Drive_Before)  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  6. OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function option_box_Callback(~, ~, handles)

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

% SET VARIABLE to the other windows
ZenAQC_vars.main=handles.main;
ZenAQC_vars.setting=m_get_setting_key(handles.main.Setting_ext,handles,true);
ZenAQC_vars.language=handles.language;
setappdata(0,'tunnel',ZenAQC_vars);

% RUN ZenOptions
w=ZenOptions;
uiwait(w);

ZenACQ_vars=getappdata(0,'tunnelback');
set(handles.msg_txt,'Visible','on','Value',ZenACQ_vars.sd_mod_active)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  OTHERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% ACTION WHEN GUI IS CLOSING ++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function ZenACQ_CloseRequestFcn(hObject, ~, ~)

% DELETE EXISTING TIMER
newtimer=timerfind;if ~isempty(newtimer);stop(newtimer);delete(newtimer);end

% DELETE EXISTING OPEN SERIAL PORTS
newobjs=instrfind;if ~isempty(newobjs);fclose(newobjs);delete(newobjs);end

% Hint: delete(hObject) closes the figure
delete(hObject);

% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% GENERATE OUTPUT TO CMD ++++++++++++++++++++++++++++++++++++++++++++++++++
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function varargout = ZenACQ_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
