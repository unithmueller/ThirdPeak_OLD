function Trackhandles = manageTrackOverlayVisualisation(Axes, Tracks, is3D, isTracks, isAlltracks, scalexy, scalez, timepoint, lengthUnit, spotSize) 
    %Function to control the plotting of tracks in the visualisation window
    %Input: Axes - To plot the track data into
            %Tracks - track data from a localisation software
            %is3d - flag if we plot in 2d or 3d
            %isTracks - flag if we want connected tracks or spots
            %isAlltracks - if we want to show the current tracks for the
            %current frame or all tracks at once
            %scalexy - scaleling value for the tracks to match the microscopy
            %image
            %scalez - scaleling value in z
    %Output: -

    %% Prepare the axes
    %Clear the axes
    cla(Axes);
    hold(Axes, "on");
    %% Decide if spots or tracks
    if isTracks
        %tracks
        plotTracksOrSpotsOverlay(Axes, Tracks, is3D, isTracks, isAlltracks, scalexy, scalez, timepoint, spotSize);
        %add the ids to the traces
        Trackhandles = Axes.Children;
        idxs = zeros(size(Trackhandles,1),1);
        for i = 1:size(Trackhandles,1)
            idxs(i) = isa(Trackhandles(i), "matlab.graphics.chart.primitive.Line");
        end
        idxs = logical(idxs);
        Trackhandles = Trackhandles(idxs);

        for i = 1:numel(Trackhandles)
            % Add a new row to DataTip showing the DisplayName of the line
            Trackhandles(i).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Track',repmat({Trackhandles(i).DisplayName},size(Trackhandles(i).XData))); 
        end
    else
        %spots
        plotTracksOrSpotsOverlay(Axes, Tracks, is3D, isTracks, isAlltracks, scalexy, scalez, timepoint, spotSize); %spots
    end
    %% Add units and description to the figure
    Axes.XLabel.String = sprintf("X [%s]", lengthUnit);
    Axes.YLabel.String = sprintf("Y [%s]", lengthUnit);
    Axes.ZLabel.String = sprintf("Z [%s]", lengthUnit);
    Axes.Title.String = "";
    hold(Axes,"off");
end