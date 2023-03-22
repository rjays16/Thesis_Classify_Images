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
set(handles.pushbutton1,'enable','off');
set(handles.pushbutton2,'enable','on');

try
x = 0;
[status_apache, result_apache] = system('systemctl is-active apache2');
[status_mysql, result_mysql] = system('systemctl is-active mysql'); 
data = urlread('http://localhost/');

    if status_apache == 0 && status_mysql == 0 && strcmp(result_apache, 'active') && strcmp(result_mysql, 'active') || ~isempty(data) 
        wb = waitbar(x,'Start Opening Camera');
        waitbar(x + 0.2, wb, 'Start Opening Camera...'); 
        camera = webcam();
        waitbar(x + 0.4, wb, 'Classify Images...');
        alex = alexnet;
        layers = alex.Layers;
        layers(23) = fullyConnectedLayer(3);
        layers(25) = classificationLayer;
        allImages = imageDatastore('myImages', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
        [trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');
        waitbar(x + 0.6, wb, 'Read Sizes of Images...');
        opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);
        myNet = trainNetwork(trainingImages, layers, opts);
        waitbar(x + 0.8, wb, 'Re training Images for classify images');
        waitbar(x + 1, wb, 'Done');
        delete(wb); 
        conn = database('localhost','root','');
        nnet = alexnet;
        status = 0;  

        while true
            picture = camera.snapshot;
            picture = imresize(picture,[227,227]);
            image(picture);
            drawnow;
            data_ClassA = exec(conn,'SELECT total FROM banana_process WHERE id = 1');
            data_ClassA = fetch(data_ClassA);
            data_ClassB = exec(conn,'SELECT total FROM banana_process WHERE id = 2');
            data_ClassB = fetch(data_ClassB);
            data_Rejected = exec(conn,'SELECT total FROM banana_process WHERE id = 3');
            data_Rejected = fetch(data_Rejected);
            a = data_ClassA.Data;
            ClassA_Interger = a{1};
            set(handles.editClassA, 'string', a);
            b = data_ClassB.Data; 
            ClassB_Interger = b{1};
            set(handles.editClassB, 'string', b);
            rejected = data_Rejected.Data;
            rejected_Integer = rejected{1};
            set(handles.editRejected, 'string', rejected);
            total = rejected_Integer;
            set(handles.editTotal, 'string', total);
            label = classify(nnet, picture);
  
            if label == 'banana'
                set(handles.edit1, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));  
                predictedLabels = classify(myNet, picture);
                
                if predictedLabels == 'ClassA'
                    set(handles.edit2, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                    set(handles.edit3, 'ForegroundColor', 'g', 'string', predictedLabels);    
                    addClassA = 1;
                    ClassA_Interger = ClassA_Interger + addClassA;
                    ClassA_string = num2str(ClassA_Interger);
                    diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
                    diff_im = medfilt2(diff_im, [3 3]);
                    diff_im = imbinarize(diff_im,0.18);
                    diff_im = bwareaopen(diff_im,300);
                    bw = bwlabel(diff_im, 8);
                    stats = regionprops(bw, 'BoundingBox', 'Centroid');
                    
                    if ~isempty(stats)
                        set(handles.edit4, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                    else
                        set(handles.edit4, 'ForegroundColor', 'r', 'string', 'X');
                    end
        
                    set_for_spot = blacked_background(picture);
                    imshow(set_for_spot);
                    drawnow limitrate;
                    grayImage = set_for_spot;
                    [rows, columns, numberOfColorChannels] = size(grayImage);
             
                    if numberOfColorChannels > 1
                        grayImage = rgb2gray(grayImage);
                    end
                
                    binaryImage = grayImage == 0;
                    binaryImage = imclearborder(binaryImage);
                    [labeledImage, numBlobs] = bwlabel(binaryImage);
                    coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
                    props = regionprops(labeledImage, 'BoundingBox', 'Centroid');
                    imshow(picture);
                    hold on;
              
                    for k = 1 : numBlobs
                        bb = props(k).BoundingBox;
                        bc = props(k).Centroid;
                        rectangle('Position',bb,'EdgeColor','c','LineWidth',2);
                    end
                    
                    drawnow limitrate;
             
                    if isempty(numBlobs)
                        set(handles.txtStatus, 'string', 'Processing');
                        set(handles.edit5, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                 
                        if ~isempty(stats)
                            query = ['UPDATE banana_process SET total = ', ClassA_string, ' WHERE id = 1'];
                            exec(conn, query);
                            query_status_table = 'UPDATE status_table SET status = 1 WHERE id = 1';
                            exec(conn, query_status_table);
                            timer = 5;
                            h = msgbox(sprintf('Please wait: %d', timer));
                            pause(timer);
                            delete(h);
                            set(handles.txtStatus, 'string', 'Ready');
                            query_status_table = 'UPDATE status_table SET status = 0 WHERE id = 1';
                            exec(conn, query_status_table);
                        end
                    else
                  
                        set(handles.edit5, 'ForegroundColor', 'r', 'string', 'X');
                        set(handles.txtStatus, 'string', 'Processing');
                        notAccepted = 1;
                        rejected_Integer = rejected_Integer + notAccepted;
                        reject_string = num2str(rejected_Integer);
                        query = ['UPDATE banana_process SET total = ', reject_string, ' WHERE id = 3'];
                        exec(conn, query);
                        query = 'UPDATE status_table SET status = 1 WHERE id = 0';
                        exec(conn, query);
                        timer = 5;
                        h = msgbox(sprintf('Please wait: %d', timer));
                        pause(timer);
                        delete(h);
                        set(handles.txtStatus, 'string', 'Ready');
                        query = 'UPDATE status_table SET status = 0 WHERE id = 1';
                        exec(conn, query);   
                    end
             
                query = 'UPDATE status_table SET status = 1 WHERE id = 0';
                exec(conn, query);
                timer = 5;
                h = msgbox(sprintf('Please wait: %d', timer));
                pause(timer);
                delete(h);
                set(handles.txtStatus, 'string', 'Ready');
                query = 'UPDATE status_table SET status = 0 WHERE id = 1';
                exec(conn, query);   
        
                elseif predictedLabels == 'ClassB'
         
                    set(handles.edit2, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                    set(handles.edit3, 'ForegroundColor', 'g', 'string', predictedLabels);    
                    addClassB = 1;
                    ClassB_Interger = ClassB_Interger + addClassB;
                    ClassB_string = num2str(ClassB_Interger);
                    diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
                    diff_im = medfilt2(diff_im, [3 3]);
                    diff_im = imbinarize(diff_im,0.18);
                    diff_im = bwareaopen(diff_im,300);
                    bw = bwlabel(diff_im, 8);
                    stats = regionprops(bw, 'BoundingBox', 'Centroid');
             
                if ~isempty(stats)
                    set(handles.edit4, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                else
                    set(handles.edit4, 'ForegroundColor', 'r', 'string', 'X');
                end
        
                set_for_spot = blacked_background(picture);
                imshow(set_for_spot);
                drawnow limitrate;
                grayImage = set_for_spot;
                [rows, columns, numberOfColorChannels] = size(grayImage);
                        
                if numberOfColorChannels > 1
                    grayImage = rgb2gray(grayImage);
                end
                
                binaryImage = grayImage == 0;
                binaryImage = imclearborder(binaryImage);
                [labeledImage, numBlobs] = bwlabel(binaryImage);
                coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
                props = regionprops(labeledImage, 'BoundingBox', 'Centroid');
                imshow(picture);
                hold on;
                
                for k = 1 : numBlobs
                    bb = props(k).BoundingBox;
                    bc = props(k).Centroid;
                    rectangle('Position',bb,'EdgeColor','c','LineWidth',2);
                end
                
                drawnow limitrate;
             
                if isempty(numBlobs)
                    set(handles.txtStatus, 'string', 'Processing');
                    set(handles.edit5, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                    
                    if ~isempty(stats)
                        query = ['UPDATE banana_process SET total = ', ClassB_string, ' WHERE id = 2'];
                        exec(conn, query);
                        query_status_table = 'UPDATE status_table SET status = 1 WHERE id = 1';
                        exec(conn, query_status_table);
                        timer = 5;
                        h = msgbox(sprintf('Please wait: %d', timer));
                        pause(timer);
                        delete(h);
                        set(handles.txtStatus, 'string', 'Ready');
                        query_status_table = 'UPDATE status_table SET status = 0 WHERE id = 1';
                        exec(conn, query_status_table);
                    end
                else
                  
                    set(handles.edit5, 'ForegroundColor', 'r', 'string', 'X');
                    set(handles.txtStatus, 'string', 'Processing');
                    notAccepted = 1;
                    rejected_Integer = rejected_Integer + notAccepted;
                    reject_string = num2str(rejected_Integer);
                    query = ['UPDATE banana_process SET total = ', reject_string, ' WHERE id = 3'];
                    exec(conn, query);
                    query = 'UPDATE status_table SET status = 1 WHERE id = 0';
                    exec(conn, query);
                    timer = 5;
                    h = msgbox(sprintf('Please wait: %d', timer));
                    pause(timer);
                    delete(h);
                    set(handles.txtStatus, 'string', 'Ready');
                    query = 'UPDATE status_table SET status = 0 WHERE id = 1';
                    exec(conn, query);   
                end
             
                query = 'UPDATE status_table SET status = 1 WHERE id = 0';
                exec(conn, query);
                timer = 5;
                h = msgbox(sprintf('Please wait: %d', timer));
                pause(timer);
                delete(h);
                set(handles.txtStatus, 'string', 'Ready');
                query = 'UPDATE status_table SET status = 0 WHERE id = 1';
                exec(conn, query);   
                
                else
                    
                    set(handles.txtStatus, 'string', 'Processing');
                    query = 'UPDATE status_table SET status = 1 WHERE id = 1';
                    exec(conn, query);
                    notAccepted = 1;
                    rejected_Integer = rejected_Integer + notAccepted;
                    reject_string = num2str(rejected_Integer);
                    query = ['UPDATE banana_process SET total = ', reject_string, ' WHERE id = 3'];
                    exec(conn, query);
                    set(handles.edit2, 'ForegroundColor', 'r', 'string', 'X');
                    set(handles.edit3, 'ForegroundColor', 'r', 'string', 'X');
                    set(handles.edit4, 'ForegroundColor', 'r', 'string', 'X');
                    set(handles.edit5, 'ForegroundColor', 'r', 'string', 'X');
                    query = 'UPDATE status_table SET status = 0 WHERE id = 1';
                    exec(conn, query);
                    timer = 5;
                    h = msgbox(sprintf('Please wait: %d', timer));
                    pause(timer);
                    delete(h);
                    set(handles.txtStatus, 'string', 'Ready');
                end
            else
                
                set(handles.edit1, 'ForegroundColor', 'r', 'string', 'X');
                set(handles.edit2, 'ForegroundColor', 'r', 'string', 'X');
                set(handles.edit3, 'ForegroundColor', 'r', 'string', 'X');
                set(handles.edit4, 'ForegroundColor', 'r', 'string', 'X');
                set(handles.edit5, 'ForegroundColor', 'r', 'string', 'X');
        end
        end
    end
catch ME
    errordlg(['Error checking services: ' ME.message]);
    set(handles.pushbutton1,'enable','on');
    set(handles.pushbutton2,'enable','off');
    system('start C:\xampp8.2.0\xampp-control.exe');
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
set(handles.edit5, 'ForegroundColor', 'red', 'string', '');
set(handles.editClassA, 'ForegroundColor', 'red', 'string', '');
set(handles.editClassB, 'ForegroundColor', 'red', 'string', '');
set(handles.editRejected, 'ForegroundColor', 'red', 'string', '');
set(handles.editTotal, 'ForegroundColor', 'red', 'string', '');
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



function editspot_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function editspot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSpot_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function editSpot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
