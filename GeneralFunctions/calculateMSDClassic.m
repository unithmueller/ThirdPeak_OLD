function destinationStruc = calculateMSDClassic(TrackData, dimension, fitValue, lengthCheck, destinationStruc)
%Function to call the MSDAnalyzer to re-calculate the MSD. Works best on
%longer tracks
%Input: TrackData as an array
        %Dimension to define if 2d or 3d MSD should be calculated
        %fitValue defines the number of points to fit to
        %destinationStruc to set the save location
%Output: destinationStruc

    %% Repack the data to be used for the MSD analysis
    %Need to put each track in a exclusive cell
    trackIDs = unique(TrackData(:,1));
    repackedData = {};
    calculatedMSDIDs = {};
    %Determine the quality with the fitValue. If length check is active, we
    %use 10% of the data and want about 5 points to fit to, so we need
    %tracks with at least 50 steps. If no length check is done, we just
    %want 5 steps, no good calcuation though
    if lengthCheck
        tmpfitValue = fitValue*10;
    else
        tmpfitValue = fitValue;
    end
    for i = 1:size(trackIDs)
        %get the first track
        currentTrack = TrackData(TrackData(:,1) == trackIDs(i),:);
        %decide if the Track matches our anticipated length
        if size(currentTrack,1) >= tmpfitValue
            %save the Id of the track
            calculatedMSDIDs{end+1} = trackIDs(i);
            %decide if we do 2d or 3d MSD
            if dimension == 2
                repackedData{end+1} = currentTrack(:,2:4);
            elseif dimension == 3
                repackedData{end+1} = currentTrack(:,2:5);
            end
        end
    end
    %% Generate the msdAnalyzer class and do the calculations
    lyzer = msdanalyzer(dimension, "px", "frame");
    lyzer = addAll(lyzer,repackedData);
    lyzer = computeMSD(lyzer);
    lyzer = fitMSD(lyzer, fitValue);
    lyzer = fitLogLogMSD(lyzer, fitValue);
    
    %% Save the generated data
    destinationStruc.InternMSD.TrackIDs = calculatedMSDIDs;
    if dimension == 2
        dimf = 2;
        destinationStruc.InternMSD.XY.MSDclass = lyzer;
        destinationStruc.InternMSD.XY.Alpha = lyzer.loglogfit.alpha;
        destinationStruc.InternMSD.XY.a = lyzer.lfit.a;
        destinationStruc.InternMSD.XY.d = lyzer.lfit.a*1/(2*dimf);  
    elseif dimension == 3
        dimf = 3;
        destinationStruc.InternMSD.XYZ.MSDclass = lyzer;
        destinationStruc.InternMSD.XYZ.Alpha = lyzer.loglogfit.alpha;
        destinationStruc.InternMSD.XYZ.a = lyzer.lfit.a;
        destinationStruc.InternMSD.XYZ.d = lyzer.lfit.a*1/(2*dimf); 
    end
end