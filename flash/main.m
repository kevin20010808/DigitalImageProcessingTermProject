close all;

%I = double(imread('cave-flash.jpg')) / 255;
%p = double(imread('cave-noflash.jpg')) / 255;

sourceImage = imread('source_image.jpg');
guideImage = imread('guide_image.jpg');
[sourceHeight, sourceWidth, ~] = size(sourceImage);
[guideHeight, guideWidth, ~] = size(guideImage);

% Resize the source image to match the dimensions of the guide image
if sourceHeight ~= guideHeight || sourceWidth ~= guideWidth
    sourceImage = imresize(sourceImage, [guideHeight, guideWidth]);
end

% Normalize the images to the range [0, 1]
I = im2double(sourceImage);
p = im2double(guideImage);

r = 20;
eps = 0.02^2;

q = zeros(size(I));

q(:, :, 1) = guidedfilter(I(:, :, 1), p(:, :, 1), r, eps);
q(:, :, 2) = guidedfilter(I(:, :, 2), p(:, :, 2), r, eps);
q(:, :, 3) = guidedfilter(I(:, :, 3), p(:, :, 3), r, eps);

outputFileName = 'filteredimage.jpg';
imwrite(q, outputFileName);


figure();
imshow([I, p, q], [0, 1]);