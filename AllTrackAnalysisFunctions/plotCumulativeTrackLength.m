function [minv, maxv, LinFitDat] = plotCumulativeTrackLength(Axes, binNumbers, SaveStructure, filterIDs, performFit)
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
           ids = cell2mat(data(:,1));
           mask = ismember(ids, filterIDs);
           data = data(mask,:);

           SaveStructure.TrackLength.Steps = data;
           SaveStructure = calculateCumulativeTrackLength(SaveStructure, SaveStructure);
           data = SaveStructure.TrackLength.CumLen;
       end
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
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
           LinFitDat = [pd(1), pd(2)];
       else
           LinFitDat = [];
       end
end