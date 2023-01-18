function [Aseg1] = blacked_background(img)
  
    Agray = colouredToGray_mex(img);
     imageSize = size(img);
     numRows = imageSize(1);
    numCols = imageSize(2);


    wavelengthMin = 4/sqrt(2);
    wavelengthMax = hypot(numRows,numCols);
    n = floor(log2(wavelengthMax/wavelengthMin));
    wavelength = 2.^(0:(n-2)) * wavelengthMin;

    deltaTheta = 45;
    orientation = 0:deltaTheta:(180-deltaTheta);

    % gabor draw the limit removing background
    g = gabor(wavelength,orientation);
    %1 1
    gabormag = imgaborfilt(Agray,g);
    %2
    for i = 1:length(g)
    sigma = 0.5*g(i).Wavelength;
    K = 3;
    gabormag(:,:,i) = imgaussfilt(gabormag(:,:,i),K*sigma); 
    end
    %2
    %*
    X = 1:numCols;
    Y = 1:numRows;
    [X,Y] = meshgrid(X,Y);
    featureSet = cat(3,gabormag,X);
    featureSet = cat(3,featureSet,Y);
    %*
    %*1
    numPoints = numRows*numCols;
    X = reshape(featureSet,numRows*numCols,[]);
    %*1
    %*2
    X = bsxfun(@minus, X, mean(X));
    X = bsxfun(@rdivide,X,std(X));
    %*2
    %*3
    coeff = pca(X);
    feature2DImage = reshape(X*coeff(:,1),numRows,numCols);
    %*3
    %*3-1
    L = kmeans(X,2,'Replicates',5);
    %*3-1
    %3-2
	L = reshape(L,[numRows numCols]);
    %3-2
    
    %*3-3
    
    Aseg1 = zeros(size(img),'like',img);
%    Aseg2 = zeros(size(img),'like',img);
    BW = L == 2;
    BW = repmat(BW,[1 1 3]);
    Aseg1(BW) = img(BW);
%      Aseg2(~BW) = img(~BW);
  end


