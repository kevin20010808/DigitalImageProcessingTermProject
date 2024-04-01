function [res] = convert2Sketch(img, white_threshold)
    scope = 255 / (255 - white_threshold);
    b = -scope * white_threshold;
    [m, n, c] = size(img);
    
    % Remove colors
    img_gray = repmat(rgb2gray(img), [1, 1, 3]);
    
    % Adjust curve using logical indexing
    below_threshold = img_gray <= white_threshold;
    img_gray(below_threshold) = 0;
    img_gray(~below_threshold) = scope * img_gray(~below_threshold) + b;

    % Copy layer 1 to layer 2 and reverse colors.
    img_gray2 = img_gray;  % Corrected constant value
    img_gray2 = imguidedfilter(img_gray2,3);
    img_gray2(:,:,1) = histeq(img_gray2(:,:,1)/255);
    img_gray2(:,:,2) = histeq(img_gray2(:,:,2)/255);
    img_gray2(:,:,3) = histeq(img_gray2(:,:,3)/255);
    % Mix layers
    img_mix = color_dodge(img_gray2, img_gray);
    res = uint8(img_mix);
    figure('Name', 'Mix layers');
    imshow(res);
end




function res = color_dodge(layer1, layer2)
    [m, n, c] = size(layer2);
    
    % Initialize result matrix
    res = zeros(size(layer2));
    layer1 = double(layer1);
    layer2 = double(layer2);
    if c == 1
        % For single channel
        is_max = (layer2 == 255);
        res(~is_max) = min(255, (layer1(~is_max) * 256) ./ (255 - layer2(~is_max)));
        res(is_max) = 255;
    else
        % For multiple channels
        for k = 1:c
            is_max = (layer2(:,:,k) == 255);
            res(:,:,k) = min(255, (layer1(:,:,k) * 256) ./ (255 - layer2(:,:,k)));
            res(is_max,k) = 255;
        end
    end
end





function res = min_filter(img, radius)
    filter_width = 1 + 2 * radius;

    if size(img, 3) == 1
        res = ordfilt2(img, 1, ones(filter_width));
    else
        res = zeros(size(img));
        for k = 1:size(img, 3)
            res(:, :, k) = ordfilt2(img(:, :, k), 1, ones(filter_width));
        end
    end
end




% Function for max filter
function res = max_filter(img, radius)
    filter_width = 1 + 2 * radius;

    if size(img, 3) == 1
        res = colfilt(img, [filter_width, filter_width], 'sliding', @max);
    else
        res = zeros(size(img));
        for k = 1:size(img, 3)
            res(:, :, k) = colfilt(img(:, :, k), [filter_width, filter_width], 'sliding', @max);
        end
    end
end