function trackdata = getTrackAnalysisData(app)
            %gets the data for the all track analysis
            switch app.Switch_4.Value
                case "Current File"
                    flagdata = 0;
                case "All Files"
                    flagdata = 1;
            end
            flagbox = app.UseROIforAnalysisCheckBox.Value;
            trackdata = {};
            if flagdata
                %All Files
                trackdata = app.TrackData;
            else
                %currentfile
                trackdata{1,2} = app.TrackFileDropDown.Value;
                trackdata{1,1} = app.CurrentTrackFileData(:,:);
            end
            if flagbox
                %only roi data
                roinames = app.ROIListDropDown.Items;
                trackdata = {};
                %data1, names2
                for i = 1:size(roinames,2)
                    trackdata{i,1} = app.ROIList{i,3};
                    trackdata{i,2} = roinames{1,i};
                end
            end
        end