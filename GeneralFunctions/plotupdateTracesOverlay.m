function plotupdateTracesOverlay(axes, Traces, flag3d, On, type, frame, scale, offsetx, offsety, offsetz, spotsize)
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
    end
    
    if On == 0
        %nothing
    else
        %get frame relevant data first
        spots = Traces(Traces(:,2) == frame,:);
        if isempty(spots)
            return
        end
        trackIds = Traces(Traces(:,2) == frame,1);
        if isempty(trackIds)
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
        for i = 1:size(trackIds)
            %for every track in the current frame
            switch type
                case 0 %only spots
                    if flag3d == 0 %2D
                        scatter(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spotsize, 'filled');
                    elseif flag3d == 1 %3D
                        scatter3(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spots(spots(:,1) == trackIds(i),5), spotsize, 'filled');
                    end
                case 1 %tracks and spots
                    %for every Track
                    curTrack = tracks{i,1};
                        if flag3d == 0
                            h = plot(axes, curTrack(:,3), curTrack(:,4));
                            handles.line(i) = h;
                            color = handles.line(i).Color;
                            scatter(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spotsize, color, 'filled');
                        elseif flag3d == 1
                             h = plot3(axes, curTrack(:,3), curTrack(:,4), curTrack(:,5));
                             handles.line(i) = h;
                             color = handles.line(i).Color;
                             scatter3(axes, spots(spots(:,1) == trackIds(i),3), spots(spots(:,1) == trackIds(i),4), spots(spots(:,1) == trackIds(i),5), spotsize, color, 'filled');
                        end
             end
         end
    end
end