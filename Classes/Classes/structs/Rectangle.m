classdef Rectangle
    %Rectangle used for ROI selection and spacial discretisation
    properties
        lowleft (1,:)
        topright (1,:)
        flag3d (1,1) = 1
        shape
    end
    
    methods
        %Constructor
        function obj = Rectangle(lowerleft, topright, flag3d)
            obj.lowleft = lowerleft;
            obj.topright = topright;
            obj.flag3d = flag3d;
            obj.shape = topolyshape(obj);
        end
        %Function to generate poly/alphashape depending on needs
        function shape = topolyshape(obj)
            if obj.flag3d == 0
                size = [obj.topright(1)-obj.lowleft(1) obj.topright(2)-obj.lowleft(2)];
                x = [obj.lowleft(1) obj.lowleft(1) obj.lowleft(1)+size(1) obj.lowleft(1)+size(1)];
                y = [obj.lowleft(2) obj.lowleft(2)+size(2) obj.lowleft(2)+size(2) obj.lowleft(2)];
                shape = polyshape(x,y);
            elseif obj.flag3d == 1
                size = [obj.topright(1)-obj.lowleft(1) obj.topright(2)-obj.lowleft(2) obj.topright(3)-obj.lowleft(3)];
                x = [obj.lowleft(1) obj.lowleft(1) obj.lowleft(1)+size(1) obj.lowleft(1)+size(1) obj.lowleft(1) obj.lowleft(1) obj.lowleft(1)+size(1) obj.lowleft(1)+size(1)];
                y = [obj.lowleft(2) obj.lowleft(2)+size(2) obj.lowleft(2) obj.lowleft(2)+size(2) obj.lowleft(2) obj.lowleft(2)+size(2) obj.lowleft(2) obj.lowleft(2)+size(2)];
                z = [obj.lowleft(3) obj.lowleft(3) obj.lowleft(3) obj.lowleft(3) obj.lowleft(3)+size(3) obj.lowleft(3)+size(3) obj.lowleft(3)+size(3) obj.lowleft(3)+size(3)];
                x = reshape(x,[],1);
                y = reshape(y,[],1);
                z = reshape(z,[],1);
                shape = alphaShape(x,y,z,Inf);
            end
        end
        %Checks if a point lies inside the rectangle. Point should be 1xn
        %dimension
        function res = isInside(obj, point)
            arguments
                obj Rectangle
                point (1,:)
            end
            if obj.flag3d == 0
                res = isinterior(obj.shape,point(1),point(2));
            elseif obj.flag3d == 1
                res = inShape(obj.shape, point(1), point(2), point(3));
            end
        end
        %Get the center coordinates of the rectangle
        function cen = getCenter(obj)
            if obj.flag3d == 0
                [cenx, ceny] = centroid(obj.shape);
                cen = [cenx ceny];
            elseif obj.flag3d == 1
                points = obj.shape.Points;
                cen = [mean(points(:,1)) mean(points(:,2)) mean(points(:,3))];
            end
        end
        %Calculates the surface area or volume of the rectangle
        function Area = getArea(obj)
            if obj.flag3d == 0
                Area = area(obj.shape);
            elseif obj.flag3d == 1
                Area = volume(obj.shape);
            end
        end
    end
    %Construct a rectangle by its centerpoint and size
    methods(Static)
        function obj = RectanglebyCenter(center, size, flag3d)
            arguments
                center (1,:)
                size (1,:)
                flag3d (1,1)
            end
            if flag3d == 0
                ll = [center(1)-size(1)/2 center(2)-size(2)/2];
                tr = [center(1)+size(1)/2 center(2)+size(2)/2];
            elseif flag3d == 1
                ll = [center(1)-size(1)/2 center(2)-size(2)/2 center(3)-size(3)/2];
                tr = [center(1)+size(1)/2 center(2)+size(2)/2 center(3)+size(3)/2];
            end
            obj = Rectangle(ll, tr, flag3d);
        end
    end
end                 