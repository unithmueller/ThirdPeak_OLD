 function calculateJumpDistances(SingleTrackData, destinationStruc)
 %Calculates the jump distances in all dimensions for a single track and
 %saves it at the end of a given save structure.
 %Input: 
 %SingleTrackData - x by 5 matrix where x defines the number of
 %steps in the given track.
 %destinationStruc: Structured array to save the data to
    %prepare the temporary arrays
    duration = size(SingleTrackData,1);

    xdist = zeros(duration,2);
    ydist = zeros(duration,2);
    zdist = zeros(duration,2);
    xydist = zeros(duration,2);
    xyzdist = zeros(duration,2);
    % do the calculations
    for i = 1:duration-1
        xdist(i,:) = [i, (SingleTrackData(i,3) - SingleTrackData(i+1,3))];
        ydist(i,:) = [i, (SingleTrackData(i,4) - SingleTrackData(i+1,4))];
        zdist(i,:) = [i, (SingleTrackData(i,5) - SingleTrackData(i+1,5))];
        xydist(i,:) = [i, sqrt(xdist(i,2)^2+ydist(i,2)^2)];
        xyzdist(i,:) = [i, sqrt(xdist(i,2)^2+ydist(i,2)^2+zdist(i,2)^2)];
    end
    %save the calculated data
    destinationStruc.JumpDist.X(end+1,:) = {SingleTrackData(1,1), xdist};
    destinationStruc.JumpDist.Y(end+1,:) = {SingleTrackData(1,1), ydist};
    destinationStruc.JumpDist.Z(end+1,:) = {SingleTrackData(1,1), zdist};
    destinationStruc.JumpDist.XY(end+1,:) = {SingleTrackData(1,1), xydist};
    destinationStruc.JumpDist.XYZ(end+1,:) = {SingleTrackData(1,1), xyzdist};
end