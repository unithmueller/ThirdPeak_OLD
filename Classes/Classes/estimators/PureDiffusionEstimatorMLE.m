classdef PureDiffusionEstimatorMLE
    properties
    end
    methods
        function result = estimateD(trajs, flag3d)
            cnt = 0;
            res = 0;
            uniqtrajs = unique(trajs(:,1));
            for i = 1:size(uniqtrajs,1)
                singletraj = trajs(uniqtrajs(i),:);
                for j = 2:size(singletraj,1)
                    res = res + appUtilsSquaredDist(singletraj(j),singletraj(j-1), flag3d);
                    cnt = cnt +1;
                end
            end
            if flag3d == 0
                result = 1/(4*trajs.acqDT*cnt)*res;
            elseif flag3d == 1
                result = 1/(6*trajs.acqDT*cnt)*res;
            end
        end
        
        function result = logLikelihood(trajs, D, flag3d)
            res = 0;
            uniqtrajs = unique(trajs(:,1));
            for i = 1:size(uniqtrajs,1)
                singletraj = trajs(uniqtrajs(i),:);
                    for j = 1:size(singletraj,1)-1
                        res = res + appUtilsSquaredDist(singletraj(j+1),singletraj(j), flag3d);
                    end
            end
            if flag3d == 0
                result = res/(4*D*trajs.acqDT);
            elseif flag3d == 1
                result = res/(6*D*trajs.acqDT);
            end
        end
    end
end

                