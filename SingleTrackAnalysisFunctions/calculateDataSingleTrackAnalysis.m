function calculateDataSingleTrackAnalysis(SingleTrackData, dimension, fitValue, lengthCheck, Timestepsize, destinationStruct)
    %This function calls several sub-functions to calculate some properties
    %from the single track data present in the single track analysis window
    %Input: SingleTrackData which contains the timepoint and position
            %destinationStruc : Structure to save to 
            
    %% Calculations
    %JumpDistances
    calculateJumpDistances(SingleTrackData, destinationStruct);
    %Get the intensity data
    gatherIntensityData(SingleTrackData, destinationStruct);
    %Calculate the MSD
    calculateMSDClassic(TrackData, dimension, fitValue, lengthCheck, destinationStruct);
    %Try to get an alread calculated MSD
    try
        destinationStruct.SwiftParams.D = {SingleTrackData(1,7)};
        %MSD = 2nDt
        MSD = 2*dimension*SingleTrackData(1,7)*Timestepsize;
        destinationStruct.SwiftParams.MSD = {MSD};
    catch
    end
    % Calculate the angles
    calculateJumpAngles(SingleTrackData, destinationStruct);
    % Calculate the total distance travelled
    calculateTotalDistanceTraveled(destinationStruct);
    % calculate netto distance travelled
    calculateNettoDistanceTravelled(SingleTrackData, destinationStruc);
    % calculate step length
    calculateNumberOfStepsinTrack(SingleTrackData, destinationStruc);
    %calculate ConfinementRatio
    calculateConfinementRatio(destinationStruc)
end