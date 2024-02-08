function LocalisationData = loadLocswithFileList(ImportSettingsStruct, fileList)
    %Function that decides which localisation data will be loaded. Depends on the
    %Import Settings dialoge which file is able to be selected
    %Works with a file list that has been given before to allow for batch
    %processing

    %Check that settings has been set
    if isa(ImportSettingsStruct, "struct")
        %get the type of import
        imptype = ImportSettingsStruct.type;
        switch imptype
            case "Custom Localisations mat"
                loadfile = fileList;
                locdata = cell(size(loadfile,1),2);
                for i = 1:size(loadfile,1)
                    locdata{i,1} = loadCustomMat(loadfile{i}, ImportSettingsStruct);
                    locdata{i,2} = loadfile{i};
                end
                %make sure that locs are actually loaded
                if size(locdata{1,1},2) < 5
                    error("Not a loc file!")
                else
                    LocalisationData = locdata;
                end
           case "Custom Localisations csv"
                 % Display uigetfile dialog
                loadfile = fileList;
                locdata = cell(size(loadfile,1),2);
                for i = 1:size(loadfile,1)
                    locdata{i,1} = loadCustomCSV(loadfile{i}, ImportSettingsStruct);
                    locdata{i,2} = loadfile{i};
                end
                %make sure that locs are actually loaded
                if size(locdata{1,1},2) < 5
                    error("Not a loc file!")
                else
                    try
                        %check for decode files
                        tmpTestdata = locdata{1,1};
                        minx = min(tmpTestdata(:,3));
                        maxz = max(tmpTestdata(:,5));
                        divTestX = minx/ImportSettingsStruct.customUnits.Pixelsize;
                        divTestZ = maxz/ImportSettingsStruct.customUnits.Pixelsize;

                        if ((divTestX < 1) && (divTestX > 0)) && (divTestZ > 1)
                            LocalisationData = adjustDecodeFiles(locdata, ImportSettingsStruct.customUnits.Pixelsize);
                        end
                    catch
                        LocalisationData = locdata;
                    end
                end
        case "SMAP-Localisations"
                loadfile = fileList;
                locdata = cell(size(loadfile,1),2);
                for i = 1:size(loadfile,1)
                    locdata{i,1} = loadSMAPLocalisations(loadfile{i});
                    locdata{i,2} = loadfile{i};
                end
                %make sure that locs are actually loaded
                if size(locdata{1,1},2) < 5
                    error("Not a loc file!")
                else
                    LocalisationData = locdata;
                end
        case "Picasso-Localisations"
                loadfile = fileList;
                locdata = cell(size(loadfile,1),2);
                for i = 1:size(loadfile,1)
                    locdata{i,1} = importPicassohdf5(loadfile{i}, ImportSettingsStruct.customUnits.Pixelsize);
                    locdata{i,2} = loadfile{i};
                end
                %make sure that locs are actually loaded
                if size(locdata{1,1},2) < 5
                    error("Not a loc file!")
                else
                    LocalisationData = locdata;
                end
        end
    end
end