function plotIntensityofTrackoverTime(Axes, saveStruc, isMean, isUnit, timeunit, timestepsize)
%Plots the intensity values of a given track over time into the given axes
%object.
%Input: Axes - axes object to plot into
       %saveStruc - structure that contains the intensity values
       %isMean - decides if mean intensity or cumulative intensity will be
       %plotted
       %isUnit decides if time unit in frame or unit
       %timeunit - contains the time unit to convert to
       %timestepsize - contains the value to change the x-ticks to
%Output: -

    %% get the data
    datY = saveStruc.Intensities{1,1};
    datX = [1:1:size(datY,1)];
    
    %if we use true units
    if isUnit
        datX = datX*timestepsize;
        xlabeltext = sprintf("Time [%s]", timeunit);
    else
        xlabeltext = "Time [frame]";
    end

    %% plot
    %decide if mean or cumulative
    if isMean
        plot(Axes,datX,datY);
        %add labels
        ylabel(Axes, "Mean Intensity");
        xlabel(Axes, xlabeltext);
    else
        %need to calculate first
        newint = zeros(size(datY,1),1);
        newint(1) = datY(1,2);
        for i = 2:size(datY,1)
            newint(i) = datY(i,2)+newint(i-1,1);
        end
        %plot
        plot(Axes, datX, newint);
        ylabel(Axes, "Cummulative Intensity");
        xlabel(Axes, xlabeltext);
    end
end