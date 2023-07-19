function destinationStruc = calculateNumberOfStepsinTrack(SingleTrackData, destinationStruc)
%Calculates the number of steps = length of a track
%Input: SingleTrackData - Localisation data of a single track
        %destinationStruc - structure to save to
%Output:
    %% Calculate the lenght
    len = size(SingleTrackData,1);
    trackid = SingleTrackData(1,1);
    %% save the data
    destinationStruc.TrackLength.Steps(end+1,:) = {trackid, len};
end