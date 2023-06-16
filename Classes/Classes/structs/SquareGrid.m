classdef SquareGrid
    %Grid to discretisize the data in bins of xy and z if 3D. Each square
    %will then be analyzed by itself.
    properties
        dx (1,1) = 1600 %size of xy grid 10x160nm
        Xmin  %smallest xy value
        Xmax  %largest xy value
        dz (1,1) = 80 %bin size in z, 80nm
        Zmin(1,1) %smallest z value
        Zmax (1,1) %largest z value
        flag3d (1,1) %flag if 3d or not
    end
    
    methods
        %Constructor
        function obj = SquareGrid(dx, minx, maxx, flag3d, dz, zmin, zmax)
            obj.dx = dx;
            obj.Xmin = minx;
            obj.Xmax = maxx;
            obj.flag3d = flag3d;
            obj.dz = dz;
            obj.Zmin = zmin;
            obj.Zmax = zmax;
        end
        %Converts a xyz position into the respective grid position
        function pos = PostoGridpos(obj, point)
            arguments
                obj SquareGrid
                point (1,:)
            end
            if obj.flag3d == 0
                x = floor(round(((point(1) - obj.Xmin(1))/obj.dx)*1000000)/1000000);
                y = floor(round(((point(2) - obj.Xmin(2))/obj.dx)*1000000)/1000000);
                if x <= 0
                    x = 1;
                end
                if y <= 0
                    y = 1;
                end
                pos = [x, y];
            elseif obj.flag3d == 1
                x = floor(round(((point(1) - obj.Xmin(1))/obj.dx)*1000000)/1000000);
                y = floor(round(((point(2) - obj.Xmin(2))/obj.dx)*1000000)/1000000);
                z = floor(round(((point(3) - obj.Zmin)/obj.dz)*1000000)/1000000);
                 if x <= 0
                    x = 1;
                 end
                if y <= 0
                    y = 1;
                end
                 if z <= 0
                     z = 1;
                 end
                pos = [x, y, z];
            end
        end
        %Converts the max position to a grid position
        function pos = gridMaxPos(obj)
            if obj.flag3d == 0
                pos = PostoGridpos(obj, obj.Xmax);
            elseif obj.flag3d == 1
                pos = PostoGridpos(obj, [obj.Xmax, obj.Zmax]);
            end
        end
        %Retrieves the center point of a square in the grid at xyz
        function pos = getPos(obj, x,y,z)
            arguments
                obj SquareGrid
                x (1,1)
                y (1,1)
                z (1,1)
            end
            x = obj.Xmin(1)+obj.dx*x+obj.dx/2;
            y = obj.Xmin(2)+obj.dx*y+obj.dx/2;
            if obj.flag3d == 0
                pos = [x y];
            elseif obj.flag3d == 1
                z = obj.Zmin(1)+obj.dz*z+obj.dz/2;
                pos = [x y z];
            end
        end
        %Gets the range of values available for the square grid
        function ran = getRange(obj)
            if obj.flag3d == 0
                xran = (obj.Xmax(1)-obj.Xmin(1))/obj.dx;
                yran = (obj.Xmax(2)-obj.Xmin(2))/obj.dx;
                ran = [xran yran];
            elseif obj.flag3d == 1
                xran = (obj.Xmax(1)-obj.Xmin(1))/obj.dx;
                yran = (obj.Xmax(2)-obj.Xmin(2))/obj.dx;
                zran = (obj.Zmax-obj.Zmin)/obj.dz;
                ran = [xran yran zran];
            end
        end
    end
    
    methods(Static)
        %Construct a square grid based on Trajectories as Input
        function obj = SquareGridbyTrajDx(trajs, dx, flag3d, dz)
            arguments
                trajs TrajectoryEnsemble
                dx (1,1) = 160
                flag3d (1,1) = 1
                dz (1,1) = 80
            end
            if flag3d == 0
                minp = trajs.getMinPointall();
                maxp = trajs.getMaxPointall();
                i = 0;
                j = 0;
                while i*dx < maxp(1)
                    i = i+1;
                end
                while j*dx < maxp(2)
                    j = j+1;
                end
                Xmax = [i*dx j*dx];
                zmin = 0;
                Zmax = 0;
            elseif flag3d == 1
                minp = trajs.getMinPointall();
                maxp = trajs.getMaxPointall();
                zmin = minp(3);
                minp = minp(1:2);
                i = 0;
                j = 0;
                k = 0;
                while i*dx < maxp(1)
                    i = i+1;
                end
                while j*dx < maxp(2)
                    j = j+1;
                end
                while k*dz < maxp(3)
                    k = k+1;
                end
                Xmax = [i*dx j*dx];
                Zmax = k*dz;
                
            end
            obj = SquareGrid(dx, minp, Xmax, flag3d, dz, zmin, Zmax);
        end
        %Construct a Square Grid by its center coordinates and the number
        %squares per grid dimension
        function obj = SquareGridbyCenterDx(dx, center, ncells, flag3d, dz, ncellz)
            if flag3d == 0
                xmin = [center(1)-dx/2-ncells*dx center(2)-dx/2-ncells*dx];
                xmax = [center(1)+dx/2+ncells*dx center(2)+dx/2+ncells*dx];
                zmin = 0;
                zmax = 0;
            elseif flag3d == 1
                xmin = [center(1)-dx/2-ncells*dx center(2)-dx/2-ncells*dx center(3)-dz/2-ncellz*dz];
                xmax = [center(1)+dx/2+ncells*dx center(2)+dx/2+ncells*dx center(3)+dz/2+ncellz*dz];
                zmin = xmin(3);
                zmax = xmax(3);
                xmin = xmin(1:2);
                xmax = xmax(1:2);
            end
            obj = SquareGrid(dx,xmin,xmax,flag3d,dz,zmin,zmax);
        end
        %Construct a Square Grid based on the dimensions of an ellips
        function obj = SquareGridbyEllips(dx, ellip, flag3d, dz)
            if flag3d == 0
                elli = ellip.topolyshape();
                %Find the smallest rectangle (grid) to fit the ellipse
                [xlim, ylim] = boundingbox(elli); %Lowleft, Upright
                xmin = [xlim(1), ylim(1)];
                xmaxx = ceil((xlim(2)-xlim(1))/dx);%how many full grids fit
                xmaxy = ceil((ylim(2)-ylim(1))/dx);
                xmax = [xlim(1)+xmaxx*dx, ylim(1)+xmaxy*dx];
                zmin = 0;
                zmax = 0;
            elseif flag3d == 1
                points = ellip.topolyshape().Points; %No buildin function for alphaShape sadly
                %Min max gives the dimensions, now need to stick them
                %together to form a rectangle
                minxyz = min(points);
                maxxyz = max(points);
                xmin = minxyz(1:2);
                zmin = minxyz(3);
                xmaxx = ceil((maxxyz(1)-minxyz(1))/dx);%how many full grids fit
                xmaxy = ceil((maxxyz(2)-maxxyz(2))/dx);
                xmaxz = ceil((maxxyz(3)-zmin)/dz);
                xmax = [xmin(1)+xmaxx*dx, xmin(2)+xmaxy*dx, zmin+xmaxz*dz];
                zmax = xmax(3);
                xmax = xmax(1:2);
            end
            obj = SquareGrid(dx,xmin,xmax,flag3d,dz,zmin,zmax);
        end
    end
end