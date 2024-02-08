function outputLabels = plotMSDClassic(Axes, saveStruc, dimension, fitval, isUnit, timeunit, lengthunit, timestep, pxsize)
%Plots the calculated MSD into the given figure
%Input: Axes - axes object to plot into
       %saveStruc - structure that contains the data
       %dimension - defines if 2d or 3d
       %fitval - amount of points to fit to
       %isUnit - defines if pixel/frame or unit/unit
       %timeunit,lengthunit - unit name of time and length
       %timestep, pxsize - size of timestep or pixel
%Output: outputLabels to be used for the GUI labels

    %% plot the msd
    %decide if 2d or 3d
    if dimension == 2
        lyzer = saveStruc.InternMSD.XY.MSDclass;
    else
        lyzer = saveStruc.InternMSD.XYZ.MSDclass;
    end
    
    %clear the axes
    cla(Axes);
    %if no msd could be done, do nothing
    try
        plotMeanMSD(lyzer, Axes,1);
        close
        labelPlotMSD(lyzer, Axes);

        %adjust the label size

        %% plot the fits
        %genearte xdata
        xData = 0:1:fitval;
        %retrieve the a and b value
        a = lyzer.lfit.a;
        b = lyzer.lfit.b;
        %retrieve uncertainty, alpha, diffusion coeffieicent
        r2fit = lyzer.lfit.r2fit;
        alpha = lyzer.loglogfit.alpha;
        D = a*1/(2*dimension);
        yData = (xData*a)+b;

        %plot
        hold(Axes,"on");
        plot(Axes, xData, yData, 'r', "LineWidth", 3);

        %adjust text labels if necessary
        if isUnit
            %adjustments text label
            xdatalabel = sprintf("Delay [%s]", timeunit);
            Axes.XLabel.String = {xdatalabel};
            ydatalabel = sprintf("MSD [%s^2]", lengthunit);
            Axes.YLabel.String = {ydatalabel};
            %adjustments xticks delay
            xdataticks = str2double(Axes.XTickLabel);
            xdataticks = xdataticks*timestep;
            app.UIAxes2_6.XTickLabel = cellstr(num2str(xdataticks));
            %yticks MSD
            ydataticks = str2double(Axes.YTickLabel);
            ydataticks = ydataticks*(pxsize*pxsize);
            Axes.YTickLabel = cellstr(num2str(ydataticks));
        end

        %% pack the data for the labels in the GUI
        outputLabels = [num2str(D), num2str(alpha), num2str(r2fit)];
    catch
    end
end
    