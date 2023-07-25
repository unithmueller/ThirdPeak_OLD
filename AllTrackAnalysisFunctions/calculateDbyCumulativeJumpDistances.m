function calculateDbyCumulativeJumpDistances(FigurePanel, SaveStructure, trackingRadius, estimateD, nRates)
%Function to determine different diffusion states from the data of the jump
%distances. Uses the function from TrackIt to estimate the different
%states.
%Input: Axes - axes to plot the histogram to
       %SaveStruc - structured array that contains the data
       %trackingRadius - radius used for linking the tracks
       %estimateD - values to start estimateing D for
       %nRates - number of different diffusion states, either 2 or 3
       
      %% get the data
      xyData = SaveStructure.JumpDist.XY;
      xyzData = SaveStructure.JumpDist.XYZ;
      
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           %xy
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = xyData(idx,:);
           end
           xyData = filteredData;
           %xyz
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = xyzData(idx,:);
           end
           xyzData = filteredData;
       end
       
       %% Unpack the cell array
       xyData = cell2mat(xyData(:,2));
       xyzData = cell2mat(xyzData(:,2));
       
       %% Plot the data
       tl = tiledlayout(FigurePanel, 2, 1);
       %% XY
       nexttile
       minv = min(xyData(:,2));
       maxv = max(xyData(:,2));
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       h1 = histogram(Axes, xyData, edges,'Normalization','cdf');
       xlim(Axes, [minv maxv]);
       dimension = "XY";
       title(Axes, join(["Jump Distance Distribution for " dimension],""));
       xlabel(Axes, sprintf("Jump Distance in [%s]", lengthUnit));
       lengthunittxt = lengthUnit;
       timeunittxt = timeunit;
       %TrackIt analysis
       Dvals = split(estimateD, ", ");
       Dvals = double(Dvals.');
       binCenters = h1.BinEdges + h1.BinWidth/2;
       hisValues = h1.Values;
       [xyout] = fitDbyCumulativeJumpDistancesbyTrackIt(binCenters, hisValues, trackingRadius, Dvals, nRates);
       %show results in graph
       text(0.1,0.9, ["Ds of Fit: " string(xyout.D)], "Units", "normalized");
       text(0.1,0.8, ["D err: " string(xyout.Derr)], "Units", "normalized");
       text(0.1,0.7, ["R²: " string(xyout.AdjR-squared)], "Units", "normalized");
       
       %% XYZ
       nexttile
       minv = min(xyzData(:,2));
       maxv = max(xyzData(:,2));
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       h2 = histogram(Axes, xyzData, edges,'Normalization','cdf');
       xlim(Axes, [minv maxv]);
       dimension = "XYZ";
       title(Axes, join(["Jump Distance Distribution for " dimension],""));
       xlabel(Axes, sprintf("Jump Distance in [%s]", lengthUnit));
       lengthunittxt = lengthUnit;
       timeunittxt = timeunit;
       %TrackIt analysis
       Dvals = split(estimateD, ", ");
       Dvals = double(Dvals.');
       binCenters = h2.BinEdges + h2.BinWidth/2;
       hisValues = h2.Values;
       [xyzout] = fitDbyCumulativeJumpDistancesbyTrackIt(binCenters, hisValues, trackingRadius, Dvals, nRates);
       text(0.1,0.9, ["Ds of Fit: " string(xyzout.D)], "Units", "normalized");
       text(0.1,0.8, ["D err: " string(xyzout.Derr)], "Units", "normalized");
       text(0.1,0.7, ["R²: " string(xyzout.AdjR-squared)], "Units", "normalized");

end