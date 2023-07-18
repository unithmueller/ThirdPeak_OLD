function outputLabels = plotAllFiguresSingleTrackAnalysis(saveStruc, AxesJDX, AxesJDY, AxesJDZ, AxesJDXYZ, dimensions, isPixel, timeunit, lengthunit, PolarAxes, AxesInten, isMean, isUnit, timestepsize, pxsize)
%Central function to call the plotting of the respective parts of the
%SingleTrackAnalysisWindow.
%Input:
%Output: outputLabels - contains information about the MSD to be shown in
%the GUI


    %% plot jump distances
    plotJumpDistancesSingleTrackAnalysis(saveStruc, AxesJDX, AxesJDY, AxesJDZ, AxesJDXYZ, dimensions, isPixel, timeunit, lengthunit)
    %% plot jump angles
    if dimension == 2
        polarhistogram(PolarAxes,saveStruc.JumpAngles.XY{1,1},12);
    else
        polarhistogram(PolarAxes,saveStruc.JumpAngles.XYZ{1,1},12);
    end
    %% plot Intensity
    plotIntensityofTrackoverTime(AxesInten, saveStruc, isMean, isUnit, timeunit, timestepsize);
    %% plot MSD
    outputLabels = plotMSDClassic(Axes, saveStruc, dimension, fitval, isUnit, timeunit, lengthunit, timestep, pxsize);

end