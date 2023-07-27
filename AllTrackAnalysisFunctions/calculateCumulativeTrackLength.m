function Outputstructure = calculateCumulativeTrackLength(Inputstructure, Outputstructure)
%Function to cumulative add the seperate track lengths.
%Input: Inputstructure: structured array that contains the track lengths
       %Outputstructure: The array to save to
%Output: Outputstructure- returns the now filled structured array
    %% grab the mean jump distances
    data = Inputstructure.TrackLength.Steps(:,2);
    
    %% calculate the cumulative sum
    cmtl = calculateCumulativeSum(cell2mat(data));
    
    %% save the new data to the structured array
    Outputstructure.TrackLength.CumLen = {cmtl(:,1)};
end