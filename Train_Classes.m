

%% 
alex = alexnet;
layers = alex.Layers

%%
layers(23) = fullyConnectedLayer(3);
layers(25) = classificationLayer;


%%
allImages = imageDatastore('Classes', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');

%%
opts = trainingOptions('sgdm', 'MaxEpochs', 100, 'InitialLearnRate', 0.00005, 'ExecutionEnvironment', 'auto');
myNet1 = trainNetwork(trainingImages, layers, opts);

%%
predictedLabels = classify(myNet1, testImages);
accuracy = mean(predictedLabels == testImages.Labels);