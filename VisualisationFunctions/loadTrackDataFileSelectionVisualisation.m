function TrackData = loadTrackDataFileSelectionVisualisation(ImportSettingsStruct)
    %Function to grab a file depending on the settings set in the import
    %settings. Will allow for tracks of filtered localisation to be
    %visualized in the validation window and used for further
    %calculations
    %Check that we have settings set
    %tracklength = minTrackLength;
    if isa(ImportSettingsStruct, "struct")
        %get the type of import
        imptype = ImportSettingsStruct.type;
        switch imptype
            case "Swift-AllData CSV"
                %% SwiftAllData
                % Display uigetfile dialog
                filterspec = {'*.csv'};
                [f, p] = uigetfile(filterspec, 'MultiSelect','on');
                % Make sure user didn't cancel uigetfile dialog
                if ~ischar(p)
                    error("No file selected")
                end
                if isa(f,"char") %only one file selected, convert to cell 
                    b = f;
                    f = cell(1,1);
                    f{1,1} = b;
                end
                loadfile = cell(size(f,2),2);
                for i = 1:size(f,2)
                    loadfile{i,1} = ImportSwiftAsTrc(fullfile(p,f{1,i}),1);
                    loadfile{i,2} = f{1,i};
                end
                %make sure that traces are actually loaded
                if size(loadfile{1,1},2) < 5
                    error("Not a trace file!")
                else
                    TrackData = loadfile;
                end
            case "Swift-MinData CSV" 
                %% SwiftMinData
                % Display uigetfile dialog
                filterspec = {'*.csv'};
                [f, p] = uigetfile(filterspec, 'MultiSelect','on');
                % Make sure user didn't cancel uigetfile dialog
                if ~ischar(p)
                    error("No file selected")
                end
                loadfile = cell(size(f,2),2);
                for i = 1:size(f,2)
                    loadfile(i,1) = ImportSwiftAsTrc(fullfile(p,f{1,i}),0);
                    loadfile(i,2) = f;
                end
                %make sure that traces are actually loaded
                if size(loadfile{1,1},2) < 5
                    error("Not a trace file!")
                else
                    TrackData = loadfile;
                end
            case "Custom CSV"
                %% Custom CSV
                % Display uigetfile dialog
                filterspec = {'*.csv'};
                [f, p] = uigetfile(filterspec, 'MultiSelect','on');
                % Make sure user didn't cancel uigetfile dialog
                if ~ischar(p)
                    error("No file selected")
                end
                if isa(f,"char") %only one file selected, convert to cell 
                    b = f;
                    f = cell(1,1);
                    f{1,1} = b;
                end
                loadfile = cell(size(f,2),2);
                for i = 1:size(f,2)
                    loadfile{i,1} = loadCustomCSV(fullfile(p,f{1,i}), ImportSettingsStruct);
                    loadfile{i,2} = f{1,i};
                end
                %make sure that traces are actually loaded
                if size(loadfile{1,1},2) < 5
                    error("Not a trace file!")
                else
                    TrackData = loadfile;
                end
            case "Custom .mat"
                %% Custom mat
                 % Display uigetfile dialog
                filterspec = {'*.mat'};
                [f, p] = uigetfile(filterspec, 'MultiSelect','on');
                % Make sure user didn't cancel uigetfile dialog
                if ~ischar(p)
                    error("No file selected")
                end
                if isa(f,"char") %only one file selected, convert to cell 
                    b = f;
                    f = cell(1,1);
                    f{1,1} = b;
                end
                loadfile = cell(size(f,2),2);
                for i = 1:size(f,2)
                    loadfile{i,1} = loadCustomMat(fullfile(p,f{1,i}), ImportSettingsStruct);
                    loadfile{i,2} = f{1,i};
                end
                %make sure that traces are actually loaded
                if size(loadfile{1,1},2) < 5
                    error("Not a trace file!")
                else
                    TrackData = loadfile;
                end
        end
        %% Filter the found data by minTrackLength of 2 to make sure that we have tracks
        if isa(TrackData,"cell")
            %multiple files selected. For every File:
            for i = 1:size(TrackData,1)
                filteredTracks = filterTracksinCellbyLength(TrackData{i,1}, 2);
                TrackData{i,1} = filteredTracks;
            end
        else
            error("Something went wrong")
        end
   end                  
end