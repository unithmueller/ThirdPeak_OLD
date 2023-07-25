function Outputstructure = calculateCumulativeMeanJumpDistance(Inputstructure, Outputstructure)
%Function to cumulative add the seperate mean jump distances.
%Input: Inputstructure: structured array that contains the jump distances
       %Outputstructure: The array to save to
%Output: Outputstructure- returns the now filled structured array
    %% grab the mean jump distances
    datX = Inputstructure.MeanJumpDist.X(:,2);
    datY = Inputstructure.MeanJumpDist.Y(:,2);
    datZ = Inputstructure.MeanJumpDist.Z(:,2);
    datXY = Inputstructure.MeanJumpDist.XY(:,2);
    datXYZ = Inputstructure.MeanJumpDist.XYZ(:,2);
    
    %% calculate the cumulative sum for every dimension
    cmjdX = calculateCumulativeSum(cell2mat(datX));
    cmjdY = calculateCumulativeSum(cell2mat(datY));
    cmjdZ = calculateCumulativeSum(cell2mat(datZ));
    cmjdXY = calculateCumulativeSum(cell2mat(datXY));
    cmjdXYZ = calculateCumulativeSum(cell2mat(datXYZ));
    
    %% save the new data to the structured array
    Outputstructure.CumMeanJumpDist.X = {cmjdX};
    Outputstructure.CumMeanJumpDist.Y = {cmjdY};
    Outputstructure.CumMeanJumpDist.Z = {cmjdZ};
    Outputstructure.CumMeanJumpDist.XY = {cmjdXY};
    Outputstructure.CumMeanJumpDist.XYZ = {cmjdXYZ};
end