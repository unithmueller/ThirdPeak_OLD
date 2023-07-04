classdef testclass
    properties 
        prop1 (1,1) double {mustBePositive} = 1
        prop2
        prop3
    end
    
    methods
        function obj = testclass(pr1, pr2, pr3)
            obj.prop1 = pr1;
            obj.prop2 = pr2;
            obj.prop3 = pr3;
        end
        
        function val = calcdiv(obj, pr4)
            val = obj.prop1/pr4;
        end
        
        function obj = set.prop1(obj, value)
            obj.prop1 = value;
        end
        
        function val = calmul(obj)
            val = obj.prop2*obj.prop3;
        end
    end
end