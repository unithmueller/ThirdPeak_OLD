function center = appUtilscenterOfMass(pts, flag3d)
    length = size(pts,1);
    xyz = sum(pts(:,3:5));
    res = xyz/length;
    if flag3d == 0
        center = res(:,1:2);
    elseif flag3d == 1
        center = res;
    end
end
