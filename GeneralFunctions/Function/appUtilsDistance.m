function dist = appUtilsDistance(point1, point2)
    if size(point1,2) < 3
        dist = sqrt( (point2(1)-point1(1)^2+(point2(2)-point1(2))^2));
    else
        dist = sqrt( (point2(1)-point1(1)^2 + (point2(2)-point1(2))^2) + (point2(3)-point1(3))^2);
    end
end
