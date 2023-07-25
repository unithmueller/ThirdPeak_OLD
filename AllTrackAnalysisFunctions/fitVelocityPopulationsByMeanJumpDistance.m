function gaussParameters = fitVelocityPopulationsByMeanJumpDistance(Axes, SaveStructure, dimension, nBins, filterIDs)
%Function to determine the number of velocity populations by fitting
%multiple gaussians onto the curve.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %dimension - defines the dimensionality to be plotted (X,Y,Z,XY,XYZ)
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       %% Get the data of choice
       data = SaveStructure.MeanJumpDist.(dimension);
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = data(:,1);
           ids = cell2mat(ids);
           idx = find(ids == filterIDs);
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = data(idx,:);
           end
           data = filteredData;
       end
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
       %% Put the data into bins
       [N,edges] = histcounts(data,nBins);
       binwidth = abs((edges(2)-edges(1)))/2;
       binCenters = edges+binwidth;
       %% Find estimates
       [f,xi] = ksdensity([binCenters; N],'Bandwidth',0.05); 
       [pks,locs,w,p] = findpeaks(f);
       initalGuessesMean = xi(locs);
       initalGuessesWidth = w;
       %% Fit the gaussians
       gaussParameters =  fitMultipleGaussians(Axes, Inputdata, initalGuessesMean, initalGuessesWidth);
       
end