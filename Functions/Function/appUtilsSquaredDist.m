function d = appUtilsSquaredDist(p1,p2,Flag3D)
    if nargin == 2 || Flag3D == 0
        d = (p2(1)-p1(1))^2 + (p2(2)-p1(2))^2;
        d = round(d,1);     
    elseif nargin == 3 || Flag3d == 1
        d = (p2(1)-p1(1))^2 + (p2(2)-p1(2))^2 + (p2(3)-p1(3))^2;
        d = round(d,1); 
    end
end