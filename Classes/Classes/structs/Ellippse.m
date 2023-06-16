classdef Ellippse
    %Ellipse to fit to the data to detect diffusion wells, regions of
    %diffusion
    properties
        mu 
        rad 
        phi 
        flag3d (1,1) = 0
        theta 
    end
    
    methods
        %Constructor
        function obj = Ellippse(mu, rad, phi, flag3d, theta)
            obj.mu = mu; %Center point of the ellipse in xyz
            obj.rad = rad; %Radius/length of the major axis and minor axis
            obj.phi = phi; % angle between major axis and xy coordinates
            obj.flag3d = flag3d; %flag if 3d or not
            obj.theta = theta; %if 3d, angle between xz and major axis
        end
        %Used to fit the ellipse in the long run. Dont really understand how and if this really works though  
        function covari = covarianceInEllRot(obj, trajs)
        arguments
          obj Ellippse
          trajs TrajectoryEnsemble
        end
            if obj.flag3d == 0
                tmp = zeros(size(trajs.trajs(:,1),1),2);
                ell = obj.topolyshape();
                for i = 1:size(trajs.trajs,1)
                    [x, y] = trajs.trajs(i,3:4);
                    if isinterior(ell,x,y)
                        tmppoint = appUtilsrot_point([x y], obj.phi, obj.flag3d, "x");
                        tmp(i) = tmppoint;
                    end
                end
                covmat = cov(tmp, appUtilscenterOfMass(tmp,obj.flag3d));
                covari = [covmat(0,0) covmat(0,1); covmat(1,0) covmat(1,1)];
                %for 3d, two angles need to be defined to describe the
                %position of the ellipsoid in space
            elseif obj.flag3d == 1
                tmp = zeros(size(trajs.trajs(:,1),1),3);
                ell = obj.topolyshape();
                for i = 1:size(trajs.trajs,1)
                    testpoint = trajs.trajs(i,3:5);
                    if inShape(ell,testpoint(1,1),testpoint(1,2),testpoint(1,3))
                        tmppoint = appUtilsrot_point(testpoint,obj.phi,obj.flag3d,"x");
                        tmppoint = appUtilsrot_point(tmppoint,obj.theta,obj.flag3d,"z");
                        tmp(i) = tmppoint;
                    end
                end
                covmat = cov(tmp, appUtilscenterOfMass(tmp, obj.flag3d));
                covari = [covmat(1,1) covmat(1,2) covmat(1,3); covmat(2,1) covmat(2,2) covmat(2,3); covmat(3,1) covmat(3,2) covmat(3,3)];
            end
        end
        %make a poly/alpha shape object from the ellipse to use the
        %respective function of these objects
        function shape = topolyshape(obj)
            if obj.flag3d == 0
                t = -pi:0.01:pi;
                x = obj.rad(1)*cos(t);
                y = obj.rad(2)*sin(t);
                rotxy = zeros(2, size(x,2));
                %Introduce the necessary rotation
                for i = 1:size(x,2)
                    temp_rotxy = appUtilsrotpoint([x(i);y(i)],[obj.phi],"",obj.flag3d);
                    rotxy(:,i) = temp_rotxy;
                end
                %move to center point
                rotxy(1,:) = rotxy(1,:) + obj.mu(1);
                rotxy(2,:) = rotxy(2,:) + obj.mu(2);
                rotxy = rotxy';
                shape = polyshape(rotxy(:,1),rotxy(:,2));
            elseif obj.flag3d == 1
                [X,Y,Z] = ellipsoid(0,0,0,obj.rad(1),obj.rad(2),obj.rad(3), 50); % 100 is a marker for precision, increase for higher precision as this will increase the vertices of the alpha shape   
                X = reshape(X,[],1);
                Y = reshape(Y,[],1);
                Z = reshape(Z,[],1);
                %Ellipsoid leaves a hole at the top and bottom -> bad
                %after 2 days -> set alpha radius to Inf FML
                
                points = [X Y Z];
                points = points';
                rot_points = zeros(3,size(points,2));
                %Introduce rotation
                for i = 1:size(points,2)
                    point = points(:,i);
                    rot_point = appUtilsrotpoint(point,[obj.theta,0,obj.phi], "xyz", 1);
                    rot_points(:,i) = rot_point;
                end
                %move to centerpoint
                rot_points(1,:) = rot_points(1,:) + obj.mu(1);
                rot_points(2,:) = rot_points(2,:) + obj.mu(2);
                rot_points(3,:) = rot_points(3,:) + obj.mu(3);
                rot_points = rot_points';
                shape = alphaShape(rot_points(:,1),rot_points(:,2),rot_points(:,3),Inf,'HoleThreshold', 0, 'RegionThreshold', 1);
            end
        end
        %gets the minimal Point coordinates of the respective shape 
        function minP = getMinPtofShape(obj)
            if obj.flag3d == 0
                shape = obj.topolyshape();
                [x,y] = boundary(shape);
                minx = min(x);
                miny = min(y);
                minP = [minx miny];
            elseif obj.flag3d == 1
                shape = obj.topolyshape();
                points = shape.Points;
                minx = min(points(:,1));
                miny = min(points(:,2));
                minz = min(points(:,3));
                minP = [minx miny minz];
            end
        end
        %gets the maximal Point coordinates of the respective shape
        function maxP = getMaxPtofShape(obj)
            if obj.flag3d == 0
                shape = obj.topolyshape();
                [x,y] = boundary(shape);
                maxx = max(x);
                maxy = max(y);
                maxP = [maxx maxy];
            elseif obj.flag3d == 1
                shape = obj.topolyshape();
                points = shape.Points;
                maxx = max(points(:,1));
                maxy = max(points(:,2));
                maxz = max(points(:,3));
                maxP = [maxx maxy maxz];
            end
        end
        %Check if some cooridnates are inside the shape in 2D and 3D
        function res = isinside(obj, point)
            arguments
                obj Ellippse
                point 
            end
            if obj.flag3d == 0
                shape = obj.topolyshape();
                res = isinterior(shape,point(1),point(2));
            elseif obj.flag3d == 1
                shape = obj.topolyshape();
                res = inShape(shape,point(1), point(2), point(3));
            end
        end
        %Checks if shapes intersect with each other in 2d and 3d
        function res = intersects(obj, shape)
            if obj.flag3d == 0
                tmp = intersect(obj.topolyshape(),shape);
                if area(tmp) > 0
                    res = 1;
                else
                    res = 0;
                end
            elseif obj.flag3d == 1
                points1 = obj.topolyshape().points;
                points2 = shape.points;
                test1 = inShape(obj.topolyshape(),points2(1),points2(2),points2(3));
                test2 = inShape(shape, points1(1), points1(2), points1(3));
                intersectshape = alphaShape([points1(test1,1); points2(test2,1)],[points1(test1,2); points2(test2,2)],[points1(test1,3); points2(test2,3)]);
                if volume(intersectshape) > 0
                    res = 1;
                else
                    res = 0;
                end
            end
        end
        %Calculates the Area/Volume of the Ellippse
        function res = getArea(obj)
            if obj.flag3d == 0
                res = area(obj.topolyshape());
            elseif obj.flag3d == 1
                res = volume(obj.topolyshape());
            end
        end
    end
    
    methods(Static)
        %generate a new ellipse from the distribution of the tracks
        function res = getEllipseFromPCA(pts, confPerc)
            arguments
                pts TrajectoryEnsemble
                confPerc (1,1) = 95
            end
            flag3d = pts.flag3d;
            pts = pts.trajs;
            if flag3d == 0
                center = appUtilscenterOfMass(pts, flag3d);
                %Covariance calculation of x and y coordinates in 2D.
                %Matlab function will calculate the center of the data
                %itself
                %covmatrix = cov(pts, center);
                covmatrix = cov(pts(:,3),pts(:,4));
                [U,S,~] = svd(covmatrix,"econ");
                S = [S(1,1) S(2,2)];
                first = 1;
                if S(1) < S(2)
                    tmp = S(1);
                    S(1) = S(2);
                    S(2) = tmp;
                    first = 2;
                end
                if U(1,first) < 0
                    U = -U;
                end
                %Is this right? -> should be
                phi = atan2(U(2,first), U(1, first));
                %2degrees of freedom
                chiSqTh = 0;
                if confPerc == 99
                    chiSqTh = 9.210;
                elseif confPerc == 95
                    chiSqTh = 5.991;
                elseif confPerc == 90
                    chiSqTh = 4.605;
                end
                
                a = sqrt(chiSqTh*S(1));
                b = sqrt(chiSqTh*S(2));
                
                if b>a
                    tmp = a;
                    a = b;
                    b=tmp;
                    phi = mod((phi+(pi/2)),pi);
                end
                %Build the ellipse from the data
                ell = Ellippse(center, [a b], phi, flag3d, 0);
                res = EllipseFit(ell, [covmatrix(1,1) covmatrix(2,2)], confPerc);
                
            elseif flag3d == 1
                center = appUtilscenterOfMass(pts, flag3d);
                %As covariance can only be done between two dimensions,
                %have to check different combinations
                covmatXY = cov(pts(:,3),pts(:,4));
                covmatXZ = cov(pts(:,3),pts(:,5));
                covmatYZ = cov(pts(:,4),pts(:,5));
                covmatrix3d = [covmatXY(1,1) covmatXY(1,2) covmatXZ(1,2); covmatXY(2,1) covmatXY(2,2) covmatYZ(1,2); covmatXZ(2,1) covmatYZ(2,1) covmatXZ(2,2)];
                [U,S,~] = svd(covmatrix3d,"econ");
                S = [S(1,1) S(2,2) S(3,3)];
                [~, I] = sort(S,'descend');
                %Get the position from S which is the biggst, aka the largest
                %eigenvalue
                first = I(1);
                %Not sure if this also works out in 3d
                if U(1,first) < 0
                    U = -U;
                end
                %y to x axis angle
                phi = atan2(U(2,first), U(1, first));
                %z to x axis angle
                theta = atan2(U(3,first), U(1,first));
                %3 degrees of freedom
                chiSqTh = 0;
                if confPerc == 99
                    chiSqTh = 11.34;
                elseif confPerc == 95
                    chiSqTh = 7.81;
                elseif confPerc == 90
                    chiSqTh = 6.25;
                end
                
                a = sqrt(chiSqTh*S(1));
                b = sqrt(chiSqTh*S(2));
                c = sqrt(chiSqTh*S(3));
                
                rads = [a b c];
                %Will pply never happen as they have been sorted before
                if b>a || c>a
                    rads = sort(rads);
                    phi = mod((phi+(pi/2)),pi);
                end
                %Generate new ellipse and Fit object
                ell = Ellippse(center, rads, phi, flag3d, theta);
                res = EllipseFit(ell, [covmatrix3d(1,1) covmatrix3d(2,2) covmatrix3d(3,3)], confPerc);
            end     
        end
    end
end
