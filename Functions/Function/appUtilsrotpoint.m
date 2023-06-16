function newpoint = appUtilsrotpoint(point, phi, axis, Flag3d)
    %Building own rotation matrixes
    rotz2d = @(angle) ([cos(angle) -sin(angle); sin(angle) cos(angle)]);
    rotx = @(angle) ([1 0 0; 0 cos(angle) -sin(angle); 0 sin(angle) cos(angle)]);
    roty = @(angle) ([cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)]);
    rotz = @(angle) ([cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]);
    if nargin == 2 || Flag3d == 0 %rotate around z axis, so stay in 2d
        if ~iscolumn(point)
            point = point';
        end
        R = rotz2d(-phi(1));
        newpoint = point'*R;
        %for 3D
    elseif nargin == 4 
        if ~iscolumn(point)
            point = point';
        end
        if axis == "x"
            R = rotx(-phi(1));
            newpoint = point'*R;
        elseif axis == "y"
            R = roty(-phi(2));
            newpoint = point'*R;
        elseif axis == "z"
            R = rotz(-phi(3));
            newpoint = point'*R;
        elseif axis == "xyz"
            newpoint = point'*rotx(-phi(1));
            newpoint = newpoint*roty(-phi(2));
            newpoint = newpoint*rotz(-phi(3));            
        end
    end
end
        
