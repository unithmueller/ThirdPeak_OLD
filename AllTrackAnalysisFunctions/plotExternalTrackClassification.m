function [minv, maxv, gaussDat, kernelDat] = plotExternalTrackClassification(Axes, SaveStructure, typenames, filterIDs, performFit)
%Function to plot the respective jump distances as a histogram in the track
%analysis window.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %typenames - list of names provided in the import settings to
       %identify the different tracks
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       
       %% Get the data of choice
       data = SaveStructure.SwiftParams.type;
       
       %% can not fit the data
       performFit = 0;
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = data(:,1);
           ids = cell2mat(ids);
           mask = ismember(ids, filterIDs);
           filteredData = data(mask,:);
           data = filteredData;
       end
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
       %% Plot the data
       types = split(typenames,", ");
       sz = size(types,1);
       minv = 0.5;
       maxv = sz+0.5;
       edges = [minv:1:maxv];
       histogram(Axes, data, edges)
       xlim(Axes, [minv maxv]);
       
       title(Axes, "Diffusion Type Distribution");
       xticks(Axes, [1:1:sz]);
       types = types.';
       xticklabels(Axes, types);
       xlabel(Axes, "Diffusion Type");
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

           %% plot
           hold(Axes,"on")
           plot(xFitData, yGauss, "--r");
           plot(xFitData, yKernel, "k");
           legend("GaussFit", "KernelFit");
           hold(Axes,"off")
           
           %% get the data from fit
           gaussDat = [median(pdGauss), mean(pdGauss), std(pdGauss), var(pdGauss)];
           kernelDat = [median(pdKernel), mean(pdKernel), std(pdKernel), var(pdKernel)];
       else
           gaussDat = [];
           kernelDat = [];
       end
end