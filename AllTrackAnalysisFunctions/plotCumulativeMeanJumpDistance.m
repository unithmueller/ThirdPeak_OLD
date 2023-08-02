function [minv, maxv, gaussDat, kernelDat] = plotCumulativeMeanJumpDistance(Axes, binNumbers, SaveStructure, dimension, isPixel, lengthUnit, filterIDs, performFit)
%Function to plot the respective cumulative mean jump distances as a histogram in the track
%analysis window. During generation of the track, the track-id is lost,
%therefore we need to filter the mean jump distance and recalculate the
%data if necessary.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %dimension - defines the dimensionality to be plotted (X,Y,Z,XY,XYZ)
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       
       %% Get the data of choice
       data = SaveStructure.CumMeanJumpDist.(dimension){1,1};
       
       %% Apply the filter if necessary. Need to filter via the mean track length
       if size(filterIDs,1)>0
           data = SaveStructure.MeanJumpDist.(dimension);
           ids = data(:,1);
           ids = cell2mat(ids);
           idx = find(ids == filterIDs);
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = data(idx,:);
           end
           SaveStructure.MeanJumpDist.(dimension) = filteredData;
           SaveStructure = calculateCumulativeMeanJumpDistance(SaveStructure, SaveStructure);
           data = SaveStructure.CumMeanJumpDist.(dimension); 
       end
       %% Unpack the cell array
       %data = cell2mat(data(:,2));
       
       %% Plot the data
       minv = min(data);
       maxv = max(data);
       edges = linspace(minv, maxv, binNumbers);
       his = histogram(Axes, data, edges);
       hixMaxValue = max(his.Values);
       xlim(Axes, [minv maxv]);
       title(Axes, join(["Cumulative Mean Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Cumulative Mean Jump Distance in [px]");
       else
           xlabel(Axes, sprintf("Cumulative Mean Jump Distance in [%s]", lengthUnit));
       end
       
       %% Decide if we fit or not
       if performFit
           %% perform fit
           pdGauss = fitdist(data, "Normal");
           pdKernel = fitdist(data, "Kernel", "Width", []);

           %% generate matching data
           xFitData = minv:1:maxv;
           yGauss = pdf(pdGauss, xFitData);
           yKernel = pdf(pdKernel, xFitData);
           maxyGauss = max(yGauss);
           maxyKernel = max(yKernel);
           %scaling factor
           scalingFactorGauss = hixMaxValue/maxyGauss;
           scalingFactorKernel = hixMaxValue/maxyKernel;
           
           %scale the data
           yGauss = yGauss*scalingFactorGauss;
           yKernel = yKernel*scalingFactorKernel;

           %% plot
           axes(Axes);
           hold(Axes,"on")
           gp = plot(Axes, xFitData, yGauss, "--r");
           kp = plot(Axes, xFitData, yKernel, "k");
           legend(Axes, "Histogram", "GaussFit", "KernelFit");
           hold(Axes,"off")
           
           %% get the data from fit
           gaussDat = [median(pdGauss), mean(pdGauss), std(pdGauss), var(pdGauss)];
           kernelDat = [median(pdKernel), mean(pdKernel), std(pdKernel), var(pdKernel)];
       else
           gaussDat = [];
           kernelDat = [];
       end
end