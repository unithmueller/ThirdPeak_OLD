function avgIntensityImage = generateAverageIntensityProjection(ImageData)
    %Function to generate the averaged intensity projection of a given image
    %stack to be used as oritenation on tracks.
    %Input: Tif stack image
    %Output: Average Intensity Projection

    %% generate the new file to save to
    %grab the size of the image
    [rows, columns, ~] = size(ImageData);
    %prepare an array to save to
    avgIntensityImage = zeros(rows, columns);
    %% iterate the pixels
    for col = 1 : columns
        for row = 1 : rows
            ZVector = ImageData(row, col, :);
            meanValue = ceil(mean(ZVector));
            avgIntensityImage(row, col) = meanValue;
        end
    end
end