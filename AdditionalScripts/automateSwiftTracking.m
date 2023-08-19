function automateSwiftTracking(ProcessingDataPath, precisionxy, precisionZ, diffractionLimit, ExpNoise, expDispla, pBleach, timeStep, timeUnit, lengthUnit, ChangeMin, IterMax)
%Recursively call the swift tracking on the system to generate the correct
%tracked files
%
    %% Check the csv files used for swift
    %Get the file paths
    locFileFolderPath = join([ProcessingDataPath "/csv"],"");
    cd(locFileFolderPath);
    csvFiles = dir("**/*.csv");
    
    % find small files
    fileSizes = cellfun(@(x) x, {csvFiles.bytes});
    fileSizes = fileSizes.';
    fileNames = cellfun(@(x) x, {csvFiles.name}, 'UniformOutput', false);
    fileNames = string(fileNames.');
    smallFilesIdx = (fileSizes(:,1) < 1028);
    
    %delete the file
    for i = 1:size(smallFilesIdx,1)
        if smallFilesIdx(i)
            delete (fileNames(i))
        end
    end

    %% Create a save location
    cd(ProcessingDataPath);
    mkdir("Tracking");

    %% Prepare the settings file
    %Grab the copy
    functionName = 'automateSwiftTracking.m';
    settingFilePath = which(functionName);
    settingFilePath = settingFilePath(1:end-(size(functionName,2)));
    settingFilePath = join([settingFilePath "parametersSwift.json"],"");
    
    %Read the file
    fid = fopen(settingFilePath);
    raw = fread(fid, inf);
    fclose(fid);
    fileContent = jsondecode(char(raw'));
    
    %Adjust the values from the given Estimates and the values already
    %calculated
    fileContent.precision = precisionxy;
    fileContent.precision_z = precisionZ;
    fileContent.diffraction_limit = diffractionLimit;
    fileContent.diffraction_limit_z = diffractionLimit;
    fileContent.exp_noise_rate = ExpNoise;
    fileContent.exp_displacement = expDispla;
    fileContent.p_bleach = pBleach;
    
    %Encode and save
    newJSON = jsonencode(fileContent);
    newJSON = double(newJSON.');
    fid = fopen('parametersSwift.json', 'w');
    fprintf(fid, '%s', newJSON);
    fclose(fid);

    %% Generate the external swift function
    swiftCommand = ["swft " locFileFolderPath "\*.csv" " -c " ProcessingDataPath "\parametersSwift.json" " --out_format ""auto"" --unit """ lengthUnit """ --tau """ string(timeStep) """ --out_values ""all all_analyses"""];
    completeCommand = join(swiftCommand, "");
    
    %% Call the command line
    status = system(completeCommand);
    
    %% Make a new save location
    count = 1;
    newFolderName = join(["Iteration_" count "_ExpDisplacement_" expDispla],"");
    cd Tracking;
    mkdir(newFolderName);
    cd(newFolderName);
    FolderPathToSave = pwd;
    
    %% Move the new files
    cd(locFileFolderPath);
    movefile('*tracked*', FolderPathToSave);
    
    %% Load the new files
    cd(FolderPathToSave);
    TrackedcsvFiles = dir("**/*.csv");
    fileNames = cellfun(@(x) x, {TrackedcsvFiles.name}, 'UniformOutput', false);
    TrackedfileNames = string(fileNames.');
    
    p = pwd;
    f = cellstr(TrackedfileNames);
    
    loadfile = cell(size(f,1),2);
    
    for i = 1:size(f,1)
        loadfile{i,1} = ImportSwiftAsTrc(fullfile(p,f{i,1}),1);
        loadfile{i,2} = f{i,1};
    end
    %make sure that traces are actually loaded
    if size(loadfile{1,1},2) < 5
        error("Not a trace file!")
    else
        TrackData = loadfile;
    end
    
    %% Running the tracking until the conditions are met
    count = 2;
    change = 1;
    while (count <= IterMax) && (change > ChangeMin)
        [change, TrackData] = iterativeTracking(TrackData, ProcessingDataPath, precisionxy, precisionZ, diffractionLimit, ExpNoise, expDispla, timeStep, timeUnit, lengthUnit, ChangeMin, count, locFileFolderPath);
        count = count+1;
    end
    
    %% Return the data

end

function [displacementChange, TrackData] = iterativeTracking(TrackData, ProcessingDataPath, precisionxy, precisionZ, diffractionLimit, ExpNoise, OLDexpDispla, timeStep, timeUnit, lengthUnit, ChangeMin, Count, locFileFolderPath)
    %% Estimate the new properties
    if size(TrackData, 1) > 1 %multiple
        TrackData = catTrackDataRename(TrackData);
    else
        %only one
       TrackData = TrackData{1,1};
    end          
    newDisplacement = calculateExpDisplacement(TrackData);
    newBleach = calculatePBleach(TrackData, timeStep, timeUnit, 0);
    
    %% Calculate the change
    %Displacement
    displacementDifference = abs(str2double(newDisplacement)-OLDexpDispla);
    displacementChangePerc = displacementDifference/OLDexpDispla;
    displacementChange = displacementChangePerc;
    
    if displacementChangePerc < ChangeMin
        return
    end
    
    %new tracking process
    %% Prepare the settings file
    %Grab the copy
    functionName = 'automateSwiftTracking.m';
    settingFilePath = which(functionName);
    settingFilePath = settingFilePath(1:end-(size(functionName,2)));
    settingFilePath = join([settingFilePath "parametersSwift.json"],"");
    
    %Read the file
    fid = fopen(settingFilePath);
    raw = fread(fid, inf);
    fclose(fid);
    fileContent = jsondecode(char(raw'));
    
    %Adjust the values from the given Estimates and the values already
    %calculated
    fileContent.precision = precisionxy;
    fileContent.precision_z = precisionZ;
    fileContent.diffraction_limit = diffractionLimit;
    fileContent.diffraction_limit_z = diffractionLimit;
    fileContent.exp_noise_rate = ExpNoise;
    fileContent.exp_displacement = str2double(newDisplacement);
    fileContent.p_bleach = str2double(newBleach);
    
    %Encode and save
    cd(ProcessingDataPath);
    newJSON = jsonencode(fileContent);
    newJSON = double(newJSON.');
    fid = fopen('parametersSwift.json', 'w');
    fprintf(fid, '%s', newJSON);
    fclose(fid);
    
    %% Generate the external swift function
    swiftCommand = ["swft " locFileFolderPath "\*.csv" " -c " ProcessingDataPath "\parametersSwift.json" " --out_format ""auto"" --unit """ lengthUnit """ --tau """ string(timeStep) """ --out_values ""all all_analyses"""];
    completeCommand = join(swiftCommand, "");
    
    %% Call the command line
    status = system(completeCommand);
    
    %% Make a new save location
    folderNameNewDisp = round(str2double(newDisplacement));
    newFolderName = join(["Iteration_" Count "_ExpDisplacement_" folderNameNewDisp],"");
    cd Tracking;
    mkdir(newFolderName);
    cd(newFolderName);
    FolderPathToSave = pwd;
    
    %% Move the new files
    cd(locFileFolderPath);
    movefile('*tracked*', FolderPathToSave);
    
    %% Load the new files
    cd(FolderPathToSave);
    TrackedcsvFiles = dir("**/*.csv");
    fileNames = cellfun(@(x) x, {TrackedcsvFiles.name}, 'UniformOutput', false);
    TrackedfileNames = string(fileNames.');
    
    p = pwd;
    f = cellstr(TrackedfileNames);
    
    loadfile = cell(size(f,1),2);
    
    for i = 1:size(f,1)
        loadfile{i,1} = ImportSwiftAsTrc(fullfile(p,f{i,1}),1);
        loadfile{i,2} = f{i,1};
    end
    %make sure that traces are actually loaded
    if size(loadfile{1,1},2) < 5
        error("Not a trace file!")
    else
        TrackData = loadfile;
    end

end