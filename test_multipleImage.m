clear;
camera = webcam();
picture = camera.snapshot;
net1 = alexnet;
net2 = alexnet;

picture = imresize(picture,[227,227]);   
image(picture);
drawnow;

while true
bbox1 = detectObjects(picture, net1);
bbox2 = detectObjects(picture, net2);
bbox = [bbox1; bbox2];
bbox1 = detectObjects(picture, net1);
bbox2 = detectObjects(picture, net2);
bbox = [bbox1; bbox2];

imshow(picture);
hold on;
for i = 1:size(bbox, 1)
    rectangle('Position', bbox(i, :), 'EdgeColor', 'r', 'LineWidth', 2);
end
hold off;
end