classdef Ring
    %Shape of a Ring Structure, similar to Ellipse and rectangle
    properties
        mu (1,:) = [0,0,0] %Centerpoint
        rads (1,2) = [3,1] %Outer inner ring rads
        radsSq (1,2) = [9,1] %Outer inner ring rads squared
        flag3d (1,1) = 1
        shape
    end
    methods
        %Constructor
        function obj = Ring(mu, rads, flag3d)
            obj.mu = mu;
            obj.rads = rads;
            obj.flag3d = flag3d;
            obj.radsSq = [round(rads(1)^2)*1000000/1000000 round(rads(2)^2)*1000000/1000000];
            obj.shape = obj.topolyshape();
        end
        %Converts to alpha/polyshape for acces to handy functions
        function shape = topolyshape(obj)
            if obj.flag3d == 0
                t = -pi:0.01:pi;
                xsmall = obj.mu(1) + obj.rads(2)*sin(t);
                ysmall = obj.mu(2) + obj.rads(2)*cos(-t);
                xbig = obj.mu(1) + obj.rads(1)*sin(t);
                ybig = obj.mu(2) + obj.rads(1)*cos(-t);
                shape = polyshape([xsmall xbig], [ysmall ybig]);
            elseif obj.flag3d == 1
                [X,Y,Z] = sphere(50);
                X = reshape(X,[],1);
                Y = reshape(Y,[],1);
                Z = reshape(Z,[],1);
                Xsmall = obj.mu(1) + obj.rads(1)*X;
                Ysmall = obj.mu(2) + obj.rads(1)*Y;
                Zsmall = obj.mu(3) + obj.rads(1)*Z;
                Xbig = obj.mu(1) + obj.rads(2)*X;
                Ybig = obj.mu(2) + obj.rads(2)*Y;
                Zbig = obj.mu(3) + obj.rads(2)*Z;
                shapesmall = alphaShape(Xsmall, Ysmall ,Zsmall, Inf);
                shapebig = alphaShape(Xbig, Ybig, Zbig, Inf);
                shape = {shapesmall, shapebig};
            end
        end
        %Checks if point is inside the shape
        function res = isInside(obj, point)
            arguments
                obj Ring
                point (1,:) = [1,1,1]
            end
            if obj.flag3d == 0
                res = isinterior(obj.shape, point(1), point(2));
            elseif obj.flag3d == 1
                res = inShape(obj.shape,point(1), point(2), point(3));
            end
        end
        %Dont know yet why we need this
        function d = insideRatio(obj, point, yratio)
            d = (obj.mu(1)-point(1))^2 + (yratio*(obj.mu(2)-point(2)))^2;
            d = round( (d*1000000)/1000000);
        end
        %Returns the centerpoint of the ring
        function cen = getCenter(obj)
            cen = obj.mu;
        end
        %Returns the radii of the ring
        function rad = getRads(obj)
            rad = obj.rads();
        end
        %gets the thickness of the ring wall
        function d = getThickness(obj)
            d = obj.rads(1) - obj.rads(2);
        end
        %gets the area or volume of the object. For 3d returns small vol,
        %big vol and the final vol of the ring structure
        function Area = getArea(obj)
            if obj.flag3d == 0
                Area = area(obj.shape);
            elseif obj.flag3d == 1
                Area1 = volume(obj.shape{1,1});
                Area2 = volume(obj.shape{1,2});
                Area = [Area1, Area2, Area2-Area1];
            end
        end
    end
end