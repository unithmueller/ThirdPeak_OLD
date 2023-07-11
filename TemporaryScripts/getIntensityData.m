function intensityData = getIntensityData(app)
            %returns the intensity data of a given track to be used for
            %analysis
            switch app.Switch_4.Value
                case "Current File"
                    flagdata = 0;
                case "All Files"
                    flagdata = 1;
            end
            flagbox = app.UseROIforAnalysisCheckBox.Value;
            intensityData = {};
            
            if flagdata
                %All Files
                for i = 1:size(app.TrackData,1)
                    intensityData{i,1} = app.TrackData{i,2};
                    data = app.TrackData{i,1};
                    intensityData{i,2} = data(:,18);
                end
            else
                %Current File
                intensityData{1,1} = app.TrackFileDropDown.Value;
                intensityData{1,2} = app.CurrentTrackFileData(:,18);
                
            end
            if flagbox
                %only roi data
                roinames = app.ROIListDropDown.Items;
                intensityData = {};
                %data1, names2
                for i = 1:size(roinames,2)
                    intensityData{i,1} = app.ROIList{i,3}(:,18);
                    intensityData{i,2} = roinames{1,i};
                end
            end
        end