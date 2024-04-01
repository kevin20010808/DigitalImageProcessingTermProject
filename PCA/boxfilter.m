function imDst = boxfilter(imSrc, r)
    [height, width] = size(imSrc);
    imDst = zeros(size(imSrc));
    
    imCum = cumsum(imSrc, 1);
    imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
    imDst(r+2:height-r, :) = imCum(2*r+2:height, :) - imCum(1:height-2*r-1, :);
    imDst(height-r+1:height, :) = repmat(imCum(height, :), [r, 1]) - imCum(height-2*r:height-r-1, :);
    imCum = cumsum(imDst, 2);
    imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
    imDst(:, r+2:width-r) = imCum(:, 2*r+2:width) - imCum(:, 1:width-2*r-1);
    imDst(:, width-r+1:width) = repmat(imCum(:, width), [1, r]) - imCum(:, width-2*r:width-r-1);
end
