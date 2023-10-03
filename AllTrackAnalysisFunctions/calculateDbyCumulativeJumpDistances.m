function [xyout, xyzout] = calculateDbyCumulativeJumpDistances(FigurePanel, SaveStructure, trackingRadius, estimateD, nRates, filterIDs, binNumbers, lengthUnit, isPixel, timestep, is2d)
%Function to determine different diffusion states from the data of the jump
%distances. Uses the function from TrackIt to estimate the different
%states.
%Input: Axes - axes to plot the histogram to
       %SaveStruc - structured array that contains the data
       %trackingRadius - radius used for linking the tracks
       %estimateD - values to start estimateing D for
       %nRates - number of different diffusion states, either 2 or 3
       
      %% get the data
      %xyData = SaveStructure.CumJumpDist.XY;
      %xyzData = SaveStructure.CumJumpDist.XYZ;
      xyData = SaveStructure.JumpDist.XY;
      xyzData = SaveStructure.JumpDist.XYZ;
      
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = cell2mat(xyData(:,1));
           mask = ismember(ids, filterIDs);
           %xy
           xyData = xyData(mask,:);
           %xyz
           xyzData = xyzData(mask,:);
       end
       
       %% Unpack the cell array
       xyData = cell2mat(xyData(:,2));
       xyzData = cell2mat(xyzData(:,2));
       
       if isPixel
            xyData = (xyData(:,2).^2)/4;
            xyzData = (xyzData(:,2).^2)/6;
       else
            xyData = (xyData(:,2).^2)/(4*timestep);
            xyzData = (xyzData(:,2).^2)/(6*timestep);
       end
       
       %% Plot the data
       tl = tiledlayout(FigurePanel, 2, 1);
       %% XY
       ax1 = nexttile(tl,1);
       Axes = ax1;
       minv = min(xyData);
       maxv = max(xyData);
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       h1 = histogram(Axes, xyData, edges,'Normalization','cdf');
       hold(Axes, "on");
       hisMaxValue = max(h1.Values);
       xlim(Axes, [minv maxv]);
       dimension = "XY";
       title(Axes, join(["Cumulative Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Cumulative Jump Distance in [px]");
       else
           xlabel(Axes, sprintf("Cumulative Jump Distance in [%s]", lengthUnit));
       end
       %TrackIt analysis
       Dvals = split(estimateD, ", ");
       oldDvals = Dvals;
       Dvals = zeros(size(oldDvals,1),1).';
       for i = 1:size(Dvals, 2)
           Dvals(i) = str2double(oldDvals{i,1});
       end
       binCenters = h1.BinEdges + h1.BinWidth/2;
       hisValues = h1.Values;
       hisValues = [hisValues, 1];
       [xyout] = fitDbyCumulativeJumpDistancesbyTrackIt(binCenters, hisValues, str2double(trackingRadius), Dvals, str2double(nRates));
       %[xyout] = fitDbyCumulativeJumpDistancesbyTrackItModified(binCenters, hisValues, str2double(trackingRadius), Dvals, str2double(nRates), 0, timestep);
       %show results in graph
       fitDatax = xyout.xy(1,1:binNumbers);
       fitDatay = xyout.xy(1,binNumbers+1:end);
       plxy = plot(Axes, fitDatax, fitDatay, "-r");
       legend(Axes, "Histogram", "Fit");

       %% XYZ
       if is2d
           xyzout = xyout;
       else
       ax2 = nexttile(tl,2);
       Axes = ax2;
       minv = min(xyzData);
       maxv = max(xyzData);
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       h2 = histogram(Axes, xyzData, edges,'Normalization','cdf');
       hold(Axes, "on");
       xlim(Axes, [minv maxv]);
       dimension = "XYZ";
       title(Axes, join(["Cumulative Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Cumulative Jump Distance in [px]");
       else
           xlabel(Axes, sprintf("Cumulative Jump Distance in [%s]", lengthUnit));
       end
       %TrackIt analysis
       binCenters = h2.BinEdges + h2.BinWidth/2;
       hisValues = h2.Values;
       hisValues = [hisValues, 1];
       [xyzout] = fitDbyCumulativeJumpDistancesbyTrackIt(binCenters, hisValues, str2double(trackingRadius), Dvals, str2double(nRates));
       %[xyzout] = fitDbyCumulativeJumpDistancesbyTrackItModified(binCenters, hisValues, str2double(trackingRadius), Dvals, str2double(nRates), 1, timestep);
       fitDataxz = xyzout.xy(1,1:binNumbers);
       fitDatayz = xyzout.xy(1,binNumbers+1:end);
       plxyz = plot(Axes, fitDataxz, fitDatayz, "-r");
       legend(Axes, "Histogram", "Fit");
       end
end