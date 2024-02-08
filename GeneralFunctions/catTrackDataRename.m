function data = catTrackDataRename(TracksinCell)
%Function to put all tracks into one dataset to analyse all tracks
%together.
%Input: TracksInCell - Tracks per Cell/Measurement in seperate (matlab)
%cells
%Output: concatenated Data
    %% determine the amount of data
    sizes = cellfun(@size, TracksinCell(:,1), 'UniformOutput', 0);
    %% prepare save structure
    allentries = 0;
    startIdx = zeros(size(TracksinCell,1)+1,1);
    startIdx(1) = 1;
    for i = 1:size(sizes,1)
        sz = sizes{i,1}(1,1);
        allentries = allentries+sz;
        startIdx(i+1) = startIdx(i)+sz;
    end
    data = zeros(allentries,sizes{1,1}(1,2)+1);
    
    count = 1;
    for i = 1:size(sizes,1)
        if sizes{i,1} > 1
            maxID = max(data(:,1));
            trackentries = sizes{i,1}(1,1)+count-1;

            putdata = zeros(size(TracksinCell{i,1},1), size(TracksinCell{i,1},2)+1);
            putdata(:,1:end-1) = TracksinCell{i,1};
            putdata(:,end) = putdata(:,1);
            putdata(:,1) = maxID+1+putdata(:,1);

            data(count:trackentries,:) = putdata;
            count = trackentries+1;
        end
    end        
end