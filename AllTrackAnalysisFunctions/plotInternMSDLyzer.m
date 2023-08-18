function [minv, maxv, gaussDat, kernelDat] = plotInternMSDLyzer(Axes, binNumbers, SaveStructure, PixelTrackData, fitValue, property, dimension, isPixel, lengthUnit, pxsize, timeunit, timestep, filterIDs, performFit)
%Function to plot the calculated MSD as a histogram in the track
%analysis window.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %TrackData - in case of filtering we need to calculate the msd anew
       %property - defines if alpha, msd or d will be plotted
       %dimension - defines the dimensionality to be plotted (XY,XYZ)
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       
       %% Get the data of choice
       data = SaveStructure.InternMSD.(dimension).(property);
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = cell2mat(data(:,1));
           mask = ismember(ids, filterIDs);
           data = data(mask,:);
       end
       %% Unpack the cell array
       if size(data,2) == 1
           
       else
           data = cell2mat(data(:,2));
       end
       
       %% Adjust the values if Unit/Unit
%        if ~isPixel & property ~= "Alpha"
%            if property == "a"
%                data = data*(pxsize*pxsize/(timestep*timestep));
%            elseif property == "d"
%                data = data*(pxsize*pxsize/(timestep));
%            end
%        end
       %% Plot the data
       minv = min(data);
       maxv = max(data);
       edges = linspace(minv, maxv, binNumbers);
       his = histogram(Axes, data, edges);
       hixMaxValue = max(his.Values);
       xlim(Axes, [minv maxv]);
       
       %% adjust the title and xlabel depending on the property
       if property == "Alpha"
           title(Axes, join(["Alpha Value Distribution for " dimension],""));
           xlabel(Axes, "Alpha");
       elseif property == "a"
           title(Axes, join(["MSD Distribution for " dimension],""));
           if isPixel
               xlabel(Axes, "MSD [px²]");
           else
               txt = join([lengthUnit "²"],"");
               xlabel(Axes, sprintf("MSD [%s]",txt));
           end
       elseif property == "d"
           title(Axes, join(["Diffusion Coefficient Distribution for " dimension],""));
           if isPixel
               xlabel(Axes, "D [px²/frame]");
           else
               txt = join([lengthUnit "²/" timeunit],"");
               xlabel(Axes, sprintf("D [%s]",txt));
           end
       elseif property == "linR"
           title(Axes, join(["R² Linear Fit Value Distribution for " dimension],""));
           xlabel(Axes, "R²");
       elseif property == "logR"
           title(Axes, join(["R² Log Fit Value Distribution for " dimension],""));
           xlabel(Axes, "R²");
       end
       
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