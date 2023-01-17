clear;
camera = webcam();
while true
    picture = camera.snapshot;
    picture = imresize(picture,[227,227]);
    image(picture);
    drawnow;
    diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
    diff_im = medfilt2(diff_im, [3 3]);
    diff_im = imbinarize(diff_im,0.18);
    diff_im = bwareaopen(diff_im,300);
    bw = bwlabel(diff_im, 8);
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    drawnow limitrate;
    
    if ~isempty(stats)
        title('Yes');
    else
        title('No');
    end
end