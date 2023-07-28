function plotJumpAngle(Axes, SaveStructure, dimension, filterIDs, performFit)
%Function to plot the jump angle distribution for the chosen tracks.
%Input: Axes - PolarAxes object to plot to
       %SaveStructure - structured array that contains the angles
       %dimension - XY or XYZ to decide if 2d or 3d
       %filterIDs - if we want to filter we bring the IDs to keep her
       %performFit - to decide if we want to fit or not(if possible)
       
       %% Get the data
       data = SaveStructure.JumpAngles.(dimension);
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = data(:,1);
           ids = cell2mat(ids);
           idx = find(ids == filterIDs);
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = data(idx,:);
           end
           data = filteredData;
       end
       
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
       %% Plot the data
       p = polarhistogram(Axes,data,12, "Normalization", "probability");
       title(Axes, "Jump Angle Distribtuion in °");
      
       %% Give a plot around the highest value so it might be easier to compare
       if performFit
           hold(Axes,"on");
           axes(Axes);
           val = p.Values;
           maxv = max(val);
           binCenters = (p.BinEdges(1:end-1) + p.BinEdges(2:end))/2;
           val = zeros(size(binCenters,2),1);
           val(:) = maxv;
           polarplot(Axes, binCenters, val);
           hold(Axes,"on");
       end
end