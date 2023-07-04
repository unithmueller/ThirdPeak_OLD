classdef MaxLikelihoodEstimator < WellEstimator
    properties
        trajs
        dt
        lambdaEst
        DVecEst
        Aest
        Dest
        ellips
    end
    
    methods(Static)
        function obj = MaxLikelihoodEstimator(trajs, dt, ellips, flag3d)
            obj.trajs = trajs;
            obj.dt = dt;
            obj.ellips = ellips;
            obj.lambdaEst = 0;
            obj.DVecEst = 0;
            obj.Aest = -1;
            obj.Dest = -1;
            obj.Flag3d = flag3d;
        end
        
        function estimateMLE()
            p1 = zeros(1,3);
            p2 = zeros(1,3);
            p3 = zeros(1,3);
            p4 = zeros(1,3);
            n = 0;
            
            uniqtraj = unique(obj.trajs(:,1));
            for i = 1:size(uniqtraj)
                singletraj = obj.trajs(uniqtraj(i),:);
                for j = 2:size(singletraj,1)
                    p1add = singletraj(j,3:5).*singletraj(j-1,3:5);
                    p2add = singletraj(j,3:5);
                    p3add = singletraj(j-1,3:5);
                    p4add = singletraj(j-1,3:5).^2;
                    
                    p1 = p1 + p1add;
                    p2 = p2 + p2add;
                    p3 = p3 + p3add;
                    p4 = p4 + p4add;
                    n = n + 1;
                end
            end
            
            if obj.Flag3d == 0
                beta1 = zeros(1,2);
                beta1(1) = (p1(1)/n-(p2(1)*p3(1))/(n*n))/(p4(1)/n-(p3(1)^2)/(n*n))+4/n;
                beta1(2) = (p1(2)/n-(p2(2)*p3(2))/(n*n))/(p4(2)/n-(p3(2)^2)/(n*n))+4/n;
                
                p1 = zeros(1,2);
                for i = 1:size(uniqtraj)
                    singletraj = obj.traj(uniqtraj(i),:);
                        for j = 2:size(singletraj,1)
                            p1add = [singletraj(j,3)-beta1(1)*singletraj(j-1,3) singletraj(j,4)-beta1(2)*singletraj(j-1,4)];
                            p1 = p1 + p1add;
                        end
                end
                
                beta2 = [p1(1)/n/(1-beta1(1)) p1(2)/n/(1-beta1(2))];
                p1 = zeros(1,2);
                for i = 1:size(uniqtraj)
                    singletraj = obj.traj(uniqtraj(i),:);
                        for j = 2:size(singletraj,1)
                            p1add = [(singletraj(j,3)-beta1(1)*singletraj(j-1,3)-beta2(1)*(1-beta1(1)))^2 (singletraj(j,4)-beta1(2)*singletraj(j-1,4)-beta2(2)*(1-beta1(2)))^2];
                            p1 = p1 + p1add;
                        end
                end
                
                beta3 = [p1(1)/n p1(2)/n];
                obj.lambdaEst = [-log(beta1(1))/obj.dt -log(beta1(2))/obj.dt];
                obj.Aest = (obj.lambdaEst(1)*(obj.ellips.rad(1)^2)/2 + obj.lambdaEst(2)*(obj.ellips.rad(2)^2)/2)/2;
                obj.DVecEst = [(obj.lambdaEst(1)*beta3(1))/(1-beta(1)^2) (obj.lambdaEst(2)*beta3(2))/(1-beta(2)^2)];
                obj.Dest = (obj.DVecEst(1)+obj.DVecEst(2))/2;
                
            elseif obj.Flag3d == 1
                beta1 = zeros(1,3);
                beta1(1) = (p1(1)/n-(p2(1)*p3(1))/(n*n))/(p4(1)/n-(p3(1)^2)/(n*n))+4/n;
                beta1(2) = (p1(2)/n-(p2(2)*p3(2))/(n*n))/(p4(2)/n-(p3(2)^2)/(n*n))+4/n;
                beta1(3) = (p1(3)/n-(p2(3)*p3(3))/(n*n))/(p4(3)/n-(p3(3)^2)/(n*n))+4/n;
                
                p1 = zeros(1,3);
                for i = 1:size(uniqtraj)
                    singletraj = obj.traj(uniqtraj(i),:);
                        for j = 2:size(singletraj,1)
                            p1add = [singletraj(j,3)-beta1(1)*singletraj(j-1,3) singletraj(j,4)-beta1(2)*singletraj(j-1,4) singletraj(j,5)-beta1(3)*singletraj(j-1,5)];
                            p1 = p1 + p1add;
                        end
                end
                
                beta2 = [p1(1)/n/(1-beta1(1)) p1(2)/n/(1-beta1(2)) p1(3)/n/(1-beta1(3))];
                p1 = zeros(1,3);
                for i = 1:size(uniqtraj)
                    singletraj = obj.traj(uniqtraj(i),:);
                        for j = 2:size(singletraj,1)
                            p1add = [(singletraj(j,3)-beta1(1)*singletraj(j-1,3)-beta2(1)*(1-beta1(1)))^2 (singletraj(j,4)-beta1(2)*singletraj(j-1,4)-beta2(2)*(1-beta1(2)))^2 (singletraj(j,5)-beta1(3)*singletraj(j-1,5)-beta2(3)*(1-beta1(3)))^2];
                            p1 = p1 + p1add;
                        end
                end
                
                beta3 = [p1(1)/n p1(2)/n p1(3)/n];
                obj.lambdaEst = [-log(beta1(1))/obj.dt -log(beta1(2))/obj.dt -log(beta1(3))/obj.dt];
                obj.Aest = (obj.lambdaEst(1)*(obj.ellips.rad(1)^2)/2 + obj.lambdaEst(2)*(obj.ellips.rad(2)^2)/2 + obj.lambdaEst(3)*(obj.ellips.rad(3)^2)/2)/2;
                obj.DVecEst = [(obj.lambdaEst(1)*beta3(1))/(1-beta(1)^2) (obj.lambdaEst(2)*beta3(2))/(1-beta(2)^2) (obj.lambdaEst(3)*beta3(3))/(1-beta(3)^2)];
                obj.Dest = (obj.DVecEst(1)+obj.DVecEst(2)+obj.DVecEst(3))/3;
            end
        end
        
        function Aest = estimateA()
            if obj.Aest == -1
                obj.estimateMLE();
                Aest = obj.Aest;
            end
        end
        
        function D = estimateD()
            if Dest == -1
                obj.estimateMLE();
                D = obj.Dest;
            end
        end
        
        function score = estimateScore()
            score = WellScore.Likelihood(wellLogLokelihoodxy(obj.trajs, obj.ellips.mu, obj.lambdaEst, lbj.DVecEst, obj.dt));
        end
        
        function lambda = estimateLambda()
            if obj.lambdaEst == 0
                obj.estimateMLE();
            end
            lambda = obj.lambdaEst;
        end
        
        function DVec = estimtaeDVec()
            if obj.DVecEst == 0
                obj.estimateMLE();
            end
            DVec = obj.DVecEst;
        end
        
        function res = wellLogLikelihood(trajs, muEst, lambdaEst, Dest, dt, Flag3d)
            N = 0;
            res = 0;
            uniqtraj = unique(trajs(:,1));
            for i = 1:size(uniqtraj)
                singletraj = obj.trajs(uniqtraj(i),:);
                for j = 1:size(singletraj,1)
                    p1 = singletraj(j,3:5);
                    p2 = singletraj(j+1,3:5);
                    temp = [p2(1)-muEst(1)-(p1.(1)-muEst(1))*exp(-lambdaEst*dt) p2(2)-muEst(2)-(p1.(2)-muEst(2))*exp(-lambdaEst*dt) p2(3)-muEst(3)-(p1.(3)-muEst(3))*exp(-lambdaEst*dt)];
                    if Flag3d == 0
                        res = res + ( (temp(1)^2+temp(2)^2)*lambdaEst/(Dest*(1-exp(-2*lambdaEst*dt))));
                    elseif Flag3d == 1
                        res = res + ( (temp(1)^2+temp(2)^2+temp(3)^2)*lambdaEst/(Dest*(1-exp(-2*lambdaEst*dt))));
                    end
                    N = N+1;
                end
            end
            res = res/N;
        end
        
        function res = wellLogLikelihoodXY(trajs, muEst, lambdaEst, Dest, dt, Flag3d)
            res = 0;
            uniqtraj = unique(trajs(:,1));
            for i = 1:size(uniqtraj)
                singletraj = obj.trajs(uniqtraj(i),:);
                for j = 1:size(singletraj,1)
                    p1 = singletraj(j,3:5);
                    p2 = singletraj(j+1,3:5);
                    temp = [p2(1)-muEst(1)-(p1.(1)-muEst(1))*exp(-lambdaEst*dt) p2(2)-muEst(2)-(p1.(2)-muEst(2))*exp(-lambdaEst*dt) p2(3)-muEst(3)-(p1.(3)-muEst(3))*exp(-lambdaEst*dt)];
                    if Flag3d == 0
                        res = res + ((temp(1)^2)*lambdaEst(1)/(Dest(1)*(1-exp(-2*lambdaEst(1)*dt)))+ (temp(2)^2)*lambdaEst(2)/(Dest(2)*(1-exp(-2*lambdaEst(2)*dt))));
                    elseif Flag3d == 1
                        res = res + ((temp(1)^2)*lambdaEst(1)/(Dest(1)*(1-exp(-2*lambdaEst(1)*dt)))+ (temp(2)^2)*lambdaEst(2)/(Dest(2)*(1-exp(-2*lambdaEst(2)*dt)))+ (temp(3)^2)*lambdaEst(3)/(Dest(3)*(1-exp(-2*lambdaEst(3)*dt))));
                    end
                end
            end
        end
    end
end
            
            
                
                
                
                            
                
                
                
            
        