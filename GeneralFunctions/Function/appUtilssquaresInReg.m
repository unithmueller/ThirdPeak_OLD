function indexlist = appUtilssquaresInReg(grid, ellip, flag3d)
%Checks if the squares of the grid are inside the region of an ellipse.
%Returns an array with the index being the grid square and the value being
%a boolean 0 or 1, depending if it is inside or not.

    %Generate the ellipse to be checked and make it a polyshape for
    %higher-level comparison function (isinterior)
    if flag3d == 0
        dx = grid.dx;
        t = -pi:0.1:pi;
        ellxcoord = ellip.mu(1)+ellip.rad(1)*cos(t);
        ellycoord = ellip.mu(2)+ellip.rad(2)*sin(t);
        ellip  = polyshape(ellxcoord,ellycoord);

        steps = round((grid.Xmax - grid.Xmin)/dx,0);
        result = zeros(steps,steps);

        [i,j] = grid.Xmin;
        [k,u] = grid.Xmax;
        %iterate over every square of the grid
        for i = i:dx:k
            for j = j:dx:u
                p1 = [i j];
                p2 = [i+dx j];
                p3 = [i j+dx];
                p4 = [i+dx j+dx];

                p = [p1; p2; p3; p4];
                %check if inside, get array with 0 and 1
                temp = isinterior(ellip,p(:,1),p(:,2));

                %if all points inside, fourtimes one, whole square is inside
                if sum(temp) == 4
                    result(i,j) = 1;
                end
            end
        end
        indexlist = result;
        
        %same in 3d or so
    elseif flag3d == 1
        dx = grid.dx;
        dz = grid.dz;
        ellcenterpoint = ellip.mu(1:3);
        ellradii = ellip.rad(1:3);
        [X,Y,Z]  = ellipsoid(ellcenterpoint(1),ellcenterpoint(2),ellcenterpoint(3),ellradii(1),ellradii(2),ellradii(3));
        alphaellipsoid = alphaShape(X,Y,Z);

        stepsxy = round((grid.Xmax - grid.Xmin)/dx,0);
        stepsz = round((grid.Zmax - grid.Zmin)/dz,0);
        result = zeros(stepsxy,stepsxy,stepsz);

        [i,j] = grid.Xmin;
        [k,u] = grid.Xmax;
        p = grid.Zmin;
        b = grid.Zmax;
        %iterate over every cube of the grid
        for i = i:dx:k
            for j = j:dx:u
                for p = p:dz:b
                    p1 = [i j p];
                    p2 = [i+dx j p];
                    p3 = [i j+dx p];
                    p4 = [i+dx j+dx p];
                    p5 = [i j p+dz];
                    p6 = [i+dx j p+dz];
                    p7 = [i j+dx p+dz];
                    p8 = [i+dx j+dx p+dz];

                    pfinal = [p1; p2; p3; p4; p5; p6; p7; p8];
                    %check if inside, get array with 0 and 1
                    temp = inShape(alphaellipsoid,pfinal(:,1),pfinal(:,2),pfinal(:,3));

                    %if all points inside, fourtimes one, whole square is inside
                    if sum(temp) == 8
                        result(i,j,p) = 1;
                    end
                end
            end
        indexlist = result;
        end
    end
end

    
    
        
        
        
    
    

    