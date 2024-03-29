clear;
% Create the video input objects for the two cameras
vid1 = webcam('USB2.0 VGA UVC WebCam');
vid2 = webcam('Full HD 1080P PC Camera');

while true
    picture1 = vid1.snapshot;
    picture1 = imresize(picture1,[227,227]);
        
    picture2 = vid2.snapshot;
    picture2 = imresize(picture2,[227,227]);
 
    imshow(picture1);
    imshow(picture2);
    drawnow;
end