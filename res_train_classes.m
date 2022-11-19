function [net] = res_train_classes()
%%
global imds;
global net;
global classifier;
global trainingFeatures;
global trainingLables;

outputFolder = fullfile('Classes');
rootFolder = fullfile(outputFolder, 'verify');

%%
categories = {'Metal_Bend', 'Metal_Not_Bend'};

imds = imageDatastore(fullfile(rootFolder,categories), 'LabelSource', 'foldernames');

%%
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2});

%%
imds = splitEachLabel(imds, minSetCount,'randomize');
countEachLabel(imds);

%%
Metal_Bend = find(imds.Labels == 'Metal_Bend', 1);
Metal_Not_Bend = find(imds.Labels == 'Metal_Not_Bend', 1);
%%

net = resnet50();


end


