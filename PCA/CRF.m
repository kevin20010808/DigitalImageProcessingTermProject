function compressedImage = CRF(inputImage)
    % Assume the input image is in double format
    % You may need to convert the image to double before applying this function

    % Simulate camera response function (CRF) compression
    % This is a simplified example, and you may need to use an actual CRF curve
    compressedImage = inputImage .^ 0.5;  % Example: square root compression

    % Ensure that the compressed image is in the valid range [0, 1]
    compressedImage = max(0, min(1, compressedImage));
end
