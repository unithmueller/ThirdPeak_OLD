 function filteredTracks = filterTracksinCellbyLength(tracksInCell, mintracklength)
%Filter the tracklength per cell
    edges = unique(tracksInCell(:,1));
    counts = histc(tracksInCell(:,1),edges); 
    interest = find(counts >= mintracklength);
    intracksnr = edges(interest); 
    filtertracks = [];
    for j = 1:length(intracksnr)
        k = intracksnr(j);
        intresttrackind = find(tracksInCell(:,1) == k);
        filtertracks = cat(1,filtertracks, tracksInCell(intresttrackind,:));
    end
    filteredTracks = filtertracks;
 end