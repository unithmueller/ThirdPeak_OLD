classdef GridEstimatorParameters < WellEstimatorParameters
    properties
        dx
        driftNptsTh
        minCellsTh
        diffInWell
        correctField
        Flag3d
    end
    methods(Static)
        function obj = GridEstimatorParameters(estType, dx, driftNptsth, mincellsth, diffinwell, correctfield, Flag3d)
            obj = obj@WellEstimatorParameters(estType);
            obj.dx = dx;
            obj.driftNptsTh = driftNptsth;
            obj.minCellsTh = mincellsth;
            obj.diffInWell = diffinwell;
            obj.correctField = correctfield;
            obj.Flag3d = Flag3d;
        end
        
        function estimator = copyChangeDx(dx)
            estimator = GridEstimatorParameters(obj.estType, dx, obj.driftNptsth, obj.mincellsth, obj.diffinwell, obj.correctfield, obj.Flag3d);
        end
    end
end