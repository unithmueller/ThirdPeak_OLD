function makeDensityMap(app, data, flag3d, superpxsize, NmbrTimeWins, minAcqDT, dopt, filter, filtersize, superZsize)
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
    
    params = DensityParameters(superpxsize, dopt, filtersize, flag3d, superZsize);
    
    scalmapwins = ScalarMapWindows.gen_density_maps(trajensembwins, params);
    
    %now the plotting
    
     for i = 1:size(scalmapwins.windows,2)
        data = flip(rot90(scalmapwins.windows(1,i).data));
        hold off;
        figure('Name', sprintf('Density Map - TimeWindow %d', i));
        if flag3d
            %3d
            [X, Y] = meshgrid(1:size(data,2),1:size(data,1));
            for Z = 1:size(data,3)
                hold on;
                C(Y,X) = data(Y,X,Z);
                if dopt == "DENS"
                    %C = C*(superpxsize*superpxsize*superZsize);
                elseif dopt == "NPTS"
                    C = cell2mat(C);
                end
                zpos = zeros(size(data,1),size(data,2));
                zpos(:) = Z;
                s = surface(X,Y,zpos,C);
                if dopt == "NPTS"
                    C = {};
                end
                s.EdgeColor = 'none';
                alpha(s,"color");
                xlabel("X Position [px]");
                ylabel("Y Position [px]");
                zlabel("Z Position [px]");
            end
            hold off
        else
            %2d
            [X, Y] = meshgrid(1:size(data,2),1:size(data,1));
            Z = zeros(size(data));
            C(Y,X) = data(Y,X);
            if dopt == "DENS"
                %C = C*(superpxsize*superpxsize);
            elseif dopt == "NPTS"
                C = cell2mat(C);
            end
            s = surface(X,Y,Z,C);
            s.EdgeColor = 'none';
            alpha(s,"color");
            alpha(s,"none");
        end
        c = colorbar;
        if dopt == "DENS"
            c.Label.String = 'Data Density [Counts/SuperpixelArea]';
        elseif dopt == "NPTS"
            c.Label.String = 'Data Density [Counts/Superpixel]';
        end
        
        xlabel("X Position [px]");
        ylabel("Y Position [px]");
        hold(gca,"off");
        clear C;
     end
end