
function varargout = player(varargin)
% PLAYER MATLAB code for player.fig
%      PLAYER, by itself, creates a new PLAYER or raises the existing
%      singleton*.
%
%      H = PLAYER returns the handle to a new PLAYER or the handle to
%      the existing singleton*.
%
%      PLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYER.M with the given input arguments.
%
%      PLAYER('Property','Value',...) creates a new PLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before player_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to player_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help player

% Last Modified by GUIDE v2.5 17-Jun-2013 21:03:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @player_OpeningFcn, ...
                   'gui_OutputFcn',  @player_OutputFcn, ...
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


% --- Executes just before player is made visible.
function player_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to player (see VARARGIN)

% Choose default command line output for player
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes player wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = player_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.controls.pause;

% --------------------------------------------------------------------
function activex1_OpenStateChange(hObject, eventdata, handles)
% hObject    handle to activex1 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.controls.play;

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.controls.stop;


% --- Executes on button press in fastforward.
function fastforward_Callback(hObject, eventdata, handles)
% hObject    handle to fastforward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.controls.fastForward;


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in fullscreen.
function fullscreen_Callback(hObject, eventdata, handles)
% hObject    handle to fullscreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.activex1.fullScreen == 1
    handles.activex1.fullScreen = 0;
else
    handles.activex1.fullScreen = 1;
end;

% --- Executes on button press in mute.
function mute_Callback(hObject, eventdata, handles)
% hObject    handle to mute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.activex1.controls.next;
if handles.activex1.settings.mute == 1
    handles.activex1.settings.mute= 0;
else
    handles.activex1.settings.mute =1;
end;


