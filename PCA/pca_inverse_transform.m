function restoredData = pca_inverse_transform(transformedData, coeff)
    % Reshape the transformed data to a 2D matrix
    [numSamples, numFeatures] = size(transformedData);

    % Perform PCA inverse transform
    restoredData = transformedData * pinv(coeff);
    
    % Reshape the restored data back to the original size
    restoredData = reshape(restoredData, [numSamples, numFeatures]);
end
