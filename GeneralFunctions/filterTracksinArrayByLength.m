function filteredTracks = filterTracksinArrayByLength(Trackdata, minLength)
    %Filters the input tracks by their length and returns only tracks that
    %are >= minLength
    %Input: TrackData as an array containing ID T X Y Z
            %minLength as a scalar value
    %Output Filtered tracks
    
    edges = unique(Trackdata(:,1));
    edges(end+1) = edges(end);
    %counts = histc(Trackdata(:,1), edges);
    [N, ~, ~] = histcounts(Trackdata(:,1), edges);
    %interest = find(counts >= minLength);
    counts = edges(1:end-1);
    counts(:,2) = N.';
    interest = counts(counts(:,2) >= minLength,1);
    filter = ismember(Trackdata(:,1),interest(:,1));
    filteredTracks = Trackdata(filter,:);
end