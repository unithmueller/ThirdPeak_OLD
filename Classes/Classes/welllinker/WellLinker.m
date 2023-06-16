classdef WellLinker
    properties
        winIdx
        wellIdx
    end
    
    methods(Static)
        function obj = WellLinker(wiIdx, weIdx)
            obj.winIdx = wiIdx;
            obj.wellIdx = weIdx;
        end
        
        function list = link(~)
            list = [];
        end
        
        function state = findfamily(windidx, links)
            state = 0;
            if links == 0
                state = -1;
            else
                for i = 1:size(links)
                    for j = 1:size(links.get(i))
                        wi = links.get(i,j);
                        if wi.wellIdx == windidx.wellIdx && wi.winIdx == widx.winIdx
                            state = i;
                        end
                    end
                    state = -1;
                end
            end
        end
    end
end
            