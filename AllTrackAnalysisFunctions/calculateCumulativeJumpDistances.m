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
        if size(tmpX,1) == 0
            datX{i,2} = 0;
        else
            datX{i,2} = calculateCumulativeSum(tmpX(:,2));
        end
        tmpY = datY{i,2};
        if size(tmpY,1) == 0
            datY{i,2} = 0;
        else
            datY{i,2} = calculateCumulativeSum(tmpY(:,2));
        end
        tmpZ = datZ{i,2};
        if size(tmpZ,1) == 0
            datZ{i,2} = 0;
        else
            datZ{i,2} = calculateCumulativeSum(tmpZ(:,2));
        end
        tmpXY = datXY{i,2};
        if size(tmpXY,1) == 0
            datXY{i,2} = 0;
        else
            datXY{i,2} = calculateCumulativeSum(tmpXY(:,2));
        end
        tmpXYZ = datXYZ{i,2};
        if size(tmpXYZ,1) == 0
            datXYZ{i,2} = 0;
        else
            datXYZ{i,2} = calculateCumulativeSum(tmpXYZ(:,2));
        end
    end
    %% put the data back into the output structure
    OutputStructure.CumJumpDist.X = datX;
    OutputStructure.CumJumpDist.Y = datY;
    OutputStructure.CumJumpDist.Z = datZ;
    OutputStructure.CumJumpDist.XY = datXY;
    OutputStructure.CumJumpDist.XYZ = datXYZ;
end