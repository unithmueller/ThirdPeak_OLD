classdef EllipseFit
    %Saves the properties of the newly build ellipse as well as the
    %confidence to this ellipse to the data
    properties
        ellips Ellippse
        S 
        confPerc (1,1) = 95
    end
    methods
        %Constructor(Ellippse, covmat(1,1)covmat(2,2), confPerc
        function obj = EllipseFit(ellip, S, confPerc)
            obj.ellips = ellip;
            obj.S = S;
            obj.confPerc = confPerc;
        end
        
        function res = getEllips(obj)
            res = obj.ellips;
        end
        
        function res = getS(obj)
            res = obj.S;
        end            
    end
end