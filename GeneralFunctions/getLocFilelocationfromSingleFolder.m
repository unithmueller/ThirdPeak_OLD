function FileLocations = getLocFilelocationfromSingleFolder(ImportSettingsStruct)
%Gets the paths for a certain file type from a single folder file list
    if isa(ImportSettingsStruct, "struct")
        %Check that settings has been set
        %get the type of import
        imptype = ImportSettingsStruct.type;
        switch imptype
            case "Custom Localisations mat"
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
                files = f.';
                fullfilenames = cellfun(@(x) join([p,x]), files, 'UniformOutput', false);
                FileLocations = fullfilenames;

           case "Custom Localisations csv"
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
                files = f.';
                fullfilenames = cellfun(@(x) join([p,x]), files, 'UniformOutput', false);
                FileLocations = fullfilenames;
                
          case "SMAP-Localisations"
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
                files = f.';
                fullfilenames = cellfun(@(x) join([p,x]), files, 'UniformOutput', false);
                FileLocations = fullfilenames;
                
          case "Picasso-Localisations"
             % Display uigetfile dialog
            filterspec = {'*.hdf5'};
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
            files = f.';
            fullfilenames = cellfun(@(x) join([p,x]), files, 'UniformOutput', false);
            FileLocations = fullfilenames;
        end
    end
end