function outputLabels = plotAllFiguresSingleTrackAnalysis(saveStruc, AxesJDX, AxesJDY, AxesJDZ, AxesJDXYZ, dimensions, isPixel, timeunit, lengthunit, PolarAxes, AxesInten, isMean, isUnit, timestepsize, pxsize, MSDAxes, fitval)
%Central function to call the plotting of the respective parts of the
%SingleTrackAnalysisWindow.
%Input:
%Output: outputLabels - contains information about the MSD to be shown in
%the GUI


    %% plot jump distances
    plotJumpDistancesSingleTrackAnalysis(saveStruc, AxesJDX, AxesJDY, AxesJDZ, AxesJDXYZ, dimensions, isPixel, timeunit, lengthunit, timestepsize);
    %% plot jump angles
    if dimensions == 2
        polarhistogram(PolarAxes,saveStruc.JumpAngles.XY{1,2},12);
    else
        polarhistogram(PolarAxes,saveStruc.JumpAngles.XYZ{1,2},12);
    end
    %% plot Intensity
    plotIntensityofTrackoverTime(AxesInten, saveStruc, isMean, isUnit, timeunit, timestepsize);
    %% plot MSD
    outputLabels = plotMSDClassic(MSDAxes, saveStruc, dimensions, fitval, isUnit, timeunit, lengthunit, timestepsize, pxsize);

end