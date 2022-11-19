 #include "mex.h"
 #include <windows.h>
 #include <stdio.h>
 #include <process.h>
 #include <stdio.h>
 
int main() {
while(true){
  picture = camera.snapshot;
    picture = imresize(picture,[227,227]);
    label = classify(nnet, picture);
    
    image(picture);
    tic;
    if label == 'banana'
        set(handles.edit1, 'ForegroundColor', 'green', 'string', '+ YES');
        toc;
        
        bel = res_train_classes(picture);
        
        tic;
        if bel == 'A' || bel == 'B'
            set(handles.edit2, 'ForegroundColor', 'green', 'string', '+ YES');
            set(handles.edit3, 'ForegroundColor', 'green', 'string', bel);
            toc;
                   tic;
        diff_im = imsubtract(picture(:,:,2), rgb2gray(picture)); 
      diff_im = medfilt2(diff_im, [3 3]);
      diff_im = imbinarize(diff_im,0.18);
      diff_im = bwareaopen(diff_im,300);
      bw = bwlabel(diff_im, 8);
      stats = regionprops(bw, 'BoundingBox', 'Centroid');
      toc;
      
      tic;
        imshow(picture)
        toc;
        
        tic;
      hold on
      parfor object = 1:length(stats)
          bb = stats(object).BoundingBox;
          bc = stats(object).Centroid;
          rectangle('Position',bb,'EdgeColor','g','LineWidth',2)
          plot(bc(1),bc(2), '-m+')
          a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
          set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'yellow');
      end
      toc;
      
      hold off
       drawnow limitrate;
       tic;
    if ~isempty(stats)
            set(handles.edit4, 'ForegroundColor', 'green', 'string', '+ YES');
        else
            set(handles.edit4, 'ForegroundColor', 'red', 'string', '- NO');
    end
    toc;
    
    tic;
          a = blacked_background(picture);
        imshow(a);
        drawnow limitrate;
        toc;
        
        tic;
        
%         grayImage = picture;
% [rows, columns, numberOfColorChannels] = size(grayImage)
% if numberOfColorChannels > 1
%   grayImage = rgb2gray(grayImage);
% end
% toc;
% 
% binaryImage = grayImage == 0;
% binaryImage = imclearborder(binaryImage);
% [labeledImage, numBlobs] = bwlabel(~im2bw(binaryImage,0.7));
% coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
% total_bk_spots=numBlobs-1
% props = regionprops(labeledImage, 'BoundingBox', 'Centroid');
% 
% imshow(a);
% hold on;
% for k = 1 : numBlobs
%    bb = props(k).BoundingBox;
%    bc = props(k).Centroid;
%    rectangle('Position',bb,'EdgeColor','c','LineWidth',2);
% end
% drawnow limitrate;
% hold off
tic;

grayImage = a;
[rows, columns, numberOfColorChannels] = size(grayImage);
toc;

tic;
if numberOfColorChannels > 1
  grayImage = rgb2gray(grayImage);
end

toc;

tic;
hp = impixelinfo();
binaryImage = grayImage == 0;
binaryImage = imclearborder(binaryImage);
[labeledImage, numBlobs] = bwlabel(~binaryImage);
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
props = regionprops(labeledImage, 'BoundingBox', 'Centroid');
toc;

tic;
imshow(picture);
hold on;
toc;

tic;
parfor k = 1 : numBlobs
   bb = props(k).BoundingBox;
   bc = props(k).Centroid;
   rectangle('Position',bb,'EdgeColor','c','LineWidth',2);
end

drawnow limitrate;
toc;

tic;
    if ~isempty(numBlobs) && numBlobs > 1
            set(handles.edit5, 'ForegroundColor', 'r', 'string',numBlobs);
        else
            set(handles.edit5, 'ForegroundColor', 'green', 'string', '- NONE');
    end
    toc;
    
    tic;
  if isempty(numBlobs) && ~isempty(stats) && numBlobs > 1
      title('Accepted');
          h = waitbar(0,'ACCEPTED');
    steps = 1000;
    parfor step = 800:steps
        waitbar(step / steps)
    end
    close(h)
  else
      title('Reject');
             h = waitbar(0,'REJECT');
    steps = 1000;
    parfor step = 800:steps
        waitbar(step / steps)
    end
    close(h)
  end
  toc;
        else
               toc; 
            set(handles.edit2, 'ForegroundColor', 'r', 'string', '- NONE');
            set(handles.edit3, 'ForegroundColor', 'r', 'string', '--');
            set(handles.edit4, 'ForegroundColor', 'r', 'string', '--');
            set(handles.edit5, 'ForegroundColor', 'r', 'string', '--');
            title('REJECT');
        
        toc;
    end
        
    else
    tic;
        drawnow limitrate;
        toc;
        set(handles.edit1, 'ForegroundColor', 'r', 'string', '- NONE');
        set(handles.edit2, 'ForegroundColor', 'r', 'string', '--');
        set(handles.edit3, 'ForegroundColor', 'r', 'string', '--');
        set(handles.edit4, 'ForegroundColor', 'r', 'string', '--');
        set(handles.edit5, 'ForegroundColor', 'r', 'string', '--');

end             
}
 
}
