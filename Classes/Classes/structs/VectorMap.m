classdef VectorMap
    properties
        squaregrid
        data
        %map
        normalized
        params
        flag3d
    end
    methods(Static)
        function obj = VectorMap(grid, data, parameters, norm, flag3d)
            obj.squaregrid = grid;
            obj.data = data;
            %obj.map = reserveMap();
            obj.normalized = norm;
            obj.params = parameters;
            obj.flag3d = flag3d;
        end
        
        function map = reserveMap()
            map = cell(size(obj.data));
        end
        
        function grid = getgrid()
            grid = obj.squaregrid;
        end
        
        function norm = isnormalized()
            norm = obj.normalized;
        end
        
        function params = getparams()
            params = obj.params;
        end
        
        function dat = getdat(i,j,k)
            if obj.flag3d == 1
                dat = obj.map{i,j,k};
            else
                dat = obj.map.get{i,j};
            end
        end
        
        function val = isSet(i,j,k)
            val = obj.map.getdat(i,j,k) >= 0;
        end
        
        function res = angular_similartiy(cells, ellips)
            if ~obj.normalized
                res = Nan(size(cells));
            end
            
            res = 0.0;
            if flag3d == 0
                for i=1:size(cells,1)
                    p = obj.squaregrid.getpos(cells.get(i,1), cells.get(i,2));
                    A = obj.getdat(cells.get(i,1:2));
                    B = [ellips.mu(1)-p(1), ellips.mu(2)-p(2)];
                    Anorm = sqrt(A(1)^2+A(2)^2);
                    Bnorm = sqrt(B(1)^2+B(2)^2);

                    tmp = (A(1)*B(1)+A(2)*B(2))/(Anorm*Bnorm);
                    if tmp > 1.0
                        tmp = 1.0;
                    elseif tmp < -1.0
                        tmp = -1.0;
                    end
                    if ~isNan(acos(tmp))
                        res = res + (1-acos(tmp)/pi);
                    end
                end
                res = res/cells.size();
            elseif flag3d == 1
                 for i=1:size(cells,1)
                    p = obj.squaregrid.getpos(cells.get(i,1), cells.get(i,2), cells.get(i,3));
                    A = obj.getdat(cells.get(i,1:3));
                    B = [ellips.mu(1)-p(1), ellips.mu(2)-p(2), ellips.mu(3)-p(3)];
                    Anorm = sqrt(A(1)^2+A(2)^2+A(3)^2);
                    Bnorm = sqrt(B(1)^2+B(2)^2+B(3)^2);

                    tmp = (A(1)*B(1)+A(2)*B(2)+A(3)*B(3))/(Anorm*Bnorm);
                    if tmp > 1.0
                        tmp = 1.0;
                    elseif tmp < -1.0
                        tmp = -1.0;
                    end
                    if ~isNan(acos(tmp))
                        res = res + (1-acos(tmp)/pi);
                    end
                end
                res = res/cells.size();
            end
        end
        
        
        function res =  max()
            res = obj.grid.max();
        end
        
        function vectormap = genDriftMap(grid, trajs, params)
            flag3d = params.flag3d;
            if flag3d
                tempmap = cell(ceil((grid.Xmax(1)-grid.Xmin(1))/grid.dx), ceil((grid.Xmax(2)-grid.Xmin(2))/grid.dx), ceil((grid.Zmax-grid.Zmin)/grid.dz));
            else
                tempmap = cell(ceil((grid.Xmax(1)-grid.Xmin(1))/grid.dx), ceil((grid.Xmax(2)-grid.Xmin(2))/grid.dx));
            end
            trajs = trajs{1,1};
            if flag3d == 0
                for i = 1:size(trajs.ids,1)
                    singltraj = trajs.trajs(trajs.trajs(:,1) == trajs.ids(i),:);
                    for j = 1:size(singltraj,1)-1
                        p1 = singltraj(j,:);
                        p2 = singltraj(j+1,:);
                        
                        if p1(:,3) < grid.Xmin(1) || p1(:,3) > grid.Xmax(1) || p1(:,4) < grid.Xmin(2) || p1(:,4) > grid.Xmax(2)
                            continue
                        end
                        
                        gpos = grid.PostoGridpos(p1(:,3:4));
        
                        tmp = tempmap{gpos(1:2)};
                        if isempty(tmp)
                            tmp = zeros(1,3);
                        end
                        x = (p2(:,3) - p1(:,3)) / (p2(:,2)-p1(:,2));
                        y = (p2(:,4) - p1(:,4)) / (p2(:,2)-p1(:,2));
                        tmp(1) = tmp(1)+1;
                        tmp(2) = tmp(2)+x;
                        tmp(3) = tmp(3)+y;
                        
                        tempmap{gpos(1), gpos(2)} = tmp;
                    end
                end
                
                drift = cell(ceil((grid.Xmax(1)-grid.Xmin(1))/grid.dx), ceil((grid.Xmax(2)-grid.Xmin(2))/grid.dx));
                for i = 1:size(drift,1)
                    for j = 1:size(drift,2)
                        if ~isempty(tempmap{i,j})
                            if tempmap{i,j}(1) >= params.nPts
                                tmp = tempmap{i,j};
                                x = tmp(2)/tmp(1);
                                y = tmp(3)/tmp(1);
                                new = [x y];
                                drift{i,j} = new;
                            end
                        end
                    end
                end
                
                vectormap = VectorMap(grid, drift, params, 0, params.flag3d);
                
            elseif flag3d == 1
                for i = 1:size(trajs.ids,1)
                    singltraj = trajs.trajs(trajs.trajs(:,1) == trajs.ids(i),:);
                    for j = 1:size(singltraj,1)-1
                        p1 = singltraj(j,:);
                        p2 = singltraj(j+1,:);
                        
                        if p1(:,3) < grid.Xmin(1) || p1(:,3) > grid.Xmax(1) || p1(:,4) < grid.Xmin(2) || p1(:,4) > grid.Xmax(2) || p1(:,5) < grid.Zmin(1) || p1(:,5) > grid.Zmax(1)
                            continue
                        end
                        
                        gpos = grid.PostoGridpos(p1(:,3:5));
                        
                        tmp = tempmap{gpos(1:3)};
                        if isempty(tmp)
                            tmp = zeros(1,4);
                        end
                        x = (p2(:,3) - p1(:,3)) / (p2(:,2)-p1(:,2));
                        y = (p2(:,4) - p1(:,4)) / (p2(:,2)-p1(:,2));
                        z = (p2(:,5) - p1(:,5)) / (p2(:,2)-p1(:,2));
                        tmp(1) = tmp(1)+1;
                        tmp(2) = tmp(2)+x;
                        tmp(3) = tmp(3)+y;
                        tmp(4) = tmp(4)+z;
                        
                        tempmap{gpos(1), gpos(2), gpos(3)} = tmp;
                    end
                end
                
                drift = cell(ceil((grid.Xmax(1)-grid.Xmin(1))/grid.dx), ceil((grid.Xmax(2)-grid.Xmin(2))/grid.dx), ceil((grid.Zmax-grid.Zmin)/grid.dz));
                for i = 1:size(drift,1)
                    for j = 1:size(drift,2)
                        for k = 1:size(drift,3)
                            if ~isempty(tempmap{i,j,k})
                                if tempmap{i,j,k}(1) >= params.nPts
                                    tmp = tempmap{i,j,k};
                                    x = tmp(2)/tmp(1);
                                    y = tmp(3)/tmp(1);
                                    z = tmp(4)/tmp(1);
                                    new = [x y z];
                                    drift{i,j,k} = new;
                                end
                            end
                        end
                    end
                end
                
                vectormap = VectorMap(grid, drift, params, 0, params.flag3d);
            end
        end
        
        function vecmap = genDriftMapFiltered(grid, trajs, params, flag3d)
            drift = reserveMap();
            treetracks = zeros(size(trajs.trajs)-size(trajs.ids),5);
            pos = 1;
            
            if flag3d == 0
                for i = 1:trajs.ids
                    singltraj = trajs.trajs(trajs.trajs(:,1) == trajs.ids(i),:);
                    for j = 1:size(singltraj,1)-1
                        treetracks(pos,:) = singltraj(j,:);
                        pos = pos+1;
                    end
                end
                
                KdTree = KDTreeSearcher(treetracks(:,3:4));
                r = params.filterSize;
                range = grid.getrange();
                gridpos = zeros(range(1)*range(2),2);
                
                pos = 1;
                for i = 1:grid.Xmax(1)
                    for j = 1:grid.Xmax(2)
                         gridpos(pos,:) = grid.getpos(i,j);
                         pos = pos+1;
                    end
                end

                curDrift = [0, 0];
                curSumW = 0;
                npts = 0;
                
                for i = 1:pos
                    IdxKDT = rangesearch(KdTree,gridpos(i,:),r);
                    filteredtracks = treetracks(IdxKDT,:);
 
                    point1 = filteredtracks(i,3:4);
                    dist = appUtilsDistance(point1 ,gridpos(i,:));
                    if dist < params.filterSize
                        point2 = filteredtracks(i+1,3:4);
                        w = cos(pi/2 * d/params.filterSize);
                        x = curDrift(1)+w*(point2(3)-point1(3))/(point2(2)-point1(2));
                        y = curDrift(2)+w*(point2(4)-point1(4))/(point2(2)-point1(2));
                        curDrift(1) = curDrift(1)+x;
                        curDrift(2) = curDrift(2)+y;
                        curSumW = curSumW+w;
                        npts = npts +1;
                    end
                    if npts > params.nPts
                        x = curDrift(1)/curSumW;
                        y = curDrift(2)/curSumW;
                        
                        drift(gridpos(i)) = [x y];
                    end
                end
                vecmap = VectorMap(grid, drift, params, 0, flag3d);
                
            elseif flag3d == 1
                for i = 1:trajs.ids
                    singltraj = trajs.trajs(trajs.trajs(:,1) == trajs.ids(i),:);
                    for j = 1:size(singltraj,1)-1
                        treetracks(pos,:) = singltraj(j,:);
                        pos = pos+1;
                    end
                end
                
                KdTree = KDTreeSearcher(treetracks(:,3:5));
                r = params.filterSize;
                range = grid.getrange();
                gridpos = zeros(range(1)*range(2),3);
                
                pos = 1;
                for i = 1:grid.Xmax(1)
                    for j = 1:grid.Xmax(2)
                        for k = 1:grid.Zmax
                             gridpos(pos,:) = grid.getpos(i,j,k);
                             pos = pos+1;
                        end
                    end
                end

                curDrift = [0, 0, 0];
                curSumW = 0;
                npts = 0;
                
                for i = 1:pos
                    IdxKDT = rangesearch(KdTree,gridpos(i,:),r);
                    filteredtracks = treetracks(IdxKDT,:);
 
                    point1 = filteredtracks(i,3:5);
                    dist = appUtilsDistance(point1 ,gridpos(i,:));
                    if dist < params.filterSize
                        point2 = filteredtracks(i+1,3:5);
                        w = cos(pi/2 * d/params.filterSize);
                        x = curDrift(1)+w*(point2(3)-point1(3))/(point2(2)-point1(2));
                        y = curDrift(2)+w*(point2(4)-point1(4))/(point2(2)-point1(2));
                        z = curDrift(3)+w*(point2(5)-point1(5))/(point2(2)-point1(2));
                        curDrift(1) = curDrift(1)+x;
                        curDrift(2) = curDrift(2)+y;
                        curDrift(3) = curDrift(3)+z;
                        curSumW = curSumW+w;
                        npts = npts +1;
                    end
                    if npts > params.nPts
                        x = curDrift(1)/curSumW;
                        y = curDrift(2)/curSumW;
                        z = curDrift(3)/curSumW;
                        
                        drift(gridpos(i)) = [x y z];
                    end
                end
                vecmap = VectorMap(grid, drift, params, 0, flag3d);
            end
        end
        
        function vecmap = rotate_field(drift, phi, flag3d)
            if flag3d == 0
                R = rotz(phi);
                v = cellfun(@(x) x(2:4)*R,drift);
                vecmap = VectorMap(drift.grid(), v, drift.params,drift.norm,drift.flag3d);
                
            elseif flag3d == 1
                R = rotz(phi)*roty(phi);
                v = cellfun(@(x) x(2:4)*R,drift);
                vecmap = VectorMap(drift.grid(), v, drift.params,drift.norm,drift.flag3d);
            end
        end
        
        function vecmap = normalized_drift(drift)
            if flag3d == 0
                v = cellfun(@(x) x(2:4)/sqrt(x(2)^2+x(3)^2),drift);
                vecmap = VectorMap(drift.grid,v,drift.params,drift.norm,drift.flag3d);
            elseif flag3d == 1
                v = cellfun(@(x) x(2:5)/sqrt(x(2)^2+x(3)^2+x(4)^2),drift);
                vecmap = VectorMap(drift.grid,v,drift.params,drift.norm,drift.flag3d);
            end
        end
        
        function vecmap = applyFactor(drift, factor)
            if flag3d == 0
                v = cellfun(@(x) x(2:4)*factor,drift);
                vecmap = VectorMap(drift.grid,v,drift.params,drift.norm,drift.flag3d);
            elseif flag3d == 1
                v = cellfun(@(x) x(2:5)*factor,drift);
                vecmap = VectorMap(drift.grid,v,drift.params,drift.norm,drift.flag3d);
            end
        end
                
               
        
        
    end
end
   
        