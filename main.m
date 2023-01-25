function varargout = main(varargin)


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

function main_OpeningFcn(hObject, eventdata, handles, varargin)


set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
bg = imread('background.png'); imagesc(bg);

set(ah,'handlevisibility','off','visible','off')

uistack(ah, 'bottom');

handles.output = hObject;

guidata(hObject, handles);


function varargout = main_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles) 
global picture;
set(handles.pushbutton1,'enable','off');
set(handles.pushbutton2,'enable','on');
x = 0;

%% start program 
wb = waitbar(x,'Start Opening Camera');
waitbar(x + 0.2, wb, 'Start Opening Camera...'); 

%% callling function webcam
camera = webcam();
waitbar(x + 0.4, wb, 'Classify Images...');

%% calling deep learning model tool alexnet
alex = alexnet;
layers = alex.Layers;

%% size of layers on alexnet 
layers(23) = fullyConnectedLayer(4);
layers(25) = classificationLayer;


%% images to compare 
allImages = imageDatastore('myImages', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');

waitbar(x + 0.6, wb, 'Read Sizes of Images...');
opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);

myNet = trainNetwork(trainingImages, layers, opts);

waitbar(x + 0.8, wb, 'Re training Images for classify images');
waitbar(x + 1, wb, 'Done');
delete(wb);

 %% setup db connection 
conn = database('thesis','root','');
nnet = alexnet;
status = 0;
        
