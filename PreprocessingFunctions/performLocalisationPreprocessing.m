function driftCorrLocs = performLocalisationPreprocessing(SaveFolderPath, SaveFolderName, ImportSettingsStruct, FileLocations, BeadLocations, options)
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
    %% grab file list and load files depending on settings
    LocalisationData = loadLocswithFileList(ImportSettingsStruct, FileLocations);
    %make sure there are no negative values for XY
    for i = 1:size(LocalisationData,1)
        tmpdata = LocalisationData{i,1};
        xdat = tmpdata(:,2);
        ydat = tmpdata(:,3);
        xdat(xdat<0) = 0;
        ydat(ydat<0) = 0;
        tmpdata(:,2:3) = [xdat,ydat];
        LocalisationData{i,1} = tmpdata;
    end
    clear xdat ydat tmpdata;
    %% set variables for saving
    maskedLocs = {};
    precisionLocs = {};
    intensityLocs = {};
    %% perform filter in XYZ with either polymask or abs values
    %polymask
    if options.XYZ.XY.UseManualPolymask
        %perform cellmask
        %make folder to save the mask
        mkdir Cellmask;
        cd Cellmask;
        for i = 1:size(LocalisationData,1)
            tmpdata = LocalisationData{i,1};
            maxX = max(tmpdata(:,2));
            maxY = max(tmpdata(:,3));
            maxXY = max([maxX, maxY]);
            tmpmaskdat = CellMaskV2(tmpdata, [round(maxXY*1.1) round(maxXY*1.1)], pwd, i);
            for j = 1:size(tmpmaskdat,2)
                maskedLocs{end+1,1} = tmpmaskdat{1,j};
                maskedLocs{end,2} = LocalisationData{i,2};
            end
        end
        cd ..;
        %absoltue values
    elseif options.XYZ.XY.X.Used || options.XYZ.XY.Y.Used
        %use the filter in XY
        for i = 1:size(LocalisationData,1)
            tmpdata = LocalisationData{i,1};
            if options.FilterActiveX
                %filter by X value
                usrminx = options.XYZ.XY.X.Min;
                usrmaxx = options.XYZ.XY.X.Max;
                tmpdata = tmpdata(tmpdata(:,2)>= usrminx & tmpdata(:,2)<= usrmaxx,:);
            end
            if options.FilterActiveY
                %filter by Y value
                usrminy = options.XYZ.XY.Y.Min;
                usrmaxy = options.XYZ.XY.Y.Max;
                tmpdata = tmpdata(tmpdata(:,3)>= usrminy & tmpdata(:,3)<= usrmaxy,:);
            end
            maskedLocs{i,1} = tmpdata;
            maskedLocs{i,2} = LocalisationData{i,2};
        end
    else
        %neither XY or polymask
        maskedLocs = LocalisationData;
    end
    %then do the Z
    if options.XYZ.Z.Used
        for i = 1:size(maskedLocs,1)
            tmpdata = maskedLocs{i,1};
            usrminz = options.XYZ.Z.Min;
            usrmaxz = options.XYZ.Z.Max;
            tmpdata = tmpdata(tmpdata(:,4)>= usrminz & tmpdata(:,4)<= usrmaxz,:);
            maskedLocs{i,1} = tmpdata;
        end
    end
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
    datatosave = LocalisationData;
    save("SMAP_Localisations.mat","datatosave");
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
    SavePeaksAsSwift(pwd, intensityLocs, size(intensityLocs,1), 1);
end