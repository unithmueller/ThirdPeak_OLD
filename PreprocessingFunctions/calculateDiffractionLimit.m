function diffractionLimitValueString = calculateDiffractionLimit(intensityFilteredLocs, lengthUnit)
%Calculates the diffraction limit from the data by looking for the smallest
%distance in each frame between two localisations. This determines the
%smalles resolution of spots that could be resolved by the localisation
%process. 

    %% calculations
    %generate a structure to save to
    nn_mindist = {};
    %for every file
    for i = 1:size(intensityFilteredLocs,1)
        tmpdat = intensityFilteredLocs{i,1};
        %only frame xyz
        tmpdat = tmpdat(:,2:5);
        %for every frame
        frames = unique(tmpdat(:,1));
        frameNNmindist = zeros(size(frames,1),2);
        for j = 1:size(frames,1)
            framenr = frames(j);
            points = tmpdat(tmpdat(:,1) == framenr,:);
            pointNNdist = zeros(size(points,1),1);
            %for every point in points
            for k = 1:size(points,1)
                %qp = query point
                qp = points(k,2:4);
                distances = zeros(size(points,1),1);
                %for every other point in points
                if size(points,1)>1
                    for p = 1:size(points,1)
                        %rp = reference point
                        rp = points(p,2:4);
                        distance = sqrt(((qp(1)-rp(1))^2)+((qp(2)-rp(2))^2)+((qp(2)-rp(2))^2));
                        distances(p) = distance;
                    end
                end
                %remove all 0 as this would mean qp = rp
                distances(distances == 0) = Inf;
                %keep the smallest distance found per point
                mintmppointdist = min(distances);
                %save it
                pointNNdist(k) = mintmppointdist;
            end
            %keep the smallest distance per frame and save it
            tmpframenndist = min(pointNNdist);
            frameNNmindist(j,1) = framenr;
            frameNNmindist(j,2) = tmpframenndist;
        end
        %keep the distances per frame and per file
        nn_mindist{i,1} = frameNNmindist(frameNNmindist(:,2)<Inf & frameNNmindist(:,2)>0,:);
        nn_mindist{i,2} = intensityFilteredLocs{i,2};
    end
    clear framennmindist frames pc tmpdat dists pointnndist points qp;
    

    %% plot
    %now we plot the data and get the mean value
    %put them all together
    dataToPlot = zeros([1,2]);
    for i = 1:size(intensityFilteredLocs.intensityLocs,1)
        nndist = nn_mindist{i,1}(:,2);
        nnumb = i*ones(size(nndist(:,1),1),1);
        dataPut = [nndist,nnumb];
        dataToPlot = [dataToPlot(:,:); dataPut];
    end
    dataToPlot(1,:) =  [];
    filenames = {};
    for i = 1:size(intensityFilteredLocs.intensityLocs,1)
        filenames{i} = nn_mindist{i,2};
    end

    h1 = figure;

    boxchart(dataToPlot(:,2),dataToPlot(:,1));
    hold on;
    swarmchart(dataToPlot(:,2),dataToPlot(:,1));
    ylabeltext = sprintf("Minimal Distnace Per Frame [%s]", lengthUnit);
    ylabel(ylabeltext);
    xlabel("Filename");
    xticks(1:1:size(intensityFilteredLocs,1));
    xticklabels(filenames);

    savefig(gcf, "DiffractionLimit");
    saveas(gcf, "DiffractionLimit.svg");
    close(gcf);
    
    %% get the smallest value of them all
    nnmean = cellfun(@mean, nn_mindist(:,1), 'UniformOutput', false);
    nnmean = cell2mat(nnmean);
    nnmean = nnmean(:,2);
    nnmean = min(nnmean);
    diffractionLimitValueString = int2str(nnmean);
    
end