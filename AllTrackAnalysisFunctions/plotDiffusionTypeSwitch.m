function [minv, maxv] = plotDiffusionTypeSwitch(Axes, SaveStructure, filterIDs)
%Function to plot the respective number of switches as a histogram in the track
%analysis window.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %filterIDs - if we use a filter we can provide the ids to search for
       %here

       %% Get the data of choice
       data = SaveStructure.SwiftParams.switchFreq;
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = data(:,1);
           ids = cell2mat(ids);
           mask = ismember(ids, filterIDs);
           data = data(mask,:);
       end
       %% Unpack the cell array
       data = cell2mat(data(:,2));
       
       %% Plot the data
       maxv = max(data);
       minv = 0.5;
       maxv = maxv+0.5;
       edges = minv:1:maxv;
       histogram(Axes, data, edges)
       xlim(Axes, [minv maxv]);
       
       title(Axes, "Number of Segments in given Tracks");
       xticks(Axes, 1:1:maxv);
       xlabel(Axes, "Number of Segments");
       ylabel(Axes, "Counts");

end