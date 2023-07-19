function plotJumpDistancesSingleTrackAnalysis(saveStruc, AxesX, AxesY, AxesZ, AxesXYZ, dimensions, isPixel, timeunit, lengthunit, timestepsize)
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
    %X_dat = [1:1:size(saveStruc.JumpDist.X{1,2},1)];
    %% Jump Distance X
    JDX_Ydat = saveStruc.JumpDist.X{1,2};
    if ~isPixel
        %need to convert the x scale to time
        JDX_Ydat(:,1) = JDX_Ydat(:,1)*timestepsize;
    end
    plot(AxesX, JDX_Ydat(:,1), JDX_Ydat(:,2));
    
    %% Jump Distance Y
    JDY_Ydat = saveStruc.JumpDist.Y{1,2};
    if ~isPixel
    %need to convert the x scale to time
        JDY_Ydat(:,1) = JDY_Ydat(:,1)*timestepsize;
    end
    plot(AxesY, JDY_Ydat(:,1), JDY_Ydat(:,2));
    
    %% Jump Distance Z
    JDZ_Ydat = saveStruc.JumpDist.Z{1,2};
    if ~isPixel
    %need to convert the x scale to time
        JDZ_Ydat(:,1) = JDZ_Ydat(:,1)*timestepsize;
    end
    plot(AxesZ, JDZ_Ydat(:,1), JDZ_Ydat(:,2));
    
    %% Jump Distance XY(Z)
    JDXYZ_Ydat = saveStruc.JumpDist.XYZ{1,2};
    if ~isPixel
    %need to convert the x scale to time
        JDXYZ_Ydat(:,1) = JDXYZ_Ydat(:,1)*timestepsize;
    end
    plot(AxesXYZ, JDXYZ_Ydat(:,1), JDXYZ_Ydat(:,2));
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