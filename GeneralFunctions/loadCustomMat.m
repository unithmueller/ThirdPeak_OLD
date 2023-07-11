function tracks = loadCustomMat(file, ImportSettingsStruct)
%Function to allow for custom .mat localisation files. Data columns need to
%be given by the user in the import settings window.

    file = load(file);
    name = fieldnames(file);
    name = name{1,1};
    file = getfield(file,name);
    type = ImportSettingsStruct.islocs;
    
    if type
    %newfile(:,1) = [];
    newfile(:,2) = file(:,ImportSettingsStruct.framenr); %t
    newfile(:,3) = file(:,ImportSettingsStruct.xpos); %x
    newfile(:,4) = file(:,ImportSettingsStruct.ypos); %y
    newfile(:,5) = file(:,ImportSettingsStruct.zpos); %z
    try
        newfile(:,6) = file(:,ImportSettingsStruct.xyerr); %xyerr
    catch
    end
    try
        newfile(:,7) = file(:,ImportSettingsStruct.zerr); %zerr
    catch
    end
    try
        newfile(:,8) = file(:,ImportSettingsStruct.int); %photons
    catch
    end
    try
        newfile(:,9) = file(:,ImportSettingsStruct.interr); %photon error
    catch
    end
    tracks = newfile;
        return
    else
    newfile(:,1) = file(:,ImportSettingsStruct.trackid); %id
    newfile(:,2) = file(:,ImportSettingsStruct.framenr); %t
    newfile(:,3) = file(:,ImportSettingsStruct.xpos); %x
    newfile(:,4) = file(:,ImportSettingsStruct.ypos); %y
    newfile(:,5) = file(:,ImportSettingsStruct.zpos); %z
    %optional data, try to grab it. definetly not the most beautiful way of
    %implementing this....
    try
        newfile(:,6) = file(:,6); %jumpdist
    catch
    end
    try
        newfile(:,7) = file(:,app.ImportSettingsStruct.d); %segmentD
    catch
    end
    try
        newfile(:,8) = file(:,app.ImportSettingsStruct.derr); %segmentDerr
    catch
    end
    try
        newfile(:,9) = file(:,14); %segmentDR
    catch
    end
    try
        newfile(:,10) = file(:,15); %segmentmeanjumpdist
    catch
    end
    try
        newfile(:,11) = file(:,16); %segmeanjumpdisterr
    catch
    end
    try
        newfile(:,12) = file(:,app.ImportSettingsStruct.msd); %segment-MSD
    catch
    end
    try
        newfile(:,13) = file(:,app.ImportSettingsStruct.msderr); %segment_MSDERR
    catch
    end
    try
        difftypedata = file(:,ImportSettingsStruct.difftype);
        diffstates = file(:,ImportSettingsStruct.diffstates);
        numbrOfStates = size(diffstates,2);
        for i = 1:numbrOfStates
            searchterm = diffstates(i);
            difftypedata(difftypedata == searchterm) = i;
        end
        newfile(:,14) = difftypedata; %motiontype
    catch
    end
    try
        newfile(:,15) = file(:,22); %segmentSTart
    catch
    end
    try
        newfile(:,16) = file(:,23); %segmentLifetime
    catch
    end
    try
        newfile(:,17) = file(:,26); %numberofsegmentintrack
    catch
    end
    %return the new tracks
    tracks = newfile;
    end
end