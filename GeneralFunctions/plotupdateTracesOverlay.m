function [lineColors, spotColors] = plotupdateTracesOverlay(axes, Traces, flag3d, On, type, frame, scale, offsetx, offsety, offsetz, spotsize, lineC, spotC)
%function to plot the tracks on top of the micrscopy image. can select to
%either be in 2d or 3d tracks, as well as if the localisations or a
%connected track should be shown. 
%Will need to figure out how to make the units of the tracks an the pixels
%work so it fits...
    arguments
        axes %UI axes
        Traces (:,:) %trackdata
        flag3d (1,1) %if 3d or not
        On %if overlay plottet or not
        type %traces or spots plottet
        frame %current frame in slider
        scale (1,1)
        offsetx (1,1)
        offsety (1,1)
        offsetz (1,1)
        spotsize (1,1)
        lineC
        spotC
    end
    
    if On == 0
        %nothing
        lineColors = lineC;
        spotColors = spotC;
    else
        %get frame relevant data first
        spots = Traces(Traces(:,2) == frame,:);
        if isempty(spots)
            lineColors = lineC;
            spotColors = spotC;
            return
        end
        trackIds = Traces(Traces(:,2) == frame,1);
        if isempty(trackIds)
            lineColors = lineC;
            spotColors = spotC;
            return
        end
        %need for loop...
        tracks = cell(size(trackIds,1),1);
        for i = 1:size(trackIds,1)
            tracks{i,1} = Traces(Traces(:,1) == trackIds(i),:);
        end
        %change scaling to match image data
        spots(:,3:4) = spots(:,3:4)*scale;
        spots(:,3) = spots(:,3)+offsetx;
        spots(:,4) = spots(:,4)+offsety;
        spots(:,5) = spots(:,5)+offsetz;
        
        for i = 1:size(trackIds,1)
            tracks{i,1}(:,3:4) = tracks{i,1}(:,3:4)*scale;
            tracks{i,1}(:,3) = tracks{i,1}(:,3)+offsetx;
            tracks{i,1}(:,4) = tracks{i,1}(:,4)+offsety;
            tracks{i,1}(:,5) = tracks{i,1}(:,5)+offsetz;
        end
        
        %need to plot
        hold(axes, "on");
        handles = struct();
        %if isempty(spotC)
        %allocate some save space for the colors
        spotColors = cell(size(spotC,1) + size(trackIds,1),2);
        lineColors = cell(size(lineC,1) + size(trackIds,1),2);
        %add the old colors
        if ~isempty(spotC)
            spotColors(1:size(spotC,1),:) = spotC;
        end
        if ~isempty(lineC)
            lineColors(1:size(lineC,1),:) = lineC;
        end
        %carry a counter for new additions
        colorCounterSpot = size(spotC,1)+1;
        colorCounterLine = size(lineC,1)+1;

        %spotColors = spotC;
        %lineColors = lineC;

        for i = 1:size(trackIds)
            %for every track in the current frame
            switch type
                case 0 %only spots
                    if flag3d == 0 %2D
                        curTrackID = trackIds(i);
                        try
                            IDs = spotColors(:,1);
                            IDs = cell2mat(IDs);
                        catch
                            IDs = [-1; -1];
                        end
                        if any(IDs == curTrackID)
                            curColor = IDs == curTrackID;
                            curColor = spotColors{curColor,2};
                            h = scatter3(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spots(spots(:,1) == trackIds(i),5), spotsize, curColor, 'filled');
                        else
                            h = scatter(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spotsize, 'filled');
                            spotColors{colorCounterSpot,1} = trackIds(i);
                            spotColors{colorCounterSpot,2} = h.CData;
                            colorCounterSpot = colorCounterSpot+1;
                        end
                    elseif flag3d == 1 %3D
                        curTrackID = trackIds(i);
                        try
                            IDs = spotColors(:,1);
                            IDs = cell2mat(IDs);
                        catch
                            IDs = [-1; -1];
                        end
                        if any(IDs == curTrackID)
                            curColor = IDs == curTrackID;
                            curColor = spotColors{curColor,2};
                            h = scatter3(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spots(spots(:,1) == trackIds(i),5), spotsize, curColor, 'filled');
                        else
                            h = scatter3(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spots(spots(:,1) == trackIds(i),5), spotsize, 'filled');
                            spotColors{colorCounterSpot,1} = trackIds(i);
                            spotColors{colorCounterSpot,2} = h.CData;
                            colorCounterSpot = colorCounterSpot+1;
                        end
                    end

                case 1 %tracks and spots
                    %for every Track
                    curTrack = tracks{i,1};
                        if flag3d == 0
                            curTrackID = trackIds(i);
                            try
                                IDs = lineColors(:,1);
                                IDs = cell2mat(IDs);
                            catch
                                IDs = [-1; -1];
                            end
                            if any(IDs == curTrackID)
                                curColor = IDs == curTrackID;
                                curColor = lineColors{curColor,2};
                                h = plot(axes, curTrack(:,3), curTrack(:,4), 'Color',curColor);
                                handles.line(i) = h;
                                color = handles.line(i).Color;
                                scatter(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spotsize, color, 'filled');
                            else
                                h = plot(axes, curTrack(:,3), curTrack(:,4));
                                handles.line(i) = h;
                                color = handles.line(i).Color;
                                lineColors{colorCounterLine,1} = trackIds(i);
                                lineColors{colorCounterLine,2} = color;
                                colorCounterLine = colorCounterLine+1;
                                scatter(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spotsize, color, 'filled');
                            end
                        elseif flag3d == 1
                            curTrackID = trackIds(i);
                            try
                                IDs = lineColors(:,1);
                                IDs = cell2mat(IDs);
                            catch
                                IDs = [-1; -1];
                            end
                            if any(IDs == curTrackID)
                                curColor = IDs == curTrackID;
                                curColor = lineColors{curColor,2};
                               h = plot3(axes, curTrack(:,3), curTrack(:,4), curTrack(:,5), 'Color', curColor);
                                handles.line(i) = h;
                                color = handles.line(i).Color;
                                scatter3(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spots(spots(:,1) == trackIds(i),5), spotsize, color, 'filled');
                            else
                                h = plot3(axes, curTrack(:,3), curTrack(:,4), curTrack(:,5));
                                handles.line(i) = h;
                                color = handles.line(i).Color;
                                lineColors{colorCounterLine,1} = trackIds(i);
                                lineColors{colorCounterLine,2} = color;
                                colorCounterLine = colorCounterLine+1;
                                scatter3(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spots(spots(:,1) == trackIds(i),5), spotsize, color, 'filled');
                            end
                        end
             end
        end
        %remove empty color placeholder
        spotColors = spotColors(~cellfun(@isempty, spotColors(:,1)),:);
        lineColors = lineColors(~cellfun(@isempty, lineColors(:,1)),:);
    end
end