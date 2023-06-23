function frc = calculateFRC(app)
    data = getTracks(app);
    param = app.TrackSettingsStruct;
    
    %need to convert data always into unit/frame
    type = split(convertCharsToStrings(param.customUnits.DataType),"/");
    comparison = strcmp(type, ["Pixel"; "Frame"]);
    if comparison %pixel/frame
        %if pixel/frame, covert pixel to unit
        data(:,3:5) = data(:,3:5)*param.customUnits.Pixelsize;
    elseif comparison(1) & (~comparison(2))%Pixel/Unit
        %if pixel/unit, must convert unit to frame and pixel to
        %unit
        time = data(:,2);
        time = round(time/param.customUnits.Timestep,0);
        data(:,2) = time;
        data(:,3:5) = data(:,3:5)*param.customUnits.Pixelsize;
    elseif (~comparison(1)) & comparison(2)%Unit/Frame
        %if unit/frame, do nothing
    else
        %if unit/unit, must convert time to frame
        time = data(:,2);
        time = round(time/param.customUnits.Timestep,0);
        data(:,2) = time;
    end
    NmbrTimeWins = 2;
    TimeWinDur = ceil(max(data(:,2))/NmbrTimeWins);
    %we need the data in two data sets, applied randomly to all data. will
    %use the frame number to assign them randomly. need to alter the frame
    %number
    
    pixelsize = param.customUnits.Pixelsize;
        
    randValues = randi([1 max(data(:,2))],size(data(:,2),1),1);
    data(:,2) = randValues;
    %bins the data 
    trajensemb = TrajectoryEnsemble(data(:,1:5), param.customUnits.Timestep, 1);
    tws = TimeWindows.empty;
    if NmbrTimeWins == 1
        %single win
        tmptws = TimeWindows.generateSingleWindow(trajensemb);
        tws(end+1) = tmptws;
    else
        %many win
        begin = min(data(:,2));
        for i = 1:NmbrTimeWins
            ending = begin+TimeWinDur;
            tmpwin = TimeWindows(TimeWinDur, 0, begin, ending);
            begin = ending+1;
            tws(end+1) = tmpwin;
        end
    end
    trajensembwins = TrajectoryEnsembleWindows(trajensemb, tws);
    params = DensityParameters(pixelsize, "NPTS", 1, 1, pixelsize);
    scalmapwins = ScalarMapWindows.gen_density_maps(trajensembwins, params);

    localizations1 = cell2mat(scalmapwins.windows(1,1).data);
    localizations2 = cell2mat(scalmapwins.windows(1,2).data);

    voxelSize = pixelsize;
    imageSize = 120;
    cutoffFrequency = 1/7;

    % localizations1: Nx3 matrix representing the 3D coordinates of the first dataset
    % localizations2: Mx3 matrix representing the 3D coordinates of the second dataset
    % voxelSize: scalar value representing the voxel size in nanometers
    % imageSize: scalar value representing the size of the reconstructed image in voxels
    % cutoffFrequency: scalar value representing the cutoff frequency for FRC analysis
    
    % Convert the localization coordinates to image indices
    indices1 = round(localizations1 ./ voxelSize) + (imageSize / 2);
    indices2 = round(localizations2 ./ voxelSize) + (imageSize / 2);
    
    % Generate the 3D histogram for the two datasets
    histogram1 = accumarray(indices1, 1, [imageSize imageSize imageSize]);
    histogram2 = accumarray(indices2, 1, [imageSize imageSize imageSize]);
    
    % Calculate the Fourier transforms of the histograms
    fft1 = fftshift(fftn(histogram1));
    fft2 = fftshift(fftn(histogram2));
    
    % Calculate the cross-power spectrum
    crossPower = fft1 .* conj(fft2);
    
    % Calculate the auto-power spectra
    autoPower1 = abs(fft1).^2;
    autoPower2 = abs(fft2).^2;
    
    % Calculate the FRC curve
    frc = real(crossPower) ./ sqrt(autoPower1 .* autoPower2);
    
    % Calculate the corresponding spatial frequencies
    frequencies = linspace(0, 0.5, imageSize/2+1) / (voxelSize * imageSize);
    
    % Apply the cutoff frequency
    cutoffIndex = find(frequencies <= cutoffFrequency, 1, 'last');
    frc = frc(1:cutoffIndex);
    frequencies = frequencies(1:cutoffIndex);
    
    % Plot the FRC curve
    figure;
    plot(frequencies, frc);
    xlabel('Spatial Frequency (1/nm)');
    ylabel('FRC');
    title('Fourier Ring Correlation');
end