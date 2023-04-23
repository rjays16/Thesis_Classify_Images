clc,clear,close all;
warning off
[filename,pathname] = uigetfile('*.*','Choose the input image');
im = imread([pathname,filename]);
scale = 600/(max(size(im(:,:,1))));        
im = imresize(im,scale*size(im(:,:,1)));
[m,n,~] = size(im);
I = rgb2gray(im);
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
Y=fft2(double(I)); Y=fftshift(Y);
Y=convn(Y,LPF); Y=ifftshift(Y);
I_en=ifft2(Y);
I_en=imresize(I_en,size(I)); 
I_en=uint8(I_en);
I_en=imsubtract(I,I_en);
I_en=imadd(I_en,uint8(mean2(I)*ones(size(I))));
level = roundn(graythresh(I_en),-2);
BW = ~im2bw(I_en,level); 
BW = double(BW);


i = 25; BW1 = BW;
while 1
    BW2 = BW1; i = i + 1;
    BW1 = imdilate(BW1,strel('disk',i));
    BW1 = bwmorph(BW1,'bridge',inf);   
    BW1 = imfill(BW1,'holes');   
    BW1 = imerode(BW1,strel('disk',i-1));   
    tmp = bwareafilt(BW1,1);            
    tmp = fix(0.05*sum(sum(tmp)));       
    BW1  = bwareaopen(BW1,tmp);          
    CC = bwconncomp(BW1);
    if CC.NumObjects<2,break;end
end
B = bwboundaries(BW1);
Dist = zeros(length(B),1); 
a = Dist; b = Dist;
for i=1:length(B)
    tmp = B{i};
    D = pdist2(tmp,tmp);
    [D,tmp] = max(D); [Dist(i),b(i)] = max(D); a(i) = tmp(b(i));
end
x = inputdlg('Enter the area of image in M^2:',...
             'Sample', [1 50]);
A = str2double(x{:}); 
Dist = Dist*sqrt(A/(n*m));
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