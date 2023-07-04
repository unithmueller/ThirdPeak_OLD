classdef MLEEstimatorParameters < WellEstimatorParameters
    properties
    end
    methods
        function obj = MLEEstimatorParameters(estType)
            obj = obj@WellEstimatorParameters(estType);
        end
    end
end
