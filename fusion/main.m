% Read the source image and guide image
sourceImage = imread('source_image.jpg');
guideImage = imread('guide_image.jpg');
[sourceHeight, sourceWidth, ~] = size(sourceImage);
[guideHeight, guideWidth, ~] = size(guideImage);

% Resize the source image to match the dimensions of the guide image
if sourceHeight ~= guideHeight || sourceWidth ~= guideWidth
    sourceImage = imresize(sourceImage, [guideHeight, guideWidth]);
end

% Normalize the images to the range [0, 1]
sourceImage = im2double(sourceImage);
guideImage = im2double(guideImage);

% Define averaging filter

h1 = fspecial('average', [31, 31]);

% Filter the source and guide images
B1 = imfilter(sourceImage, h1, 'replicate');
B2 = imfilter(guideImage, h1, 'replicate');
D1 = sourceImage - B1;
D2 = guideImage - B2;

% Define Laplacian filter
h2 = fspecial('laplacian', 0.2);
H1 = imfilter(sourceImage, h1, 'replicate');
H2 = imfilter(guideImage, h2, 'replicate');

H1 = abs(H1);
H2 = abs(H2);

% Define Gaussian filter
h3 = fspecial('gaussian', [11, 11], 5);

% Filter the Laplacian images
S1 = imfilter(H1, h3, 'replicate');
S2 = imfilter(H2, h3, 'replicate');

% Compute weight maps
P1 = wmap(S1, S2);
P2 = wmap(S2, S1);

% Set epsilon values
eps1 = 0.3^2;
eps2 = 0.03^2;

% Initialize filtered images
Wb1 = zeros(size(sourceImage));
Wb2 = zeros(size(sourceImage));
Wd1 = zeros(size(sourceImage));
Wd2 = zeros(size(sourceImage));

% Apply guided filtering for each channel
for i = 1:3
    Wb1(:,:,i) = guidedfilter(sourceImage(:,:,i), P1(:,:,i), 8, eps1);
    Wb2(:,:,i) = guidedfilter(sourceImage(:,:,i), P1(:,:,i), 8, eps1);
    Wd1(:,:,i) = guidedfilter(sourceImage(:,:,i), P1(:,:,i), 4, eps2);
    Wd2(:,:,i) = guidedfilter(sourceImage(:,:,i), P1(:,:,i), 4, eps2);
end

% Compute maximum weights
Wbmax = Wb1 + Wb2;
Wdmax = Wd1 + Wd2;

% Normalize weights
Wb1 = Wb1 ./ Wbmax;
Wb2 = Wb2 ./ Wbmax;
Wd1 = Wd1 ./ Wdmax;
Wd2 = Wd2 ./ Wdmax;

% Compute final images
B = B1 .* Wb1 + B2 .* Wb2;
D = D1 .* Wd1 + D2 .* Wd2;

% Combine the images
filteredImage = B + D;

% Display the original image, guide image, and filtered image
figure;

subplot(131);
imshow(sourceImage);
title('Source Image');

subplot(132);
imshow(guideImage);
title('Guide Image');

subplot(133);
imshow(filteredImage);
title('Filtered Image');

outputFileName = 'filtered_image.jpg';
imwrite(filteredImage, outputFileName);
disp(['Filtered image saved as ' outputFileName]);

