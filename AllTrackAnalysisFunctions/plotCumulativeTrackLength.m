function [minv, maxv, gaussDat, kernelDat] = plotCumulativeTrackLength(Axes, binNumbers, SaveStructure, filterIDs, performFit)
%Function to plot the cumulative track lengths as a histogram in the track
%analysis window.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       
       %% Get the data of choice
       data = SaveStructure.TrackLength.CumLen;
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           data = SaveStructure.TrackLength.Steps;
           ids = data(:,1);
           ids = cell2mat(ids);
           idx = find(ids == filterIDs);
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = data(idx,:);
           end
           SaveStructure.TrackLength.Steps = filteredData;
           SaveStructure = calculateCumulativeTrackLength(SaveStructure, SaveStructure);
           data = SaveStructure.TrackLength.CumLen;
       end
       %% Unpack the cell array
       data = cell2mat(data);
       
       %% Plot the data
       minv = 1;
       maxv = size(data,1);
       plt = plot(Axes, data);
       xlim(Axes, [minv maxv]);
       title(Axes, "Cumulative Track Length");
       xlabel(Axes, "Number of Tracks");
       ylabel(Axes, "Cumulative Track Length");

       %% Decide if we fit or not
       if performFit
           %% perform fit
           xFitData = 1:1:size(data,1);
           [pd, S] = polyfit(xFitData, data, 1);

           %% generate matching data
           [yLinFitdata, delta] = polyval(pd, xFitData, S);
           
           %% plot
           axes(Axes);
           hold(Axes,"on")
           pdp = plot(Axes, xFitData, yLinFitdata, "-r");
           conf = plot(Axes, xFitData,yLinFitdata+2*delta,'m--',xFitData,yLinFitdata-2*delta,'m--');
           legend(Axes, "Cumulative Track Length", "LinearFit", "95% CI");
           hold(Axes,"off")
           
           %% get the data from fit
           gaussDat = [pd];
           %kernelDat = [median(pdKernel), mean(pdKernel), std(pdKernel), var(pdKernel)];
       else
           gaussDat = [];
           kernelDat = [];
       end
end