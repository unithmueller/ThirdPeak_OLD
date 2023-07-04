classdef VectorMapWindows
    properties
        wins
        flag3d
    end
    methods 
        function obj=VectorMapWindows()
            obj.wins = [];
            obj.flag3d = 0;
        end
    end
    
    methods(Static)
        
        function mapwindows = gen_drift_maps(trajsw, opts, flag3d)
            mapwindows = VectorMapWindows();
            for i = 1:size(trajsw.wins,1)
                if flag3d == 0
                    if opts.filter
                        mapwindows.wins = [mapwindows.wins VectorMap.genDriftMapFiltered(SquareGrid.SquareGridbyTrajDx(trajsw.wins(i), opts.dx, opts.flag3d, opts.dz), trajsw.wins(i), opts)];
                    else
                        mapwindows.wins = [mapwindows.wins VectorMap.genDriftMap(SquareGrid.SquareGridbyTrajDx(trajsw.wins{i}, opts.dx, opts.flag3d, opts.dz), trajsw.wins(i), opts)];
                    end
                elseif flag3d == 1
                    if opts.filter
                        mapwindows.wins = [mapwindows.wins VectorMap.genDriftMapFiltered(SquareGrid.SquareGridbyTrajDx(trajsw.wins(i), opts.dx, opts.flag3d, opts.dz), trajsw.wins(i), opts)];
                    else
                        mapwindows.wins = [mapwindows.wins VectorMap.genDriftMap(SquareGrid.SquareGridbyTrajDx(trajsw.wins{i}, opts.dx, opts.flag3d, opts.dz), trajsw.wins(i), opts)];
                    end
                end
            end
        end
    end
end

                    
            