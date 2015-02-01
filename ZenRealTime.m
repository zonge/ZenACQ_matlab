function varargout = ZenRealTime(varargin)
% ZENREALTIME MATLAB code for ZenRealTime.fig
%      ZENREALTIME, by itself, creates a new ZENREALTIME or raises the existing
%      singleton*.
%
%      TS_PLOT = ZENREALTIME returns the handle to a new ZENREALTIME or the handle to
%      the existing singleton*.
%
%      ZENREALTIME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZENREALTIME.M with the given input arguments.
%
%      ZENREALTIME('Property','Value',...) creates a new ZENREALTIME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ZenRealTime_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ZenRealTime_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ZenRealTime

% Last Modified by GUIDE v2.5 21-Dec-2014 19:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenRealTime_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenRealTime_OutputFcn, ...
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


% --- Executes just before ZenRealTime is made visible.
function ZenRealTime_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ZenRealTime (see VARARGIN)

% Choose default command line output for ZenRealTime
handles.output = hObject;


ZenACQ_vars=getappdata(0,'tunnel');  % GET VARIABLES FROM ZenACQ

handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;
handles.CHANNEL=ZenACQ_vars.CHANNEL;

handles.selected_ch=[];
handles.max_buf=1024;
set(handles.nb_point_box,'String',num2str(handles.max_buf));

handles.color=handles.main.color;


% Display available channels
for i=1:size(handles.CHANNEL.ch_info,2)
     ChNb=handles.CHANNEL.ch_info{1,i}.ChNb;
     box_ch=eval(['handles.ch_' num2str(ChNb)]);
     name_ch=eval(['handles.ch_s_' num2str(ChNb)]);
     set(box_ch,'Visible','on');
     set(name_ch,'Visible','on');
end


% % TEST
% 
% FREQ=0.5;
% DUTY=100;
% 
%     ADC_freq=2097152; %ADC speed CONSTANT VARIABLE
%     period=(ADC_freq/FREQ)-1;
%     duty=(DUTY*ADC_freq/100/FREQ)-1;
%     if DUTY==100;duty=1999999999;end
%     if FREQ==0;period=4194303999;end
% 
%     
% for serial=1:size(handles.CHANNEL.ch_serial,2)
% fprintf(handles.CHANNEL.ch_serial{serial},['adcperiod ' num2str(period)]); 
% pause(0.1)
% fprintf(handles.CHANNEL.ch_serial{serial},['adcduty ' num2str(duty)]); 
% pause(0.1)
% fprintf(handles.CHANNEL.ch_serial{serial},'calvoltage 0.5'); 
% pause(0.1)
% fprintf(handles.CHANNEL.ch_serial{serial},'Calchannel 0xff'); 
% pause(0.1)
% end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ZenRealTime wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ZenRealTime_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ch_1.
function ch_1_Callback(hObject, ~, handles)
% hObject    handle to ch_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = channel_action( handles,hObject );

guidata(hObject, handles);

% --- Executes on button press in ch_2.
function ch_2_Callback(hObject, ~, handles)
% hObject    handle to ch_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = channel_action( handles,hObject );

guidata(hObject, handles);

% --- Executes on button press in ch_3.
function ch_3_Callback(hObject, ~, handles)
% hObject    handle to ch_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = channel_action( handles,hObject );

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in ch_4.
function ch_4_Callback(hObject, ~, handles)
% hObject    handle to ch_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = channel_action( handles,hObject );

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in ch_5.
function ch_5_Callback(hObject, ~, handles)
% hObject    handle to ch_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = channel_action( handles,hObject );

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in ch_6.
function ch_6_Callback(hObject, ~, handles)
% hObject    handle to ch_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = channel_action( handles,hObject );

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in ch_7.
function ch_7_Callback(~, ~, ~)
% hObject    handle to ch_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_7


% --- Executes on button press in ch_8.
function ch_8_Callback(~, ~, ~)
% hObject    handle to ch_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_8


% --- Executes on button press in ch_9.
function ch_9_Callback(~, ~, ~)
% hObject    handle to ch_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch_9



function nb_point_box_Callback(hObject, ~, handles)
% hObject    handle to nb_point_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb_point_box as text
%        str2double(get(hObject,'String')) returns contents of nb_point_box as a double

handles.max_buf=1024*4;
Nb_point=str2double(get(hObject,'String'));

if isnan(Nb_point)
    set(handles.nb_point_box,'String',num2str(handles.max_buf));
else
    
    set(handles.nb_point_box,'String',num2str(2^(nextpow2(Nb_point+1)-1)))
    handles.max_buf=2^(nextpow2(Nb_point+1)-1);  
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function nb_point_box_CreateFcn(hObject, ~, ~)
% hObject    handle to nb_point_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
    
% --- Executes on button press in togglebutton.
function togglebutton_Callback(hObject, ~, handles)
% hObject    handle to togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% GET CH number.
ChNb=zeros(1,size(handles.CHANNEL.ch_info,2));
for i=1:size(handles.CHANNEL.ch_info,2)
     ChNb(i)=handles.CHANNEL.ch_info{1,i}.ChNb;
end
nb_of_channel=size(handles.selected_ch,2);

% SET ADC RATE
for ch=1:nb_of_channel
    serial=ChNb==handles.selected_ch(ch);
    fprintf(handles.CHANNEL.ch_serial{serial},'ADCRATE 256'); 
end

pause(0.1)
if get(hObject,'Value')==1
	set(handles.ch_1,'Enable','off');
    set(handles.ch_2,'Enable','off');
    set(handles.ch_3,'Enable','off');
    set(handles.ch_4,'Enable','off');
    set(handles.ch_5,'Enable','off');
    set(handles.ch_6,'Enable','off');
    set(handles.ch_7,'Enable','off');
    set(handles.ch_8,'Enable','off');
    set(handles.ch_9,'Enable','off');

    set(handles.nb_point_box,'Enable','off');
    
    for ch=1:nb_of_channel
        serial=ChNb==handles.selected_ch(ch);
        fprintf(handles.CHANNEL.ch_serial{serial},'Zapout 1');
    end
    
elseif get(hObject,'Value')==0
    set(handles.ch_1,'Enable','on');
    set(handles.ch_2,'Enable','on');
    set(handles.ch_3,'Enable','on');
    set(handles.ch_4,'Enable','on');
    set(handles.ch_5,'Enable','on');
    set(handles.ch_6,'Enable','on');
    set(handles.ch_7,'Enable','on');
    set(handles.ch_8,'Enable','on');
    set(handles.ch_9,'Enable','on');

    set(handles.nb_point_box,'Enable','on');
    
    for ch=1:nb_of_channel
        serial=ChNb==handles.selected_ch(ch);
        fprintf(handles.CHANNEL.ch_serial{serial},'Zapout 0');
    end
end

zone=str2double(handles.setting.time_zone);

GpsRef=datenum('06-Jan-1980 00:00:00');  % Gps date ref
gps_week=fix((datenum(date)-GpsRef)/7);  % Get Number of week

Week_time=addtodate(GpsRef, gps_week*604800+zone*3600-16, 'second');  %%UTC time

if ~isempty(handles.selected_ch)
Display_Zapout( handles,handles.selected_ch,Week_time );
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if get(handles.togglebutton,'Value')==0
    delete(hObject);
else
    h = msgbox('Please, stop the straming first','ZenACQ');
    uiwait(h);
end
