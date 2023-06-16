classdef WellScore
    %Stores the Score of the Well as well as the type of the score
    properties
        type %1 = Empty, 2=Parabolic, 3=Likelihood, 4=Density
        value
    end
    methods
        %Constructor
        function obj = WellScore(type, value)
            obj.type = type;
            obj.value = value;
        end
        %retunrs the value of the score
        function val = getValue(obj)
            val = obj.value;
        end
        %checks the type and if the type matches, check if it better or not
        function result = isBetterThan(obj, other)
            arguments
                obj WellScore
                other WellScore
            end
            %Empty
            if obj.type == 1
                result = 0;
                warning("Is Empty");
            %Parabolic
            elseif obj.type == 2
                if obj.type == other.type
                    result = obj.value < other.getValue();
                elseif other.type == 1
                    result = 1;
                else
                    result = 0;
                    warning("Types dont match");
                end
            %Likelihood    
            elseif obj.type == 3
                if obj.type == other.type
                    result = obj.value > other.getValue();
                elseif other.type == 1
                    result = 1;
                else
                    result = 0;
                    warning("Types dont match");
                end
            %Density    
            elseif obj.type == 4
                if obj.type == other.type
                    result = obj.value > other.getValue();
                elseif other.type == 1
                    result = 1;
                else
                    result = 0;
                    warning("Types dont match");
                end
            end
        end
        %Gets the worst value possible for given type
        function result = worstValue(obj)
            %Emtpy
            if obj.type == 1
                result = NaN;
            elseif obj.type == 2
                result = 1.0;
            elseif obj.type == 3
                result = -Inf;
            elseif obj.type == 4
                result = -Inf;
            end
        end
    end
end