function getVolumeAreaoccupiedByTracks(Axes, TrackData, dimension, filterIDs)
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
    if dimension == 2
        [k,av] = convhull(TrackData(:,3), TrackData(:,4));
        plot(Axes, TrackData(k,3), TrackData(k,4));
        text(0.1,0.1, ["Area: " string(av)], "Units", "normalized");
    else
        [k,av] = convhull(TrackData(:,3), TrackData(:,4), TrackData(:,5));
        plot(Axes, TrackData(k,3), TrackData(k,4), TrackData(k,5));
        text(0.1,0.1, ["Volume: " string(av)], "Units", "normalized");
    end

end