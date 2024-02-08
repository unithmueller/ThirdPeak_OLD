function Outputstructure = calculateCumulativeMeanJumpDistance(Inputstructure, Outputstructure)
%Function to cumulative add the seperate mean jump distances.
%Input: Inputstructure: structured array that contains the jump distances
       %Outputstructure: The array to save to
%Output: Outputstructure- returns the now filled structured array
    %% grab the mean jump distances
    ids = Inputstructure.MeanJumpDist.X(:,1);
    ids = cell2mat(ids{1,1});
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
    
    %% calculate min array size as during filter it might change
    minSize = min([size(cmjdX,1), size(cmjdY,1), size(cmjdZ,1), size(cmjdXY,1), size(cmjdXYZ,1)]);
    
    %% repack the data
    opcmjdX = cell(minSize,2);
    opcmjdY = cell(minSize,2);
    opcmjdZ = cell(minSize,2);
    opcmjdXY = cell(minSize,2);
    opcmjdXYZ = cell(minSize,2);
    for i = 1:minSize
        opcmjdX{i,1} = ids(i);
        opcmjdX{i,2} = cmjdX(i);
        opcmjdY{i,1} = ids(i);
        opcmjdY{i,2} = cmjdY(i);
        opcmjdZ{i,1} = ids(i);
        opcmjdZ{i,2} = cmjdZ(i);
        opcmjdXY{i,1} = ids(i);
        opcmjdXY{i,2} = cmjdXY(i);
        opcmjdXYZ{i,1} = ids(i);
        opcmjdXYZ{i,2} = cmjdXYZ(i);
    end
    
    %% save the new data to the structured array
    Outputstructure.CumMeanJumpDist.X = opcmjdX;
    Outputstructure.CumMeanJumpDist.Y = opcmjdY;
    Outputstructure.CumMeanJumpDist.Z = opcmjdZ;
    Outputstructure.CumMeanJumpDist.XY = opcmjdXY;
    Outputstructure.CumMeanJumpDist.XYZ = opcmjdXYZ;
end