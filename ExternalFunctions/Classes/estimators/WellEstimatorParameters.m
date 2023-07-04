classdef WellEstimatorParameters
    properties
        estType
    end
    methods
        function obj=WellEstimatorParameters(estType)
            obj.estType = estType;
        end
    end
end