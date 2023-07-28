function destinationStruc = calculateTotalDistanceTraveled(destinationStruc)
%Funtion to calculate the total distance a particle has travelled during
%its lifetime
%Input: destinationStruc already containing the calculated jump distances
%Output:
    %% grab the already calculated jump distances
    datXY = destinationStruc.JumpDist.XY;
    datXYZ = destinationStruc.JumpDist.XYZ;
    
    %% set temporary save structures
    totalDistanceXY = zeros(size(datXY));
    totalDistanceXYZ = zeros(size(datXYZ));
    
    %% calculate the total distance
    %using for loop, results in cell array with [id, length]
    for i = 1:size(datXY,1)
        tmpXYdat = sum(datXY{i,2}(:,2));
        tmpXYid = datXY{i,1};
        tmpXYZdat = sum(datXYZ{i,2}(:,2));
        tmpXYZid = datXYZ{i,1};

        totalDistanceXY(i,1:2) = [tmpXYid, tmpXYdat];
        totalDistanceXYZ(i,1:2) = [tmpXYZid, tmpXYZdat];
    end
    
    %% save to destination
    destinationStruc.TrackLength.AbsLength.XY(end+1,1) = {totalDistanceXY};
    destinationStruc.TrackLength.AbsLength.XYZ(end+1,1) = {totalDistanceXYZ};
end