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
                locdata = {};
                for i = 1:size(loadfile,1)
                    locdata{i,1} = loadCustomMat(loadfile{i}, ImportSettingsStruct);
                    locdata{i,2} = loadfile{i};
                end
                %make sure that locs are actually loaded
                if size(locdata{1,1},2) < 5
                    error("Not a loc file!")
                else
                    LocalisationData = loadfile;
                end
           case "Custom Localisations csv"
                 % Display uigetfile dialog
                loadfile = fileList;
                locdata = {};
                for i = 1:size(loadfile,1)
                    locdata{i,1} = loadCustomCSV(loadfile{i}, ImportSettingsStruct);
                    locdata{i,2} = loadfile{i};
                end
                %make sure that locs are actually loaded
                if size(locdata{1,1},2) < 5
                    error("Not a loc file!")
                else
                    LocalisationData = loadfile;
                end
        case "SMAP-Localisations"
                loadfile = fileList;
                locdata = {};
                for i = 1:size(loadfile,1)
                    locdata{i,1} = loadSMAPLocalisations(loadfile{i});
                    locdata{i,2} = loadfile{i};
                end
                %make sure that locs are actually loaded
                if size(locdata{1,1},2) < 5
                    error("Not a loc file!")
                else
                    LocalisationData = loadfile;
                end
        end
    end
end