classdef DistanceWellLinker<WellLinker
    properties
        maxFrameGap
        maxDist
    end
    
    methods(Static)
        function obj = DistanceWellLinker(maxframe, maxdist)
            obj.maxFrameGap = maxframe;
            obj.maxDist = maxdist;
        end
        
        function fg = getMaxFrameGap()
            fg = obj.maxFrameGap;
        end
        
        function md = getMaxDist()
            md = obj.maxDist;
        end
        
        function list = linkWins(wellWins, flag3d)
            res = cells(size(wellWins.wins)-1);
            curWin = wellWins.wins(end).wells;
            cnt = 1;
            for i = 1:size(curWin)
                res{cnt}  = [size(wellsWins.wins),i];
                cnt = cnt + 1;
            end
            for i = size(wellWins.wins)-2:-1:0
                for k = 1:size(wellWins.wins(i).wells)
                    potwell = wellWins.wins(i).wells(k);
                    added = 0;
                    for j = 1:cnt
                        windowidx = res{j}(:);
                        p1 = wellWins.wins{windowidx(1)}.wells{windowidx(2)}.ell.mu;
                        p2 = potwell.ell.mu;
                        if windowidx-i <= obj.maxFrameGap && appUtilsSquaredDist(p1,p2,flag3d) < obj.maxDist^2
                            res{j} = [[i,k], res{j}];
                            added = 1;
                            break
                        end
                    end
                    if added == 0
                        res{cnt} = [i,k];
                        cnt = cnt +1;
                    end
                end
            end
            list = res;
        end
    end
end
                        
                
            
        