        function manageTrackOverlay(app)
            %controls how and if tracks or psots are shown depending on the
            %selection of the user
            %set the properties for the function
            switch app.Switch.Value
                case "3D"
                    flag3d = 1;
                case "2D"
                    flag3d = 0;
            end
            switch app.ShowTracksSwitch.Value
                case "On"
                    flagOn = 1;
                case "Off"
                    flagOn = 0;
            end
            switch app.Switch_6.Value
                case "All"
                    flagtrc = 1;
                case "Single Track"
                    flagtrc = 0;
            end
            %get scaling values
            scalexy = app.ScaleXYEditField.Value;
            scalez = app.ScaleZEditField.Value;
            scalexy = 1/scalexy;
            %clear the axes
            cla(app.UIAxes);
            %manageBackgroundImage(app);
            hold(app.UIAxes,"on");
            %plot the traces
            updateVisualisationTracesOverlay(app, flag3d, flagOn, flagtrc, scalexy, scalez, 1); %tracks
            %add the ids to the traces
            app.Trackhandles = app.UIAxes.Children;
            idxs = zeros(size(app.Trackhandles,1),1);
            for i = 1:size(app.Trackhandles,1)
                idxs(i) = isa(app.Trackhandles(i), "matlab.graphics.chart.primitive.Line");
            end
            idxs = logical(idxs);
            app.Trackhandles = app.Trackhandles(idxs);
            
            for i = 1:numel(app.Trackhandles)
                % Add a new row to DataTip showing the DisplayName of the line
                app.Trackhandles(i).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Track',repmat({app.Trackhandles(i).DisplayName},size(app.Trackhandles(i).XData))); 
            end
            if flagtrc == 0
                updateVisualisationTracesOverlay(app, flag3d, flagOn, flagtrc, scalexy, scalez, 0); %spots
            end
            %plot the background if necessary
            manageBackgroundImage(app);
            %add the units to the figure
            unitscale = app.ImportSettingsStruct.customUnits.LengthUnit;
            app.UIAxes.XLabel.String = sprintf("X [%s]", unitscale);
            app.UIAxes.YLabel.String = sprintf("Y [%s]", unitscale);
            app.UIAxes.ZLabel.String = sprintf("Z [%s]", unitscale);
            app.UIAxes.Title.String = "";
            hold(app.UIAxes,"off");
        end