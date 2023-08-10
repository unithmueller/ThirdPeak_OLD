function gaussParameters = fitVelocityPopulationsByMeanJumpDistance(Axes, SaveStructure, dimension, nBins, filterIDs, populationNumber, lengthUnit, isPixel)
%Function to determine the number of velocity populations by fitting
%multiple gaussians onto the curve.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %dimension - defines the dimensionality to be plotted (X,Y,Z,XY,XYZ)
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       %% Get the data of choice
       data = SaveStructure.MeanJumpDist.(dimension);
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = data{1,1};
           ids = cell2mat(ids);
           mask = ismember(ids, filterIDs);
           tmpdata = data{1,2};
           tmpdata = tmpdata(mask,:);
           data{1,2} = tmpdata;
       end
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
       %% Put the data into bins
       [N,edges] = histcounts(data,nBins);
       binwidth = abs((edges(2)-edges(1)))/2;
       binCenters = edges+binwidth;
       binCenters = binCenters(1:end-1);
       %% Find estimates for the number of peaks
       NumberOfPeaks = str2double(populationNumber);
       % smooth the histogram
       dist = fitdist(data, 'kernel', "Kernel", "box");
       bw = dist.BandWidth;
       xvals = binCenters;
       yvals = pdf(dist, xvals);
       P = allpeaks(binCenters, yvals);
       P = P(P(:,2)>0.15,:);
       NmbrMax = size(P,1);
       Count = 1;
       
       while ((NmbrMax > NumberOfPeaks*2) || (NmbrMax <= NumberOfPeaks-1)) && (Count < 50)
           if (NmbrMax > NumberOfPeaks*2)
               bw = bw*1.05;
           elseif (NmbrMax <= NumberOfPeaks-1)
               bw = bw*0.95;
           end
           
           dist = fitdist(data, 'kernel', "Kernel", "box", "Width", bw);
           yvals = pdf(dist, xvals);
           P = allpeaks(binCenters, yvals);
           %meanPeak = mean(P(:,2));
           %P = P(P(:,2)>meanPeak,:);
           NmbrMax = size(P,1);
           Count = Count+1;
       end
       %% get estimates
       if Count < 50
           %% Fit the gaussians
           widths = estimateWidth(data, P);
           gaussParameters =  fitMultipleGaussians(Axes, [binCenters.', yvals.'], P(:,1), widths, lengthUnit, isPixel);
       end
       
end

function widths = estimateWidth(data, Peaks)
    %Roughly estimates the potential width of the peaks
    minX = min(data);
    maxX = max(data);
    distances = [];
    if size(Peaks,1) == 1
        distances(1,1) = Peaks(1,1)-minX;
        distances(1,2) = maxX-Peaks(1,1);
    else
        distances(1,1) = Peaks(1,1)-minX;
        for i = 2:size(Peaks,1)
            distances(i,1) = Peaks(i,1) - Peaks(i-1,1);
            distances(i-1,2) = Peaks(i,1) - Peaks(i-1,1);
        end
        distances(end,2) = maxX - Peaks(end,1); 
    end
    AmpSum = sum(Peaks(:,2));
    normAmp = Peaks(:,2)/AmpSum;
    distances = sqrt(distances)*0.1.*normAmp;
    widths = mean(distances,2);
end