classdef WellDetectionParameters < AnalysisParameters
    properties
        estPs
        bestItShift
        flag3d
    end
    methods(Static)
        function obj = WellDetectionParameters(expname, estPs, bestitshift, flag3d)
            obj = obj@AnalysisParameters(expname);
            obj.estPs = estPs;
            obj.bestItShift = bestitshift;
            obj.flag3d = flag3d;
        end
        
        function para = getanalysisType()
            para = obj.Type.WELL;
        end
    end
end