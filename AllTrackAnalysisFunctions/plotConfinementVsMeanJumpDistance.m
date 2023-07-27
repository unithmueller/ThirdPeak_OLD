function plotConfinementVsMeanJumpDistance(Axes, SaveStructure, dimension, filterIDs)
%Function to give a 2d plot of the confinement radius vs the mean jump
%distance. This can give information about different mobility groups within
%the not-so-diffusive particles. In accordance to the TrackIt funtion
%Input: Axes - axes to plot into
       %SaveStructure - structured array that contains the msdlyzer data
       %filteredIDs - to save the data according to the IDs
%Output:

    %% get the data
    MSD_IDs = SaveStructure.InternMSD.TrackIDs;
    MSDs = SaveStructure.InternMSD.(dimension).MSDclass.msd;
    alphas = SaveStructure.InternMSD.(dimension).MSDclass.alpha;
    meanJumpDist = SaveStructure.JMeanJumpDist.(dimension);
    calculatedData = [];
    
    %% filter the data if necessary
    if size(filterIDs,1)>0
           ids = MSD_IDs(:,1);
           ids = cell2mat(ids);
           idx = find(ids == filterIDs);
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = MSDs(idx,:);
           end
           MSDs = filteredData;
           % filter the data alphas
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = alphas(idx,:);
           end
           alphas = filteredData;
           MSD_IDs = MSD_IDs(idx);
    end
    
    %% filter the remaining tracks on their alpha
    idx = find(alphas < 0.7);
    MSD_IDs = MSD_IDs(idx);
    MSDs = MSDs(idx);
    
    calculatedData = zeros(size(idx,1),4);
  
    %% Determine the confinement radius fit function
    % provide the fit model
    g = fittype('R*R*(1-exp(-4*D*(t/R*R)))+offset', 'coefficient', {'R','D','offset'}, 'independent', {'t'});
    %set the fit options
    fo = fitoptions(g, "Method", "NonlinearLeastSqaures", "Lower", [0,0,-Inf], "StartPoint", [0.5, 0.5, 1], "Algorithm", 'Levenberg-Marquardt');
    
    %% fit the msd of tracks to the model and save it
    for i = 1:size(MSDs)
        datay = MSDs{i,1};
        datax = [1:1:size(datay,1)];
        
        [fitobject,gof] = fit(datax,datay,g,fo);
        rsq = gof.rsquare;
        [R,D,~] = coeffvalues(fitobject);
        id = MSD_IDs(i);
        output = [id, rsq, R, D];
        calculatedData(i,:) = output;
    end
    
    %% Filter the mean jump distance by the remaining tracks
    remainingIDs = calculatedData(:,1);
    ids = meanJumpDist(:,1);
    idx = find(ids == remainingIDs);
    filteredData = {};
    for i = 1:size(idx)
        filteredData(:,i) = meanJumpDist(idx,:);
    end
    meanJumpDist = filteredData;
    
    %% Unpack the data and arrange for plotting
    meanJumpDist = cell2mat(meanJumpDist(:,2));
    calculatedData(:,5) = meanJumpDist;
    
    %% Plot the data
    hold(Axes, "on");
    for i = 1:size(calculatedData(:,1))
        scatter(Axes,calculatedData(i,5), calculatedData(i,3), "Displayname",num2str(calculatedData(i,1)));
    end
    
    %% add track number
    Spothandles = Axes.Children;
    for i = 1:numel(Spothandles)
        % Add a new row to DataTip showing the DisplayName of the line
        Spothandles(i).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Track',repmat({Spothandles(i).DisplayName},size(Spothandles(i).XData))); 
    end

end