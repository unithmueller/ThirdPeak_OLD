function [PixeldestinationStruc, UnitdestinationStruc] = calculateMSDClassic(TrackData, dimension, fitValue, lengthCheck, PixeldestinationStruc, UnitdestinationStruc, timestep, pxsize)
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
    repackedData = cell(size(trackIDs,1),1);
    calculatedMSDIDs = cell(size(trackIDs,1),1);
    IdsCounter = 1;
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
            calculatedMSDIDs{IdsCounter} = trackIDs(i);
            
            %decide if we do 2d or 3d MSD
            if dimension == 2
                repackedData{IdsCounter} = currentTrack(:,2:4);
            elseif dimension == 3
                repackedData{IdsCounter} = currentTrack(:,2:5);
            end
            IdsCounter = IdsCounter+1;
        end
    end
    %cleanup the cell arrays
    calculatedMSDIDs = calculatedMSDIDs(~cellfun(@isempty, calculatedMSDIDs),:);
    repackedData = repackedData(~cellfun(@isempty, repackedData),:);
    %% Generate the msdAnalyzer class and do the calculations
    lyzer = msdanalyzer(dimension, "px", "frame");
    lyzer = addAll(lyzer,repackedData);
    lyzer = computeMSD(lyzer);
    lyzer = fitMSD(lyzer, fitValue);
    lyzer = fitLogLogMSD(lyzer, fitValue);
    
    %% repack the data and add the track ids
    ids = cell2mat(calculatedMSDIDs);
    if dimension == 2
        dimf = 2;
    elseif dimension == 3
        dimf = 3;
    end
    alphas = cell(size(ids,1),2);
    As = cell(size(ids,1),2);
    UnitAs = cell(size(ids,1),2);
    Ds = cell(size(ids,1),2);
    UnitDs = cell(size(ids,1),2);
    linR = cell(size(ids,1),2);
    logR = cell(size(ids,1),2);
    for i = 1:size(ids,1)
        alphas{i,1} = ids(i);
        alphas{i,2} = lyzer.loglogfit.alpha(i);
        As{i,1} = ids(i);
        As{i,2} = lyzer.lfit.a(i);
        UnitAs{i,1} = ids(i);
        UnitAs{i,2} = lyzer.lfit.a(i)*(pxsize*pxsize/(timestep*timestep));
        Ds{i,1} = ids(i);
        Ds{i,2} = lyzer.lfit.a(i)*1/(2*dimf);
        UnitDs{i,1} = ids(i);
        UnitDs{i,2} = lyzer.lfit.a(i)*1/(2*dimf)*(pxsize*pxsize/(timestep));
        linR{i,1} = ids(i);
        linR{i,2} = lyzer.lfit.r2fit(i);
        logR{i,1} = ids(i);
        logR{i,2} = lyzer.loglogfit.r2fit(i);
    end
    %% Save the generated data
    %For the pixel unit
    PixeldestinationStruc.InternMSD.TrackIDs = calculatedMSDIDs;
    
    if dimension == 2
        PixeldestinationStruc.InternMSD.XY.MSDclass = lyzer;
        PixeldestinationStruc.InternMSD.XY.Alpha = alphas;
        PixeldestinationStruc.InternMSD.XY.a = As;
        PixeldestinationStruc.InternMSD.XY.d = Ds;
        PixeldestinationStruc.InternMSD.XY.logR = logR; 
        PixeldestinationStruc.InternMSD.XY.linR = linR; 
    elseif dimension == 3
        PixeldestinationStruc.InternMSD.XYZ.MSDclass = lyzer;
        PixeldestinationStruc.InternMSD.XYZ.Alpha = alphas;
        PixeldestinationStruc.InternMSD.XYZ.a = As;
        PixeldestinationStruc.InternMSD.XYZ.d = Ds; 
        PixeldestinationStruc.InternMSD.XYZ.logR = logR; 
        PixeldestinationStruc.InternMSD.XYZ.linR = linR; 
    end

    %for the unit unit
    UnitdestinationStruc.InternMSD.TrackIDs = calculatedMSDIDs;
    
    if dimension == 2
        UnitdestinationStruc.InternMSD.XY.MSDclass = lyzer;
        UnitdestinationStruc.InternMSD.XY.Alpha = alphas;
        UnitdestinationStruc.InternMSD.XY.a = UnitAs;
        UnitdestinationStruc.InternMSD.XY.d = UnitDs;
        UnitdestinationStruc.InternMSD.XY.logR = logR; 
        UnitdestinationStruc.InternMSD.XY.linR = linR; 
    elseif dimension == 3
        UnitdestinationStruc.InternMSD.XYZ.MSDclass = lyzer;
        UnitdestinationStruc.InternMSD.XYZ.Alpha = alphas;
        UnitdestinationStruc.InternMSD.XYZ.a = UnitAs;
        UnitdestinationStruc.InternMSD.XYZ.d = UnitDs; 
        UnitdestinationStruc.InternMSD.XYZ.logR = logR; 
        UnitdestinationStruc.InternMSD.XYZ.linR = linR; 
    end
end