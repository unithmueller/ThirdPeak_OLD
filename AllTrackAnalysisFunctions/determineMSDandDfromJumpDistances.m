function fitResults = determineMSDandDfromJumpDistances(FigurePanel, SaveStructure, isPixel, filterIDs, lengthUnit, timeunit, timestep, binNumbers)
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
       
       xData = xData(:,2);
       yData = yData(:,2);
       zData = zData(:,2);
       xyData = xyData(:,2);
       xyzData = xyzData(:,2);
       
       %% Plot the data
       tl = tiledlayout(FigurePanel, 5, 1);
       ax1 = nexttile(tl,1);
       %% X
       Axes = ax1;
       minv = min(xData);
       maxv = max(xData);
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       hisx = histogram(Axes, xData, edges);
       hixMaxValue = max(hisx.Values);
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
       maxyGauss = max(yGauss);
       %scaling factor
       scalingFactorGauss = hixMaxValue/maxyGauss;
       %scale the data
       yGauss = yGauss*scalingFactorGauss;
       % plot fit
       hold(Axes,"on");
       plot(Axes, xFitData, yGauss, "--r");
       legend(Axes, "Histogram", "GaussFit");
       %fit data
       meanData = mean(xData);
       sst = sum((xData-meanData).^2); %total sum of squares
       gof.sse = sum((xData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       %calculate MSD and D
       xMSD = std(pdGauss)^2;
       if isPixel
           xD = xMSD/(2);
       else
           xD = xMSD/(2*timestep);
       end
       %pack the properties
       xxFitData = [gof.rsquare, xMSD, xD];
       
       %% Y
       ax2 = nexttile(tl,2);
       Axes = ax2;
       minv = min(yData);
       maxv = max(yData);
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       hisy = histogram(Axes, yData, edges);
       hixMaxValue = max(hisy.Values);
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
       maxyGauss = max(yGauss);
       %scaling factor
       scalingFactorGauss = hixMaxValue/maxyGauss;
       %scale the data
       yGauss = yGauss*scalingFactorGauss;

       hold(Axes,"on");
       plot(Axes, xFitData, yGauss, "--r");
       legend(Axes, "Histogram", "GaussFit");
       %fit data
       meanData = mean(yData);
       sst = sum((yData-meanData).^2); %total sum of squares
       gof.sse = sum((yData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       %calculate MSD and D
       yMSD = std(pdGauss)^2;
       if isPixel
           yD = yMSD/(2);
       else
           yD = yMSD/(2*timestep);
       end
       %show results in graph
       yFitData = [gof.rsquare, yMSD, yD];
       
       %% Z
       ax3 = nexttile(tl,3);
       Axes = ax3;
       minv = min(zData);
       maxv = max(zData);
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       hisz = histogram(Axes, zData, edges);
       hixMaxValue = max(hisz.Values);
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
       maxyGauss = max(yGauss);
       %scaling factor
       scalingFactorGauss = hixMaxValue/maxyGauss;
       %scale the data
       yGauss = yGauss*scalingFactorGauss;
           
       hold(Axes,"on")
       plot(Axes, xFitData, yGauss, "--r");
       %fit data
       meanData = mean(zData);
       sst = sum((zData-meanData).^2); %total sum of squares
       gof.sse = sum((zData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       %calculate MSD and D
       zMSD = std(pdGauss)^2;
       if isPixel
           zD = zMSD/(2);
       else
           zD = zMSD/(2*timestep);
       end
       %show results in graph
       zFitData = [gof.rsquare, zMSD, zD];
       
       %% XY
       ax4 = nexttile(tl,4);
       Axes = ax4;
       minv = min(xyData);
       maxv = max(xyData);
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       hisxy = histogram(Axes, xyData, edges);
       hixMaxValue = max(hisxy.Values);
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
       maxyGauss = max(yGauss);
       scalingFactorGauss = hixMaxValue/maxyGauss;
       yGauss = yGauss*scalingFactorGauss;
       
       hold(Axes,"on")
       plot(Axes, xFitData, yGauss, "--r");
       %fit data
       meanData = mean(xyData);
       sst = sum((xyData-meanData).^2); %total sum of squares
       gof.sse = sum((xyData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       %calculate MSD and D
       xyMSD = std(pdGauss)^2;
       if isPixel
           xyD = xyMSD/(2*2);
       else
           xyD = xyMSD/(2*2*timestep);
       end

       xyFitData = [gof.rsquare, xyMSD, xyD];
       %% XYZ
       ax5 = nexttile(tl,5);
       Axes = ax5;
       minv = min(xyzData);
       maxv = max(xyzData);
       edges = linspace(minv, maxv, binNumbers);
       %histogram
       hisxyz = histogram(Axes, xyzData, edges);
       hixMaxValue = max(hisxyz.Values);
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
       maxyGauss = max(yGauss);
       scalingFactorGauss = hixMaxValue/maxyGauss;
       yGauss = yGauss*scalingFactorGauss;
       
       hold(Axes,"on")
       plot(Axes, xFitData, yGauss, "--r");
       %fit data
       meanData = mean(xyzData);
       sst = sum((xyzData-meanData).^2); %total sum of squares
       gof.sse = sum((xyzData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       %calculate MSD and D
       xyzMSD = std(pdGauss)^2;
       if isPixel
           xyzD = xyzMSD/(2*3);
       else
           xyzD = xyzMSD/(2*3*timestep);
       end
       %show results in graph
       xyzFitData = [gof.rsquare, xyzMSD, xyzD];
       
       %% pack the fit results
       fitResults = [xxFitData; yFitData; zFitData; xyFitData; xyzFitData];

end