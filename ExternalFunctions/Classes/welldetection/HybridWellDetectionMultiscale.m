classdef HybridWellDetectionMultiscale
    properties
        expname
        dxseeds
        filtseeds
        densitythresh
        seeddist
        maxsize
        minptsthresh
        confellperc
        estiparams
        bestitshift
        itchooserparams
        dxMin
        dxMax
        dxStep
        flag3d
    end
    
    methods(Static)
        function obj = HybridWellDetectionMultiscale(expname, dxseeds, filtseeds, dxmin, dxmax, dxstep, densitythres, seeddist, maxsize, minptsthresh, confellperc, estparams, bestitshift, itchooserparams, flag3d)
            obj.expname = expname;
            obj.dxseeds = dxseeds;
            obj.filtseeds = filtseeds;
            obj.dxMin = dxmin;
            obj.dxMax = dxmax;
            obj.dxStep = dxstep;
            obj.densitythresh = densitythres;
            obj.seeddist = seeddist;
            obj.maxsize = maxsize;
            obj.minptsthresh = minptsthresh;
            obj.confellperc = confellperc;
            obj.estiparams = estparams;
            obj.bestitshift = bestitshift;
            obj.itchooserparams = itchooserparams;
            obj.flag3d = flag3d;
        end
        
        function name = getalgoname()
            name = obj.expname;
        end
        
        function fitWellFromSeed(trajs, seedpoint)
            res = FitResultMultiscale();
            for i = obj.dxMin:dxStep:dxMax
                res.addFitResult(i, WellFromSeedDx(trajs, seedpoint, i));
            end
        end
        
        function param = getParams()
            param = obj.estiparams;
        end
    end
end
                