%% start looping webcam 
while true
    %% capture and resizing into 227 video image
    picture = camera.snapshot;
    picture = imresize(picture,[227,227]);
        image(picture);
        drawnow;
        
        %% Selecting stats if the banana is class a
        data_ClassA = exec(conn,'SELECT total FROM banana_process WHERE id = 1');
        data_ClassA = fetch(data_ClassA);
        
        %% Selecting stats if the banana is class b
        data_ClassB = exec(conn,'SELECT total FROM banana_process WHERE id = 2');
        data_ClassB = fetch(data_ClassB);
        
        %% Selecting stats if the banana is class rejected
        data_Rejected = exec(conn,'SELECT total FROM banana_process WHERE id = 3');
        data_Rejected = fetch(data_Rejected);
        
        %% assigning stats for class a
        a = data_ClassA.Data;
        ClassA_Interger = a{1};
        set(handles.editClassA, 'string', a);

        %% assigning stats for class b
        b = data_ClassB.Data; 
        ClassB_Interger = b{1};
        set(handles.editClassB, 'string', b);

        %% assigning stats for rejected
        rejected = data_Rejected.Data;
        rejected_Integer = rejected{1};
        set(handles.editRejected, 'string', rejected);
        
        %% overall total test for banana process
        total = ClassA_Interger + ClassB_Interger + rejected_Integer;
        set(handles.editTotal, 'string', total);

        %% compare video image into default neural network
        label = classify(nnet, picture);
  
        %% check condition if the object is banana
        if label == 'banana'
      set(handles.edit1, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));  
      %% train images convolutional neural network for classify banana variety 
      predictedLabels = classify(myNet, testImages);
      
      %% check if the banana is Cavendish 
      if predictedLabels == 'ClassA' || predictedLabels == 'ClassB'
        set(handles.edit2, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
        set(handles.edit3, 'ForegroundColor', 'g', 'string', predictedLabels);
        %% check the color of the cavendish banana if green or not 
        diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
        diff_im = medfilt2(diff_im, [3 3]);
        diff_im = imbinarize(diff_im,0.18);
        diff_im = bwareaopen(diff_im,300);
        bw = bwlabel(diff_im, 8);
        stats = regionprops(bw, 'BoundingBox', 'Centroid');
        
        %% check the image of what class of the the cavendish (If the banana is cavendish)
         if predictedLabels == 'ClassA' && ~isempty(stats)
             addClassA = 1;
             a = a + addClassA;
             
             %% Update banana_process set class={a} where id=1
             update(conn,'banana_process',{'class'},{a},{'WHERE id=1'});
             set(handles.edit4, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
             
              %% for Preprocessing only if status is 1 and 0
        status = 1;
        set(handles.txtStatus, 'string', 'Processing');
        update(conn,'status_table',{'status'},{status});
        timer = 10;
            while timer>=1
                h = msgbox(sprintf('Please wait: %d', timer));
                pause(1);
                n = n-1;
                delete(h);
            end
         status = 0;
         set(handles.txtStatus, 'string', 'Ready');
         update(conn,'status_table',{'status'},{status});
         
         elseif predictedLabels == 'ClassB' && ~isempty(stats)
             addClassB = 1;
             b = b + addClassB;
             
             %% Update banana_process set class={b} where id=2
             update(conn,'banana_process',{'class'},{b},{'WHERE id=2'});
             set(handles.edit4, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
         else
              notAccepted = 1;
             rejected = rejected + notAccepted;
             
             %% Update banana_process set class={rejected} where id=3
             update(conn,'banana_process',{'class'},{rejected},{'WHERE id=3'});
             set(handles.edit3, 'ForegroundColor', 'r', 'string', 'X');
             
              %% for Preprocessing only if status is 1 and 0
        status = 1;
        set(handles.txtStatus, 'string', 'Processing');
        update(conn,'status_table',{'status'},{status});
        timer = 10;
            while timer>=1
                h = msgbox(sprintf('Please wait: %d', timer));
                pause(1);
                n = n-1;
                delete(h);
            end
         status = 0;
         set(handles.txtStatus, 'string', 'Ready');
         update(conn,'status_table',{'status'},{status});
         end
         
      else
            %% for Preprocessing only if status is 1 and 0
        status = 1;
        set(handles.txtStatus, 'string', 'Processing');
        update(conn,'status_table',{'status'},{status});
        timer = 10;
            while timer>=1
                h = msgbox(sprintf('Please wait: %d', timer));
                pause(1);
                n = n-1;
                delete(h);
            end
         status = 0;
         set(handles.txtStatus, 'string', 'Ready');
         update(conn,'status_table',{'status'},{status});
         
        set(handles.edit2, 'ForegroundColor', 'r', 'string', 'X');
        set(handles.edit3, 'ForegroundColor', 'r', 'string', 'X');
      end
  else
      set(handles.edit1, 'ForegroundColor', 'r', 'string', 'X');
      set(handles.edit2, 'ForegroundColor', 'r', 'string', 'X');
      set(handles.edit3, 'ForegroundColor', 'r', 'string', 'X');
      set(handles.edit4, 'ForegroundColor', 'r', 'string', 'X');

  end
end

function pushbutton4_Callback(hObject, eventdata, handles)

close all; clear all; clc; delete(gcp('nocreate'));


function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)



function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');

end

function uipanel2_CreateFcn(hObject, eventdata, handles)


function figure1_SizeChangedFcn(hObject, eventdata, handles)

function pushbutton5_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
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


% --- Executes on key press with focus on pushbutton4 and none of its controls.
function pushbutton4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1, 'ForegroundColor', 'red', 'string', '');
set(handles.edit2, 'ForegroundColor', 'red', 'string', '');
set(handles.edit3, 'ForegroundColor', 'red', 'string', '');
set(handles.edit4, 'ForegroundColor', 'red', 'string', '');

set(handles.pushbutton1,'enable','on');
set(handles.pushbutton2,'enable','off');
clear all; clc;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all; clear all; clc; delete(gcp('nocreate'));



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editClassA_Callback(hObject, eventdata, handles)
% hObject    handle to editClassA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editClassA as text
%        str2double(get(hObject,'String')) returns contents of editClassA as a double


% --- Executes during object creation, after setting all properties.
function editClassA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editClassA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editClassB_Callback(hObject, eventdata, handles)
% hObject    handle to editClassB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editClassB as text
%        str2double(get(hObject,'String')) returns contents of editClassB as a double


% --- Executes during object creation, after setting all properties.
function editClassB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editClassB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editRejected_Callback(hObject, eventdata, handles)
% hObject    handle to editRejected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editRejected as text
%        str2double(get(hObject,'String')) returns contents of editRejected as a double


% --- Executes during object creation, after setting all properties.
function editRejected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editRejected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTotal_Callback(hObject, eventdata, handles)
% hObject    handle to editTotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTotal as text
%        str2double(get(hObject,'String')) returns contents of editTotal as a double


% --- Executes during object creation, after setting all properties.
function editTotal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
