function destinationStruc = retrieveDiffusionParametersFromSwift(SingleTrackData, destinationStruc)
%Grabs the diffusion data from the swift analysis and saves it in the data
%structure for easy access.
%Input: SingleTrackData - data of a single track
        %destinationStruc - structured array to save to
%Output: destinationStruc - returns the filled array

    %% grab the data and fill the array
    destinationStruc.SwiftParams.MSD(end+1,:) = {SingleTrackData(1,1),SingleTrackData(1,12)};
    destinationStruc.SwiftParams.MSDerr(end+1,:) = {SingleTrackData(1,1),SingleTrackData(1,13)};
    destinationStruc.SwiftParams.D(end+1,:) = {SingleTrackData(1,1),SingleTrackData(1,7)};
    destinationStruc.SwiftParams.Derr(end+1,:) = {SingleTrackData(1,1),SingleTrackData(1,8)};
    destinationStruc.SwiftParams.type(end+1,:) = {SingleTrackData(1,1),SingleTrackData(1,14)};
end