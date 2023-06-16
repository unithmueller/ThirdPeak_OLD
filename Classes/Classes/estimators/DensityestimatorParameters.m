classdef DensityestimatorParameters < WellEstimatorParameters
    properties
        diffInWell
    end
    methods
        function obj=DensityestimatorParameters(estType, diffInwell)
            obj@WellEstimatorParameters(estType);
            obj.diffInWell = diffInwell;
        end
    end
end
        
        