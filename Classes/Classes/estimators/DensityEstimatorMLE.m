classdef DensityEstimatorMLE < WellEstimator
    %Estimate the density with maximum likelihood method
    properties
        trajectories
        ellips
        Cdiag
        MaxLikeEstimator
        Flag3d
    end
    methods(Static)
        %constructor
        function obj=DensityEstimatorMLE(trajs, ellip, Cdiag, Flag3d)
            if nargin < 3
                obj.trajectories = [];
                obj.ellips = [];
                obj.Cdiag = [];
                obj.Flag3d = 0;
            elseif nargin == 3
                obj.trajectories = trajs;
                obj.ellips = ellip;
                obj.Cdiag = Cdiag;
                obj.Flag3d = 0;
            elseif nargin == 4
                obj.trajectories = trajs;
                obj.ellips = ellip;
                obj.Cdiag = Cdiag;
                obj.Flag3d = Flag3d;
            
            obj.MaxLikeEstimator = MaxLikelihoodEstimator(appUtilstrajsInShape(obj.trajectories, obj.ellips, obj.Flag3d), obj.trajectories.acqDT, obj.ellips);
            end
        end
        
        function A = estimateA()
            d = obj.estimateD();
            A = DensityEstimator.Aformula(obj.Cdiag, obj.ell.rad(),D, obj.Flag3d);
        end
        
        function D = estimateD()
            obj.MaxLikeEstimator.estimateD();
        end
        
        function estimateScore()
            error("Error in DensityEstimatorMLE");
        end
    end
end
            
            