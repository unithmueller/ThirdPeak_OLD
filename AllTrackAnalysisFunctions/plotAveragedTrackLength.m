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
           ids = cell2mat(StepNumberdata(:,1));
           mask = ismember(ids, filterIDs);
           StepNumberdata = StepNumberdata(mask,:);

           Totaldistancedata = Totaldistancedata(mask,:);
           
           Nettodistancedata = Nettodistancedata(mask,:);
       end
       %% Unpack the cell array
       StepNumberdata = cell2mat(StepNumberdata(:,2));
       Totaldistancedata = cell2mat(Totaldistancedata);
       Totaldistancedata = Totaldistancedata(:,2);
       Nettodistancedata = cell2mat(Nettodistancedata(:,2));
       
       %% prepare a tiled layout
       tl = tiledlayout(FigurePanel, 1,3);
       
       %% Plot the data
       ax1 = nexttile(tl,1);
       avg = boxplot(ax1, StepNumberdata);
       title(ax1, "Average Track Length in Steps")
       xlabel(ax1, "Tracks")
       ylabel(ax1, "Track Length [steps]")
       
       ax2 = nexttile(tl,2);
       tot = boxplot(ax2, Totaldistancedata);
       title(ax2, "Average Total Track Length")
       xlabel(ax2, "Tracks")
       if isPixel
           ylabel(ax2, "Total Track Length [px]")
       else
           ylabel(ax2, sprintf("Total Track Length [%s]", lengthUnit))
       end
       
       ax3 = nexttile(tl,3);
       net = boxplot(ax3, Nettodistancedata);
       title(ax3, "Average Netto Track Length")
       xlabel(ax3, "Tracks")
       if isPixel
           ylabel(ax3, "Netto Track Length [px]")
       else
           ylabel(ax3, sprintf("Netto Track Length [%s]", lengthUnit))
       end
end