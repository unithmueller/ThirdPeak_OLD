function switchUnits(app)
            %if switch from px/frame to unit/unit 
            %convert data
            setDataToAnalyze(app);
            if app.Switch.Value == "Pixel/Frame"
                %nothing as managing is done in data setting
            else
                %convert data to units. %data is in px/frame
                %time = app.DataToAnalyze(:,2);
                %time = time*app.VisualisationWindow.ImportSettingsStruct.customUnits.Timestep;
                %app.DataToAnalyze(:,2) = time;
                xyzdata = app.DataToAnalyze(:,3:5);
                xyzdata = xyzdata*app.VisualisationWindow.ImportSettingsStruct.customUnits.Pixelsize;
                app.DataToAnalyze(:,3:5) = xyzdata;
            end
            %clear calculations
            app.CalculatedDataStruct = app.setSaveStruct();
            app.FilterCalculatedDataStruct = app.setSaveStruct();
            %plot anew current window
            managePlots(app);
        end