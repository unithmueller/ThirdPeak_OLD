function insideTrajs = appUtilstrajsInShape(trajectories, ellips, Flag3d)
%returns all the trajectories that in the given alpha/polyshape
    %case for 2d
    trajs = trajectories.trajs;
    if Flag3d == 0
        x = trajs(:,3);
        y = trajs(:,4);
        insideTest = isinterior(ellips, x, y);
        insideTrajs = trajs(insideTest == 1,:);
        %case for 3d
    elseif Flag3d == 1
        x = trajs(:,3);
        y = trajs(:,4);
        z = trajs(:,5);
        insideTest = inShape(ellips, x, y, z);
        insideTrajs = trajs(insideTest == 1,:);
    end
end
    