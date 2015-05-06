function varargout = ZenMTestimates(varargin)
% ZENMTESTIMATES MATLAB code for ZenMTestimates.fig
%      ZENMTESTIMATES, by itself, creates a new ZENMTESTIMATES or raises the existing
%      singleton*.
%
%      H = ZENMTESTIMATES returns the handle to a new ZENMTESTIMATES or the handle to
%      the existing singleton*.
%
%      ZENMTESTIMATES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZENMTESTIMATES.M with the given input arguments.
%
%      ZENMTESTIMATES('Property','Value',...) creates a new ZENMTESTIMATES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ZenMTestimates_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ZenMTestimates_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ZenMTestimates

% Last Modified by GUIDE v2.5 11-Oct-2014 18:01:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ZenMTestimates_OpeningFcn, ...
                   'gui_OutputFcn',  @ZenMTestimates_OutputFcn, ...
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


% --- Executes just before ZenMTestimates is made visible.
function ZenMTestimates_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ZenMTestimates (see VARARGIN)

% Choose default command line output for ZenMTestimates
handles.output = hObject;


% GET PARAMETERS FROM ZenACQ
ZenACQ_vars=getappdata(0,'tunnel');
handles.main=ZenACQ_vars.main;
handles.setting=ZenACQ_vars.setting;
handles.language=ZenACQ_vars.language;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ZenMTestimates wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ZenMTestimates_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function day_box_Callback(~, ~, ~)
% hObject    handle to day_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of day_box as text
%        str2double(get(hObject,'String')) returns contents of day_box as a double


% --- Executes during object creation, after setting all properties.
function day_box_CreateFcn(hObject, ~, ~)
% hObject    handle to day_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hour_box_Callback(~, ~, ~)
% hObject    handle to hour_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hour_box as text
%        str2double(get(hObject,'String')) returns contents of hour_box as a double


% --- Executes during object creation, after setting all properties.
function hour_box_CreateFcn(hObject, ~, ~)
% hObject    handle to hour_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_box_Callback(~, ~, ~)
% hObject    handle to min_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_box as text
%        str2double(get(hObject,'String')) returns contents of min_box as a double


% --- Executes during object creation, after setting all properties.
function min_box_CreateFcn(hObject, ~, ~)
% hObject    handle to min_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sec_box_Callback(~, ~, ~)
% hObject    handle to sec_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sec_box as text
%        str2double(get(hObject,'String')) returns contents of sec_box as a double


% --- Executes during object creation, after setting all properties.
function sec_box_CreateFcn(hObject, ~, ~)
% hObject    handle to sec_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Calculate_estimations.
function Calculate_estimations_Callback(~, ~, handles)
% hObject    handle to Calculate_estimations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


day_box=get(handles.day_box,'String');
hour_box=get(handles.hour_box,'String');
min_box=get(handles.min_box,'String');
sec_box=get(handles.sec_box,'String');

% CHECK ANSWER
if isnan(str2double(day_box)) &&  ~isempty(day_box)
    beep
    set(handles.day_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.day_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.day_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.day_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    return ;
elseif isempty(day_box)
    day_box='0';
end

if isnan(str2double(hour_box)) &&  ~isempty(hour_box) 
    beep
    set(handles.hour_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.hour_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.hour_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.hour_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    return ;
elseif isempty(hour_box)
    hour_box='0';
end

if isnan(str2double(min_box)) &&  ~isempty(min_box)
    beep
    set(handles.min_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.min_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.min_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.min_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    return ;
elseif isempty(min_box)
    min_box='0';
end

if isnan(str2double(sec_box)) &&  ~isempty(sec_box)
    beep
    set(handles.sec_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.sec_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    set(handles.sec_box,'BackgroundColor',[1 0 0])
    pause(0.1)
    set(handles.sec_box,'BackgroundColor',[1 1 1])
    pause(0.1)
    return ;
elseif isempty(sec_box)
    sec_box='0';
end

freq_popup=get(handles.freq_popup,'Value');
if freq_popup==1
    freq=256;
elseif freq_popup==2
    freq=1024;
elseif freq_popup==3
    freq=4096;
end

sec=str2double(day_box)*86400+str2double(hour_box)*3600+str2double(min_box)*60+str2double(sec_box);
tsfrq=freq; % USER


nfft=64;                     % data window length
ndfc=9;                      % decimation filter length
mdl=25;                      % maximum number decimation levels
nhfreq=3;                    % # harmonic frequencies per data window 
noverlap=3*nfft/4;           % data window overlap, 75% for 4PiProlate & Kaiser tapers  
noffset=nfft-noverlap;       % data window offset

SUMMARY1=zeros(mdl,3);
SUMMARY2=zeros(mdl,2);

fileSize=((tsfrq*4+40)*sec)/(1000^2);
set(handles.file_size_msg,'String',['File size : ' num2str(fileSize) ' MB'])
npnt  = tsfrq*sec;

nfc = 0;        % initialize # fourier coefficient estimates
for i = 1:mdl
	
    if npnt<nfft
        break;
    end

    ndl = i;
    nw = 1 + ((npnt-nfft)/noffset); % # data windows
    nfc = nfc + nw*nhfreq;
    SUMMARY1(i,1) = ndl;             % Decimation level
    SUMMARY1(i,2) = floor(nw);         % one estimate per window at each frequency
    SUMMARY2(i,1) = 6*tsfrq/32;      % using same harmonics from 32 & 64 pnt windows
    SUMMARY2(i,2) = 8*tsfrq/32;
    npnt = ((npnt-ndfc)/2) + 1;
    tsfrq = tsfrq/2;
    
    if SUMMARY2(i,1)<0.0007
        break;
    end
    
end

DATA(1:ndl,1)=SUMMARY2(1:ndl,1);
DATA(ndl+1:ndl*2,1)=SUMMARY2(1:ndl,2);
DATA(1:ndl,2)=SUMMARY1(1:ndl,2);
DATA(ndl+1:ndl*2,2)=SUMMARY1(1:ndl,2);
DATA(1:ndl,3)=SUMMARY1(1:ndl,1);
DATA(ndl+1:ndl*2,3)=SUMMARY1(1:ndl,1);

DATA=sortrows(DATA,1);

set(handles.file_size_msg,'Visible','on')
set(handles.table_estimates,'data',DATA,'Visible','on')

% --- Executes on selection change in freq_popup.
function freq_popup_Callback(~, ~, ~)
% hObject    handle to freq_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns freq_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from freq_popup


% --- Executes during object creation, after setting all properties.
function freq_popup_CreateFcn(hObject, ~, ~)
% hObject    handle to freq_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
