classdef TrajectoryProxy < Trajectory
    properties
        ptsIds
        traj
        flag3d
    end
    methods
        function obj = TrajectoyProxy(ptsIds, traj, flag3d)
        obj.ptsIds = ptsIds;
        obj.traj  = traj;
        obj.flag3d = flag3d;
        end
        
        function pointlist = points()
            if flag3d == 0
                pointlist = obj.traj(obj.ptsIds, 3:4);
            elseif flag3d == 1
                pointlist = obj.traj(obj.ptsIds, 3:5);
            end
        end
        
    end
end
