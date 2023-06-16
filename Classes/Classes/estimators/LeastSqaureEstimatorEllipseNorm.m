classdef LeastSqaureEstimatorEllipseNorm < GridEstimator
    properties
    end
    methods(Static)
        function obj = LeastSqaureEstimatorEllipseNorm(traj, drift, nh, ellips, inEllipseOnly,Flag3d)
            obj = obj@GridEstimator(traj,ellips,drift,nh,inEllipseOnly,Flag3d);
        end
        
        function result = estimateA()
            if obj.Flag3d == 0
                num = 0.0;
                den = 0.0;
                for i =1:size(obj.nh,1)
                    gpos = obj.nh(i);
                    point = obj.drift.grid(gpos);
                    temppoint = [point(1) - obj.ellips.mu(1); point(2)-obj.ellips.mu(2)];
                    rot_point = appUtilsrotpoint(temppoint,obj.ellips.phi());
                    rot_drift = appUtilsrotpoint(obj.drift.drift(gpos),obj.ellips.phi());
                    
                    num = num + appUtilsvnorm([(rot_point(1)/obj.ellips.rad(1)^2) (rot_point(2)/obj.ellips.rad(2)^2)],0)*appUtilsvnorm(rot_drift,0);
                    den = den + ((rot_point(1)^2) / (obj.ellips.rad(1)^4))+ ((rot_point(2)^2) / (obj.ellips.rad(2)^4));
                end
                result = num/den/2;
                
            elseif obj.Flag3d == 1
                num = 0.0;
                den = 0.0;
                for i =1:size(obj.nh,1)
                    gpos = obj.nh(i);
                    point = obj.drift.grid(gpos);
                    temppoint = [point(1) - obj.ellips.mu(1); point(2)-obj.ellips.mu(2); point(3)-obj.ellips.mu(3)];
                    rot_point = appUtilsrotpoint(temppoint, obj.ellips.phi(),"xyz",1); % a bit more difficutl to do in 3d...
                    rot_drift = appUtilsrotpoint(obj.drift.drift(gpos),obj.ellips.phi,"xyz",1); % a bit more difficult to do in 3d
                    
                    num = num + appUtilsvnorm([(rot_point(1)/obj.ellips.rad(1)^2) (rot_point(2)/obj.ellips.rad(2)^2) (rot_point(3)/obj.ellips.rad(3)^2)],1)*appUtilsvnorm(rot_drift,1);
                    den = den + ((rot_point(1)^2) / (obj.ellips.rad(1)^4))+ ((rot_point(2)^2) / (obj.ellips.rad(2)^4))+ ((rot_point(3)^2) / (obj.ellips.rad(3)^4));
                end
                result = num/den/3; % i have no idea what i am doing....
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
                    num = num + appUtilsvnorm([((rot_drift(1)*rot_point(1)) / (obj.ellips.rad(1)^2)) ((rot_drift(2)*rot_point(2)) / (obj.ellips.rad(2)^2))],0)*appUtilsvonorm(rot_drift);
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
                    num = num + appUtilsvnorm([((rot_drift(1)*rot_point(1)) / (obj.ellips.rad(1)^2)) ((rot_drift(2)*rot_point(2)) / (obj.ellips.rad(2)^2)) ((rot_drift(3)*rot_point(3)) / (obj.ellips.rad(3)^2))],0)*appUtilsvonorm(rot_drift);
                    den = den + ((rot_point(1)^2) / (obj.ellips.rad(1)^4))+ ((rot_point(2)^2) / (obj.ellips.rad(2)^4))+ ((rot_point(3)^2) / (obj.ellips.rad(3)^4));
                end
                result = Wellscore.Parabolic(1-num^2/den/fnorm);
            end
        end
    end
end
            