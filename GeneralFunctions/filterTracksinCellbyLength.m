 function filteredTracks = filterTracksinCellbyLength(tracksInCell, mintracklength)
    %Filter the tracklength per cell
    edges = unique(tracksInCell(:,1));
    edges(end+1) = edges(end);
    [counts, ~, ~] = histcounts(tracksInCell(:,1),edges); 
    counts = counts.';
    interest = [edges(1:end-1) counts];
    interest = interest(interest(:,2) >= mintracklength,:);
    intracksnr = interest(:,1);
    filter = ismember(tracksInCell(:,1), intracksnr);
    filteredTracks = tracksInCell(filter,:);
 end