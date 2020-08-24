function varargout = TXX(varargin)
%TXX MATLAB code file for TXX.fig
%      TXX, by itself, creates a new TXX or raises the existing
%      singleton*.
%
%      H = TXX returns the handle to a new TXX or the handle to
%      the existing singleton*.
%
%      TXX('Property','Value',...) creates a new TXX using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to TXX_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TXX('CALLBACK') and TXX('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TXX.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TXX

% Last Modified by GUIDE v2.5 27-Feb-2019 11:30:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TXX_OpeningFcn, ...
                   'gui_OutputFcn',  @TXX_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before TXX is made visible.
function TXX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for TXX
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TXX wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TXX_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;global m;global n;global videoa;global obj;
%% Input video
[filename pathname]=uigetfile('*.avi','Select the input video file from your directory');

if isequal(filename,0) | isequal(pathname,0)
    warndlg('Video is not selected');
else
   % vid1=VideoReader('1.avi');
   
vid1=[filename pathname];
    helpdlg('video is selected');
    
    end
vid_inp=filename;
obj = VideoReader(vid_inp,'Tag', 'My reader object');
vid=read(obj);
frames = obj.NumberOfFrames;
disp(['No of frames in input video : ' num2str(frames) ' frames' ])
k=vid;
pause(1)
msgbox('Input video')
pause(2)
implay(k);
pause(0.5)
[m n]=size(vid);
%%
video = obj.read();
axes(handles.axes1);
title 'Input Video'
fps=10;
% % for i=1:max(video(1,1,1,:))
for i=1:15

    imshow(video(:,:,:,i));
    pause(1/fps);
end
[m n]=size(vid);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global message_bit;global vid;
clc;
%% Text message to be embedded with video
message_bit=input('Enter the data to be Hidden : ','s');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;global enkey;global enc_key;global fgh;global message_bit;global m;global n;

x = inputdlg('Enter the stego key:',...
             'Enter the stego key', [1 50]);
enkey = str2num(x{:}); 
enc_key =enkey;
fgh=dec2bin(enkey)

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;global enkey;global enc_key;global fgh;global message_bit; global vid;
global m;global n;global si;global T; global obj
[sbarm sbarn]=size(message_bit);
si=length(message_bit);
[m n]=size(vid);
minb=m*n/2;k=vid;
xcoordinate=double(size(k,1));
ycoordinate=double(size(k,2));
Covariance = k .* (ycoordinate * ycoordinate');
nAssets = numel(xcoordinate); r = 0.002;     % number of assets and desired return
Aeq = ones(1,nAssets); beq = 1;              % equality Aeq*x = beq
Aineq = -xcoordinate'; bineq = -r;           % inequality Aineq*x <= bineq
lb = zeros(nAssets,1); ub = ones(nAssets,1); % bounds lb <= x <= ub
c = zeros(nAssets,1);                        % objective has no linear term; set it to zero
options = optimset('Algorithm','interior-point-convex');
T = AppEmbedding(k,message_bit);


save TT T message_bit si enkey enc_key  obj


vidObj = VideoWriter('watermarked.avi'); % create avi file
open(vidObj);

% Add next frame to movie

% newFrameOut = T;
writeVideo(vidObj,T);

close(vidObj); % all done, close file

vid_water_inp='watermarked.avi';
obj1 = VideoReader(vid_water_inp,'Tag', 'My reader object');
vid1=read(obj1);
frames1 = obj1.NumberOfFrames;
disp(['No of frames in watermarked video : ' num2str(frames1) ' frames' ])
pause(1)
msgbox('Watermarked video')

%% play video
video1 = obj1.read();
axes(handles.axes2);
title 'Watermarked Video'
fps=10;
for i=1:15

% % % for i=1:max(video1(1,1,1,:))
    imshow(video1(:,:,:,i));
    pause(1/fps);
end
disp('process completed')
msgbox('process completed')


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ILLA;