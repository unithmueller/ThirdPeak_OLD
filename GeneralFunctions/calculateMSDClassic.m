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
    
    %% repack the data and add the track ids
    ids = cell2mat(calculatedMSDIDs).';
    if dimension == 2
        dimf = 2;
    elseif dimension == 3
        dimf = 3;
    end
    alphas = {};
    As = {};
    Ds = {};
    linR = {};
    logR = {};
    for i = 1:size(ids,1)
        alphas{i,1} = ids(i);
        alphas{i,2} = lyzer.loglogfit.alpha(i);
        As{i,1} = ids(i);
        As{i,2} = lyzer.lfit.a(i);
        Ds{i,1} = ids(i);
        Ds{i,2} = lyzer.lfit.a(i)*1/(2*dimf);
        linR{i,1} = ids(i);
        linR{i,2} = lyzer.lfit.r2fit(i);
        logR{i,1} = ids(i);
        logR{i,2} = lyzer.loglogfit.r2fit(i);
    end
    %% Save the generated data
    destinationStruc.InternMSD.TrackIDs = calculatedMSDIDs;
    
    if dimension == 2
        destinationStruc.InternMSD.XY.MSDclass = lyzer;
        destinationStruc.InternMSD.XY.Alpha = alphas;
        destinationStruc.InternMSD.XY.a = As;
        destinationStruc.InternMSD.XY.d = Ds;
        destinationStruc.InternMSD.XY.logR = logR; 
        destinationStruc.InternMSD.XY.linR = linR; 
    elseif dimension == 3
        destinationStruc.InternMSD.XYZ.MSDclass = lyzer;
        destinationStruc.InternMSD.XYZ.Alpha = alphas;
        destinationStruc.InternMSD.XYZ.a = As;
        destinationStruc.InternMSD.XYZ.d = Ds; 
        destinationStruc.InternMSD.XYZ.logR = logR; 
        destinationStruc.InternMSD.XYZ.linR = linR; 
    end
end