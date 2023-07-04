function makeDriftMap(app, flag3d, superpxsize, NmbrTimeWins, minAcqDT, nump, filter, filtersize, superZsize)
 %app: calling app; flag3d if 3d is used (1) or not (0); superpxsize is the
 %size for the grid/bins; NmbrTimeWins defines the number of temporal bins
 %that are generated; minAcqDT is the exposure time/frame rate; nump is the
 %minimal number of points in a bin that will lead to processing, filter i
 %dont know yet, filtersize is the distance to be considered for processing
    %Make the grid to put the data in
    data = getCurrentData(app);
    data = cell2mat(data(1,1));
        %need to convert data always into unit/frame
    type = split(convertCharsToStrings(app.ImportSettingsStruct.customUnits.DataType),"/");
    comparison = strcmp(type, ["Pixel"; "Frame"]);
    if comparison %pixel/frame
        %if pixel/frame, covert pixel to unit
        data(:,3:5) = data(:,3:5)*app.ImportSettingsStruct.customUnits.Pixelsize;
    elseif comparison(1) & (~comparison(2))%Pixel/Unit
        %if pixel/unit, must convert unit to frame and pixel to
        %unit
        time = data(:,2);
        time = round(time/app.ImportSettingsStruct.customUnits.Timestep,0);
        data(:,2) = time;
        data(:,3:5) = data(:,3:5)*app.ImportSettingsStruct.customUnits.Pixelsize;
    elseif (~comparison(1)) & comparison(2)%Unit/Frame
        %if unit/frame, do nothing
    else
        %if unit/unit, must convert time to frame
        time = data(:,2);
        time = round(time/app.ImportSettingsStruct.customUnits.Timestep,0);
        data(:,2) = time;
    end
    trajensemb = TrajectoryEnsemble(data(:,1:5), minAcqDT, flag3d);

    maxXY = max(data(:,3:4));
    minZ = min(data(:,5));
    maxZ = max(data(:,5));

    TimeWinDur = ceil(max(data(:,2))/NmbrTimeWins);
    
    tws = TimeWindows.empty;
    if NmbrTimeWins == 1
        %single win
        tmptws = TimeWindows.generateSingleWindow(trajensemb);
        tws(end+1) = tmptws;
    else
        %many win
        begin = min(data(:,2));
        for i = 1:NmbrTimeWins
            ending = begin+TimeWinDur;
            tmpwin = TimeWindows(TimeWinDur, 0, begin, ending);
            begin = ending+1;
            tws(end+1) = tmpwin;
        end
    end
    
    trajensembwins = TrajectoryEnsembleWindows(trajensemb, tws);
    
    params = DriftParameters(superpxsize, nump, filter, filtersize, flag3d, superZsize);
    
    VecMapWins = VectorMapWindows();
    
    mapwindows = VectorMapWindows.gen_drift_maps(trajensembwins, params, flag3d);
    
    %Need to plot them
    vecmaps = mapwindows.wins;
    for i = 1:size(vecmaps,2)
        if flag3d 
            data = vecmaps(1,i).data;
            %X Y Z U V W data
            [X, Y, Z] = meshgrid(1:size(data,1),1:size(data,2), 1:size(data,3));
            U = zeros(size(data,2),size(data,1), size(data,3));
            V = zeros(size(data,2),size(data,1), size(data,3));
            W = zeros(size(data,2),size(data,1), size(data,3));
            
            for j = 1:size(data,1)
                for k = 1:size(data,2)
                    for l = 1:size(data,3)
                        if ~isempty(data{j,k,l})
                            U(k,j,l) = data{j,k,l}(1);
                            V(k,j,l) = data{j,k,l}(2);
                            W(k,j,l) = data{j,k,l}(2);
                        end
                    end
                end
            end
            figure('Name',sprintf('Drift Map - TimeWindow %d', i));
            quiver3(X,Y,Z,U,V,W);
            xlabel("X Position [px]");
            ylabel("Y Position [px]");
            zlabel("Z Position [px]");
            %axis equal
        else
            data = vecmaps(1,i).data;
            %X Y U V data
            [X, Y] = meshgrid(1:size(data,1),1:size(data,2));
            U = zeros(size(data,2),size(data,1));
            V = zeros(size(data,2),size(data,1));
            
            for l = 1:size(data,1)
                for k = 1:size(data,2)
                    if ~isempty(data{l,k})
                        U(k,l) = data{l,k}(1);
                        V(k,l) = data{l,k}(2);
                    end
                end
            end
            figure('Name',sprintf('Drift Map - TimeWindow %d', i));
            quiver(X,Y,U,V);
            xlabel("X Position [px]");
            ylabel("Y Position [px]");
            axis equal
        end
    end
end