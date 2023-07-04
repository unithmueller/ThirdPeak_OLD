classdef ScalarMapWindows
    properties
        windows
    end
    
    methods
        function obj = ScalarMapWindows()
            obj.windows = [];
        end

        function vals = getValues(obj)
            vals = obj.windows.getValues();
        end
        
        function pos = getPositions(obj)
            pos = obj.windows.getPositions();
        end
        
        function maxss = getmaxs(obj)
            maxss = zeros(size(obj.windows));
            for i = 1:size(obj.windows)
                maxss(i) = max(obj.windows.get(i));
            end
        end
    end
    
    methods(Static)
        
        function scalmapwins = gen_density_maps(trajsw, params)
            scalmapwins = ScalarMapWindows();
            for i = 1:size(trajsw.wins,1)
                scalmapwins.windows  = [scalmapwins.windows, ScalarMap.genDensityMap(SquareGrid.SquareGridbyTrajDx(trajsw.wins{i,1}, params.dx, params.flag3d, params.dz), trajsw.wins{i,1}, params)];
            end
        end
        
        function scalmapwins = gen_diffusion_maps(trajsw, params)
            scalmapwins = ScalarMapWindows();
            for i = 1:size(trajsw.wins,1)
                if params.filter
                    scalmapwins.windows = [scalmapwins.windows, ScalarMap.genDiffusionMapFiltered(SquareGrid.SquareGridbyTrajDx(trajsw.wins{i,1}, params.dx, params.flag3d, params.dz), trajsw.wins{i,1}, params)];
                else
                    scalmapwins.windows = [scalmapwins.windows, ScalarMap.genDiffusionMap(SquareGrid.SquareGridbyTrajDx(trajsw.wins{i,1}, params.dx, params.flag3d, params.dz), trajsw.wins{i,1}, params)];
                end
            end
        end
    end
end
                    
        
        
            