function Axes = getVolumeAreaoccupiedByTracks(Axes, TrackData, dimension, filterIDs)
%Function to determine the Volume or Area occupied by tracks
%Input: Axes- axes object to plot to
       % TrackData - localisation data of the tracks in 2d or 3d
       % dimension - override 3d if 2d if wanted
       % filterIDs - filter the track data by the respective track ids
       % first
%Output:

    %% filter the data if necessary
    if size(filterIDs,1) > 0
        TrackData = TrackData(TrackData(:,1) == filterIDs, :);
    end
    
    %% decide if 2d or 3d and plot
    dimension = convertStringsToChars(dimension);
    if size(dimension,2) < 2
        dimension = 'XY';
    end
    if size(dimension,2) == 2
        view(Axes,2);
        [k,av] = convhull(TrackData(:,3), TrackData(:,4));
        plot(Axes, TrackData(k,3), TrackData(k,4));
        axis(Axes, "auto");
        text(Axes, 0.1,0.1, ["Area: " string(av)], "Units", "normalized");
        xlabel(Axes, "X Dimension");
        ylabel(Axes, "Y Dimension");
    else
        [k,av] = convhull(TrackData(:,3), TrackData(:,4), TrackData(:,5));
        TR = triangulation(k,TrackData(:,3),TrackData(:,4),TrackData(:,5));
        f1 = figure;
        set(f1, "Visible", "off");
        ts = trisurf(TR);
        newhandle = copyobj(ts, Axes);
        axis(Axes, "auto");
        view(Axes,3);
        text(Axes, 0.1,0.1,0.1, ["Volume: " string(av)], "Units", "normalized");
        xlabel(Axes, "X Dimension");
        ylabel(Axes, "Y Dimension");
        zlabel(Axes, "Z Dimension");
    end

end