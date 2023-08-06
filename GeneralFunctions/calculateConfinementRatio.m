function destinationStruc = calculateConfinementRatio(destinationStruc)
%Function to calculate the confinement ratio. The ratio between the total
%distance travelled and the netto distance travelled
%Input: destinationStruc - structure that contains the absolute length and
%the netto length calculated previously

    %% grab the data
    totaldatXY = cell2mat(destinationStruc.TrackLength.AbsLength.XY);
    totaldatXYZ = cell2mat(destinationStruc.TrackLength.AbsLength.XYZ);
    netdatXY =  cell2mat(destinationStruc.TrackLength.NetLength.XY);
    netdatXYZ = cell2mat(destinationStruc.TrackLength.NetLength.XYZ);
    
    %% prepare save structures
    %ratioXY = zeros(size(totaldatXY,1),2);
    %ratioXYZ = zeros(size(totaldatXY,1),2);
    
    %% calculate the ratio
    ratioXY(:,1) = totaldatXY(:,1);
    ratioXYZ(:,1) = totaldatXYZ(:,1);
    ratioXY(:,2) = totaldatXY(:,2)./netdatXY(:,2);
    ratioXYZ(:,2) = totaldatXYZ(:,2)./netdatXYZ(:,2);
    
    %% repack the data
    XY = {};
    XYZ = {};
    for i = 1:size(ratioXY,1)
        XY{i,1} = ratioXY(i,1);
        XY{i,2} = ratioXY(i,2);
        XYZ{i,1} = ratioXYZ(i,1);
        XYZ{i,2} = ratioXYZ(i,2);
    end

    %% save the ratio
    destinationStruc.TrackLength.ConfRatio.XY = XY;
    destinationStruc.TrackLength.ConfRatio.XYZ = XYZ;
end