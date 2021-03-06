 function varargout = Trafficmain(varargin)
% TRAFFICMAIN M-file for Trafficmain.fig
%      TRAFFICMAIN, by itself, creates a new TRAFFICMAIN or raises the existing
%      singleton*.

%singleton" option to prevent an appearing of more than one instance of gui
%
%      H = TRAFFICMAIN returns the handle to a new TRAFFICMAIN or the handle to
%      the existing singleton*.
%
%      TRAFFICMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAFFICMAIN.M with the given input arguments.
%
%      TRAFFICMAIN('Property','Value',...) creates a new TRAFFICMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Trafficmain_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Trafficmain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Trafficmain


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Trafficmain_OpeningFcn, ...
                   'gui_OutputFcn',  @Trafficmain_OutputFcn, ...
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


% --- Executes just before Trafficmain is made visible.
function Trafficmain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Trafficmain (see VARARGIN)

% Choose default command line output for Trafficmain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Trafficmain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Trafficmain_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





%{



Every graphics "object" (a figure, an axes, a button, a textbox etc) is represented by a "handle" variable. That's the hObject.

If you're making a GUI, you actually want to store data about the "state" of the program inside the GUI somewhere. Think of a GUI with 2 buttons (one with a "+", one with a "-") and a text display that starts at "1". If the user clicks the +, that display should increment. If the user clicks the "-" that display should decrement.

Somewhere in the GUI, a "counter" variable needs to be stored. One way of doing it is storing it in the "guidata" of your figure's GUI. That's a special location specifically for GUIs. I think that there are two reasons why it's special:

Every hObject (a pushbutton, an axes, etc) that is a child of the same figure points to the same "guidata". So it's a common place for all parts of a GUI to share data.
Any callback function in the GUI automatically gets the guidata as its third argument. That is, whenever you click a button of a GUI with some guidata set, the input parameters (by default) is always a copy of guidata(GUIhandle), made immediately at the time of clicking the button.
So a callback function will look like:

function pushButtonCallback(buttonHandle, eventData, handles)
...
disp(handles)
Now, handles is just a structure, so let's say that we've stored the counter that we're using in handles.counter. In other words, somewhere at the start of your GUI you had lines like:

handles = guidata(hObject);
handles.counter = 1;
guidata(hObject, handles);
When they hit the "+" button, we want to increment handles.counter, but we also want this new value available to every other callback. To do that, we need to update the handles.counter field, and then put handles back into the GUIs guidata. As soon as we've done that, the next time the user clicks a button, they'll be using the newly updated version of handles.

function plusPushButtonCallback(buttonHandle, eventData, handles)
% At THIS point, "handles" is just a copy of guidata for the GUI
handles.counter = handles.counter + 1;
% At THIS point, "handles" is different to the guidata for the GUI
guidata(buttonHandle, handles);
% At THIS point, "handles" has been put back in as new guidata for the GUI

%}











% --- Executes on button press in pushbutton1.
%load video
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid

[ vfilename, vpathname ] = uigetfile( '*.avi', 'Select the video' );
vid=aviread(strcat( vpathname, vfilename ));
axes(handles.axes1);
movie(vid);
axis off
last = {vid.cdata};
lastim = last{1,length(last)};
axes(handles.axes1);
imshow(lastim);
axis off
%axis equal sets the aspect ratio so that the data units are the same in
%every direction.
axis equal




% --- Executes on button press in pushbutton2.

%convert to frames.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid frames
frames = {vid.cdata};
for i = 1:length(frames)
    figure(1),
    subplot(20,10,i),  imagesc(frames{i});
   
    %imagesc(C) displays C as an image. Each element of C corresponds to a
    %rectangular area in the image. 
    axis image off
    drawnow;
end;


% --- Executes on button press in pushbutton3.
%    related to main detection bright light
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frames
for i = 1:200
        img = frames{i};
        [m n c] = size(img);
        if c == 3
           img = rgb2gray(img);
        end
        morphedgebseg(img);
        
end

%main detection
% --- Executes on button press in pushbutton4.

function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frames 
numveh = zeros(200,2);
for ite = 1:70
        img = frames{ite};
        [m n c] = size(img);
        if c == 3
           img = rgb2gray(img);
        end
%converting rgb to bw
%=================================================================
tic
 morphedgebseg(img);
 %-------------------
 im = imread('out2.jpg');
  bim =im2bw(im);%grayscale to binary
 roire = imread('roipoly134.jpg');
[aa1 bb1] = size(bim);
roire=imresize(roire,[aa1 bb1]);%B = imresize(A, scale) returns image B that is scale times the size of A. 
%The input image A can be a grayscale, RGB, or binary image. If scale is between 0 and 1.0, B is smaller than A. If scale is greater than 1.0, B is larger than A.


