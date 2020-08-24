function varargout = RXX(varargin)
% RXX MATLAB code for RXX.fig
%      RXX, by itself, creates a new RXX or raises the existing
%      singleton*.
%
%      H = RXX returns the handle to a new RXX or the handle to
%      the existing singleton*.
%
%      RXX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RXX.M with the given input arguments.
%
%      RXX('Property','Value',...) creates a new RXX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RXX_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RXX_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RXX

% Last Modified by GUIDE v2.5 27-Feb-2019 11:31:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RXX_OpeningFcn, ...
                   'gui_OutputFcn',  @RXX_OutputFcn, ...
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


% --- Executes just before RXX is made visible.
function RXX_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RXX (see VARARGIN)

% Choose default command line output for RXX
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RXX wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RXX_OutputFcn(hObject, eventdata, handles) 
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
global vid;global m;global n; global obj
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
%%


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
global obj
x = inputdlg('Enter the stego key:',...
             'Enter the stego key', [1 50]);
enkey = str2num(x{:}); 
enc_key =enkey;
fgh=dec2bin(enkey);
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x;global enkey;global enc_key;global fgh;global message_bit; global vid;
global m;global n;global si;global T;global obj
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

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global   x1   enkey  dnkey  lk;
global enc_key decc_key obj



% global k;
clc

load TT

% dnkey=input('Enter the Decryption key number:\n');
x1 = inputdlg('Enter the de-stego key:',...
             'Enter the de-stego key', [1 50]);
         
  dnkey = str2num(x1{:}); 
decc_key =dnkey;
fghh=dec2bin(dnkey)
% % % T= VideoReader('watermarked.avi','Tag', 'My reader object');
% % % T=read(T);
% % % si



global T si


lk=AppExtraction(T,si)
if enc_key == decc_key

disp('Press Enter to see the Hidden Text');
pause
Secret_Bit_Stream=char(lk);

disp('The Hidded data is: ')


disp(Secret_Bit_Stream)

% vv=abs((logical(k)-logical(T)).^2); 
% mse  = sum(vv(:))/numel(k);
% 
% psnr = 10*log10(255*255/mse)


else
    errordlg('Incorrect Key.....Please enter correct key','File Error');

end       

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global T  x1  si enkey  dnkey  lk;
global enc_key decc_key obj
load TT

dnkey = str2num(x1{:}); 
decc_key =dnkey;
fghh=dec2bin(dnkey);

if enkey==dnkey
disp('Press Enter to see the Hidden Text');
pause
Secret_Bit_Stream=char(lk);



else
    errordlg('Incorrect Key.....Please enter correct key','File Error');

end



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
global x;global enkey;global enc_key;global fgh;global message_bit; global vid;
global m;global n;global si;global T; global lk;global videoa;global obj;
videoa = obj.read();
axes(handles.axes1);
fps=10;
% % for i=1:max(video(1,1,1,:))
for i=1:15

    imshow(videoa(:,:,:,i));
    title 'De-Watermarked Video'

    pause(1/fps);
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ILLA;