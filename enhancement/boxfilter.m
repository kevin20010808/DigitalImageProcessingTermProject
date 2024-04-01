function imDst = boxfilter(imSrc, r)
    % 獲取輸入圖像的大小
    [hei, wid] = size(imSrc);
    
    % 初始化輸出圖像
    imDst = zeros(size(imSrc));
    
    % 計算沿垂直方向的累積和
    imCum = cumsum(imSrc, 1);
    
    % 更新輸出圖像的頂部部分
    imDst(1:r+1, :) = imCum(1+r:2*r+1, :);
    
    % 中間
    imDst(r+2:hei-r, :) = imCum(2*r+2:hei, :) - imCum(1:hei-2*r-1, :);
    
    % 底部
    imDst(hei-r+1:hei, :) = repmat(imCum(hei, :), [r, 1]) - imCum(hei-2*r:hei-r-1, :);
    
    % 計算沿水平方向的累積和
    imCum = cumsum(imDst, 2);
    
    % 更新輸出圖像的左側部分
    imDst(:, 1:r+1) = imCum(:, 1+r:2*r+1);
    
    % 中間
    imDst(:, r+2:wid-r) = imCum(:, 2*r+2:wid) - imCum(:, 1:wid-2*r-1);
    
    % 右側
    imDst(:, wid-r+1:wid) = repmat(imCum(:, wid), [1, r]) - imCum(:, wid-2*r:wid-r-1);
end
