classdef LeastSquareEstimatorCircle < GridEstimator
    properties
        flag3d
    end
    methods(Static)
        function obj=LeastSquareEstimatorCircle(trajs, drift, nh, ellips, Dinellips, flag3d)
            obj=obj@GridEstimator(trajs, ellips, drift, nh, Dinellips,flag3d);
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
                    
                    num = num + rot_drift(1)*rot_point(1)+rot_drift(1)*rot_point(1);
                    den = den + rot_point(1)^2+rot_point(2)^2;
                end
                result = -(obj.ellips.rad(1)^2)*num/den/2;
                
            elseif obj.Flag3d == 1
                num = 0.0;
                den = 0.0;
                for i =1:size(obj.nh,1)
                    gpos = obj.nh(i);
                    point = obj.drift.grid(gpos);
                    temppoint = [point(1) - obj.ellips.mu(1); point(2)-obj.ellips.mu(2); point(3)-obj.ellips.mu(3)];
                    rot_point = appUtilsrotpoint(temppoint, obj.ellips.phi(),"xyz",1); % a bit more difficutl to do in 3d...
                    rot_drift = appUtilsrotpoint(obj.drift.drift(gpos),obj.ellips.phi,"xyz",1); % a bit more difficult to do in 3d
                    
                    num = num + rot_drift(1)*rot_point(1)+rot_drift(1)*rot_point(1)+rot_drift(3)*rot_point(3);
                    den = den + rot_point(1)^2+rot_point(2)^2+rot_point(3)^2;
                end
                result = -(obj.ellips.rad(1)^2)*num/den/2;
            end
        end
        
        function result = estimateScore()
            if obj.Flag3d == 0
                num = 0.0;
                ptSum = 0.0;
                fieldSum = 0.0;
                for i =1:size(obj.nh,1)
                    gpos = obj.nh(i);
                    point = obj.drift.grid(gpos);
                    temppoint = [point(1) - obj.ellips.mu(1); point(2)-obj.ellips.mu(2)];
                    rot_point = appUtilsrotpoint(temppoint,obj.ellips.phi());
                    rot_drift = appUtilsrotpoint(obj.drift.drift(gpos),obj.ellips.phi());

                    num = num + (rot_point(1)*rot_drift(1)+rot_point(2)*rot_drift(2));
                    ptSum = ptSum + ((rot_point(1)^2) + (rot_point(1)^2));
                    fieldSum = fieldSum + (rot_drift(1)^2 + rot_drift(2)^2);
                end
                result = Wellscore.Parabolic(1-(num^2)/(ptSum*fieldSum));
            elseif obj.Flag3d == 1
                num = 0.0;
                ptSum = 0.0;
                fieldSum = 0.0;
                for i =1:size(obj.nh,1)
                    gpos = obj.nh(i);
                    point = obj.drift.grid(gpos);
                    temppoint = [point(1) - obj.ellips.mu(1); point(2)-obj.ellips.mu(2); point(3)-obj.ellips.mu(3)];
                    rot_point = appUtilsrotpoint(temppoint, obj.ellips.phi(),"xyz",1); % a bit more difficutl to do in 3d...
                    rot_drift = appUtilsrotpoint(obj.drift.drift(gpos),obj.ellips.phi,"xyz",1); % a bit more difficult to do in 3d
                    
                    num = num + (rot_point(1)*rot_drift(1)+rot_point(2)*rot_drift(2)+rot_point(3)*rot_drift(3));
                    ptSum = ptSum + ((rot_point(1)^2) + (rot_point(2)^2)+ (rot_point(3)^2));
                    fieldSum = fieldSum + (rot_drift(1)^2 + rot_drift(2)^2 + rot_drift(3)^2);
                end
                result = Wellscore.Parabolic(1-(num^2)/(ptSum*fieldSum));
            end
        end
        
    end
end
