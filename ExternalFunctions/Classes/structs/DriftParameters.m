classdef DriftParameters
    properties
        dx
        nPts
        filter
        filtersize
        flag3d
        dz
    end
    methods
        function obj = DriftParameters(dx, nump, filter, filtersize, flag3d, dz)
            obj.dx = dx;
            obj.nPts = nump;
            obj.filter = filter;
            obj.filtersize = filtersize;
            obj.flag3d = flag3d;
            obj.dz = dz;
        end
        
        function res = isequal(object)
            if obj == object
                res = 1;
            else
                res = 0;
            end
        end
    end
end