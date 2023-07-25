 function destinationStruc = calculateMeanJumpDistances(inputStruc, destinationStruc)
    %calculates the mean jump distances from already calculated jump
    %distances.
    %Input: inputStruc: Structured array in which the jump distances are
    %saved
    %       distinationStruc: Structured array to save to
    
    %get the input data from the input array
    datX = inputStruc.JumpDist.X;
    datY = inputStruc.JumpDist.Y;
    datZ = inputStruc.JumpDist.Z;
    datXY = inputStruc.JumpDist.XY;
    datXYZ = inputStruc.JumpDist.XYZ;
    
    %calculate the mean of the data for every track in all dimensions
    %% X
    mX = cellfun(@mean,datX(:,2), 'UniformOutput',0);
    for i = 1:size(mX,1)
        if mX{i} == 0
            mX{i} = [0,0];
        end
    end
    mX = cell2mat(mX);
    mX = {datX(:,1), mX(:,2)};
    
    %% Y
    mY = cellfun(@mean,datY(:,2), 'UniformOutput',0);
    for i = 1:size(mY,1)
        if mY{i} == 0
            mY{i} = [0,0];
        end
    end
    mY = cell2mat(mY);
    mY = {datY(:,1), mY(:,2)};
    
    %% Z
    mZ = cellfun(@mean,datZ(:,2), 'UniformOutput',0);
    for i = 1:size(mZ,1)
        if mZ{i} == 0
            mZ{i} = [0,0];
        end
    end
    mZ = cell2mat(mZ);
    mZ = {datZ(:,1), mZ(:,2)};
    
    %% XY
    mXY = cellfun(@mean,datXY(:,2), 'UniformOutput',0);
    for i = 1:size(mXY,1)
        if mXY{i} == 0
            mXY{i} = [0,0];
        end
    end
    mXY = cell2mat(mXY);
    mXY = {datXY(:,1), mXY(:,2)};
    
    %% XYZ
    mXYZ = cellfun(@mean,datXYZ(:,2), 'UniformOutput',0);
    for i = 1:size(mXYZ,1)
        if mXYZ{i} == 0
            mXYZ{i} = [0,0];
        end
    end
    mXYZ = cell2mat(mXYZ);
    mXYZ = {datXYZ(:,1), mXYZ(:,2)};
    
    %% Save the data
    destinationStruc.MeanJumpDist.X = mX;
    destinationStruc.MeanJumpDist.Y = mY;
    destinationStruc.MeanJumpDist.Z = mZ;
    destinationStruc.MeanJumpDist.XY = mXY;
    destinationStruc.MeanJumpDist.XYZ = mXYZ;
    end