% --- Executes on button press in record.
function record_Callback(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = 12;%%�����ʸ���
count = 3;%%ÿ�������ʵ�������    
Fs=11025;
    tmp = sprintf('\n��ʼ¼��������\n');
    set(handles.result,'String',tmp);
    x= wavrecord(5*Fs, Fs, 'int16');
    %x=wavread('������9ģ��24.wav');
    tmp = sprintf('\n¼������������\n');
    set(handles.result,'String',tmp);
    [x1 x2] = vad(x);
    m = mfcc(x);
    m = m(x1:x2,:);
    test.mfcc = m;
    dist = zeros(num,count);
    for i = 1:num
        for j = 1:count
            fname = sprintf('%dmfcc%d.txt',i-1,j);
            ref(i,j).mfcc = load(fname);
            dist(i,j) = dtw(test.mfcc, ref(i,j).mfcc);
        end
    end
    dist = dist*(-1);
    for j = 1:num
        d(j) = max(dist(j,:));
    end
    [tmp,k] = max(d);%min����Ҫ��������Ϊ��������max�ѩn��b��
if tmp < j || tmp > j %�ж��Ƿ����
    tmp = sprintf('ʶ������ʾ��\n%dΪʶ����\n',k-1);
    set(handles.result,'String',tmp);
    switch k-1
        case 0
            fastforward_Callback(hObject, eventdata, handles);
        case 1
            play_Callback(hObject, eventdata, handles);
        case 2
            stop_Callback(hObject, eventdata, handles);
        case 3
            pause_Callback(hObject, eventdata, handles);
        case 4
            fullscreen_Callback(hObject, eventdata, handles);
        case 5
            open_Callback(hObject, eventdata, handles);
        case 6
            close_Callback(hObject, eventdata, handles);
        case 7
            mute_Callback(hObject, eventdata, handles);
        case 8
            singlecircle_Callback(hObject, eventdata, handles);
        case 9
            singleplay_Callback(hObject, eventdata, handles);
        case 10
            fastreverse_Callback(hObject, eventdata, handles);
        case 11
            fileinfo_Callback(hObject, eventdata, handles);     
    end;
else
    tmp = sprintf('ʶ������ʾ��\nδʶ��ɹ�\n');
    set(handles.result,'String',tmp);
end

% --- Executes on button press in singlecircle.
function singlecircle_Callback(hObject, eventdata, handles)
% hObject    handle to singlecircle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.settings.playCount=999;

% --- Executes on button press in singleplay.
function singleplay_Callback(hObject, eventdata, handles)
% hObject    handle to singleplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.settings.playCount=1;


% --- Executes on button press in fileinfo.
function fileinfo_Callback(hObject, eventdata, handles)
% hObject    handle to fileinfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Hnd2=get(handles.activex1);
tmp = sprintf('�ļ���Ϣ��\n��ǰ�ļ����ƣ�%s\n��ǰ�ļ����ȣ�%s\n',Hnd2.currentMedia.name,Hnd2.currentMedia.durationString);
set(handles.text,'String',tmp);

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%persistent wenjian(20)='D:\����\ҹ�ĸ�����\ҹ�ĸ����� - 1.mp3';
% persistent num;
% if isempty(num)
% num=0;
% end
% num=num+1;
[filename,pathname]=uigetfile('*.*','ѡ��һ���ļ�');
if ~filename
    return
end
set(handles.activex1,'URL',fullfile(pathname,filename));
% wenjian(num)=handles.activex1.URL;


% --- Executes on button press in fastreverse.
function fastreverse_Callback(hObject, eventdata, handles)
% hObject    handle to fastreverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.activex1.controls.fastReverse;


% --- Executes on key press with focus on record and none of its controls.
function record_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to record (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in HMMrecord.
function HMMrecord_Callback(hObject, eventdata, handles)
% hObject    handle to HMMrecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num = 12;%%�����ʸ���
count =30;%%ÿ�������ʵ�������
for i = 1:num
    fname = sprintf('tr%d.txt',i);
    aa(i).tr = load(fname);
    fname = sprintf('e%d.txt',i);
    bb(i).e = load(fname);
end 
%%��ʶ��ģ�崦��
juzhen = load('all.txt');
Fs=11025;
tmp = sprintf('\n¼����ʼ������\n');
set(handles.result,'String',tmp);
x= wavrecord(5*Fs, Fs, 'int16');
tmp = sprintf('\n¼������������\n');
set(handles.result,'String',tmp);
[x1 x2] = vad(x);
m = mfcc(x);
m = m(x1:x2,:); 
%%�������
seq = zeros(size(m,1),1);
for i = 1:size(m,1)
    min = 9999;
    for j = 1:size(juzhen,1)
        tmp = norm(m(i,:)-juzhen(j,:));
        if tmp < min
            min = tmp;
            tag = j;
        end
    end
    seq(i) = tag;
end
%%��������������
logseq=zeros(num,1);
for i = 1:num
    [tmpstate(i).pstate,logseq(i)] = hmmdecode(seq',aa(i).tr,bb(i).e);
end
[tmp1,maxnum]=max(logseq);
if tmp1 > i || tmp1 < i
    tmp = sprintf('ʶ������ʾ��\n%dΪʶ����\n',maxnum-1);
    set(handles.result,'String',tmp);
    switch mod(maxnum-1,12)
        case 0
            fastforward_Callback(hObject, eventdata, handles);
        case 1
            play_Callback(hObject, eventdata, handles);
        case 2
            stop_Callback(hObject, eventdata, handles);
        case 3
            pause_Callback(hObject, eventdata, handles);
        case 4
            fullscreen_Callback(hObject, eventdata, handles);
        case 5
            open_Callback(hObject, eventdata, handles);
        case 6
            close_Callback(hObject, eventdata, handles);
        case 7
            mute_Callback(hObject, eventdata, handles);
        case 8
            singlecircle_Callback(hObject, eventdata, handles);
        case 9
            singleplay_Callback(hObject, eventdata, handles);
        case 10
            fastreverse_Callback(hObject, eventdata, handles);
        case 11
            fileinfo_Callback(hObject, eventdata, handles);     
    end;
else
    tmp = sprintf('ʶ������ʾ��\nδʶ��ɹ���\n');
    set(handles.result,'String',tmp);
end
