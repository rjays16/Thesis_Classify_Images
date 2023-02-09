% Load the image
img = imread('daw.png');

% Convert to grayscale
gray = rgb2gray(img);

% Apply the Canny edge detector
edges = edge(gray, 'Canny');

% Perform the Hough Transform
[H, theta, rho] = hough(edges);

% Find the peaks in the Hough Transform
peaks = houghpeaks(H, 5);

% Extract the angle information from the Hough Transform
angle = theta(peaks(2, 2));

% Convert the angle to degrees
angle = angle * 180 / pi;

% Display the angle
disp(angle)