classdef TrajectoryEnsembleWindows
    %Combines TimeWindows and TrajectoryEnsemble to Trajectories in a given
    %Time Window
    properties
        wins 
        minAqcdT
        flag3d
    end
    
    methods
        %Constructor, takes TrajectoryEnsembles and TimeWindows
        function obj = TrajectoryEnsembleWindows(te, tws)
            arguments
                te TrajectoryEnsemble
                tws TimeWindows
            end
            obj.minAqcdT = te.minAcqDT;
            obj.flag3d = te.flag3d;
            %Amount of TimeWindows, also number of bins
            binCount = size(tws,2);
            obj.wins = cell(binCount,1);
            edges = zeros(binCount,2);
            %Generate edges for the bins
            for i = 0:binCount-1
                tempedges = tws(1).getWindow(i);
                edges(i+1,:) = tempedges;
            end
            %Sort points of tracks into bins given by edges
            for i = 1:binCount
                obj.wins{i,1} = TrajectoryEnsemble(te.trajs(te.trajs(:,2) <= edges(i,2) & te.trajs(:,2) >= edges(i,1) ,:), te.minAcqDT, te.flag3d); 
            end
        end
        %Get the maximum values for xyz and t of each TimeWindow in a cell
        function coord = getmaxCoords(obj)
            tmax = cellfun(@(x) max(x(:,2)),obj.wins, 'UniformOutput',false);
            xmax = cellfun(@(x) max(x(:,3)),obj.wins, 'UniformOutput',false);
            ymax = cellfun(@(x) max(x(:,4)),obj.wins, 'UniformOutput',false);
            zmax = cellfun(@(x) max(x(:,5)),obj.wins, 'UniformOutput',false);
            coord = {tmax, xmax, ymax, zmax}; %coord{1,1-4}
        end
        %Grabs the already calculated instantanous velocities from the
        %given points and caluclates the mean for the new timewindow
        function vel = getinstantVelocities(obj)
            vel = zeros(size(obj.wins,1),1);
            for i = 1:size(obj.wins,1)
                trajs = obj.wins{i,1};
                vel(i) = median(trajs(:,6));
            end
            %Convert all Nan(no tracks in window) to 0
            vel(isnan(vel)) = 0;
        end
        %For consistency, Positions already contained in the tracks
        function pos = getinstVeloPositions(obj)
            pos = cell(size(obj.wins,1),1);
            for i = 1:size(obj.wins,1)
                trajs = obj.wins{i,1};
                pos{i} = trajs(:,3:5);
            end
        end
        %Put all tracks together again
        function trajEnsemble = flatten(obj)
            win = obj.wins;
            win(~cellfun('isempty',win));
            trajs = cell2mat(win);
            trajEnsemble = TrajectoryEnsemble(trajs,obj.minAqcdT,obj.flag3d);
        end
    end
end
                
        
                

        
        