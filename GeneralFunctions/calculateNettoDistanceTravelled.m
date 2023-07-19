function destinationStruc = calculateNettoDistanceTravelled(SingleTrackData, destinationStruc)
%Function to calculate the netto distance of a particles. Takes the first
%and the last position and calculates the vector size in between.
%Input: SingleTrackData - Localisation data of a single track
       % destinationStruc - struc to save to
%Output: 
    %% calculate the distances
    xdist = (SingleTrackData(1,3) - SingleTrackData(end,3));
    ydist = (SingleTrackData(1,4) - SingleTrackData(end,4));
    zdist = (SingleTrackData(1,5) - SingleTrackData(end,5));
    xydist = [SingleTrackData(1,1), sqrt(xdist^2+ydist^2)];
    xyzdist = [SingleTrackData(1,1), sqrt(xdist^2+ydist^2+zdist^2)];
    
    %% save the calculated data
    destinationStruc.TrackLength.NetLength.XY(end+1,:) = {xydist(1,1), xydist(1,2)};
    destinationStruc.TrackLength.NetLength.XYZ(end+1,:) = {xyzdist(1,1), xyzdist(1,2)};
end