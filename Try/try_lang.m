clear;
%%alexnet = alexnet;
%%layers = alexnet.Layers;
%%layers(23) = fullyConnectedLayer(4);
%%layers(25) = classificationLayer;
%%allImages = imageDatastore('myImages', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
%%[trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');
%%opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);
%%myNet = trainNetwork(trainingImages, layers, opts);

I = imread('try2.jpg');
%%sz = myNet.Layers(1).InputSize;

A = [150 800 300 500]; % [xmin ymin width height]
cropped_imageA = imcrop(I, A);

input_dataA = single(cropped_imageA);
input_dataA = (input_dataA - 128) / 128;

B = [460 800 260 500]; % [xmin ymin width height]
cropped_imageB = imcrop(I, B);

input_dataB = single(cropped_imageB);
input_dataB = (input_dataB - 128) / 128;

C = [730 800 300 500]; % [xmin ymin width height]
cropped_imageC = imcrop(I, C);

input_dataC = single(cropped_imageC);
input_dataC = (input_dataC - 128) / 128;

D = [1050 800 300 500]; % [xmin ymin width height]
cropped_imageD = imcrop(I, D);

input_dataD = single(cropped_imageD);
input_dataD = (input_dataD - 128) / 128;

E = [1340 800 300 500]; % [xmin ymin width height]
cropped_imageE = imcrop(I, E);

input_dataE = single(cropped_imageE);
input_dataE = (input_dataE - 128) / 128;

F = [1650 800 350 500]; % [xmin ymin width height]
cropped_imageF = imcrop(I, F);

input_dataF = single(cropped_imageF);
input_dataF = (input_dataF - 128) / 128;

% Run the image through the network and get the classification result
%% output = classify(myNet, input_data);

picture_resize = imresize(input_dataA,[227,227]);
imshow(input_dataA);
 hold on;
 rectangle('Position', [150 800 300 500], 'EdgeColor', 'red');
 text(400, 750, 'A', 'Color', 'red', 'FontSize', 20);
 hold off;
 
 hold on;
 rectangle('Position', [460 800 260 500], 'EdgeColor', 'b');
 text(700, 750, 'B', 'Color', 'b', 'FontSize', 20);
 hold off;
 
 hold on;
 rectangle('Position', [730 800 300 500], 'EdgeColor', 'r');
 text(1000, 750, 'C', 'Color', 'r', 'FontSize', 20);
 hold off;
 
 hold on;
 rectangle('Position', [1050 800 300 500], 'EdgeColor', 'b');
 text(1310, 750, 'D', 'Color', 'b', 'FontSize', 20);
 hold off;
 
 hold on;
 rectangle('Position', [1340 800 300 500], 'EdgeColor', 'r');
 text(1600, 750, 'E', 'Color', 'r', 'FontSize', 20);
 hold off;
 
 hold on;
 rectangle('Position', [1650 800 350 500], 'EdgeColor', 'b');
 text(1970, 750, 'F', 'Color', 'b', 'FontSize', 20);
 hold off;
 
 gray = rgb2gray(I);
 edges = edge(gray, 'Canny');
 [H, theta, rho] = hough(edges);
 peaks = houghpeaks(H, 5);
 angle = theta(peaks(2, 2));
 angle = angle * 180 / pi;
 disp(angle)
 degrees = angle * (180/pi);
 degrees = floor(degrees / 1000);
 result_degree = mod(degrees, 1000);
 disp([num2str(result_degree), char(176)]);
 %%disp([sprintf('%.0f', degrees), char(176)]);
%% disp([sprintf('%.3f', degrees), char(176)]);
% Display the result
%%disp(output);