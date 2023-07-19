function destinationStruc = calculateConfinementRatio(destinationStruc)
%Function to calculate the confinement ratio. The ratio between the total
%distance travelled and the netto distance travelled
%Input: destinationStruc - structure that contains the absolute length and
%the netto length calculated previously

    %% grab the data
    totaldatXY = destinationStruc.TrackLength.AbsLength.XY;
    totaldatXYZ = destinationStruc.TrackLength.AbsLength.XYZ;
    netdatXY =  destinationStruc.TrackLength.NetLength.XY;
    netdatXYZ = destinationStruc.TrackLength.NetLength.XYZ;
    
    %% prepare save structures
    ratioXY = zeros(size(totaldatXY,1),2);
    ratioXYZ = zeros(size(totaldatXY,1),2);
    
    %% calculate the ratio
    for i = 1:size(totaldatXY,1)
        ratioXY(i,1) = totaldatXY{i,1};
        ratioXYZ(i,1) = totaldatXYZ{i,1};
        ratioXY(i,2) = totaldatXY{i,2}/netdatXY{i,2};
        ratioXYZ(i,2) = totaldatXYZ{i,2}/netdatXYZ{i,2};
    end

    %% save the ratio
    destinationStruc.TrackLength.ConfRatio.XY(end+1,:) = {ratioXY(1,1), ratioXY(1,2)};
    destinationStruc.TrackLength.ConfRatio.XYZ(end+1,:) = {ratioXYZ(1,1), ratioXYZ(1,2)};
end