function [precisionXYString, precisionZString] = calculatePrecision(intensityLocs)
%Calculates the overall precision of the localisation data using the method
%also used in SPTAnalyser: log-trans -> mean -> retrans
%Input: intesity filtered localisations
%Sturcture:error in 6 for xy and 7 for z.
    %% get the data
    %grab data from all files
    [allprecXY, ~] = allocateSaveMatrixbyCells(intensityLocs, 1);
    [allprecZ, startIdx] = allocateSaveMatrixbyCells(intensityLocs, 1);
    % for every file
    for i = 1:size(intensityLocs,1)
        tmpdata = intensityLocs{i,1};
        allprecXY(startIdx(i):startIdx(i+1)-1) = tmpdata(:,6);
        allprecZ(startIdx(i):startIdx(i+1)-1) = tmpdata(:,7);
    end
    %% calculations
    %logtransform the data
    logprecXY = log(allprecXY);
    logprecZ = log(allprecZ);
    %retransform and get the mean
    meanprecXY = exp(mean(logprecXY));
    meanprecZ = exp(mean(logprecZ));
    %% plot the data
    h1 = histfit(allprecXY,[],'kernel');
    text(h1(1).Parent,-100,100, ["Mean Precision XY: " meanprecXY]);
    savefig(gcf, "PrecisionXY");
    saveas(gcf, "PrecisionXY.svg");
    close(gcf);
    h2 = histfit(allprecZ,[],'kernel');
    text(h2(1).Parent,-200,100, ["Mean Precision Z: " meanprecZ]);
    savefig(gcf, "PrecisionZ");
    saveas(gcf, "PrecisionZ.svg");
    close(gcf);
    %% return the values for the mean in the GUI
    precisionXYString = int2str(meanprecXY);
    precisionZString = int2str(meanprecZ);
end