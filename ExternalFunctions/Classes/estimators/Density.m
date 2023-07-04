classdef Density < WellScore
    properties
    end
    methods(Static)
        function obj=Density(value)
            obj=obj@WellScore(value);
        end
        function res = betterThan(other)
            if other == []
                res = 1;
            elseif obj.value > other.value
                res = 1;
            end
        end
        function res = worstValue()
            res = -inf;
        end
    end
end