function destinationStruc = gatherIntensityData(SingleTrackData, destinationStruc)
    %Grabs the intesity data from Single Tracks and saves it in the
    %structured array to be used later

    %% get the intensity values
    intensities = SingleTrackData(:,18);
    %% pack it into the destination
    destinationStruc.Intensities(end+1,:) = {SingleTrackData(1,1), intensities};
end