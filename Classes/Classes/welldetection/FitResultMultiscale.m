classdef FitResultMultiscale < FitResult
    properties
        results
        dxBest
        itChoose
    end
    
    methods(Static)
        function obj = FitResultMultiscale()
            obj = obj@FitResult();
            obj.results = cells();
            obj.dxBest = 0;
            obj.itChoose = [];
        end
        
        function res = getresults()
            res = obj.results;
        end
        
        function dx = getdxBest()
            dx = obj.dxBest;
        end
        
        function addFitResult(dx, fitres)
            obj.results{end} = [dx, fitres];
        end
        
        function setBestIt(chooser)
            obj.itChoose = chooser;
            for i = 1:size(obj.results,1)
                if obj.results{i} == emtpy
                    continue
                elseif choose.params.estPs.name == "GridEstParams"
                    itChoose = choose.cloneUpdateEstParams(GridEstimatorParameters(choose.ps.estPs).copyChangedx(dx));
                    obj.results{i}.setBestIt(itChoose);
                elseif bestScore == empty || obj.results{i}.bestScore().betterThan(bestScore)
                    bestScore = obj.results{i}.bestScore();
                    obj.dxBest = i;
                end
            end
        end
        
        function it = getbestIt()
            it = obj.results{obj.dxBest}.bestIt();
        end
        
        function potwell = getbestWell(trajs, params)
            if obj.dxBest == emtpy
                potwell = empty;
            else
                potwell = obj.results{obj.dxBest}.bestWell(trajs, params);
            end
        end
        
        function score = getscores()
            score = obj.results{obj.dxBest}.scores();
        end
        
        function computeBestDx()
            bestScore = empty;
            for i = 1:size(obj.results,1)
                if obj.results{i} == empty || obj.results{i}.bestScore() == WellScore.emtpy
                    continue
                elseif obj.bestScore == empty || obj.results{i}.bestScore().betterThan(bestScore)
                    bestScore = obj.results{i}.bestScore();
                    obj.dxBest = i;
                end
            end
        end
    end
end
                