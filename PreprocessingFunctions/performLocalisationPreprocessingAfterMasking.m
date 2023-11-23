function driftCorrLocs = performLocalisationPreprocessingAfterMasking(SaveFolderPath, SaveFolderName, loadedMaskedLocs, BeadLocations, options)
    %Main function for the preprocessing of the localisation data.
   %Input: SaveFolderPath: Path on the Disk to save to
   %SaveFolderName: Name of the subfolder generated in the SaveFolderPath
   %to save to
   %ImportSettingsStruct: Contains information of the file types being used
   %FileLocations: List of paths to the files that will be processed
   %Options: Options from the GUI for filtering
   %Output: Filtered Localisations
    %% set save location and go there
    cd(SaveFolderPath);
    counter = 1;
    foldername = iterateSaveFoldername(SaveFolderName, counter);
    cd(foldername);
    %% set variables for saving
    maskedLocs = {};
    precisionLocs = {};
    intensityLocs = {};
    
    %% Load the data after masking
    maskedLocs = loadedMaskedLocs;
    %% filter by precisions
    %XY precision
    if options.precision.XY.Used
        for i = 1:size(maskedLocs,1)
            try
                tmpdata = maskedLocs{i,1};
                usrsigma = options.precision.XY.sigma;
                tmpdata = tmpdata(tmpdata(:,6)<= usrsigma & tmpdata(:,6)<= usrsigma,:);
                precisionLocs{i,1} = tmpdata;
                precisionLocs{i,2} = maskedLocs{i,2};
            catch
            end
        end
    else
        precisionLocs = maskedLocs;
    end
    %if something went wrong, remove the file
    try    
        for i = 1:size(precisionLocs,1)
                tmp = precisionLocs{i,1};
                if size(tmp,1)<5
                    precisionLocs(i,:) = [];
                end
        end
    catch
    end
    %Z precision
    if options.precision.Z.Used
        for i = 1:size(precisionLocs,1)
            try
            tmpdata = precisionLocs{i,1};
            usrsigma = options.precision.Z.sigma;
            tmpdata = tmpdata(tmpdata(:,7)<= usrsigma,:);
            precisionLocs{i,1} = tmpdata;
            precisionLocs{i,2} = precisionLocs{i,2};
            catch
            end
        end
    end
    %if something went wrong, remove the file
        try    
        for i = 1:size(precisionLocs,1)
                tmp = precisionLocs{i,1};
                if size(tmp,1)<5
                    precisionLocs(i,:) = [];
                end
        end
    catch
    end
    if ~options.precision.XY.Used && ~options.precision.Z.Used
        precisionLocs = maskedLocs;
    end
    %% filter by intensity
    if options.intensity.Used
        for i = 1:size(precisionLocs,1)
            try
            tmpdata = precisionLocs{i,1};
            usrminInt = options.intensity.Min;
            usrmaxInt = options.intensity.Max; 
            tmpdata = tmpdata(tmpdata(:,8)>= usrminInt & tmpdata(:,8)<= usrmaxInt,:);
            intensityLocs{i,1} = tmpdata;
            intensityLocs{i,2} = precisionLocs{i,2};
            catch
            end
        end
        try
            for i = 1:size(intensityLocs,1)
                tmp = intensityLocs{i,1};
                if size(tmp,1)<5
                    intensityLocs(i,:) = [];
                end
            end
        catch
        end
    else
        intensityLocs = precisionLocs;
    end
    %% perform the drift correction
    if options.drift.Performdrift == 1
        %do drift correction
        if options.drift.ReferenceAvailable == 1
            %calculate by drift of a bead
            driftCorrLocs = performPreprocessingDriftCorrectionWithBead(BeadLocations, intensityLocs);
        else
            %calculate by the data
            driftCorrLocs = performPreprocessingDriftCorrectionwoBead(intensityLocs);
        end
    else
        driftCorrLocs = intensityLocs;
    end
    %% save the data to disk
    clear tmpdata tmpmaskdat;
    %save the localisations in mat and for swift
    datatosave = maskedLocs;
    save("maskedLocalisations.mat","datatosave");
    datatosave = precisionLocs;
    save("precisionFilteredLocalisations.mat","datatosave");
    datatosave = intensityLocs;
    save("intensityFilteredLocalisations.mat","datatosave");
    datatosave = driftCorrLocs;
    save("driftCorrectedLocalisations.mat","datatosave");
    %save the filter settings
    setvalues = options;
    save("PropertiesUsed.mat","setvalues");
    %save for swift
    SavePeaksAsSwift(pwd, driftCorrLocs, size(intensityLocs,1), 1);
end