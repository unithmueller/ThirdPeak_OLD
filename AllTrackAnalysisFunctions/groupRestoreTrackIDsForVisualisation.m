function FileIDs = groupRestoreTrackIDsForVisualisation(TracksinCell, concatTracks, filterIDs)
%Funcion to restore the filtered track ids in the All Tracks mode to their
%respective file name and the remaining tracks per file
%Input: TrackData - original track data
       %filterIds - Ids left after filtering in case of the All Tracks mode
%Output: structured array with filename and remaining IDs

    %% associated the new track id with the respective file the track originated from
    sizes = cellfun(@size, TracksinCell(:,1), 'UniformOutput', 0);
    
    %% save structure
    FileIDs = {};
    FileIDs(:,1) = TracksinCell(:,2);
    %% determine the track-id range per file
    count = 1;
    for i = 1:size(sizes,1)
        if sizes{i,1} > 1
            trackentries = sizes{i,1}(1,1)+count-1;
            IDRange = [count:1:trackentries];
            FileIDs(i,2) = IDRange;
            count = trackentries+1;
        end
    end
    
    %% filter the IDs
    for i = 1:size(sizes,1) 
        if sizes{i,1} > 1
            possibleIDs = FileIDs{i,2};
            filteredPossibleIDs = possibleIDs(possibleIDS == filterIDs);
            FileIDs{i,2} = filteredPossibleIDs;
        end
    end
    
    %% restore original id
    for i = 1:size(sizes,1) 
        if sizes{i,1} > 1
            possibleIDs = FileIDs{i,2};
            trueIDs = concatTracks(concatTracks(:,1) == possibleIDs,end);
            FileIDs{i,2} = trueIDs;
        end
    end
end