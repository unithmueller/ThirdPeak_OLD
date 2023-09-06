function SaveStructure = calculateValuesAllAnalysisForSaveStructure(TrackData, SaveStructure)
%Function to manage the calculation of additional values from the original
%track data provided by the main app. After the properties have been
%calculated, they will be saved into the provided data structure. In the
%end, the provided data structure will be returned. 
%Input: TrackData - Original Trackdata as an array
       %SaveStructure - Structured Array With predefined fields
%Output: Provided SaveStructure, now filled with the additional calculated
%data

    %% For every single track in the data provided
    trackIDs = unique(TrackData(:,1));
    for i = 1:numel(trackIDs)
        singleTrackData = TrackData(TrackData(:,1) == trackIDs(i),:);
        %% Make sure the track is long enough
        if size(singleTrackData,1) < 3
            continue
        end
        %% Calculate the Jump Distances
        SaveStructure = calculateJumpDistances(singleTrackData, SaveStructure);
        %% Get the diffusion parameters from swift
        try
            SaveStructure = retrieveDiffusionParametersFromSwift(singleTrackData, SaveStructure);
        catch
        end
        %% calculate the jump angles
        SaveStructure = calculateJumpAngles(singleTrackData, SaveStructure);
        %% calculate the netto distance
        SaveStructure = calculateNettoDistanceTravelled(singleTrackData, SaveStructure);
        %% calculate the step numbers
        SaveStructure = calculateStepNumbers(singleTrackData, SaveStructure);
        %% determine the number of segments per track
        try
        SaveStructure = determineSegmentNumbers(singleTrackData, SaveStructure);
        catch
        end
    end

    %% Use the data from the structured array to calculate more properties
    SaveStructure = calculateCumulativeJumpDistances(SaveStructure, SaveStructure);
    SaveStructure = calculateMeanJumpDistances(SaveStructure, SaveStructure);
    SaveStructure = calculateCumulativeMeanJumpDistance(SaveStructure, SaveStructure);
    SaveStructure = calculateCumulativeTrackLength(SaveStructure, SaveStructure);
    SaveStructure = calculateTotalDistanceTraveled(SaveStructure);
    SaveStructure = calculateConfinementRatio(SaveStructure);
end