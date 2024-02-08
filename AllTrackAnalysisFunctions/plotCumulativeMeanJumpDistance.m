function [minv, maxv, LinFitDat] = plotCumulativeMeanJumpDistance(Axes, binNumbers, SaveStructure, dimension, isPixel, lengthUnit, filterIDs, performFit)
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
       data = SaveStructure.CumMeanJumpDist.(dimension);
       
       %% Apply the filter if necessary. Need to filter via the mean track length
       if size(filterIDs,1)>0
           data = SaveStructure.MeanJumpDist.(dimension);
           ids = data{:,1};
           ids = cell2mat(ids);
           mask = ismember(ids, filterIDs);
           filteredIDs = ids(mask);
           mjd = data{1,2};
           filteredData = mjd(mask);
           newids = cell(size(filterIDs),1);
           for i = 1:size(filterIDs)
               newids(i,1) = {filteredIDs(i)};
           end
           %filteredIDs = {filteredIDs};
           newPackedData = {newids, filteredData};

           SaveStructure.MeanJumpDist.(dimension) = newPackedData;
           SaveStructure = calculateCumulativeMeanJumpDistance(SaveStructure, SaveStructure);
           data = SaveStructure.CumMeanJumpDist.(dimension); 
       end
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
       %% Plot the data
       minv = min(data);
       maxv = max(data);
       edges = linspace(minv, maxv, binNumbers);
       his = histogram(Axes, data, edges, "Normalization", "cumcount");
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
           binWidth = his.BinWidth/2;
           xdat = his.BinEdges;
           xdat = xdat+binWidth;
           xdat = xdat(1:end-1);
           ydat = his.Values;
           
           [pdLinear, S] = polyfit(xdat,ydat,1);

           %% generate matching data
           xFitData = minv:1:maxv;
           [yLinear, delta] = polyval(pdLinear, xFitData, S);
           maxyLinear = max(yLinear);

           %% plot
           axes(Axes);
           hold(Axes,"on")
           Lp = plot(Axes, xFitData, yLinear, "--r");
           conf = plot(Axes, xFitData,yLinear+2*delta,'m--',xFitData,yLinear-2*delta,'m--');
           legend(Axes, "Histogram", "Linear Fit", "95% CI");
           hold(Axes,"off")
           
           %% get the data from fit
           LinFitDat = [pdLinear(1), pdLinear(2)];
       else
           LinFitDat = [];
       end
end