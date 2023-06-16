classdef WellEstimatorFactory
    properties
        trajs
        ellips
        params
        flag3d
    end
    methods(Static)
        function obj=WellEstimatorFactory(trajs, ellips,params, flag3d)
            obj.trajs = trajs;
            obj.ellips = ellips;
            obj.params = params;
            obj.flag3d = flag3d;
        end
        
        function gridestimator = getGridEst(estType, trajs, ellips, drift, nh, diffInwell, flag3D)
            if estType == WellEstimator.type.LSQELL
                gridestimator = LeastSquareEstimatorEllipse(trajs, drift, nh, ellips, diffInwell, flag3d);
            elseif estType == WellEstimator.type.LSQELLNORM
                gridestimator = LeastSqaureEstimatorEllipseNorm(trajs,drift,nh,ellips,diffInwell,flag3d);
            elseif estType == WellEstimator.type.LSQCIRC
                gridestimator  = LeastSquareEstimatorCircle(trajs,drift,nh,ellips,diffInwell,flag3d);
            elseif estType == WellEstimator.type.LSQELLNORMFIT
                gridestimator = LeastSquareEstimatorEllipseNormFit(trajs,drift,nh,ellips,diffInwell,flag3d);
            end
        end
        
        function wellestimator = getEst()
            if obj.params.estType == WellEstimator.type.LSQELL || obj.params.estType == WellEstimator.type.LSQELLNORM || obj.params.estType == WellEstimator.type.LSQCIRC || obj.params.estType == WellEstimator.type.LSQELLNORMFIT
                psCur = obj.params;
                locG = SquareGrid(psCur.dx. obj.ellips.mu, 50);
                nh = appUtilssquaresInReg(locG, obj.ellips, obj.flag3d);
                driftparams = DriftParameters(locG.dx, psCur.driftNptsTh, false, 0);
                drift = Vectormap.genDriftMap(locG, obj.trajs, driftparams);
                nh = appUtilsfilter_empty_squares(drift, nh, obj.flag3d);
                if size(nh(nh() >= 1)) < psCur.minCellsTh
                    return
                end
                wellestimator = WellEstimatorFactor.getGridEst(psCur.estType, obj.trajs, obj.ellips, drift, nh, psCur.diffInWell);
                if psCur.correctField
                    A = wellestimator.estimateA();
                    lambda = A/ellips.rad(1)^2 + A/ellips.rad(1)^2;
                    wellestimator = WellEstimatorFactory.getGridEst(psCur.estType, obj.trajs, obj.ellips, Vectormap.applyFactor(drift, 1+lambda*trajs.acqDT()/2),nh, psCur.diffInWell, flag3d);
                end
            elseif obj.params.estType == WellEstimator.type.DENS || obj.params.estType == WellEstimator.type.DENSMLE
                psCur = obj.params;
                CinEll = ellips.covarianceInEllRot(obj.trajs);
                if psCur.estType == WellEstimator.type.Dens
                    wellestimator = DensityEstimator(obj.trajs, obj.ellips, [CinEll(1,1) CinEll(2,2)], psCur.diffInWell, flag3d);
                elseif psCur.estType == WellEstimator.type.DENSMLE
                    wellestimator = DensityEstimatorMLE(obj.trajs, obj.ellips, [CinEll(1,1) CinEll(2,2)], psCur.diffInWell, obj.flag3d);
                end
            elseif obj.params.estType == WellEstimator.type.MLE
                MaxLikelihoodEstimator(appUtilstrajsInShape(obj.trajs, obj.ellips, flag3d),obj.trajs.acqDT(), obj.ellips);
            end
        end      
    end
end