classdef PotWellWindow < PotWell
    properties
        timeWin
        ell
        A
        D
        score
        flag3d
    end
    methods(Static)
        function obj = PotWellWindow(ellips, A, D, score, timeWin, flag3d)
            obj = obj@PotWell(ellips,A,D,score,flag3d);
            obj.timeWin = timeWin;
            obj.flag3d  = flag3d;
        end
        
        function obj = PotWellWindowbyPotwell(potwell, timewin, flag3d)
            obj.ell = potwell.ellips;
            obj.A = potwell.A;
            obj.D = potwell.D;
            obj.score = potwell.score;
            obj.timeWin = timewin;
            obj.flag3d = flag3d;
        end
   
        function win = getTimewin()
            win = obj.timeWin;
        end
    end
end