[aa bb] = size(roire);
%--------------------

%---------
%extracting white regions with corresponding pos in image
for as = 1:aa
    for bs = 1:bb
        if roire(as,bs) == 255
            copyregion(as,bs) = bim(as,bs);% reason behind using bim is gives 0 and 1 op which means complete black or white
        end
    end
end
%---------
figure(3),
imshow(copyregion)

%[L, num] = bwlabel(BW, n) returns in num the number of connected objects found in BW.
[labeledImage numberOfBlobs] = bwlabel(copyregion, 8);

%regionprops store data to blob measurements -bouding box of connected
%region centriod of region area of region -for each roi
 blobMeasurements = regionprops(labeledImage, 'BoundingBox','Centroid','Area');
%  centroids = cat(1, blobMeasurements.Centroid);
centroids = [];
 figure(4);
 imshow(img)
 hold on
 %hold on retains plots in the current axes so that new plots added to the
 %axes do not delete existing plots.
 %here is the code for centriod measurement
  for k = 1 : numberOfBlobs
      if blobMeasurements(k).Area>50 && blobMeasurements(k).Area<300 
        boundingBox = blobMeasurements(k).BoundingBox; % place box.
        rectangle('Position',boundingBox,'EdgeColor','g' )%draw rectangle with green color
        centroids = [centroids;blobMeasurements(k).Centroid]
        % store centriod in centriods
        hold on
      end
  end
   
  
 %=========================================================
  hold on
  plot(centroids(:,1), centroids(:,2), 'b*')%plot centroid with blue star
  hold on
 %main calculation start here
 copycentroids = centroids;
 centroids = round(centroids);
 ch = centroids(:,2);
 [row col] = size(centroids);
 ind = zeros(row,2);
 ind(:,1) = 1:row;
 for q = 1:(row-1)
    temp = centroids(q,2);
    for x = q+1:numel(ch)

         if (temp>ch(x)-5) && (temp<ch(x)+5)
            ind(q,2) = x;
        end
    end
 end
 count = 0;
  ch = centroids(:,2);
  %counting of vehicles start here------
 for q = 1:row
      temp = centroids(q,2);
   
     for x = q+1:numel(ch)
        if (temp>ch(x)-8) && (temp<ch(x)+8)
            %getting two adjacent centroids
           p1 = centroids(q,:);
           p2 = centroids(x,:);
           F =pdist([p1;p2]);
           if F<60
               X = [p1(1,1),p2(1,1)];
               Y = [p1(1,2),p2(1,2)];
               line(X,Y,'LineWidth',1,'Color',[1 1 0])
               count = count+1;
           end
        end
    end
 end
 endtime = toc;
 
 %saving data to numveh.mat starts here
 numveh(ite,:) = [count,endtime];
 save numveh numveh
%=================================================================
        
end


% --- Executes on button press in pushbutton5.
%graph no of vehicles
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load numveh
set(handles.uitable1,'Data',numveh);
figure(5),
bar(numveh(:,1)');
title('Detected Vehicles Per Frame');
xlabel('Number Of Frames');
ylabel('Count');
figure(6),
plot(numveh(:,2),'-ro');
title('Time Computation');
xlabel('Number Of Frames');
ylabel('Time(s)');


% --- Executes on button press in pushbutton7.
%speed graph
function pushbutton7_Callback(hObject, eventdata, handles)
load vehiclespeed;
figure;
semilogx(vehiclespeed, 'b*-');
ylim([1 50]);
legend('Speed Estimation','Proposed Method');
xlabel('Speed');
ylabel('Vehicles');
title('SPEED ESTIMATION');
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
%background detection
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid frames
for i = 1:30
     im = frames{i};
    [a b c]=size(im);
    if (c==3)
        I=rgb2gray(im);
    else
        I=im;
    end
    f=edge(I,'sobel');
    figure(2),imshow(f);
end


% --- Executes on button press in pushbutton9.
%error correction preprocessing
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid frames nFrames
for i = 1:200
     im = frames{i};
G = fspecial('gaussian',[2 2],2);
img1 = imfilter(im,G,'same');
figure(2),
imshow(img1);
axis off;
title('Preprocessed Image','color','Black','fontsize',14,'fontname','Times New Roman');
end

%estimation
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = load('numveh.mat')
for f = fieldnames(S)
   disp(['Field named: ' f{1} ]);
   disp('Has value ')
   disp(S.(f{1}))
   
end
M = max(S.(f{1}))
   
   disp(M)
   
  
   
   
C = [num2str(M+2),' '];
set(handles.text2, 'string', C);
   
   
