close all;

img= imread('filtered_image.jpg');


% 获取图像大小
[height, width, ~] = size(img);

% 类似直方图均衡化
img = histeq(img); 

% 灰度处理
grayImage = rgb2gray(img);


% Make image lighter.
img = uint8(double(img) .* 1.5);


% Threshold for curve adjusting : During curve adjusting, the pixels whose
% values are less than this threshold will be set to 0. 
white_threshold = 40;

convert2Sketch(img, white_threshold);
