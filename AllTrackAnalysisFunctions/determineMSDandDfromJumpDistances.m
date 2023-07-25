function determineMSDandDfromJumpDistances(FigurePanel, SaveStructure, isPixel, filterIDs, lengthUnit, timeunit, timestep)
%Function to determine the MSD and D from 1D and 2D displacements of the
%tracks. Will only lead to an overall estimation and will not be able to
%determine different diffusion types/groups.
%Input:FigurePanel - Panel to plot the graphs
      %SaveStructure - structured array that contains the 1d displacements
      %isPixel - determines the data type if pixel or unit
      %filterIDs - contains only the IDs to work with if filter is used
      
      %% get the data
      xData = SaveStructure.JumpDist.X;
      yData = SaveStructure.JumpDist.Y;
      zData = SaveStructure.JumpDist.Z;
      xyData = SaveStructure.JumpDist.XY;
      xyzData = SaveStructure.JumpDist.XYZ;
      
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = xData(:,1);
           ids = cell2mat(ids);
           idx = find(ids == filterIDs);
           %x
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = xData(idx,:);
           end
           xData = filteredData;
           %y
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = yData(idx,:);
           end
           yData = filteredData;
           %z
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = zData(idx,:);
           end
           zData = filteredData;
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
       xData = cell2mat(xData(:,2));
       yData = cell2mat(yData(:,2));
       zData = cell2mat(zData(:,2));
       xyData = cell2mat(xyData(:,2));
       xyzData = cell2mat(xyzData(:,2));
       
       %% Plot the data
       tl = tiledlayout(FigurePanel, 5, 1);
       nexttile
       %% X
       minv = min(xData(:,2));
       maxv = max(xData(:,2));
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       histogram(Axes, xData, edges)
       xlim(Axes, [minv maxv]);
       dimension = "X";
       title(Axes, join(["Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Jump Distance in [px]");
           lengthunittxt = "px";
           timeunittxt = "frame";
       else
           xlabel(Axes, sprintf("Jump Distance in [%s]", lengthUnit));
           lengthunittxt = lengthUnit;
           timeunittxt = timeunit;
       end
       %fit
       pdGauss = fitdist(xData, "Normal");
       xFitData = minv:1:maxv;
       yGauss = pdf(pdGauss, xFitData);
       hold on
       plot(xFitData, yGauss, "--r");
       %fit data
       meanData = mean(xData);
       sst = sum((xData-meanData).^2); %total sum of squares
       gof.sse = sum((xData-yGauss).^2); %residual sum of squares
       gof.rsquare = 1-gof.sse/sst;
       %calculate MSD and D
       xMSD = std(pdGauss)^2;
       if isPixel
           xD = xMSD/(2);
       else
           xD = xMSD/(2*timestep);
       end
       %show results in graph
       text(0.1,0.9, ["R² of Fit: " string(gof.rsquare)], "Units", "normalized");
       text(0.1,0.8, ["MSD: " string(xMSD) " [" lengthunittxt "²/" timeunittxt "²"], "Units", "normalized");
       text(0.1,0.7, ["D: " string(xD) " [" lengthunittxt "²/" timeunittxt], "Units", "normalized");
       
       %% Y
       nexttile
       minv = min(yData(:,2));
       maxv = max(yData(:,2));
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       histogram(Axes, yData, edges)
       xlim(Axes, [minv maxv]);
       dimension = "Y";
       title(Axes, join(["Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Jump Distance in [px]");
           lengthunittxt = "px";
           timeunittxt = "frame";
       else
           xlabel(Axes, sprintf("Jump Distance in [%s]", lengthUnit));
           lengthunittxt = lengthUnit;
           timeunittxt = timeunit;
       end
       %fit
       pdGauss = fitdist(yData, "Normal");
       xFitData = minv:1:maxv;
       yGauss = pdf(pdGauss, xFitData);
       hold on
       plot(xFitData, yGauss, "--r");
       %fit data
       meanData = mean(yData);
       sst = sum((yData-meanData).^2); %total sum of squares
       gof.sse = sum((yData-yGauss).^2); %residual sum of squares
       gof.rsquare = 1-gof.sse/sst;
       %calculate MSD and D
       yMSD = std(pdGauss)^2;
       if isPixel
           yD = yMSD/(2);
       else
           yD = yMSD/(2*timestep);
       end
       %show results in graph
       text(0.1,0.9, ["R² of Fit: " string(gof.rsquare)], "Units", "normalized");
       text(0.1,0.8, ["MSD: " string(yMSD) " [" lengthunittxt "²/" timeunittxt "²"], "Units", "normalized");
       text(0.1,0.7, ["D: " string(yD) " [" lengthunittxt "²/" timeunittxt], "Units", "normalized");
       
       %% Z
       nexttile
       minv = min(zData(:,2));
       maxv = max(zData(:,2));
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       histogram(Axes, zData, edges)
       xlim(Axes, [minv maxv]);
       dimension = "Z";
       title(Axes, join(["Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Jump Distance in [px]");
           lengthunittxt = "px";
           timeunittxt = "frame";
       else
           xlabel(Axes, sprintf("Jump Distance in [%s]", lengthUnit));
           lengthunittxt = lengthUnit;
           timeunittxt = timeunit;
       end
       %fit
       pdGauss = fitdist(zData, "Normal");
       xFitData = minv:1:maxv;
       yGauss = pdf(pdGauss, xFitData);
       hold on
       plot(xFitData, yGauss, "--r");
       %fit data
       meanData = mean(zData);
       sst = sum((zData-meanData).^2); %total sum of squares
       gof.sse = sum((zData-yGauss).^2); %residual sum of squares
       gof.rsquare = 1-gof.sse/sst;
       %calculate MSD and D
       zMSD = std(pdGauss)^2;
       if isPixel
           zD = zMSD/(2);
       else
           zD = zMSD/(2*timestep);
       end
       %show results in graph
       text(0.1,0.9, ["R² of Fit: " string(gof.rsquare)], "Units", "normalized");
       text(0.1,0.8, ["MSD: " string(zMSD) " [" lengthunittxt "²/" timeunittxt "²"], "Units", "normalized");
       text(0.1,0.7, ["D: " string(zD) " [" lengthunittxt "²/" timeunittxt], "Units", "normalized");
       
       %% XY
       nexttile
       minv = min(xyData(:,2));
       maxv = max(xyData(:,2));
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       histogram(Axes, xyData, edges)
       xlim(Axes, [minv maxv]);
       dimension = "XY";
       title(Axes, join(["Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Jump Distance in [px]");
           lengthunittxt = "px";
           timeunittxt = "frame";
       else
           xlabel(Axes, sprintf("Jump Distance in [%s]", lengthUnit));
           lengthunittxt = lengthUnit;
           timeunittxt = timeunit;
       end
       %fit
       pdGauss = fitdist(xyData, "Normal");
       xFitData = minv:1:maxv;
       yGauss = pdf(pdGauss, xFitData);
       hold on
       plot(xFitData, yGauss, "--r");
       %fit data
       meanData = mean(xyData);
       sst = sum((xyData-meanData).^2); %total sum of squares
       gof.sse = sum((xyData-yGauss).^2); %residual sum of squares
       gof.rsquare = 1-gof.sse/sst;
       %calculate MSD and D
       xyMSD = std(pdGauss)^2;
       if isPixel
           xyD = xyMSD/(2*2);
       else
           xyD = xyMSD/(2*2*timestep);
       end
       %show results in graph
       text(0.1,0.9, ["R² of Fit: " string(gof.rsquare)], "Units", "normalized");
       text(0.1,0.8, ["MSD: " string(xyMSD) " [" lengthunittxt "²/" timeunittxt "²"], "Units", "normalized");
       text(0.1,0.7, ["D: " string(xyD) " [" lengthunittxt "²/" timeunittxt], "Units", "normalized");
       
       %% XYZ
       nexttile
       minv = min(xyzData(:,2));
       maxv = max(xyzData(:,2));
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       histogram(Axes, xyzData, edges)
       xlim(Axes, [minv maxv]);
       dimension = "XYZ";
       title(Axes, join(["Jump Distance Distribution for " dimension],""));
       if isPixel
           xlabel(Axes, "Jump Distance in [px]");
           lengthunittxt = "px";
           timeunittxt = "frame";
       else
           xlabel(Axes, sprintf("Jump Distance in [%s]", lengthUnit));
           lengthunittxt = lengthUnit;
           timeunittxt = timeunit;
       end
       %fit
       pdGauss = fitdist(xyzData, "Normal");
       xFitData = minv:1:maxv;
       yGauss = pdf(pdGauss, xFitData);
       hold on
       plot(xFitData, yGauss, "--r");
       %fit data
       meanData = mean(xyzData);
       sst = sum((xyzData-meanData).^2); %total sum of squares
       gof.sse = sum((xyzData-yGauss).^2); %residual sum of squares
       gof.rsquare = 1-gof.sse/sst;
       %calculate MSD and D
       xyzMSD = std(pdGauss)^2;
       if isPixel
           xyzD = xyzMSD/(2*3);
       else
           xyzD = xyzMSD/(2*3*timestep);
       end
       %show results in graph
       text(0.1,0.9, ["R² of Fit: " string(gof.rsquare)], "Units", "normalized");
       text(0.1,0.8, ["MSD: " string(xyzMSD) " [" lengthunittxt "²/" timeunittxt "²"], "Units", "normalized");
       text(0.1,0.7, ["D: " string(xyzD) " [" lengthunittxt "²/" timeunittxt], "Units", "normalized");

end