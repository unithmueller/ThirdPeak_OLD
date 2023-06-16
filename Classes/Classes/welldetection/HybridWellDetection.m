classdef HybridWellDetection
    properties
        estParams
        bestItShift
        name
        lastFitResults
        dxSeeds
        filtSeeds
        densityThresh
        seedDist
        dx
        maxSizeX
        maxSizeZ
        minPtsThres
        confEllPerc
        ItChooserParams
        flag3d
        dz
        params
        gDens
        dens
    end
    
    methods(Static)
        function obj = HybridWellDetection(expname, dxseeds, filtseeds, densitythresh,seeddist, dx, maxsizex, minptsthres, confellperc, estparams, bestitshift, itchooserparams, flag3d, dz, maxsizez)
            obj.name = expname;
            obj.dxSeeds = dxseeds;
            obj.filtSeeds = filtseeds;
            obj.densityThresh = densitythresh;
            obj.seedDist = seeddist;
            obj.dx = dx;
            obj.maxSizeX = maxsizex;
            obj.maxSizeZ = maxsizez;
            obj.minPtsThres = minptsthres;
            obj.confEllPerc = confellperc;
            obj.estParams = estparams;
            obj.bestItShift = bestitshift;
            obj.ItChooserParams = itchooserparams;
            obj.flag3d = flag3d;
            obj.dz = dz;
        end
        
        function name = getname()
            name = obj.name;
        end
        
        function res = WellFromSeedDx(trajs, seedpoint, dx, flag3d, dz)
            if flag3d == 0
                c = seedpoint;
                res = FitResult();
                maxItx = ceil(obj.maxSize/dx);
                k = 1;
                while k <= maxItx
                    rect = Rectangle(c,(2*k+1)*dx,0);
                    pts = appUtilspointsInReg(trajs,rect,0);
                    if size(pts) < obj.minPtsThres
                        res.addEmptyIteration();
                        k = k+1;
                        continue
                    end
                    ellFit = Ellippse.ellipse_from_pca(pts, obj.param.confEllPerc);
                    ell = ellFit.ell();
                    
                    trajs_in = appUtilstrajsInShape(trajs.traj, ell, flag3d);
                    
                    estparam = obj.params.estimatorparams;
                    if estparam.name == "GridEstimator"
                        estparam = estparam.copyChangeDx(dx);
                    end
                    est = WellEstimatorFactory(trajs, ell, estparam).getEst();
                    if exists("est", "var") == 0
                        res.addEmtpyIteration();
                        k = k+1;
                        continue
                    end
                    res.addIteration(ell, trajs_in.get_from_ids(),ellFit.S(), est);
                    k = k+1;
                end

            elseif flag3d == 1
                c = seedPoint;
                res = FitResult();
                maxItx = ceil(obj.maxSizeX/dx);
                maxItz = ceil(obj.maxSizeZ/dz);
                k = 1;
                while k <= maxItx
                    rect = Rectangle(c,[(2*k+1)*dx, (2*k+1)*dx, (2*k+1)*dz],1);
                    pts = appUtilspointsInReg(trajs,rect,1);
                    if size(pts) < obj.minPtsThres
                        res.addEmptyIteration();
                        k = k+1;
                        continue
                    end
                    ellFit = Ellippse.ellipse_from_pca(pts, obj.param.confEllPerc);
                    ell = ellFit.ell();
                    
                    trajs_in = appUtilstrajsInShape(trajs.traj, ell, flag3d);
                    
                    estparam = obj.params.estimatorparams;
                    if estparam.name == "GridEstimator"
                        estparam = estparam.copyChangeDx(dx);
                    end
                    est = WellEstimatorFactory(trajs, ell, estparam).getEst();
                    if exists("est", "var") == 0
                        res.addEmtpyIteration();
                        k = k+1;
                        continue
                    end
                    res.addIteration(ell, trajs_in.get_from_ids(),ellFit.S(), est);
                    k = k+1;
                end
            end
        end
        
        function fitres = fitWellFromSeed(trajs, seedPoint, flag3d)
           fitres =  WellFromSeedDx(trajs, seedPoint, obj.params.dx, flag3d, obj.params.dz);
        end
        
        function seeds = computeSeedsCenter(trajs)
            obj.gDens = SquareGrid(trajs, obj.params.dxSeeds);
            obj.dens = ScalarMap.genDensityMap(obj.gDens, trajs, DensityParameters(obj.params.dxSeeds, ScalarMap.DensityOption.DENS, obj.param.filtSeeds, obj.flag3d), obj.flag3d);
            seeds = appUtilsgetHighestdensityCells(obj.dens, obj.densitythresh, obj.flag3d);
        end
        
        function wells = detectWells(trajs)
            seedsPt = obj.computeSeedsCenter(trajs);
            itChooser = IterationChooser(obj.params.itChooserparam, trajs);
            detectedWells = [];
            for i = 1:size(seedsPt)
                fitRes = fitWellFromSeed(trajs, seedsPt(i));
                if exists("fitRes","val")
                    fitRes.setBestIt(itChooser);
                    tmpWell = fitRes.bestWell(trajs, params);
                    if exists("tmpWell", "var") && tmpWell.A > 0 && tmpWell.D > -1 && tmpWell.core.value > -1
                        detectedWells = [detectedWells, tmpWell];
                    end
                end
            end
            tokeep = appUtilsremove_overlapping_wells(detectedWells);
            obj.lastFitResults = [];
            for i = 1:size(tokeep)
                obj.lastFitResults = [obj.lastFitResult, tokeep(i).fitResult()];
            end
            wells = PotWells(tokeep);
        end
        
        function param = getParameters()
            param = obj.params;
        end
    end
end
            
                        
        
        
            
            
            
        