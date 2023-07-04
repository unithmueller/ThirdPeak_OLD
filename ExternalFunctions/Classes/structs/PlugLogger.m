classdef PlugLogger
    properties
        maxWins;
        curWins;
    end
    
    methods(Static)
        function obj = PlugLogger()
            obj.maxWins = 0;
            obj.curWins = 0;
        end
        
        function setmaxWins(mw)
            obj.maxWins = mw;
        end
        
        function setcurWind(cw)
            obj.curWins = cw;
        end
        
        function mw = getMaxWind()
            mw = obj.maxWins;
        end
        
        function cw = getCurWin()
            cw = obj.curWins;
        end
    end
end
