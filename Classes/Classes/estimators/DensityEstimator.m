classdef DensityEstimator < WellEstimator
    %Estimator to work with the density of a well
    properties
        trajectories; %trajectories
        ellips; %ellips region to be considered
        DinEllipseOnly; %if only the ellips region is to be considered
        Cdiag; %covariance in ellipse rotated
        Flag3d; %if 3d or not
    end
    
    methods(Static)
        %Constructor
        function obj = DensityEstimator(trajs, ell, Cdiag, DinEll, Flag3d)
            if nargin == 0
                obj.trajectories = [];
                obj.ellips = [];
                obj.DinEllipseOnly = 0;
                obj.Cdiag = [];
                obj.Flag3d = 0;
            elseif nargin == 4
                obj.trajectories = trajs;
                obj.ellips = ell;
                obj.DinEllispeOnly = DinEll;
                obj.Cdiag = Cdiag;
                obj.Flag3d = Flag3d;
            end
        end
        
        function a = Aformula(Cdiag, rads, D, Flag3d)
            %is 3d or not, calculates A in ellipse using diffusion values
            if nargin <= 3 || Flag3d == 0
                a = ((D*rads(1)^2/Cdiag(1)) + (D*rads(2)^2/Cdiag(2)))/4;
            elseif nargin == 4 || Flag3d == 1
                a = ((D*rads(1)^2/Cdiag(1))+(D*rads(2)^2/Cdiag(2))+(D*rads(3)^2/Cdiag(3)))/8; %need to check if this checks out in 3d
            end
        end
        
        function A = estimateA()
            d = obj.estimateD();
            A = obj.Aformula(obj.Cdiag, obj.ell.rad(), d);
        end
        
        function D = estimateD()
          D = appUtilsEstimateD(obj.trajectories, obj.DinEll, obj.ellips, obj.Flag3d);
        end
        
        function estimateScore()
            error("Unsuportet Operation");
        end
    end
end           