classdef PotWells
    properties 
        wells
        flag3d
    end
    methods
        function obj = PotWells(wells, flag3d)
            obj.wells = wells;
            obj.flag3d = flag3d;
        end
    end
end