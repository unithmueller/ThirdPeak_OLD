function plotJumpDistancesSingleTrackAnalysis(saveStruc, AxesX, AxesY, AxesZ, AxesXYZ, dimensions, isPixel, timeunit, lengthunit)
%Function to perform the plotting of the calculated Jump distances into the
%given axes objects in the figure
%Input: saveStruc - structures array that contains the data
       %AxesX - axes object for the x jump distances
       %AxesY - axes object for the y jump distances
       %AxesZ - axes object for the z jump distances
       %AxesXYZ - axes object for the xy or xyz jump distances
       %dimensions - determines if 2d or 3d
       %isPixels determines if pixel values or true values are used
%Output: -
    
    %% amount of steps
    X_dat = [1:1:size(saveStruc.JumpDist.X(:,2),1)];
    %% Jump Distance X
    JDX_Ydat = saveStruc.JumpDist.X(:,2);
    plot(AxesX, X_dat, JDX_Ydat);
    
    %% Jump Distance Y
    JDY_Ydat = saveStruc.JumpDist.Y(:,2);
    plot(AxesY, X_dat, JDY_Ydat);
    
    %% Jump Distance Z
    JDZ_Ydat = saveStruc.JumpDist.Z(:,2);
    plot(AxesZ, X_dat, JDZ_Ydat);
    
    %% Jump Distance XY(Z)
    JDXYZ_Ydat = saveStruc.JumpDist.XYZ(:,2);
    plot(AxesXYZ, X_dat, JDXYZ_Ydat);
    %change title accordingly
    if dimensions == 2
        title(AxesXYZ, "Jump Distance in XY");
    else
        title(AxesXYZ, "Jump Distance in XYZ");
    end
    
    %% add labels
    %decide on the label text
    if isPixel == 1%px/frame
        xlabeltext = "Time [frame]";
        ylabeltext = "Jump Distance [px]";
    elseif isPixel == 0 %unit/unit
        xlabeltext = sprintf("Time [%s]", timeunit);
        ylabeltext = sprintf("Jump Distance [%s]", lengthunit);
    end
    
    %associate labels with axes
    xlabel(AxesX, xlabeltext);
    ylabel(AxesX, ylabeltext);
    xlabel(AxesY, xlabeltext);
    ylabel(AxesY, ylabeltext);
    xlabel(AxesZ, xlabeltext);
    ylabel(AxesZ, ylabeltext);
    xlabel(AxesXYZ, xlabeltext);
    ylabel(AxesXYZ, ylabeltext);
end