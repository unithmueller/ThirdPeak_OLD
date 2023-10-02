function [Axes, outAlphaRad, outparas] = getVolumeAreaoccupiedByTracks(Axes, TrackData, dimension, filterIDs, methodChosen, alphaRadius, useManualRad, isPixel, lengthU)
%Function to determine the Volume or Area occupied by tracks
%Input: Axes- axes object to plot to
       % TrackData - localisation data of the tracks in 2d or 3d
       % dimension - override 3d if 2d if wanted
       % filterIDs - filter the track data by the respective track ids
       % first
%Output:

    %% filter the data if necessary
    if size(filterIDs,1) > 0
        mask = ismember(TrackData(:,1), filterIDs);
        TrackData = TrackData(mask, :);
    end
    
    %% decide if 2d or 3d and which approach and plot
    dimension = convertStringsToChars(dimension);
    av = [];
    alphaParam = [];
    if size(dimension,2) < 2
        dimension = 'XY';
    end
    if size(dimension,2) == 2
        view(Axes,2);
        if string(methodChosen) == "Convex Hull"
            [k,av] = convhull(TrackData(:,3), TrackData(:,4));
            plot(Axes, TrackData(k,3), TrackData(k,4));
            axis(Axes, "auto");
            text(Axes, 0.1,0.1, ["Area: " string(av)], "Units", "normalized");
            a = 1;
        else
            if useManualRad
                a = alphaRadius;
                shp = alphaShape(TrackData(:,3), TrackData(:,4),a);
            else
                shp = alphaShape(TrackData(:,3), TrackData(:,4));
                a = criticalAlpha(shp,'one-region');
                shp = alphaShape(TrackData(:,3), TrackData(:,4),a);
            end
            fignew = figure('Visible','off'); % Invisible figure
            h = plot(shp);
            newh = copyobj(h, Axes);
            alphaParam = area(shp);
            text(Axes, 0.1,0.1, ["Area: " string(area(shp))], "Units", "normalized");
        end
        if isPixel
            xlabel(Axes, "X Dimension [px]");
            ylabel(Axes, "Y Dimension [px]");
        else
            xlabel(Axes, sprintf("X Dimension [%s]", lengthU));
            ylabel(Axes, sprintf("Y Dimension [%s]", lengthU));
        end
    else
        view(Axes,3);
        if string(methodChosen) == "Convex Hull"
            [k,av] = convhull(TrackData(:,3), TrackData(:,4), TrackData(:,5));
            TR = triangulation(k,TrackData(:,3),TrackData(:,4),TrackData(:,5));
            f1 = figure;
            set(f1, "Visible", "off");
            ts = trisurf(TR);
            newhandle = copyobj(ts, Axes);
            axis(Axes, "auto");
            text(Axes, 0.1,0.1,0.1, ["Volume: " string(av)], "Units", "normalized");
            a = 1;
        else
            if useManualRad
                a = alphaRadius;
                shp = alphaShape(TrackData(:,3), TrackData(:,4), TrackData(:,5), a);
            else
                shp = alphaShape(TrackData(:,3), TrackData(:,4), TrackData(:,5));
                a = criticalAlpha(shp,'one-region');
                shp = alphaShape(TrackData(:,3), TrackData(:,4), TrackData(:,5),a);
            end
            fignew = figure('Visible','off'); % Invisible figure
            h = plot(shp);
            newh = copyobj(h, Axes);
            alphaParam = volume(shp);
            text(Axes, 0.1,0.1, ["Volume: " string(volume(shp))], "Units", "normalized");
        end
        alphaParam = round(alphaParam,2);
        if isPixel
            xlabel(Axes, "X Dimension [px]");
            ylabel(Axes, "Y Dimension [px]");
            zlabel(Axes, "Z Dimension [px]");
        else
            xlabel(Axes, sprintf("X Dimension [%s]", lengthU));
            ylabel(Axes, sprintf("Y Dimension [%s]", lengthU));
            zlabel(Axes, sprintf("Z Dimension [%s]", lengthU));
        end
    end
    
    %% output values
    outAlphaRad = a;
    outparas = {};
    if isempty(av)
        if size(dimension,2) == 2
            outparas{1,1} = "Area";
            outparas{1,2} = alphaParam;
        else
            outparas{1,1} = "Volume";
            outparas{1,2} = alphaParam;
        end
    else
        if size(dimension,2) == 2
            outparas{1,1} = "Area";
            outparas{1,2} = av;
        else
            outparas{1,1} = "Volume";
            outparas{1,2} = av;
        end
    end
    if isPixel
        if size(dimension,2) == 2
            outparas{1,3} = "px²";
        else
            outparas{1,3} = "px³";
        end
    else
        if size(dimension,2) == 2
            outparas{1,3} = join([lengthU "²"],"");
        else
            outparas{1,3} = join([lengthU "³"],"");
        end
    end
end