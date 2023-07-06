function FilteredData = performPreprocessingDriftCorrectionwoBead(FilteredData)
    %Corrects for drift and then return the data.
    %Input: Data in form of a struct with localisation and filepath
    %respectively.
    %Output: Drift Corrected data set as well as the information of the
    %drift
    
    %% Estimate the drift properties
    %find a good estimate for the number of time bins based on the data density
    %get the amount of points and the maximal frame
    inputDataProperties = zeros(size(FilteredData,1),2);
    for i = 1:size(FilteredData,1)
        tmpdat = FilteredData{i,1};
        inputDataProperties(i,1) = size(tmpdat,1);
        inputDataProperties(i,2) = max(tmpdat(:,2));
    end
    %normalize the values by framenumber, get basically mean locs/frame
    inputDataProperties(:,3) = inputDataProperties(:,1)./inputDataProperties(:,2);
    
    %minimal number of locs per bin
    minLocNum = 100;
    %number of frames necessary to reach that number
    inputDataProperties(:,4) = minLocNum./inputDataProperties(:,3);
    %given by the maximum frame number the number of bins
    inputDataProperties(:,5) = floor(inputDataProperties(:,2)./inputDataProperties(:,4));
    %at least one window should be considered
    inputDataProperties(inputDataProperties(:,5) == 0,5) = 1;
    
    %% Perform drift correction
    %generate default options
    driftspecs = drift_default_meanshift();
 
    %repack the data and correct for drift
    for i = 1:size(FilteredData,1)
        %for every file
        newdata = [];
        tmpdata = [];
        %repack in fitting format
        %needs to be in format x y z frame
        tmpdata = FilteredData{i,1};
        tmpdata = sortrows(tmpdata,2);
        newdata(:,1) = tmpdata(:,3);
        newdata(:,2) = tmpdata(:,4);
        newdata(:,3) = tmpdata(:,5);
        newdata(:,4) = tmpdata(:,2);
        
        driftspecs.nTimeBin = inputDataProperties(i,5);

        %run analysis
        [shifteddata, drift_info] = compute_drift_3D(newdata, driftspecs);
        %bring data back in the usual format
        tmpdata(:,3) = shifteddata(:,1);
        tmpdata(:,4) = shifteddata(:,2);
        tmpdata(:,5) = shifteddata(:,3);
        tmpdata = sortrows(tmpdata,1);
        
        %return data
        FilteredData{i,1} = tmpdata;
    end
end