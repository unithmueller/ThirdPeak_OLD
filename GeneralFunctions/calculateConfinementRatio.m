function calculateConfinementRatio(destinationStruc)
%Function to calculate the confinement ratio. The ratio between the total
%distance travelled and the netto distance travelled
%Input: destinationStruc - structure that contains the absolute length and
%the netto length calculated previously

    %% grab the data
    totaldatXY = destinationStruc.TrackLength.AbsLength.XY;
    totaldatXYZ = destinationStruc.TrackLength.AbsLength.XYZ;
    netdatXY =  destinationStruc.TrackLength.NetLength.XY;
    netdatXYZ = destinationStruc.TrackLength.NetLength.XYZ;
    
    %% calculate the ratio
    ratioXY = totaldatXY(:,2)./cell2mat(netdatXY(:,2));
    ratioXYZ = totaldatXYZ(:,2)./cell2mat(netdatXYZ(:,2));
    
    %% repack the ratio
    ids = totaldatXYZ(:,1);
    ratioXY = [ids, ratioXY];
    ratioXYZ = [ids, ratioXYZ];
    
    %% save the ratio
    destinationStruc.TrackLength.ConfRatio.XY = ratioXY;
    destinationStruc.TrackLength.ConfRatio.XYZ = ratioXYZ;
end