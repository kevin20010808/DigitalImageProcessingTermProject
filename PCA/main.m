% Read the source image and guide image
sourceImage = imread('source_image.jpg');
guideImage = imread('guide_image.jpg');
[sourceHeight, sourceWidth, ~] = size(sourceImage);
[guideHeight, guideWidth, ~] = size(guideImage);
% Resize the source image to match the dimensions of the guide image
if sourceHeight ~= guideHeight || sourceWidth ~= guideWidth
    sourceImage = imresize(sourceImage, [guideHeight, guideWidth]);
end

sourceImage = im2double(sourceImage);
guideImage = im2double(guideImage);

% Apply PCA to source image for each color channel
coeffSource(:, :, 1) = pca(sourceImage(:, :, 1));
transformedSource(:,:,1) = sourceImage(:, :, 1) * coeffSource(:, :, 1);
coeffSource(:, :, 2) = pca(sourceImage(:, :, 2));
transformedSource(:,:,2) = sourceImage(:, :, 2) * coeffSource(:, :, 2);
coeffSource(:, :, 3) = pca(sourceImage(:, :, 3));
transformedSource(:,:,3) = sourceImage(:, :, 3) * coeffSource(:, :, 3);

% Apply PCA to guide image for each color channel
coeffGuide(:, :, 1) = pca(guideImage(:, :, 1));
transformedGuide(:,:,1) = guideImage(:, :, 1) * coeffGuide(:, :, 1);
coeffGuide(:, :, 2) = pca(guideImage(:, :, 2));
transformedGuide(:,:,2) = guideImage(:, :, 2) * coeffGuide(:, :, 2);
coeffGuide(:, :, 3) = pca(guideImage(:, :, 3));
transformedGuide(:,:,3) = guideImage(:, :, 3) * coeffGuide(:, :, 3);

% Simulate camera response function (CRF) compression
compressedSource = CRF(transformedSource);
compressedGuide = CRF(transformedGuide);

% Inverse PCA transformation
restoredSource = zeros(size(sourceImage));
restoredGuide = zeros(size(guideImage));

for i = 1:3
    restoredSource(:, :, i) = compressedSource(:, :, i) * inv(coeffSource(:, :, i)');
    restoredGuide(:, :, i) = compressedGuide(:, :, i) * inv(coeffGuide(:, :, i)');
end



% Guided filtering using MATLAB's imguidedfilter function for each channel
radius = 1; % Adjust the radius as needed
epsilon = 0.1; % Adjust the epsilon as needed

filteredSource = zeros(size(sourceImage));
for i = 1:3
    filteredSource(:, :, i) = guidedfilter(restoredSource(:, :, i), restoredGuide(:, :, i), radius, epsilon);
end

% Display or save the final result
figure;imshow(filteredSource);
outputFileName = 'filteredSource.jpg';
imwrite(filteredSource, outputFileName);
disp(['Filtered image saved as ' outputFileName]);

