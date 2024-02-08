function plotConfinementVsMeanJumpDistance(Axes, SaveStructure, dimension, filterIDs, Dused, isPixel, lengthUnit, timeunit, pxsize, timestepsize)
%Function to give a 2d plot of the confinement radius vs the mean jump
%distance. This can give information about different mobility groups within
%the not-so-diffusive particles. In accordance to the TrackIt funtion
%Input: Axes - axes to plot into
       %SaveStructure - structured array that contains the msdlyzer data
       %filteredIDs - to save the data according to the IDs
%Output:

    %% get the data
    %decide which diffusion coefficient to take and convert alpha if
    %necessary
    if Dused == "internal MSD Fit"
        Ds = SaveStructure.InternMSD.(dimension).d;
        alphas = SaveStructure.InternMSD.(dimension).Alpha;
        alphas = cell2mat(alphas);
    elseif Dused == "external"
        Ds = SaveStructure.SwiftParams.D;
        alphas = SaveStructure.SwiftParams.type;
        alphas = cell2mat(alphas);
        alphas(alphas(:,2) == 2,2) = 0.6;
    end
    %calculate MSD from D
    MSDs(:,1) = cell2mat(Ds(:,1));
    MSDs(:,2) = (2*size(dimension,2)).*cell2mat(Ds(:,2));
    meanJumpDist = SaveStructure.MeanJumpDist.(dimension);
    meanJumpDist = [cell2mat(meanJumpDist{1,1}), meanJumpDist{1,2}];
    
    %% filter the data if necessary
    if size(filterIDs,1)>0
           ids = alphas(:,1);
           mask = ismember(ids, filterIDs);
           alphas = alphas(mask,:);
           MSDs = MSDs(mask,:);
           meanJumpDist = meanJumpDist(mask,:);
    end
    
    %% filter the remaining tracks on their alpha
    idx = find(alphas(:,2) < 0.7);
    MSDs = MSDs(idx,:);
    meanJumpDist = meanJumpDist(idx,:);

    calculatedData = zeros(size(idx,1),4);
    %% convert the data into the same Units
    %the msd is always in pixel/frame; the meanJumpDistance is in
    %dependence of the isPixel value in pixel or unit. Need du adjust
    %accordingly
   % if isPixel
   % else
    %    MSDs(:,2) = MSDs(:,2).*(pxsize*pxsize/(timestepsize*timestepsize));
   % end
  
    %% Determine the confinement radius fit function
    % provide the fit model
    g = fittype('R*R*(1-exp(-4*D*(t/R*R)))+offset', 'coefficient', {'R','D','offset'}, 'independent', {'t'});
    %set the fit options
    fo = fitoptions(g);
    fo = fitoptions(fo, "Lower", [0,0,-Inf], "StartPoint", [0.5, 0.5, 1], "Algorithm", 'Trust-Region');
    %% fit the msd of tracks to the model and save it
    for i = 1:size(MSDs)
        datax = 0:1:10;
        datay = MSDs(i,2)*datax;
        
        [fitobject,gof] = fit(datax.',datay.',g,fo);
        rsq = gof.rsquare;
        res = coeffvalues(fitobject);
        R = res(1);
        D = res(2);
        id = MSDs(i,1);
        output = [id, rsq, R, D];
        calculatedData(i,:) = output;
    end
    clear fitobject fo go
  
    %% Unpack the data and arrange for plotting
    calculatedData(:,5) = meanJumpDist(:,2);
    
    %% Plot the data
    hold(Axes, "on");
    for i = 1:size(calculatedData(:,1))
        scatter(Axes,calculatedData(i,5), calculatedData(i,3), "Displayname",num2str(calculatedData(i,1)));
    end
    title(Axes, "Confinement Radius vs. Mean Jump Distance")
    if isPixel
        xlabel(Axes, "Mean Jump Distance [px]");
        ylabel(Axes, "Confinement Radius [px]");
    else
        xlabel(Axes, sprintf("Mean Jump Distance [%s]", lengthUnit));
        ylabel(Axes, sprintf("Confinement Radius [%s]", lengthUnit));
    end

    
    %% add track number
    Spothandles = Axes.Children;
    for i = 1:numel(Spothandles)
        % Add a new row to DataTip showing the DisplayName of the line
        Spothandles(i).DataTipTemplate.DataTipRows(end+1) = dataTipTextRow('Track',repmat({Spothandles(i).DisplayName},size(Spothandles(i).XData))); 
    end

end