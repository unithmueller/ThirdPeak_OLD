function respoint = appUtilsrot_point(point, phi, flag3d, axis)
    if flag3d == 0
        x = cos(-phi)*point(1)-sin(-phi)*point(2);
        y = sin(-phi)*point(1)+cos(-phi)*point(2);
        respoint = [x y];
    elseif flag3d == 1
        if axis == "x"
            r = rotx(phi);
            respoint = point*r;
        elseif axis == "y"
            r = roty(phi);
            respoint = point*r;
        elseif axis == "z"
            r = rotz(phi);
            respoint = point*r;
        elseif axis == "xz"
            r = rotx(phi);
            respoint = point*r;
            r = rotz;
            respoint = respoint*r;
        end
    end
end
    