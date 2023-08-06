function [minv, maxv, gaussDat, kernelDat] = plotNumberOfStepsPerTrack(Axes, binNumbers, SaveStructure, filterIDs, performFit)
%Function to plot the track step number as a histogram in the track
%analysis window.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       
       %% Get the data of choice
       data = SaveStructure.TrackLength.Steps;
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = cell2mat(data(:,1));
           mask = ismember(ids, filterIDs);
           data = data(mask,:);
       end
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
       %% Plot the data
       minv = min(data);
       maxv = max(data);
       edges = linspace(minv, maxv, binNumbers);
       his = histogram(Axes, data, edges);
       hixMaxValue = max(his.Values);
       xlim(Axes, [minv maxv]);
       title(Axes, "Track Length Distribution");
       xlabel(Axes, "Track Length [steps]");
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
           hold(Axes,"on")
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