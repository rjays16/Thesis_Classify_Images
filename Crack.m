% Clear memory and command window
clc,clear,close all;
warning off

%% Uploading input image
[filename,pathname] = uigetfile('*.*','Choose the input image');
im = imread([pathname,filename]);
% set the image size to suitable value
scale = 600/(max(size(im(:,:,1))));        
im = imresize(im,scale*size(im(:,:,1)));
% % Image resize
[m,n,~] = size(im);

%% Image processing
% Convert image from RGB to gray scale
I = rgb2gray(im);

% Image enhancment
% First) 9*9 low pass filter
[f1,f2]=freqspace(size(I),'meshgrid');
D=100/size(I,1);
LPF = ones(9); 
r=f1.^2+f2.^2;
for i=1:9
    for j=1:9
        t=r(i,j)/(D*D);
        LPF(i,j)=exp(-t);
    end
end
% Second) applying filter
Y=fft2(double(I)); Y=fftshift(Y);
Y=convn(Y,LPF); Y=ifftshift(Y);
I_en=ifft2(Y);
% Third) blurr image
I_en=imresize(I_en,size(I)); 
I_en=uint8(I_en);
I_en=imsubtract(I,I_en);
I_en=imadd(I_en,uint8(mean2(I)*ones(size(I))));

% Segmentation of image
level = roundn(graythresh(I_en),-2); % Calculate threshold using  Otsu's method
BW = ~im2bw(I_en,level);  % Convert image to binary image using threshold
BW = double(BW);

% Removing noise and conecting image
i = 25; BW1 = BW;
while 1
    BW2 = BW1; i = i + 1;
    BW1 = imdilate(BW1,strel('disk',i));  % dialate image
    BW1 = bwmorph(BW1,'bridge',inf);      % connecting close parts
    BW1 = imfill(BW1,'holes');            % filling small spaces
    BW1 = imerode(BW1,strel('disk',i-1));   % erode image
    tmp = bwareafilt(BW1,1);              % get size of biggest connected shape
    tmp = fix(0.05*sum(sum(tmp)));        % size considered noise
    BW1  = bwareaopen(BW1,tmp);           % remove isolated pixels
    CC = bwconncomp(BW1);
    if CC.NumObjects<2,break;end          % break the loop at convergence
end
B = bwboundaries(BW1); % Cracks boundaries

%% Claculating cracks dimensions
Dist = zeros(length(B),1); % Preallocation
a = Dist; b = Dist; % Preallocation
for i=1:length(B)
    tmp = B{i};
    D = pdist2(tmp,tmp); % Euclidean distance between each 2 points
    % Value and position of farthest 2 points
    [D,tmp] = max(D); [Dist(i),b(i)] = max(D); a(i) = tmp(b(i));
end


%% Showing results
figure('Position',[76,84,1249,578])
subplot(2,2,1),imshow(I,[]);
title('Gray scale Image');

subplot(2,2,2),imshow(I_en,[]);
title('Enhancement image');

subplot(2,2,3),imshow(BW,[]);
title(['Segmented Image -- Threshold = ',num2str(level)]);

subplot(2,2,4),imshow(BW1,[]);
title('Removed noise Image');

x = inputdlg('Enter the area of image in M^2:',...
             'Sample', [1 50]);
A = str2double(x{:}); 
Dist = Dist*sqrt(A/(n*m)); % convert distances into meters

figure,imshow(im);hold on
for i=1:length(B)
    tmp = B{i};
    plot(tmp(:,2),tmp(:,1),'r','LineWidth',2);
    plot([tmp(a(i),2),tmp(b(i),2)],[tmp(a(i),1),...
        tmp(b(i),1)],'*-b','LineWidth',2);
    text(1+0.5*sum([tmp(a(i),2),tmp(b(i),2)]),1+0.5*sum([tmp(a(i),1),...
        tmp(b(i),1)]),num2str(Dist(i)),'Color','k','FontSize',20);
end
hold off,title('Final Result');
warning on