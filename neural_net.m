function [] = neural_net()

global net;
global imds;
global trainingLables;
global augmentedTestSet;
global trainingFeatures;
global featureLayer;
global testSet;
global imageSize;
global classifier;

outputFolder = fullfile('Classes');
rootFolder = fullfile(outputFolder, 'verify');

%%
categories = {'Metal_Bend', 'Metal_Not_Bend'};

imds = imageDatastore(fullfile(rootFolder,categories), 'LabelSource', 'foldernames');

Metal_Bend = find(imds.Labels == 'Metal_Bend', 1);
Metal_Not_Bend = find(imds.Labels == 'MetalNot_Bend', 1);

%%
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2});

%%
imds = splitEachLabel(imds, minSetCount,'randomize');
countEachLabel(imds);

%%
net = resnet50();
net.Layers(1);
net.Layers(end);
%%
numel(net.Layers(end).ClassNames);
[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');
imageSize = net.Layers(1).InputSize;

%%
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet,'ColorPreprocessing', 'gray2rgb');

%%
% w1 = net.Layers(2).Weights;
% w1 = mat2gray(w1);

%%
featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, 'MiniBatchSize', 32, 'OutputAs', 'columns');

%%
trainingLables = trainingSet.Labels;
classifier = fitcecoc(trainingFeatures, trainingLables, 'Learner', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');
end

