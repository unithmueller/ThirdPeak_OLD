function res = appUtilspointsInReg(trajs, shape, flag3d)
    res = zeros(size(trajs.trajs));
    cnt = 1;
    for i = 1:size(trajs.trajs)
        point = trajs.trajs(i,:);
        if flag3d == 0
            if shape.isinside(point(3:4))
                res(cnt,:) = point(1,:);
                cnt = cnt + 1;
            end
        elseif flag3d == 1
            if shape.isinside(point(3:5))
                res(cnt,:) = point(1,:);
                cnt = cnt + 1;
            end
        end
    end
    res = res(res(:,1) ~= 0,:);
end