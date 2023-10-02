function [fitResults, dataResults, unitResults] = determineMSDandDfromJumpDistances(FigurePanel, SaveStructure, isPixel, filterIDs, lengthUnit, timeunit, timestep, binNumbers)
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
           ids = cell2mat(xData(:,1));
           mask = ismember(ids, filterIDs);
           %x
           xData = xData(mask,:);
           %y
           yData = yData(mask,:);
           %z
           zData = zData(mask,:);
           %xy
           xyData = xyData(mask,:);
           %xyz
           xyzData = xyzData(mask,:);
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
       [h,p] = kstest(xData);
       gof.kstsh = h;
       gof.kstsp = p;
       %calculate MSD and D
       xMSD = std(pdGauss)^2;
       fitxMSDStd = std(pdGauss);
       if isPixel
           xD = xMSD/(2);
           fitxDStd = fitxMSDStd/2;
       else
           xD = (xMSD)/(2*timestep);
           fitxDStd = fitxMSDStd/(2*timestep);
       end
       %do the standart MSD = 2DT on the data
       dataXMSDSTD = std(xData.^2);
       dataXMSD = mean(xData.^2);
       if isPixel
           dataxD = dataXMSD/(2);
           dataXDSTD = dataXMSDSTD/2;
       else
           dataxD = dataXMSD/(2*timestep);
           dataXDSTD = dataXMSDSTD/(2*timestep);
       end
       %pack the properties
       xxFitData = [h, p, xMSD, fitxMSDStd, xD, fitxDStd];
       xxDataData = [h, p, dataXMSD, dataXMSDSTD, dataxD, dataXDSTD];
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
       [h,p] = kstest(yData);
       %calculate MSD and D
       yMSD = std(pdGauss)^2;
       yMSDstd = std(pdGauss);
       if isPixel
           yD = yMSD/(2);
           yDstd = yMSDstd/2;
       else
           yD = (yMSD)/(2*timestep);
           yDstd = yMSDstd/(2*timestep);
       end
       %do the standart MSD = 2DT on the data
       dataYSTD = std(yData.^2);
       dataYMSD = mean(yData.^2);
       if isPixel
           datayD = dataYMSD/(2);
           datayDstd = dataYSTD/2;
       else
           datayD = (dataYMSD)/(2*timestep);
           datayDstd = dataYSTD/(2*timestep);
       end
       %show results in graph
       yFitData = [h,p, yMSD, yMSDstd, yD, yDstd];
       yDataData = [h,p, dataYMSD, dataYSTD, datayD, datayDstd];
       
       %% Z
       try
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
       legend(Axes, "Histogram", "GaussFit");
       %fit data
       meanData = mean(zData);
       sst = sum((zData-meanData).^2); %total sum of squares
       gof.sse = sum((zData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       [h,p] = kstest(zData);
       %calculate MSD and D
       zMSD = std(pdGauss)^2;
       zMSDstd = std(pdGauss);
       if isPixel
           zD = zMSD/(2);
           zDstd = zMSDstd/2;
       else
           zD = (zMSD)/(2*timestep);
           zDstd = zMSDstd/(2*timestep);
       end
       %show results in graph
       dataZMSDstd = std(zData.^2);
       dataZMSD = mean(zData.^2);
       if isPixel
           datazD = dataZMSD/(2);
           datazDstd = dataZMSDstd/2;
       else
           datazD = (dataZMSD)/(2*timestep);
           datazDstd = dataZMSDstd/(2*timestep);
       end
       zFitData = [h,p, zMSD, zMSDstd, zD, zDstd];
       zDataData = [h,p, dataZMSD, dataZMSDstd, datazD, datazDstd];
       catch
           zFitData = [0, 0, 0, 0, 0];
           zDataData = [0, 0, 0, 0, 0];
       end
       
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
       legend(Axes, "Histogram", "GaussFit");
       %fit data
       meanData = mean(xyData);
       sst = sum((xyData-meanData).^2); %total sum of squares
       gof.sse = sum((xyData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       [h,p] = kstest(xyData);
       %calculate MSD and D
       xyMSD = std(pdGauss)^2;
       xyMSDstd = std(pdGauss);
       if isPixel
           xyD = xyMSD/(2*2);
           xyDstd = xyMSDstd/2;
       else
           xyD = (xyMSD)/(2*2*timestep);
           xyDstd = xyMSDstd/(2*2*timestep);
       end
      dataXYMSDstd = std(xyData.^2);
      dataXYMSD = mean(xyData.^2);
       if isPixel
           dataxyD = (dataXYMSD)/(2*2);
           dataXYDstd = dataXYMSDstd/(2*2);
       else
           dataxyD = (dataXYMSD)/(2*2*timestep);
           dataXYDstd = dataXYMSDstd/(2*2*timestep);
       end

       xyFitData = [h,p, xyMSD, xyMSDstd, xyD, xyDstd];
       xyDataData = [h,p, dataXYMSD, dataXYMSDstd, dataxyD, dataXYDstd];
       %% XYZ
       try
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
       legend(Axes, "Histogram", "GaussFit");
       %fit data
       meanData = mean(xyzData);
       sst = sum((xyzData-meanData).^2); %total sum of squares
       gof.sse = sum((xyzData-yGauss).^2); %residual sum of squares
       gof.rsquare = abs(median(1-gof.sse/sst));
       [h,p] = kstest(xyzData);
       %calculate MSD and D
       xyzMSD = std(pdGauss)^2;
       xyzMSDstd = std(pdGauss);
       if isPixel
           xyzD = xyzMSD/(2*3);
           xyzDstd = xyzMSDstd/(2*3);
       else
           xyzD = (xyzMSD)/(2*3*timestep);
           xyzDstd = xyzMSDstd/(2*3*timestep);
       end
       %show results in graph
       dataXYZMSDstd  = std(xyzData.^2);
       dataXYZMSD = mean(xyzData.^2);
       if isPixel
           dataxyzD = (dataXYZMSD)/(2*3);
           dataXYZDstd = dataXYZMSDstd/(2*3);
       else
           dataxyzD = (dataXYZMSD)/(2*3*timestep);
           dataXYZDstd = dataXYZMSDstd/(2*3*timestep);
       end

       xyzFitData = [h,p, xyzMSD, xyzMSDstd, xyzD, xyzDstd];
       xyzDataData = [h,p, dataXYZMSD, dataXYZMSDstd, dataxyzD, dataXYZDstd];
       catch
       end
       
       %% pack the fit results
       
       fitResults = [xxFitData; yFitData; zFitData; xyFitData; xyzFitData];
       dataResults = [xxDataData; yDataData; zDataData; xyDataData; xyzDataData];
       
       if isPixel
           unitResults = ["0=norm dist, 1=not","P-Value","px²", "px²", "px²/frame", "px²/frame"];
       else
           sqUnit = join([lengthUnit, "²"], "");
           diffUnit = join([sqUnit "/" string(timestep) " " timeunit], "");
           unitResults = ["0=norm dist, 1=not","P-Value", sqUnit, sqUnit, diffUnit, diffUnit];
       end

end