function fig = Karyogramm3DwithType(Trackdata, amount, flag3d, typeselect, LocPrecXY, LocPrecZ, Unit)
%Should Plot the tracks next to each other with the assigned diffusion type
%next or beneath it. Can select the number of tracks to be plottet 

    %Trackdata structure:
    
    %newfile(:,1) = file(:,30); %id
    %newfile(:,2) = file(:,1); %t
    %newfile(:,3) = file(:,2); %x
    %newfile(:,4) = file(:,3); %y
    %newfile(:,5) = file(:,4); %z
    %newfile(:,14) = file(:,21); %motiontype

    arguments
        Trackdata (:,:)
        amount (1,1) 
        flag3d (1,1)
        typeselect
        LocPrecXY
        LocPrecZ
        Unit
    end 
    
    fig = figure("Visible","off","Name","Karyogram Traces");
    %get number of tracks
    tracknmbrs = unique(Trackdata(:,1));
    numbroftracks = size(tracknmbrs,1);
    if numbroftracks == 0
        error("No tracks found!");
    end
    
    %Check that there are enouch tracks to work with
    if amount > numbroftracks
        amount = numbroftracks;
    elseif amount == 0
        amount = numbroftracks;
    end
    
    dimensions = zeros(numbroftracks,10);
    normalizedTracks = zeros(size(Trackdata));
    
    j = 1;
    for i = 1:numbroftracks
        %get data for one track
        currentTrack = Trackdata(Trackdata(:,1) == tracknmbrs(i),:);
        numbrofFrames = size(currentTrack,1);
        %get the min max values of the track to get the area it uses
        minX = min(currentTrack(:,3));
        maxX = max(currentTrack(:,3));
        minY = min(currentTrack(:,4));
        maxY = max(currentTrack(:,4));
        minZ = min(currentTrack(:,5));
        maxZ = max(currentTrack(:,5));
        rangeX = maxX-minX;
        rangeY = maxY-minY;
        rangeZ = maxZ-minZ;
        %store it
        dimensions(i,:) = [currentTrack(1,1) minX maxX minY maxY minZ maxZ rangeX rangeY rangeZ];
        %Normalize the track
        currentTrack(:,3) = currentTrack(:,3)-minX;
        currentTrack(:,4) = currentTrack(:,4)-minY;
        currentTrack(:,5) = currentTrack(:,5)-(minZ+rangeZ/2);
        
        normalizedTracks(j:j+numbrofFrames-1,:) = currentTrack(:,:);
        j = j + numbrofFrames;
    end
    
    %Filter the tracks depending on the selection of tracktype
    switch typeselect
        case "All"
        case "Diffusion"
            normalizedTracks = normalizedTracks(normalizedTracks(:,14) == 2,:);
        case "Immobile"
            normalizedTracks = normalizedTracks(normalizedTracks(:,14) == 1,:);
        case "Directed"
            normalizedTracks = normalizedTracks(normalizedTracks(:,14) == 3,:);
        case "Directed_Diffusion"
            normalizedTracks = normalizedTracks(normalizedTracks(:,14) == 4,:);
        case "None"
            normalizedTracks = normalizedTracks(normalizedTracks(:,14) == 0,:);
    end
            
    %plot depending on data type in 2d or 3d into the given axes. should
    %try to make them always perfect square distributed
    tracknmbrs = unique(normalizedTracks(:,1));
    numberOfTracks = size(tracknmbrs,1); %number of tracks to distribute
    len = ceil(sqrt(numberOfTracks));
    
    %to fit different length scales, spacer value has to be calculated for
    %every dataset. will use the largest track perimeter.
    
    spacervalue = max([max(dimensions(:,8)) max(dimensions(:,9))]);
    
    numbrColums = len;
    counter = 0;
    spacerX = spacervalue;
    spacerY = 0;
    
    %Check that there are enouch tracks to work with
    if amount > size(tracknmbrs,1)
        amount = size(tracknmbrs,1);
    elseif amount == 0
        amount = size(tracknmbrs,1);
    end
    
    for i = 1:amount
        trackid = tracknmbrs(i);
        ind = find(normalizedTracks(:,1)==trackid);
        if flag3d == 1
            plot3(normalizedTracks(ind,3)+spacerX, normalizedTracks(ind,4)+spacerY, normalizedTracks(ind,5));
            hold on
        else
            plot(normalizedTracks(ind,3)+spacerX, normalizedTracks(ind,4)+spacerY);
            hold on
        end
        %set the names if possible
        dim = size(normalizedTracks);
        
        if (typeselect == "All") && (dim(2) > 5)
            switch normalizedTracks(ind(end),14)
                case 0
                    txt = "none";
                case 2
                    txt = "diffusion";
                case 1
                    txt = "immobile";
                case 3
                    txt = "directed";
                case 4
                    txt = "directed_diffusion";
                case 5
                    txt = "diffusion";
            end
            text(spacerX, spacerY,txt);
        end
        counter = counter + 1;
        if numberOfTracks>5 && mod(counter,numbrColums) == 0
            %Five plots have been done at the current row
            counter = 0;
            spacerX = spacervalue;
            if numberOfTracks == 1
                spacerY = spacerY + spacervalue + max([dimensions(dimensions(:,1)==tracknmbrs(i),9) dimensions(dimensions(:,1)==tracknmbrs(i),9) dimensions(dimensions(:,1)==tracknmbrs(i),9) dimensions(dimensions(:,1)==tracknmbrs(i),9) dimensions(dimensions(:,1)==tracknmbrs(i),9)]);
            else
                spacerY = spacerY + spacervalue + max([dimensions(dimensions(:,1)==tracknmbrs(i),9) dimensions(dimensions(:,1)==tracknmbrs(i-1),9) dimensions(dimensions(:,1)==tracknmbrs(i-2),9) dimensions(dimensions(:,1)==tracknmbrs(i-3),9) dimensions(dimensions(:,1)==tracknmbrs(i-4),9)]);
            end
        else
            %only the next plot in the current row
            spacerX = spacerX + dimensions(dimensions(:,1) == trackid, 8)+spacervalue;
        end
    end
    %plot locprec
    if flag3d == 1
        [X, Y, Z] = ellipsoid(0,0,0,LocPrecXY, LocPrecXY, LocPrecZ);
        X = reshape(X,[],1);
        Y = reshape(Y,[],1);
        Z = reshape(Z, [],1);
        shp = alphaShape(X, Y, Z);
        plot(shp);
    else
        viscircles([0, 0],LocPrecXY);
    end
    
    %axis equal
    xlabel(sprintf("X-Position [%s]", Unit));
    ylabel(sprintf("Y-Position [%s]", Unit));
    zlabel(sprintf("Z-Position [%s]", Unit));
    fig.set("Visible","on");
end
    
