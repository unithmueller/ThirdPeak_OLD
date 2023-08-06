function [minv, maxv, gaussDat, kernelDat] = plotTrackRatios(Axes, binNumbers, SaveStructure, property, dimension, isPixel, lengthUnit, filterIDs, performFit)
%Function to plot the respective absolute and netto distances as well as the ratio as a histogram in the track
%analysis window.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the data
       %property - decides between abs length, net length or ratio
       %dimension - defines the dimensionality to be plotted (XY,XYZ)
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       
       %% Get the data of choice
       data = SaveStructure.TrackLength.(property).(dimension);
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = cell2mat(data(:,1));
           mask = ismember(ids, filterIDs);
           data = data(mask,:);
       end
       %% Unpack the cell array
       if size(data,2) == 1
           data = data{1,1}(:,2);
       else
           data = cell2mat(data(:,2));
       end
       
       %% Plot the data
       minv = min(data);
       maxv = max(data);
       edges = linspace(minv, maxv, binNumbers);
       his = histogram(Axes, data, edges);
       hixMaxValue = max(his.Values);
       xlim(Axes, [minv maxv]);
       %% decide on the labelling of the plot
       if property == "NetLength"
           title(Axes, join(["Netto Length Distribution of Tracks for " dimension],""));
           if isPixel
               xlabel(Axes, "Netto Track Distance in [px]");
           else
               xlabel(Axes, sprintf("Netto Track Distance in [%s]", lengthUnit));
           end
       elseif property == "AbsLength"
               title(Axes, join(["Total Track Distance Distribution of Tracks for " dimension],""));
           if isPixel
               xlabel(Axes, "Total Track Distance in [px]");
           else
               xlabel(Axes, sprintf("Total Track Distance in [%s]", lengthUnit));
           end
       elseif property == "ConfRatio"
               title(Axes, join(["Confinement Ratio Distribution of Tracks for " dimension],""));
               xlabel(Axes, "Ratio Total Distance/Netto Distance");
       end
       ylabel(Axes, "Counts");
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
           hold(Axes,"on");
           gp = plot(Axes, xFitData, yGauss, "--r");
           kp = plot(Axes, xFitData, yKernel, "k");
           legend(Axes, "Histogram", "GaussFit", "KernelFit");
           hold(Axes,"off")
           
           %% get the data from fit
           gaussNLL = negloglik(pdGauss);
           kernelNLL = negloglik(pdKernel);
           gaussDat = [median(pdGauss), mean(pdGauss), std(pdGauss), var(pdGauss), gaussNLL];
           kernelDat = [median(pdKernel), mean(pdKernel), std(pdKernel), var(pdKernel), kernelNLL];
       else
           gaussDat = [];
           kernelDat = [];
       end
end