function varargout = ZenLayout(varargin)
% ZENLAYOUT MATLAB code for ZenLayout.fig
%      ZENLAYOUT, by itself, creates a new ZENLAYOUT or raises the existing
%      singleton*.
%
%      H = ZENLAYOUT returns the handle to a new ZENLAYOUT or the handle to
%      the existing singleton*.
%
%      ZENLAYOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZENLAYOUT.M with the given input arguments.
%
%      ZENLAYOUT('Property','Value',...) creates a new ZENLAYOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ZenLayout_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ZenLayout_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ZenLayout

% Last Modified by GUIDE v2.5 23-Jan-2015 12:30:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenLayout_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenLayout_OutputFcn, ...
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


% --- Executes just before ZenLayout is made visible.
function ZenLayout_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ZenLayout (see VARARGIN)

% Choose default command line output for ZenLayout
handles.output = hObject;

ZenACQ_vars=getappdata(0,'tunnel');  % GET VARIABLES FROM ZenACQ

handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;
DATA=ZenACQ_vars.DATA;
RowName=ZenACQ_vars.RowName;

SX_azimut=ZenACQ_vars.setup_infos.SX_azimuth;
A_space=ZenACQ_vars.setup_infos.A_space;
S_space=ZenACQ_vars.setup_infos.S_space;
z_positive=ZenACQ_vars.setup_infos.z_positive;
Xstn_box=ZenACQ_vars.setup_infos.Xstn_box;
Ystn_box=ZenACQ_vars.setup_infos.Ystn_box;

% Clear Graph
cla

j=0;
for i=1:size(DATA,1)
    
    % Continue if OFF
    if strcmp(DATA{i,1},'Off')
        continue
    else
        j=j+1;
    end
    
    % SELECT COLOR DEPEND OF CMP
    if strcmp(DATA{i,1},'Ex')
        color=handles.main.color(2,:);
    elseif strcmp(DATA{i,1},'Ey')
        color=handles.main.color(1,:);
    elseif strcmp(DATA{i,1},'Hx')
        color=handles.main.color(5,:);
    elseif strcmp(DATA{i,1},'Hy')
        color=handles.main.color(4,:);
    elseif strcmp(DATA{i,1},'Hz')
        color=handles.main.color(6,:);
    elseif strcmp(DATA{i,1},'TX1')
        color=handles.main.color(3,:);
    elseif strcmp(DATA{i,1},'TX2')
        color=handles.main.color(7,:);
    end
    
    % PLOT VECTOR
    quiver_plot(handles,DATA{i,1},DATA{i,2},DATA{i,4},DATA{i,3},DATA{i,5},SX_azimut,z_positive,A_space,S_space,DATA{i,7}/180*pi,color);  
    try
    legend_list{j}=[DATA{i,1} ' [ ' num2str(DATA{i,6}) ' ] (ch:' num2str(RowName(i)) ')'];
    catch
    end
    
end
    
if j>0
set(handles.layout_plot,'DataAspectRatio',[1,1,1],'YGrid','On','YMinorGrid','On','XGrid','On','XMinorGrid','On');
try
legend(handles.layout_plot,legend_list,'Visible','off');
%aa.Visible='off';
catch
end
xlabel('X-Coordinate')
ylabel('Y-Coordinate')
title(['Station : ' num2str(Xstn_box) ':' num2str(Ystn_box)])
end

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes ZenLayout wait for user response (see UIRESUME)
% uiwait(handles.ZenLayout);


% --- Outputs from this function are returned to the command line.
function varargout = ZenLayout_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close ZenLayout.
function ZenLayout_CloseRequestFcn(hObject, ~, ~)
% hObject    handle to ZenLayout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tequila_status
tequila_status=false;

% Hint: delete(hObject) closes the figure
delete(hObject);
