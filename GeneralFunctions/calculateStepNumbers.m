 function destinationStruc = calculateStepNumbers(SingleTrackData, destinationStruc)
 %calculates the length of a given track and saves is in the structured
 %array of choice.
 %Input: SingleTrackData: x by 5 array of a single track
 %      destinationStruc: structured array to save to
    trackid = SingleTrackData(1,1);
    len = size(SingleTrackData,1);
    destinationStruc.TrackLength.Steps(end+1,:) = {trackid, len};
end