clear 
camera = webcam();

while true
    picture = camera.snapshot;
    picture = imresize(picture,[227,227]);
        image(picture);
        drawnow;
        
        a = blacked_background(picture);
         imshow(a);
         drawnow limitrate;
         
         grayImage = a;
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
end