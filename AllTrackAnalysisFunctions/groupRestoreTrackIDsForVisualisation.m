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
    
    %% associate tracks to file
    %find a downward step in the track numbers indicating a new file
    idxLastElement = [];
    for i = 2:size(concatTracks,1)
        prevId = concatTracks(i-1,end);
        currId = concatTracks(i,end);
        if currId < prevId
            idxLastElement(end+1) = i-1;
        end
    end
    idxLastElement(end+1) = size(concatTracks(:,1),1);
    %build the edges of the seperate files
    fileNmbr = size(FileIDs,1);
    edges = zeros(fileNmbr,2);
    edges(:,2) = idxLastElement;
    for i = 2:fileNmbr
        edges(i,1) = edges(i-1,2)+1;
    end
    edges(1:1) = 1;
    
    %% associate the tracks to the file names
    for i = 1:fileNmbr
      FileIDs(i,2) = {concatTracks(edges(i,1):edges(i,2),:)};
    end
    
    %% filter the IDs
    for i = 1:fileNmbr
        if size(FileIDs{i,2},1) > 1
            possibleIDs = FileIDs{i,2}(:,1);
            Lia = ismember(possibleIDs, filterIDs.');
            trueFilteredIDs = FileIDs{i,2}(Lia,end);
            FileIDs{i,2} = unique(trueFilteredIDs);
        end
    end
    
end