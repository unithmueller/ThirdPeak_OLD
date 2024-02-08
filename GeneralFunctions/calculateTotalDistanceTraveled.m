function destinationStruc = calculateTotalDistanceTraveled(destinationStruc)
%Funtion to calculate the total distance a particle has travelled during
%its lifetime
%Input: destinationStruc already containing the calculated jump distances
%Output:
    %% grab the already calculated jump distances
    datXY = destinationStruc.JumpDist.XY;
    datXYZ = destinationStruc.JumpDist.XYZ;
    
    %% set temporary save structures
    totalDistanceXY = cell(size(datXY,1),2);
    totalDistanceXYZ = cell(size(datXY,1),2);
    
    %% calculate the total distance
    %using for loop, results in cell array with [id, length]
    for i = 1:size(datXY,1)
        tmpXYdat = sum(datXY{i,2}(:,2));
        tmpXYid = datXY{i,1};
        tmpXYZdat = sum(datXYZ{i,2}(:,2));
        tmpXYZid = datXYZ{i,1};

        totalDistanceXY{i,1} = tmpXYid;
        totalDistanceXY{i,2}= tmpXYdat;
        totalDistanceXYZ{i,1} = tmpXYZid;
        totalDistanceXYZ{i,2} = tmpXYZdat;
    end

    %% save to destination
    destinationStruc.TrackLength.AbsLength.XY = totalDistanceXY;
    destinationStruc.TrackLength.AbsLength.XYZ = totalDistanceXYZ;
end