        function outputImage = generateAverageIntensityProjection(app)
            %generates the average intensity projection if this option is
            %chosen by the user
            imagestack = app.ImageData;
            %generate the averageIntensityProjection
            [rows, columns, ~] = size(imagestack);
            outputImage = zeros(rows, columns);
            for col = 1 : columns
                for row = 1 : rows
                    ZVector = imagestack(row, col, :);
                    meanValue = ceil(mean(ZVector));
                    outputImage(row, col) = meanValue;
                end
            end
            %app.AveragedImageData = outputImage;
        end