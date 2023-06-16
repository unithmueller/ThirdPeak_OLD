function updateVisualisationTracesOverlay(app, flag3d, flagon, flagtrc, scalexy, scalez, type)
%function to plot the tracks on top of the micrscopy image. can select to
%either be in 2d or 3d tracks, as well as if the localisations or a
%connected track should be shown. 
%Will need to figure out how to make the units of the tracks an the pixels
%work so it fits...
    Traces = app.getTracks();
    axes = app.UIAxes;
    if flagon == 0
        %nothing
        cla(axes);
    else
        %check if all traces = all frames, or a single traces = single
        %frame
        spotframe = app.TimepointEditField.Value;
        if flagtrc == 0
            frame = app.TimepointEditField.Value;
        else
            frame = unique(Traces(:,2));
        end
        %get frame relevant data first
        spots = Traces(Traces(:,2) == spotframe,:);
        if isempty(spots)
            return
        end
        if flagtrc == 0
            trackIds = Traces(Traces(:,2) == frame,1);
        else
            trackIds = unique(Traces(:,1));
        end
        if isempty(trackIds)
            return
        end
        %need for loop...
        tracks = cell(size(trackIds,1),1);
        for i = 1:size(trackIds,1)
            tracks{i,1} = Traces(Traces(:,1) == trackIds(i),:);
        end
        %change scaling to match image data
        spots(:,3:4) = spots(:,3:4)*scalexy;
        spots(:,5) = spots(:,5)*scalez;
        
        for i = 1:size(trackIds,1)
            tracks{i,1}(:,3:4) = tracks{i,1}(:,3:4)*scalexy;
            tracks{i,1}(:,5) = tracks{i,1}(:,5)*scalez;
        end

        switch type
            case 0
                %spots
                if flag3d == 0
                    scatter(axes, spots(:,3), spots(:,4), 20);

                elseif flag3d == 1
                    scatter3(axes, spots(:,3), spots(:,4), spots(:,5), 20);
                end
            case 1
                %tracks
                for i = 1:size(trackIds,1)
                %for every Track
                curTrack = tracks{i,1};
                    if flag3d == 0
                        plot(axes, curTrack(:,3), curTrack(:,4), "Displayname",num2str(curTrack(1,1)));
                        %hold on
                        %scatter(axes, spots(:,3), spots(:,4), 10);
                    elseif flag3d == 1
                         plot3(axes, curTrack(:,3), curTrack(:,4), curTrack(:,5),"Displayname",num2str(curTrack(1,1)));
                         %hold on
                         %scatter3(axes, spots(:,3), spots(:,4), spots(:,5), 10);
                    end
                end
        end
    end
end