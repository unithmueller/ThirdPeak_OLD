classdef DensityWellDetection < WellDetection
    properties
        dx
        densityThresh
        seedDist
        dr
        localGridDx
        localGridSize
        rMin
        rMax
        ratMaxDist
        itChooserparam
        flag3d
        dz
        griddz
        lastFitResult
    end
    
    methods(Static)
        function obj = DensityWellDetection(expname, dx, densitythres, seeddist, localgriddx, localgridsize, dr, rmin, rmax, ratmaxdist, estparams, itchooserparams, flag3d, dz, griddz)
            obj = obj@WellDetection(expname,estparams,0);
            obj.dx = dx;
            obj.densitythresh = densitythres;
            obj.seedDist = seeddist;
            obj.localGridDx = localgriddx;
            obj.localGridSize = localgridsize;
            obj.dr = dr;
            obj.rMin = rmin;
            obj.rMax = rmax;
            obj.ratMaxDist = ratmaxdist;
            obj.itChooserparam = itchooserparams;
            obj.flag3d = flag3d;
            obj.dz = dz;
            obj.griddz = griddz;
            obj.lastFitReulst = [];
        end
        
        function name = getalgoName()
            name = obj.expname;
        end
        
        function res = getRatioAndAngleFromCov(covmatrix)
            if flag3d == 0
                [U,S,~] = svd(covmatrix);
                first = 1;
                if S(1) < S(2)
                    tmp = S(1);
                    S(1) = S(2);
                    S(2) = tmp;
                    first = 2;
                end
                if U(1,first) < 0
                    U = -U;
                end
                v1 = S(2)/S(1);
                v2 = atan2(U(2,first), U(1,first));
                res = [v1, v2];
            elseif flag3d == 1
                [U,S,~] = svd(covmatrix);
                first = 1;
                so = sort(S(1:3));
                pos = find(S == so(3));
                first = pos;
                if U(1,first) < 0
                    U = -U;
                end
                v1 = S(2)/S(1);
                v2 = atan2(U(2,first), U(1,first));
                v3 = S(3)/S(1);
                v4 = atan2(U(3,first), U(1,first));
                res = [v1, v2, v3, v4];
            end
        end
        
        function fitres = fitWellFrommSeed(trajs, muEst)
            gridSize = floor((obj.rMax - obj.rMin)/obj.dr)-1;
            circs = cells(gridSize);
            for i = 1:gridSize
                cen = obj.rMin+obj.dr*(i+1);
                circs(i) = Ellippse(muEst, [cen, cen], 0);
            end
            maxRatIt = -1;
            maxRat = inf;
            maxAng = inf;
            covRatios = zeros(gridSize);
            for i = 1:gridSize
                pts = appUtilspointsInReg(trajs.trajs, circs(i));
                if size(pts) < 5
                    covRatios(i) = inf;
                    continue
                end
                covmat = cov(pts, muEst);
                tmp = obj.RatioAndAngleFromCov(covmat);
                covRatios(i) = tmp(1);
                
                if maxRatIt == -1 || (obj.rMin+obj.dr*i+obj.dr/2)<obj.ratMaxDist && covRatios(i) > maxRat
                    maxRatIt = i;
                    maxRat = covRatios(i);
                    maxAng = tmp(2);
                end
            end
            if maxRatIt == -inf
                fitres = [];
            else
                ring = cell(gridSize);
                for i = 1:gridSize
                    cenx = obj.rMin+obj.dr*(i);
                    ceny = obj.rMin+obj.dr*(i+1);
                    rings(i) = Ring(muEst, [cenx, ceny]);
                end
                densRingRat = zeros(gridSize);
                for i = 1:size(traj.ids)
                    singltraj = traj.traj(traj.traj(1) == traj.ids(i),:);
                    for k = 1:size(singltraj)
                        for p = 1:gridSize
                            if rings(p).getinsideRatio(singltraj(k,3:4), maxRat)
                                densRingRat(p) = densRingRat(p)+1;
                                break
                            end
                        end
                    end
                end
                for i = 1:gridSize
                    densRingRat(i) = densRingRat(i)/rings(i).getarea();
                end
                res = FitResultDensity();
                for i = 1:gridSize
                    rest = rings(i).rads(1)+rings(i).dr();
                    ell = Ellippse(muEst, [rest, maxRat*rest], maxAng);
                    trajs_in = appUtilstrajsInShape(trajs.traj.ell);
                    
                    estim = WellEstimatorFactory(trajs, ell, obj.params).getEst();
                    if exists("estim","var")
                        res.addEmptyIteration();
                        continue
                    end
                    res.addIteration(ell, trajs_in.ids,[], estim, WellScore.Density(densRingRat(i)));
                end
            end
        end
        
        function seedlist = computeSeedCenter(trajs)
            grid = SquareGrid(trajs, obj.dx);
            dens = ScalarMap.genDensityMap(grid, trajs, DensityParameters(grid.dx, ScalarMap.DensityOption.DENS, 0, obj.flag3d));
            seeds = appUtilsgetHighestdensityCells(dens, obj.params.densityth, obj.flag3d);
            seeds = appUtilsremoveclosebycells(dens, seeds, distthresh, obj.flag3d);
            seedlist = seeds;
        end
        
        function center = computeCenterAlphas(points, grid, dens, alphas)
            maxVal = dens.getmax();
            cents = zeros(size(alphas));
            for i = 1:size(alphas)
                squarestokeep = zeros(size(grid));
                cnt = 1;
                for k = 1:size(dens)
                    for p = 1:size(dens)
                        val = dens{k,p};
                        if val > alphas(i)*maxVal
                            squarestokeep(cnt) = [k,p];
                            cnt = cnt+1;
                        end
                    end
                end
                pointstokeep = [];
                for k = 1:size(squarestokeep)
                    c = grid.getpos(squarestokeep(i,1:2));
                    point1 = [c(1)-grid.dx/2, c(2)-grid.dx/2];
                    point2 = [c(1)+grid.dx/2, c(2)+grid.dx/2];
                    reg = Rectangle(point1, point2, obj.flag3d);
                    pointstokeep = [pointstokeep, appUtilspointsInReg(points.trajs(3:4), reg, obj.flag3d)];
                end
                cents(i) = appUtilscenterOfMass(pointstokeep, obj.flag3d);
            end
            center = appUtilscenterOfMass(cents, obj.flag3d);
        end
        
        function res = detectWells(trajs)
            alphas = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5];
            seedPts = obj.computeSeedsCenter(trajs);
            itChoose = IterationChooser.get(obj.params.itChooserparam, trajs);
            detectedWells = [];
            
            for i = 1:size(seedPts)
                locGrid = SquareGrid(obj.params.localGridDx, seedPts(i), obj.params.localGridSize);
                locDens = ScalarMap.genDensityMap(locGrid, trajs, DensityParamters(locGrid.dx(), ScalarMap.DensityOption.NPTS,0, obj.flag3d));
                locPoints = appUtilspointsInReg(trajs, locGrid.boundary(), obj.flag3d);
                muEst = obj.computeCenterAlphas(locPoints, locGrid, locDens, alphas);
                fitRes = obj.fitWellFromSeed(trajs, muEst);
                if fitRes.getisemtpy() == 0
                    fitRes.setBestIt(itChoose);
                    tmpWell = fitRes.bestWell(trajs, params);
                    if exists('tmpWell','var')
                        detectedWells = [detectedWells, tmpWell];
                    end
                end
            end
            
            toKeep = appUtilsremove_overlapping_wells(detectedWells);
            mergedWells = [];
            obj.lastFitResults = [];
            for k = 1:size(toKeep)
                mergedWells = [mergedWells, detectedWells(k)];
                obj.lastFitResult = [obj.lastFitResult, detectedWells(k).fitResult()];
            end
            res = PotWells(mergedWells);
        end
        
        function params = getWellDetectionParamters()
            params = obj.params;
        end
        
        function name = getName()
            name = obj.DensityWellDetection.name;
        end
    end
end
