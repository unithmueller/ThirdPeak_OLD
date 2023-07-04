function data = catTrackDataRename(TracksinCell)
    sizes = cellfun(@size, TracksinCell(:,1), 'UniformOutput', 0);
    allentries = 0;
    for i = 1:size(sizes,1)
        sz = sizes{i,1}(1,1);
        allentries = allentries+sz;
    end

    
    data = zeros(allentries,sizes{1,1}(1,2));
    count = 1;
    for i = 1:size(sizes,1)
        if sizes{i,1} > 1
            maxID = max(data(:,1));
            trackentries = sizes{i,1}(1,1)+count-1;

            putdata = TracksinCell{i,1};
            putdata(:,1) = maxID+1+putdata(:,1);

            data(count:trackentries,:) = putdata;
            count = trackentries+1;
        end
    end        
end