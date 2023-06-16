classdef LeastSquareEstimatorEllipseNormFit < GridEstimator
    properties
    end
    
    methods(Static)
        function obj = LeastSquareEstimatorEllipseNormFit(traj, drift, nh, ellips, inEllipseOnly, Flag3d)
            obj = obj@GridEstimator(traj, ellips, drift, nh, inEllipseOnly, Flag3d);
        end
        
        function result = estimateA()
            if Flag3d == 0
                xs = zeros(size(obj.nh));
                ys = zeros(size(obj.nh));

                for i = 1:size(obj.nh)
                    gpos = nh(i);
                    pos = obj.drift.grid(gpos);
                    pos(1) = pos(1) - obj.ellips.mu(1);
                    pos(2) = pos(2) - obj.ellips.mu(2);
                    xs(i) = appUtilsvnorm(pos,0);
                    ys(i) = appUtilsvnorm(drift(gpos),0);
                end
                fit = polyfit(xs,ys,1);

                result = fit * obj.ellips.rad(1)^2 / 2;
            elseif Flag3d == 1
                xs = zeros(size(obj.nh));
                ys = zeros(size(obj.nh));

                for i = 1:size(obj.nh)
                    gpos = nh(i);
                    pos = obj.drift.grid(gpos);
                    pos(1) = pos(1) - obj.ellips.mu(1);
                    pos(2) = pos(2) - obj.ellips.mu(2);
                    pos(3) = pos(3) - obj.ellips.mu(3);
                    xs(i) = appUtilsvnorm(pos,1);
                    ys(i) = appUtilsvnorm(drift(gpos),1);
                end
                fit = polyfit(xs,ys,1);

                result = fit * obj.ellips.rad(1)^2 / 2;
            end
        end
        
        function result = estimateScore()
            if obj.Flag3d == 0
                fnorm = 0.0;
                num = 0.0;
                den = 0.0;
                for i =1:size(obj.nh,1)
                    gpos = obj.nh(i);
                    point = obj.drift.grid(gpos);
                    temppoint = [point(1) - obj.ellips.mu(1); point(2)-obj.ellips.mu(2)];
                    rot_point = appUtilsrotpoint(temppoint,obj.ellips.phi());
                    rot_drift = appUtilsrotpoint(obj.drift.drift(gpos),obj.ellips.phi());

                    fnorm = fnorm + (rot_drift(1)^2+rot_drift(2)^2);
                    num = num + ((rot_drift(1)*rot_point(1)) / (obj.ellips.rad(1)^2)) + ((rot_drift(2)*rot_point(2)) / (obj.ellips.rad(2)^2));
                    den = den + ((rot_point(1)^2) / (obj.ellips.rad(1)^4))+ ((rot_point(2)^2) / (obj.ellips.rad(2)^4));
                end
                result = Wellscore.Parabolic(1-num^2/den/fnorm);
            elseif obj.Flag3d == 1
                num = 0.0;
                den = 0.0;
                for i =1:size(obj.nh,1)
                    gpos = obj.nh(i);
                    point = obj.drift.grid(gpos);
                    temppoint = [point(1) - obj.ellips.mu(1); point(2)-obj.ellips.mu(2); point(3)-obj.ellips.mu(3)];
                    rot_point = appUtilsrotpoint(temppoint, obj.ellips.phi(),"xyz",1); % a bit more difficutl to do in 3d...
                    rot_drift = appUtilsrotpoint(obj.drift.drift(gpos),obj.ellips.phi,"xyz",1); % a bit more difficult to do in 3d
                    
                    fnorm = fnorm + (rot_drift(1)^2+rot_drift(2)^2+rot_drift(3)^2);
                    num = num + ((rot_drift(1)*rot_point(1)) / (obj.ellips.rad(1)^2)) + ((rot_drift(2)*rot_point(2)) / (obj.ellips.rad(2)^2)) + ((rot_drift(3)*rot_point(3)) / (obj.ellips.rad(3)^2));
                    den = den + ((rot_point(1)^2) / (obj.ellips.rad(1)^4))+ ((rot_point(2)^2) / (obj.ellips.rad(2)^4))+ ((rot_point(3)^2) / (obj.ellips.rad(3)^4));
                end
                result = Wellscore.Parabolic(1-num^2/den/fnorm);
            end
        end
    end
end