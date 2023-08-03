function plotConfinementVsMeanJumpDistance(Axes, SaveStructure, dimension, filterIDs)
%Function to give a 2d plot of the confinement radius vs the mean jump
%distance. This can give information about different mobility groups within
%the not-so-diffusive particles. In accordance to the TrackIt funtion
%Input: Axes - axes to plot into
       %SaveStructure - structured array that contains the msdlyzer data
       %filteredIDs - to save the data according to the IDs
%Output:

    %% get the data
    MSD_IDs = cell2mat(SaveStructure.InternMSD.TrackIDs);
    Ds = SaveStructure.InternMSD.(dimension).d;
    MSDs = (2*size(dimension,2)).*Ds;
    alphas = SaveStructure.InternMSD.(dimension).Alpha;
    meanJumpDist = SaveStructure.MeanJumpDist.(dimension);
    meanJumpDist = [cell2mat(meanJumpDist{1,1}), meanJumpDist{1,2}];
    % repack the data
    InternalMSD = {};
    InternalD = {};
    InternalAlpha = {};
    for i = 1:size(MSD_IDs,2)
        InternalMSD(i,1:2) = {MSD_IDs(i), MSDs(i)};
        InternalD(i,1:2) = {MSD_IDs(i), Ds(i)};
        InternalAlpha(i,1:2) = {MSD_IDs(i), alphas(i)};
    end
    useExternal = 0;
    %get external data if present
    try
        ExternalD = SaveStructure.SwiftParams.D;
        ExternalMSD = SaveStructure.SwiftParams.MSD;
        ExternalAlpha = SaveStructure.SwiftParams.type;
        if size(ExternalD,1) > size(MSD_IDs,2)*10
            useExternal = 1;
        end
    catch
    end
    
    %% decide for the data
    if useExternal
        MSDs = ExternalMSD;
        Alpha = cell2mat(ExternalAlpha);
        Alpha(Alpha(:,2) == 2,2) = 0.6;
    else
        MSDs = InternalMSD;
        Alpha = InternalAlpha;
    end
    
    %% filter the data if necessary
    if size(filterIDs,1)>0
           ids = cell2mat(Alpha(:,1));
           idx = find(ids == filterIDs);
           filteredMSDData = {};
           filteredAlphaData = {};
           for i = 1:size(idx)
               filteredMSDData(i,:) = MSDs(idx,:);
               filteredAlphaData(i,:) = Alpha(idx,:);
           end
           MSDs = filteredMSDData;
           Alpha = filteredAlphaData;
    end
    
    %% filter the remaining tracks on their alpha
    idx = find(Alpha(:,2) < 0.7);
    MSDs = MSDs(idx,:);

    calculatedData = zeros(size(idx,1),4);
  
    %% Determine the confinement radius fit function
    % provide the fit model
    g = fittype('R*R*(1-exp(-4*D*(t/R*R)))+offset', 'coefficient', {'R','D','offset'}, 'independent', {'t'});
    %set the fit options
    fo = fitoptions(g);
    fo = fitoptions(fo, "Lower", [0,0,-Inf], "StartPoint", [0.5, 0.5, 1], "Algorithm", 'Levenberg-Marquardt');
    %% fit the msd of tracks to the model and save it
    for i = 1:size(MSDs)
        datax = [0:1:10];
        datay = MSDs{i,2}*datax;
        
        [fitobject,gof] = fit(datax.',datay.',g,fo);
        rsq = gof.rsquare;
        res = coeffvalues(fitobject);
        R = res(1);
        D = res(2);
        id = MSDs{i,1};
        output = [id, rsq, R, D];
        calculatedData(i,:) = output;
    end
    clear fitobject fo go
    %% Filter the mean jump distance by the remaining tracks
    remainingIDs = calculatedData(:,1);
    newMeanJump = zeros(size(remainingIDs,1),2);
    for i = 1:size(remainingIDs,1)
        trackid = remainingIDs(i);
        newMeanJump(i,:) = meanJumpDist(meanJumpDist(:,1) == trackid,:);
    end
    meanJumpDist = newMeanJump;
    
    %% Unpack the data and arrange for plotting
    calculatedData(:,5) = meanJumpDist(:,2);
    
    %% Plot the data
    hold(Axes, "on");
    for i = 1:size(calculatedData(:,1))
        scatter(Axes,calculatedData(i,5), calculatedData(i,3), "Displayname",num2str(calculatedData(i,1)));
    end
    xlabel(Axes, "Mean Jump Distance");
    ylabel(Axes, "Confinement Radius");
    
    %% add track number
    Spothandles = Axes.Children;
    for i = 1:numel(Spothandles)
        % Add a new row to DataTip showing the DisplayName of the line
        Spothandles(i).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Track',repmat({Spothandles(i).DisplayName},size(Spothandles(i).XData))); 
    end

end