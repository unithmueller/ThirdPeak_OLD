function performDriftCorrection(data)
    %get options
    driftspecs = drift_default_meanshift();
    
    %get data of all app.Trackdata are cells, data/name
    for i = 1:numel(data(:,1))
        %for every trackfile
        newdata = [];
        tmpdata = [];
        %repack in fitting format
        %needs to be in format x y z frame id
        tmpdata = data(i,1);
        tmpdata = cell2mat(tmpdata);
        tmpdata = sortrows(tmpdata,2);
        newdata(:,1) = tmpdata(:,3);
        newdata(:,2) = tmpdata(:,4);
        newdata(:,3) = tmpdata(:,5);
        newdata(:,4) = tmpdata(:,2);
        %newdata(5) = tmpdata(1);
        
        timebins = ceil(max(tmpdata(:,2))/100);
        if timebins < 5
            timebins = 5;
        end
        driftspecs.nTimeBin = timebins;
        driftspecs.calc_error = 0;

        %run analysis
        [shifteddata, drift_info] = compute_drift_3D(newdata, driftspecs);
        
        tmpdata(:,3) = shifteddata(:,1);
        tmpdata(:,4) = shifteddata(:,2);
        tmpdata(:,5) = shifteddata(:,3);
        tmpdata = sortrows(tmpdata,1);
        
        %return data
        %data(i,1) = [];
        data{i,1} = tmpdata;
    end
end