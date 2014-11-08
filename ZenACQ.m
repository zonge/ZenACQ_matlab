function varargout = ZenACQ(varargin)
% ZENACQ MATLAB code for ZenACQ.fig
%      ZENACQ, Acquisition Interface for ZenBox

% Last Modified by GUIDE v2.5 06-Nov-2014 12:53:07

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

clc;

handles = ZenACQ_ini(handles);

% Update handles structure
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  1. RECEIVER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function receiver_Callback(~, ~, handles)

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
    % RUN ZenRX
    ZenRX;
else
    warndlg(handles.language.ZenACQ_err1,'ZenACQ');
end
                     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  2. TRANSMITER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function transmitter_Callback(~, ~, handles)

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
    % RUN ZenTX
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
ZenPREF

% UPDATE GUI AND PARAMETERS
handles.ZenACQsetting = m_get_setting_key(handles.main.Setting_ext,handles,true);

if str2double(handles.ZenACQsetting.ZenACQ_mode)==2 % IF TX MODE
    set(handles.receiver,'Position',[5.6 30.538 44.4 5.692]);
    set(handles.transmitter,'Visible','on','Position',[5.6 24.5 44.4 5.692])
else                                          % IF NOT TX MODE
    set(handles.receiver,'Position',[5.6 27 44.4 9.231]);
    set(handles.transmitter,'Visible','off','Position',[5.6 23.692 44.4 2.538])
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
ZenOptions



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
