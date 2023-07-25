function plotAveragedTrackLength(FigurePanel, SaveStructure, filterIDs, isPixel, lengthUnit)
%Function to plot the average track step number, total distance and netto distance as a boxplot in the track
%analysis window.
%Input: Axes - axes object to plot into
       %SaveStructure - structured array that contains the jump distances
       %filterIDs - if we use a filter we can provide the ids to search for
       %here
       %performFit - will try to perform several fits to find a matching
       %distribution
       
       %% Get the data of choice
       StepNumberdata = SaveStructure.TrackLength.Steps;
       Totaldistancedata = SaveStructure.TrackLength.AbsLength.XYZ;
       Nettodistancedata = SaveStructure.TrackLength.NetLength.XYZ;
       
       %% Apply the filter if necessary
       if size(filterIDs,1)>0
           ids = StepNumberdata(:,1);
           ids = cell2mat(ids);
           idx = find(ids == filterIDs);
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = StepNumberdata(idx,:);
           end
           StepNumberdata = filteredData;
           
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = Totaldistancedata(idx,:);
           end
           Totaldistancedata = filteredData;
           
           filteredData = {};
           for i = 1:size(idx)
               filteredData(:,i) = Nettodistancedata(idx,:);
           end
           Nettodistancedata = filteredData;
       end
       %% Unpack the cell array
       StepNumberdata = cell2mat(StepNumberdata(:,2));
       Totaldistancedata = cell2mat(Totaldistancedata(:,2));
       Nettodistancedata = cell2mat(Nettodistancedata(:,2));
       
       %% prepare a tiled layout
       tl = tiledlayout(FigurePanel, 1,3);
       
       %% Plot the data
       nexttile
       boxplot(StepNumberdata);
       title("Average Track Length in Steps")
       xlabel("Tracks")
       ylabel("Track Length [steps]")
       
       nexttile
       boxplot(Totaldistancedata);
       title("Average Total Track Length")
       xlabel("Tracks")
       if isPixel
           ylabel("Total Track Length [px]")
       else
           ylabel(sprintf("Total Track Length [%s]", lengthUnit))
       end
       
       nexttile
       boxplot(Nettodistancedata);
       title("Average Netto Track Length")
       xlabel("Tracks")
       if isPixel
           ylabel("Netto Track Length [px]")
       else
           ylabel(sprintf("Netto Track Length [%s]", lengthUnit))
       end
end