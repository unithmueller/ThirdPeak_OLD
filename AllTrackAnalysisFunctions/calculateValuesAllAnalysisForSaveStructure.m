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
        %% Calculate the Jump Distances
        SaveStructure = calculateJumpDistances(singleTrackData, SaveStructure);
        %% Get the diffusion parameters from swift
        SaveStructure = retrieveDiffusionParametersFromSwift(singleTrackData, SaveStructure);
        %% calculate the jump angles
        SaveStructure = calculateJumpAngles(singleTrackData, SaveStructure);
        %% calculate the netto distance
        SaveStructure = calculateNettoDistanceTravelled(singleTrackData, SaveStructure);
        %% calculate the step numbers
        calculateStepNumbers(singleTrackData, SaveStructure);
        %% determine the number of segments per track
        determineSegmentNumbers(singleTrackData, SaveStructure);
    end
    %% Use the data from the structured array to calculate more properties
    SaveStructure = calculateCumulativeJumpDistances(InputStructure, SaveStructure);
    SaveStructure = calculateMeanJumpDistances(inputStruc, SaveStructure);
    SaveStructure = calculateCumulativeMeanJumpDistance(Inputstructure, SaveStructure);
    SaveStructure = calculateCumulativeTrackLength(Inputstructure, SaveStructure);
    SaveStructure = calculateTotalDistanceTraveled(SaveStructure);
    SaveStructure = calculateConfinementRatio(SaveStructure);
end