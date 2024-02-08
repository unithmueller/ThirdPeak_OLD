function Outputstructure = calculateCumulativeTrackLength(Inputstructure, Outputstructure)
%Function to cumulative add the seperate track lengths.
%Input: Inputstructure: structured array that contains the track lengths
       %Outputstructure: The array to save to
%Output: Outputstructure- returns the now filled structured array
    %% grab the mean jump distances
    data = Inputstructure.TrackLength.Steps;
    ids = cell2mat(data(:,1));
    steps = data(:,2);
    %% calculate the cumulative sum
    cmtl = calculateCumulativeSum(cell2mat(steps));
    
    %% repack the data
    cumlen = cell(size(ids,1),2);
    for i = 1:size(ids,1)
        cumlen{i,1} = ids(i);
        cumlen{i,2} = cmtl(i);
    end
    
    %% save the new data to the structured array
    Outputstructure.TrackLength.CumLen = cumlen;
end