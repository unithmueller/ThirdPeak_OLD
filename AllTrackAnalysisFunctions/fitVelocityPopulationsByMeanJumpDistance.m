function gaussParameters = fitVelocityPopulationsByMeanJumpDistance(Axes, SaveStructure, dimension, nBins, filterIDs, populationNumber, lengthUnit, isPixel)
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
       binCenters = binCenters(1:end-1);
       %% Find estimates for the number of peaks
       NumberOfPeaks = str2double(populationNumber);
       % smooth the histogram
       dist = fitdist(data, 'kernel', "Kernel", "box");
       bw = dist.BandWidth;
       xvals = binCenters;
       yvals = pdf(dist, xvals);
       P = allpeaks(binCenters, yvals);
       NmbrMax = size(P,1);
       Count = 1;
       
       while ((NmbrMax > NumberOfPeaks*2) || (NmbrMax <= NumberOfPeaks-1)) && (Count < 20)
           bw = bw*0.9;
           dist = fitdist(data, 'kernel', "Kernel", "box", "Width", bw);
           yvals = pdf(dist, xvals);
           P = allpeaks(binCenters, yvals);
           NmbrMax = size(P,1);
           Count = Count+1;
       end
       %% get estimates
       if Count < 20
           %% Fit the gaussians
           gaussParameters =  fitMultipleGaussians(Axes, [binCenters.', yvals.'], P(:,1), P(:,2), lengthUnit, isPixel);
       end
       
end