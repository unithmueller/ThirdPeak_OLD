function TrackData = loadTrackDataFileSelection(app, minTrackLength, type)
%Button to select the trace data matching the microscopy data.
            %Depends on the Import Settings dialoge which file is able to
            %be selected
            tracklength = minTrackLength;
            if isa(app.ImportSettingsStruct, "struct")
                %Check that settings has been set
                %get the type of import
                imptype = app.ImportSettingsStruct.type;
                switch imptype
                    case "Swift-AllData CSV"
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
                    case "Swift-MinData CSV" %Need to che4ck what the output is from this mode
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
                            loadfile{i,1} = loadCustomCSV(app, fullfile(p,f{1,i}), "Tracks");
                            loadfile{i,2} = f{1,i};
                        end
    
                        %make sure that traces are actually loaded
                        if size(loadfile{1,1},2) < 5
                            error("Not a trace file!")
                        else
                            TrackData = loadfile;
                        end
                    case "Custom .mat"
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
                            loadfile{i,1} = loadCustomMat(app, fullfile(p,f{1,i}));
                            loadfile{i,2} = f{1,i};
                        end
    
                        %make sure that traces are actually loaded
                        if size(loadfile{1,1},2) < 5
                            error("Not a trace file!")
                        else
                            TrackData = loadfile;
                        end
                end
                
                if isa(TrackData,"cell")
                    %multiple files selected. For every File:
                    for i = 1:size(TrackData,1)
                        filteredTracks = filterTracksinCellbyLength(TrackData{i,1}, tracklength);
                        TrackData{i,1} = filteredTracks;
                    end
                else
                    error("Something went wrong")
                end
            end           
end
