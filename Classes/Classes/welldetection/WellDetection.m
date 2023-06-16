classdef WellDetection
    properties
        fitresult
    end
    
    methods(Static)
        function obj = WellDetection()
            fitresult = [];
        end
        
        function potwellwins = detectWellsTimeWindows(algo, trajs)
            res = PotWellsWindows();
            for i = 1:size(traj.wins)
                if traj.wins(i).trajs == empty()
                    res.wins = [res.wins, PotWells()];
                else
                    res.wins = [res.wins, algo.detectWells(trajs.wins(i))];
                end
            end
            potwellwins = res;
        end
        
        function fitr = lastFitResult()
            fitr = obj.fitresult;
        end
    end
end

            
            