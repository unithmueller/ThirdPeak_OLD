function tracks = loadCustomCSVfun(app, file)
    del = app.ImportSettingsStruct.separator;
    skip = 1 + app.ImportSettingsStruct.headlerlines;
    file = dlmread(file, del, skip);
    
    type = app.ImportSettingsStruct.type;
    

    if type == "Custom Localisations csv"
    %newfile(:,1) = [];
    newfile(:,2) = file(:,app.ImportSettingsStruct.framenr); %t
    newfile(:,3) = file(:,app.ImportSettingsStruct.xpos); %x
    newfile(:,4) = file(:,app.ImportSettingsStruct.ypos); %y
    newfile(:,5) = file(:,app.ImportSettingsStruct.zpos); %z
    tracks = newfile;
        return
    else
    newfile(:,1) = file(:,app.ImportSettingsStruct.trackid); %id
    newfile(:,2) = file(:,app.ImportSettingsStruct.framenr); %t
    newfile(:,3) = file(:,app.ImportSettingsStruct.xpos); %x
    newfile(:,4) = file(:,app.ImportSettingsStruct.ypos); %y
    newfile(:,5) = file(:,app.ImportSettingsStruct.zpos); %z
    try
        newfile(:,6) = file(:,6); %jumpdist
        newfile(:,7) = file(:,app.ImportSettingsStruct.d); %segmentD
        newfile(:,8) = file(:,app.ImportSettingsStruct.derr); %segmentDerr
        newfile(:,9) = file(:,14); %segmentDR
        newfile(:,10) = file(:,15); %segmentmeanjumpdist
        newfile(:,11) = file(:,16); %segmeanjumpdisterr
        newfile(:,12) = file(:,app.ImportSettingsStruct.msd); %segment-MSD
        newfile(:,13) = file(:,app.ImportSettingsStruct.msderr); %segment_MSDERR
        newfile(:,14) = file(:,app.ImportSettingsStruct.difftype); %motiontype
        newfile(:,15) = file(:,22); %segmentSTart
        newfile(:,16) = file(:,23); %segmentLifetime
        newfile(:,17) = file(:,26); %numberofsegmentintrack 
    end

    tracks = newfile;
    end
end