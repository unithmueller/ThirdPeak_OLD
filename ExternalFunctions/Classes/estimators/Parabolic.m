classdef Parabolic < WellScore
    properties
    end
    methods(Static)
        function obj = Parabolic(value)
            obj = obj@WellScore(value);
        end
        function res = betterThan(other)
            if other == []
                res = 1;
            elseif obj.value < other.value
                res = 1;
            end
        end
        function res = WorstValue()
            res = 1.0;
        end
    end
end
                
                
            