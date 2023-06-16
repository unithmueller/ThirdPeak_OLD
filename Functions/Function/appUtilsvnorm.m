function norm = appUtilsvnorm(v, Flag3D)
    if nargin > 1 && Flag3D == 1
        norm = sqrt(v(1)^2 + v(2)^2 + v(3)^2);
    else
        norm = sqrt(v(1)^2 + v(2)^2);
    end
end
        