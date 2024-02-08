function [finalvoxelsize,error] = calculateFSC(data, parameters)
    %Calculates the Fourier Shell Correlation from the track data.
    %Grabs the image dimensions from the import settings
    %dialogue to set the necessary parameters.
    param = parameters;
    finalvoxelsize = zeros(1,10);
    
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
    for j = 1:10
        fsc = 1;
        pixelsize = param.customUnits.Pixelsize;
        %using a cutoff value of 0.143
        while fsc > 0.143
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

            volume1 = cell2mat(scalmapwins.windows(1,1).data);
            volume2 = cell2mat(scalmapwins.windows(1,2).data);

            % Pad the volumes to a power of 2 for efficient FFT computation
            sizeX = size(volume1, 1);
            sizeY = size(volume1, 2);
            sizeZ = size(volume1, 3);
            paddedSizeX = 2^nextpow2(sizeX);
            paddedSizeY = 2^nextpow2(sizeY);
            paddedSizeZ = 2^nextpow2(sizeZ);

            % Fourier transform of the volumes
            ftVolume1 = fftn(volume1, [paddedSizeX, paddedSizeY, paddedSizeZ]);
            ftVolume2 = fftn(volume2, [paddedSizeX, paddedSizeY, paddedSizeZ]);

            % Compute the cross-correlation and auto-correlation terms
            crossCorrelation = ftVolume1 .* conj(ftVolume2);
            autoCorrelation1 = ftVolume1 .* conj(ftVolume1);
            autoCorrelation2 = ftVolume2 .* conj(ftVolume2);

            % Compute the FSC
            fsc = abs(sum(crossCorrelation(:))) ./ sqrt(sum(autoCorrelation1(:)) .* sum(autoCorrelation2(:)));
            pixelsize = ceil(pixelsize-(pixelsize*0.05));
        end
        finalvoxelsize(1,j) = pixelsize;
    end
    finalvoxelsize = mean(finalvoxelsize);
    error = std(finalvoxelsize);
end