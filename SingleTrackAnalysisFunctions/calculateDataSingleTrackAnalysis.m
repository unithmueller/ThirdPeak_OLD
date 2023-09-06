function destinationStruct = calculateDataSingleTrackAnalysis(SingleTrackData, dimension, fitValue, lengthCheck, Timestepsize, destinationStruct)
    %This function calls several sub-functions to calculate some properties
    %from the single track data present in the single track analysis window
    %Input: SingleTrackData which contains the timepoint and position
            %destinationStruc : Structure to save to 
            
    %% Calculations
    %JumpDistances
    destinationStruct = calculateJumpDistances(SingleTrackData, destinationStruct);
    %Get the intensity data
    destinationStruct = gatherIntensityData(SingleTrackData, destinationStruct);
    %Calculate the MSD
    [destinationStruct, ~] = calculateMSDClassic(SingleTrackData, dimension, fitValue, lengthCheck, destinationStruct, destinationStruct, 1, 1);
    %Try to get an alread calculated MSD
    try
        destinationStruct.SwiftParams.D = {SingleTrackData(1,7)};
        %MSD = 2nDt
        MSD = 2*dimension*SingleTrackData(1,7)*Timestepsize;
        destinationStruct.SwiftParams.MSD = {MSD};
    catch
    end
    % Calculate the angles
    destinationStruct = calculateJumpAngles(SingleTrackData, destinationStruct);
    % Calculate the total distance travelled
    destinationStruct = calculateTotalDistanceTraveled(destinationStruct);
    % calculate netto distance travelled
    destinationStruct = calculateNettoDistanceTravelled(SingleTrackData, destinationStruct);
    % calculate step length
    destinationStruct = calculateNumberOfStepsinTrack(SingleTrackData, destinationStruct);
    %calculate ConfinementRatio
    destinationStruct = calculateConfinementRatio(destinationStruct);
end