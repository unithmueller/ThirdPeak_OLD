classdef PotWellsWindows
    properties
        wins
        linker
        links
        flag3d
    end
    methods(Static)
        function obj = PotWellsWindows(wells, flag3d)
            obj.wins = wells;
            obj.flag3d = flag3d;
            obj.linker = [];
            obj.links = [];
        end
        
        function res = flattenArray()
            res = reshapte(obj.wins,1,[]);
        end
            
        function linkWells(linker)
            obj.linker = linker;
            obj.links = linker.link(obj);
        end
        
        function links = getlinks()
            links = obj.links;
        end
        
        function linker = getLinker()
            linker = obj.linker;
        end
    end
end