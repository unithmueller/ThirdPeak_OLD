function FilteredData = performPreprocessingDriftCorrectionWithBead(BeadData, FilteredData)
    %Corrects for drift of a bead and then uses this to correct for the cell. Then return the data.
    %Input: Data in form of a struct with localisation and filepath
    %respectively.
    %Output: Drift Corrected data set as well as the information of the
    %drift
    
    %% Estimate the drift properties
    %find a good estimate for the number of time bins based on the data density
    %get the amount of points and the maximal frame
    inputDataProperties = zeros(size(BeadData,1),2);
    for i = 1:size(BeadData,1)
        tmpdat = BeadData{i,1};
        inputDataProperties(i,1) = size(tmpdat,1);
        inputDataProperties(i,2) = max(tmpdat(:,2));
    end
    %normalize the values by framenumber, get basically mean locs/frame
    inputDataProperties(:,3) = inputDataProperties(:,1)./inputDataProperties(:,2);
    
    %minimal number of locs per bin
    minLocNum = 100;
    %number of frames necessary to reach that number
    inputDataProperties(:,4) = minLocNum/inputDataProperties(:,3);
    %given by the maximum frame number the number of bins
    inputDataProperties(:,5) = floor(inputDataProperties(:,2)./inputDataProperties(:,4));
    %at least one window should be considered
    inputDataProperties(inputDataProperties(:,5) == 0,5) = 1;
    
    %% Perform drift correction of the beads
    %generate default options
    driftspecs = drift_default_meanshift();
    driftInfos = {};
 
    %repack the data and correct for drift
    for i = 1:size(BeadData,1)
        %for every file
        newdata = [];
        tmpdata = [];
        %repack in fitting format
        %needs to be in format x y z frame
        tmpdata = BeadData{i,1};
        tmpdata = sortrows(tmpdata,2);
        newdata(:,1) = tmpdata(:,3);
        newdata(:,2) = tmpdata(:,4);
        newdata(:,3) = tmpdata(:,5);
        newdata(:,4) = tmpdata(:,2);
        
        driftspecs.nTimeBin = inputDataProperties(i,5);

        %run analysis
        [~, drift_info] = compute_drift_3D(newdata, driftspecs);
        driftInfos{i,1} = drift_info;
    end
    %% Apply drift onto cell data
    %for every cell/bead pair
    for i = 1:size(BeadData,1)
        %grab the drift infos
        allinfo = driftInfos{i,1};
        xinterp = allinfo.drift_info.xinterp;
        yinterp = allinfo.drift_info.yinterp;
        zinterp = allinfo.drift_info.zinterp;
        data = FilteredData{i,1};
        shifteddata = zeros(size(data));
        %correct for every frame with the respective shift
        for j = 1:size(FilteredData{i,1},1)
            idx = find(data(:,2) == j);
            shifteddata(idx,2) = data(idx,2);
            shifteddata(idx,3) = data(idx,3)-xinterp(i);
            shifteddata(idx,4) = data(idx,4)-yinterp(i);
            shifteddata(idx,5) = data(idx,5)-zinterp(i);
        end
        %add the rest of the data
        shifteddata(:,6) = data(:,6);
        shifteddata(:,7) = data(:,7);
        shifteddata(:,8) = data(:,8);
        shifteddata(:,9) = data(:,9);
        shifteddata(:,10) = data(:,10);
        
        FilteredData{i,1} = shifteddata;
    end
    %% Return the data

end