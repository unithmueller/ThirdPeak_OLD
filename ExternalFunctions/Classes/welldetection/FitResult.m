classdef FitResult
    properties
        ellips
        pcaSs
        trajids
        estimators
        scores
        isemtpy
        numIt
        itChooser
        bestIt
    end
    
    methods(Static)
        function obj = FitResult()
            obj.ellips = [];
            obj.pcaSs = [];
            obj.trajids = [];
            obj.estimators = [];
            obj.scores = [];
            obj.isemtpy = [];
            obj.numIt = 0;
            obj.bestIt = -1;
            obj.itChooser = [];
        end
        
        function el = getellips()
            el = obj.ellips;
        end
        
        function ids = getrajids()
            ids = obj.trajids;
        end
        
        function es = getestimators()
            es = obj.estimators;
        end
        
        function pca = getpcaSs()
            pca = obj.pcaSs;
        end
        
        function em = getisemtpy()
            em = obj.isempty;
        end
        
        function nu = getnumit()
            nu = obj.numIt;
        end
        
        function best = getbestIt()
            best = obj.bestIt;
        end
        
        function setBestIt(choose)
            obj.itChooser = choose;
            obj.bestIt = choose.bestIteration(obj);
        end
        
        function setScore(iteration, wellscore)
            obj.scores.set(iteration,wellscore);
        end
        
        function score = getscores()
            score = obj.scores;
        end
        
        function score = getbestScore()
            if obj.bestIt == -1
                score = -1;
            else
                score = obj.scores(obj.bestIt);
            end
        end
        
        function addIteration(ellips, trajids, pcaS, estimator)
            obj.ellips = [obj.ellips, ellips];
            obj.pcaSs = [obj.pcaSs, pcaS];
            obj.trajsid = [obj.trajids, trajids];
            obj.estimators = [obj.estimators, estimator];
            obj.scores = [obj.scores, WellScore.empty];
            obj.isempty = [obj.isempty, 0];
            obj.numIt = obj.numIt + 1;
        end
        
        function addemptyIteration()
            obj.ellips = [obj.ellips, 0];
            obj.pcaSs = [obj.pcaSs, 0];
            obj.trajsid = [obj.trajids, 0];
            obj.estimators = [obj.estimators, 0];
            obj.scores = [obj.scores, WellScore.empty];
            obj.isempty = [obj.isempty, 1];
            obj.numIt = obj.numIt + 1;
        end
        
        function potwell = getBestWell(trajs, params)
            if obj.bestIt < 0
                potwell = [];
            else
                A = -inf;
                computed = 0;
                if A == -inf
                    for it = obj.bestIt+params.bestItShift:-1:obj.bestIt
                        if it >= obj.ellips.size || obj.isempty(it)
                            continue
                        end
                        pts = appUtilspointsInReg(trajs, obj.ellips, params.flag3d);
                        if size(pts,1) <= 5
                            continue
                        else
                            computed = 1;
                            A = obj.ests.it.estimateA();
                        end
                    end
                    if computed == 0
                        potwell = [];
                    else
                        D = obj.ests.it.estimateD();
                    end
                    potwell = [];
                    if params.algoname == "DensityMLE"
                        potwell = PotWell(obj.ellips.bestIt, A, D, FitResultDensity(obj).densScores.bestIt);
                    else
                        potwell = PotWell(obj.ellips.bestIt,A,D,obj.scores.bestIt);
                        potwell.attachFitResult(obj);
                    end
                end
            end
        end
    end
end
                    
                    
                        
                    
                
        
            