 function determineSegmentNumbers(SingleTrackData, destinationStruc)
 %determines the number of segments in a given track and saves is in the structured
 %array of choice.
 %Input: SingleTrackData: x by 23 array of a single track
 %      destinationStruc: structured array to save to
    trackid = SingleTrackData(1,1);
    segments = SingleTrackData(1,22);
    destinationStruc.SwiftParams.switchFreq(end+1,:) = {trackid, segments};
end