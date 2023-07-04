classdef DensityParameters
    properties
        dx
        dopt
        filtNhSize
        flag3d
        dz
    end
    methods
        function obj=DensityParameters(dx, dopt, filtnhsize, flag3d, dz)
            obj.dx = dx;
            obj.dopt = dopt;
            obj.filtNhSize = filtnhsize;
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
        
        