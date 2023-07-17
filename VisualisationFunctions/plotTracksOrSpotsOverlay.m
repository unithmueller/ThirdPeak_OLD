function plotTracksOrSpotsOverlay(Axes, Tracks, is3d, isTracks, isAlltracks, scalexy, scalez, timepoint, spotSize)
    %Function to plot the tracks on top of the microscopy image. This is purely
    %the plotting functionality to populate the axes object. Further refinement
    %is done in manageTrackOverlayVisualisation.
    %Input: Axes - To plot the track data into
                %Tracks - track data from a localisation software
                %is3d - flag if we plot in 2d or 3d
                %isTracks - flag if we want connected tracks or spots
                %isAlltracks - if we want to show the current tracks for the
                %current frame or all tracks at once
                %scalexy - scaleling value for the tracks to match the microscopy
                %image
                %scalez - scaleling value in z
                %type - if spots or tracks
                %timepoint - if we want single tracks at a given timepoint
    %Output: -
    
    %% Determine the data range: single frame vs all
    if isAlltracks %process all data
        %get the relevant TrackIDs
        trackIDs = unique(Tracks(:,1));
    else %only the ones present in the given frame
        trackIDs = unique(Tracks(Tracks(:,2) == timepoint,1));
    end
    %stop if nothing has been found
    if isempty(trackIDs)
        return
    end
    %% Get the Spots and Tracks
    %spots are only active in the given frame
    currentSpots = [];
    for i = 1:size(trackIDs,1)
        currentSpots = [currentSpots; Tracks(Tracks(:,1) == trackIDs(i),:)];
    end
    currentSpots = currentSpots(currentSpots(:,2) == timepoint,:);
    %get the tracks
    currentTracks = cell(size(trackIDs,1),1);
    for i = 1:size(trackIDs,1)
        currentTracks{i,1} = Tracks(Tracks(:,1) == trackIDs(i),:);
    end
    %% Adjust the scaling to match the microscope image
    currentSpots(:,3:4) = currentSpots(:,3:4)*scalexy;
    currentSpots(:,5) = currentSpots(:,5)*scalez;
        
    for i = 1:size(trackIDs,1)
        currentTracks{i,1}(:,3:4) = currentTracks{i,1}(:,3:4)*scalexy;
        currentTracks{i,1}(:,5) = currentTracks{i,1}(:,5)*scalez;
    end
    %% Plot the data
    switch isTracks
        case 0
            %spots
            if is3d == 0
                scatter(Axes, currentSpots(:,3), currentSpots(:,4), spotSize,"filled");
            elseif is3d == 1
                scatter3(Axes, currentSpots(:,3), currentSpots(:,4), currentSpots(:,5), spotSize,"filled");
            end
            
        case 1
            %tracks
            for i = 1:size(trackIDs,1)
            %for every Track
            curTrack = currentTracks{i,1};
                if is3d == 0
                    plot(Axes, curTrack(:,3), curTrack(:,4), "Displayname",num2str(curTrack(1,1)));
                elseif is3d == 1
                    plot3(Axes, curTrack(:,3), curTrack(:,4), curTrack(:,5),"Displayname",num2str(curTrack(1,1)));
                end
            end
            %plot the current spot in addition if we dont plot all tracks
            if ~isAlltracks
                 %spots
                if is3d == 0
                    scatter(Axes, currentSpots(:,3), currentSpots(:,4), spotSize, "filled");
                elseif is3d == 1
                    scatter3(Axes, currentSpots(:,3), currentSpots(:,4), currentSpots(:,5), spotSize, "filled");
                end
            end
    end
end