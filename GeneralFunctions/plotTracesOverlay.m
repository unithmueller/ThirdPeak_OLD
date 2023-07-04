function handles = plotTracesOverlay(axes, Traces, flag3d, scale, offsetx, offsety, offsetz)
%function to plot the tracks on top of the micrscopy image. can select to
%either be in 2d or 3d tracks, as well as if the localisations or a
%connected track should be shown. 
%Will need to figure out how to make the units of the tracks an the pixels
%work so it fits...
    arguments
        axes 
        Traces (:,:)
        flag3d (1,1)
        scale (1,1)
        offsetx (1,1)
        offsety (1,1)
        offsetz (1,1)
    end
    %change scaling to match image data
    adjTraces = Traces(:,:);
    adjTraces(:,3:4) = Traces(:,3:4)*scale;
    adjTraces(:,3) = adjTraces(:,3)+offsetx;
    adjTraces(:,4) = adjTraces(:,4)+offsety;
    adjTraces(:,5) = adjTraces(:,5)+offsetz;
    
    IDs = unique(adjTraces(:,1));
    %fig = gcf;
    axes = axes;
    set(axes,"Visible","off");
    hold on
    spothandles = gobjects(size(adjTraces(:,1),1),1); %Handle
    for i = 1:size(adjTraces(:,1),1)
        if flag3d == 0
            spothandles(i) = scatter(axes, adjTraces(i,3), adjTraces(i,4), 10);
            hold on
        elseif flag3d == 1
            spothandles(i) = scatter3(axes, adjTraces(i,3), adjTraces(i,4), adjTraces(i,5), 10);
            hold on
        end
    end
    spothandles(end).Visible = "off";
    
    trackhandles = gobjects(size(IDs,1),1); %Handles
    for i = 1:size(IDs,1)
        %for every Track
        curID = IDs(i);
        curTrack = adjTraces(adjTraces(:,1)==curID,:);
        if flag3d == 0
            trackhandles(i) = plot(axes, curTrack(:,3), curTrack(:,4));
            %hold on
        elseif flag3d == 1
            trackhandles(i) = plot3(axes, curTrack(:,3), curTrack(:,4), curTrack(:,5));
            %hold on
        end
    end
    trackhandles(end).Visible = "off";
    trackhandles = {IDs, trackhandles};

    handles = {spothandles, trackhandles};
end
   