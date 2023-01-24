clear;
camera = webcam();
alex = alexnet;
layers = alex.Layers;
layers(23) = fullyConnectedLayer(4);
layers(25) = classificationLayer;
allImages = imageDatastore('myImages', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');
opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);
myNet = trainNetwork(trainingImages, layers, opts);


while true
        picture = camera.snapshot;
        picture = imresize(picture,[227,227]);
        testImages = picture;

        predictedLabels = classify(myNet, testImages);
          image(picture);
          title(char(predictedLabels));
          drawnow;
end