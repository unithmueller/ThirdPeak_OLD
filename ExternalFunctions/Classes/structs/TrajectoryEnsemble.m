classdef TrajectoryEnsemble
    %Contains the trajectories of a single cell with:
    %1             2          3  4  5     6          7 8 9
    %ID, Timepoint(w/o unit), x, y, z, instvelos, centerofmass
    %as well as params for smallest timestep(minAcqDT, if 3d is done and an
    %extra parameter for all the different track ids for easy access
    properties
        trajs {mustBeNonempty} = [1, 1, 1, 1, 1]
        minAcqDT {mustBeNumeric} = 1
        flag3d {mustBeNumericOrLogical} = 0
        ids {mustBeNumeric} = [1, 1]
    end
    
    methods
        %Constructor
        function obj = TrajectoryEnsemble(trajs, minAcqDT, flag3d)
            obj.trajs = trajs;
            obj.minAcqDT = minAcqDT;
            obj.flag3d = flag3d;
            obj.ids = unique(trajs(:,1));
            obj.calcinstvelos();
            obj.center_of_mass();
        end
        %Checks if a track id exists in ensemble
        function value = trajidexists(obj, id)
            value = sum(obj.trajs(:,1) == id);
            if value > 0
                value = 1;
            else
                value = 0;
            end
        end
        %Calculates the instantanous velocities of tracks and adds them to
        %column 6 in the array
        function calcinstvelos(obj)
            obj.trajs(:,6) = 0;
            if obj.flag3d == 0
                for i = 1:size(obj.ids)
                    singltraj = obj.trajs(obj.trajs(:,1) == obj.ids(i),:);
                    for j = 1:size(singltraj(:,1))-1
                        instvelo = sqrt((((singltraj(j+1,3)-singltraj(j,3))^2) + ((singltraj(j+1,4)-singltraj(j,4))^2))/((singltraj(j+1,2)-singltraj(j,2))));
                        singltraj(j,6) = instvelo;
                    end
                   obj.trajs(obj.trajs(:,1) == obj.ids(i),6) = singltraj(:,6);
                end
            elseif obj.flag3d == 1
                for i = 1:size(obj.ids)
                    singltraj = obj.trajs(obj.trajs(:,1) == obj.ids(i),:);
                    for j = 1:size(singltraj(:,1))-1
                        instvelo = sqrt( (((singltraj(j+1,3)-singltraj(j,3))^2) + ((singltraj(j+1,4)-singltraj(j,4))^2) + ((singltraj(j+1,5)-singltraj(j,5))^2))/(singltraj(j+1,2)-singltraj(j,2)) );
                        singltraj(j,6) = instvelo;
                    end
                    obj.trajs(obj.trajs(:,1) == obj.ids(i),6) = singltraj(:,6);
                end
            end
        end
        %Calculates the center of mass for every track and adds it to
        %column 7, 8 and 9 in the array
        function center_of_mass(obj)
            if obj.flag3d == 0
                obj.trajs(:,7:9) = 0;
                for i = 1:size(obj.ids)
                    singltraj = obj.trajs(obj.trajs(:,1) == obj.ids(i),:);
                    x = sum(singltraj(:,3));
                    y = sum(singltraj(:,4));
                    x = x/size(singltraj,1);
                    y = y/size(singltraj,1);
                    res = repmat([x y],size(singltraj,1),1);
                    obj.trajs(obj.trajs(:,1) == obj.ids(i), 7:8) = res;
                end
            elseif obj.flag3d == 1
                obj.trajs(:,7:9) = 0;
                for i = 1:size(obj.ids)
                    singltraj = obj.trajs(obj.trajs(:,1) == obj.ids(i),:);
                    x = sum(singltraj(:,3));
                    y = sum(singltraj(:,4));
                    z = sum(singltraj(:,5));
                    x = x/size(singltraj,1);
                    y = y/size(singltraj,1);
                    z = z/size(singltraj,1);
                    res = repmat([x y z],size(singltraj,1),1);
                    obj.trajs(obj.trajs(:,1) == obj.ids(i), 7:9) = res;
                end
            end
        end
        %gets the smallest cooridantes from a given track in xyz
        function minp = getMinPointTraj(obj, id)
            arguments
                obj
                id {mustBeNumeric} = 1
            end
            singltraj = obj.trajs(obj.trajs(:,1) == id,:);
            if obj.flag3d == 0
                minp = min(singltraj(:,3:4));
            elseif obj.flag3d == 1
                minp = min(singltraj(:,3:5));
            end
        end
        %gets the overall smallest point coordinates of all tracks
        function minp = getMinPointall(obj)
            if obj.flag3d == 0
                minp = min(obj.trajs(:,3:4));
            elseif obj.flag3d == 1
                minp = min(obj.trajs(:,3:5));
            end
        end
        %gets the coordinates of a given track with the largest x,y (and z)
        %cooridantes
        function maxp = getMaxPointTraj(obj, id)
            arguments
                obj
                id {mustBeNumeric} = 1
            end
            singltraj = obj.trajs(obj.trajs(:,1) == id,:);
            if obj.flag3d == 0
                maxp = max(singltraj(:,3:4));
            elseif obj.flag3d == 1
                maxp = max(singltraj(:,3:5));
            end
        end
        %gets the coordinates with the overall largest x,y and z cooridates for
        %all tracks
        function maxp = getMaxPointall(obj)
            if obj.flag3d == 0
                maxp = max(obj.trajs(:,3:4));
            elseif obj.flag3d == 1
                maxp = max(obj.trajs(:,3:5));
            end
        end        
        %gets the smallest timestep in all tracks(min 1)
        function res = findMinDT(obj)
            res = zeros(size(obj.trajs,1)-1,1);
            for i = 1:size(obj.trajs)-1
                temp = obj.trajs(i+1,2) - obj.trajs(i,2);
                res(i) = temp;
            end
            res = min(res);
        end
        %gets the overall range of timepoints for all tracks in the
        %ensemble
        function res = getTimeRange(obj)
            minn = min(obj.trajs(:,2));
            maxx = max(obj.trajs(:,2));
            res = [minn maxx];
        end
        %filters the tracks for a minimal track length
        function filterTracks(obj, minLen)
            arguments
                obj
                minLen {mustBeNumeric} = 5
            end
            for i = 1:size(obj.ids)
                singltraj = obj.trajs(obj.trajs(:,1) == obj.ids(i),:);
                if size(singltraj,1) < minLen
                    obj.trajs(obj.trajs(:,1) == obj.ids(i),:) = [];
                    obj.ids(obj.ids == obj.ids(i)) = [];
                end
            end
        end
        %generates a poly/alphashape around the complete trajectory
        %ensemble
        function rect = boundingRect(obj)
            if obj.flag3d == 0
                minn = min(obj.trajs(:,3:4));
                maxx = max(obj.trajs(:,3:4));
                x = [minn(1) maxx(1) maxx(1) minn(1)];
                y = [minn(2) minn(2) maxx(2) maxx(2)];
                rect = polyshape(x,y);
                
            elseif obj.flag3d == 1
                minn = min(obj.trajs(:,3:5));
                maxx = max(obj.trajs(:,3:5));
                len = maxx(1) - minn(1);
                wid = maxx(2) - minn(2);
                dep = maxx(3) - minn(3);
                x = [minn(1) minn(1) minn(1) minn(1) minn(1)+len minn(1)+len minn(1)+len minn(1)+len];
                y = [minn(2) minn(2) minn(2)+wid minn(2)+wid minn(2) minn(2)+wid minn(2) minn(2)+wid];
                z = [minn(3) minn(3)+dep minn(3)+dep minn(3) minn(3) minn(3) minn(3)+dep minn(3)+dep];
                rect = alphaShape(x.',y.',z.');
            end
        end
    end
end