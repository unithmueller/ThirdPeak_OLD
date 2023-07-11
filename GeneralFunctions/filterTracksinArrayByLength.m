function filteredTracks = filterTracksinArrayByLength(Trackdata, minLength)
    %Filters the input tracks by their length and returns only tracks that
    %are >= minLength
    %Input: TrackData as an array containing ID T X Y Z
            %minLength as a scalar value
    %Output Filtered tracks
    
    edges = unique(Trackdata(:,1));
    counts = histc(Trackdata(:,1), edges);
    interest = find(counts >= minLength);
    intrestTrackNumber = edges(interest);
    filteredTracks = [];
    for i = 1:length(intrestTrackNumber)
        j = intrestTrackNumber(i);
        interestTrackIndx = find(Trackdata(:,1) == j);
        filteredTracks = [filteredTracks; Trackdata(interestTrackIndx,:)];
    end
end