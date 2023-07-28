function destinationStruc = calculateConfinementRatio(destinationStruc)
%Function to calculate the confinement ratio. The ratio between the total
%distance travelled and the netto distance travelled
%Input: destinationStruc - structure that contains the absolute length and
%the netto length calculated previously

    %% grab the data
    totaldatXY = destinationStruc.TrackLength.AbsLength.XY{1,1};
    totaldatXYZ = destinationStruc.TrackLength.AbsLength.XYZ{1,1};
    netdatXY =  cell2mat(destinationStruc.TrackLength.NetLength.XY);
    netdatXYZ = cell2mat(destinationStruc.TrackLength.NetLength.XYZ);
    
    %% prepare save structures
    ratioXY = zeros(size(totaldatXY,1),2);
    ratioXYZ = zeros(size(totaldatXY,1),2);
    
    %% calculate the ratio
    ratioXY(:,1) = totaldatXY(:,1);
    ratioXYZ(:,1) = totaldatXYZ(:,1);
    ratioXY(:,2) = totaldatXY(:,2)./netdatXY(:,2);
    ratioXYZ(:,2) = totaldatXYZ(:,2)./netdatXYZ(:,2);

    %% save the ratio
    destinationStruc.TrackLength.ConfRatio.XY(end+1,1) = {ratioXY};
    destinationStruc.TrackLength.ConfRatio.XYZ(end+1,1) = {ratioXYZ};
end