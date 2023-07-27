function OutputStructure = calculateCumulativeJumpDistances(InputStructure, OutputStructure)
%Function calculates the cumulative jump distances from the normal
%jumpdistances in each dimension.
%jd_n = jd_1 + jd_2 + ... + jd_n
%Input: InputStructure that contains jump distances
       %OutputStructure: structured array to save to
%Output: Returns the filled OutputStructure array

    %% get the jump distances
    datX = InputStructure.JumpDist.X;
    datY = InputStructure.JumpDist.Y;
    datZ = InputStructure.JumpDist.Z;
    datXY = InputStructure.JumpDist.XY;
    datXYZ = InputStructure.JumpDist.XYZ;
    
    %% calculate the cumulative jump distances
    for i = 1:size(datX,1)
        tmpX = datX{i,2};
        datX{i,2} = calculateCumulativeSum(tmpX(:,2));
        tmpY = datY{i,2};
        datY{i,2} = calculateCumulativeSum(tmpY(:,2));
        tmpZ = datZ{i,2};
        datZ{i,2} = calculateCumulativeSum(tmpZ(:,2));
        tmpXY = datXY{i,2};
        datXY{i,2} = calculateCumulativeSum(tmpXY(:,2));
        tmpXYZ = datXYZ{i,2};
        datXYZ{i,2} = calculateCumulativeSum(tmpXYZ(:,2));
    end
    %% put the data back into the output structure
    OutputStructure.CumJumpDist.X = datX;
    OutputStructure.CumJumpDist.Y = datY;
    OutputStructure.CumJumpDist.Z = datZ;
    OutputStructure.CumJumpDist.XY = datXY;
    OutputStructure.CumJumpDist.XYZ = datXYZ;
end