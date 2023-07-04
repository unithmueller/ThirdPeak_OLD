classdef GridEstimator < WellEstimator
    properties
        trajectories
        ellips
        drift
        nh
        DinEllipsOnly
    end
    methods(Static)
        function obj = GridEstimator(trajectories, ellips, drift, nh, DinEllipseOnly, Flag3d)
            obj.trajectories = trajectories;
            obj.ellips = ellips;
            obj.drift = drift;
            obj.nh = nh;
            obj.DinEllipseOnly = DinEllipseOnly;
            obj.Flag3d = Flag3d;
        end
        
        function D = estimateD()
            D = appUtilsEstimateD(obj.trajectories, obj.DinEllipseOnly, obj.ellips, obj.Flag3d);
        end
        
        function drift = getdrift()
            drift = obj.drift;
        end
        
        function nh = getnh()
            nh = obj.nh;
        end
    end
end