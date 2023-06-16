classdef PotWell
    %Describes the attraction force for particles in a given region
    properties
        ellips Ellippse
        A (1,1)
        D (1,1)
        score WellScore
        fitRes
        correctedD
        flag3d (1,1)
    end
    methods
        %Constructor
        function obj = PotWell(ell,a,d,score, flag3d)
            obj.ellips = ell;
            obj.A = a; %attraction coeff
            obj.D = d; %Diff coeff
            obj.score = score;
            obj.flag3d = flag3d;
            obj.correctedD = 0;
            obj.fitRes = [];
        end
        %adds a fit result to the class
        function obj = attachFitResult(obj, fitres)
            obj.fitRes = fitres;
        end
        %Returns the ellipse in the potwell
        function ell = getEllips(obj)
            ell = obj.ellips;
        end
        %Retruns the score of the pot well
        function score = getScore(obj)
            score = obj.score;
        end
        %Returns the attraction coefficient of the potwell
        function a = getA(obj)
            a = obj.A;
        end
        %Returns the diffusion coefficient
        function d = getD(obj)
            d = obj.D;
        end
        %
        function time = getResidenceTime(obj)
            if obj.flag3d == 0
                time = obj.ellips.rad(1)*obj.ellips.rad(2)*obj.D / (4*obj.A*obj.A)*exp(obj.A/obj.D);
            elseif obj.flag3d == 1
                time = (4/3)*obj.ellips.rad(1)*obj.ellips.rad(2)*obj.ellips.rad(3)*obj.D / (4*obj.A*obj.A)*exp(obj.A/obj.D);
            end
        end
        
        function res = getFitresult()
            res = obj.fitRes;
        end
        
        function res = getDcorrected(dt)
            a = obj.ellips.rad(1);
            b = obj.ellips.rad(2);
            c = obj.ellips.rad(3);
            if flag3d == 0
                lambda = (2*obj.A/(a*a)+2*obj.A/(b*b))/2;
                res = obj.D*(1+lambda*dt);
            elseif flag3d == 1
                lambda = (2*obj.A/(a*a)+2*obj.A/(b*b)+2*obj.A/(c*c))/3;
                res = obj.D*(1+lambda*dt);
            end
        end
        
        function correctD(dt)
            if obj.correctedD == 0
                obj.D = obj.getDcorrected(dt);
                obj.correcteD = 1;
            end
        end
    end
end
                
            
            
            
            