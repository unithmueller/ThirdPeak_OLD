classdef ScalarMap
    properties
        squaregrid
        data
        map
        params
        flag3d
        densityopt
    end
    
    methods
        function obj = ScalarMap(grid, data, param, flag3d)
            obj.squaregrid = grid;
            obj.data = data;
            obj.params = param;
            obj.flag3d = flag3d;
            %obj.densityopt = ["NPTS", "DENS", "LOGDENS"];
        end
        
        function grid = getGrid(obj)
            grid = obj.squaregrid;
        end
        
        function par = getParams(obj)
            par = obj.params;
        end
        
        function dat = getDat(obj, pos)
            if obj.flag3d == 0
                dat = obj.data.getdat(pos(1), pos(2));
            elseif obj.flag3d == 1
                dat = obj.data.getdat(pos(1), pos(2), pos(3));
            end
        end
        
        function val = isSet(obj, pos)
            if obj.flag3d == 0
                val = obj.data.isSet(pos(1), pos(2));
            elseif obj.flag3d == 1
                val = obj.data.isSet(pos(1), pos(2), pos(3));
            end
        end
        
        function maxx = getMax(obj)
            maxx = cellfun(@(x) max(cell2mat(x)),obj.data);
        end
        
        function maxx = getmaxfromselection(obj, positions)
            subset = zeros(size(positions,1),3);
            for i = 1:size(positions,1)
                tmppos = positions(i);
                subset(i) = obj.data.getDat(tmppos);
            end
            maxx = max(subset);
        end
        
        function dat = getallValues(obj)
            dat = cell2mat(obj.data);
        end
        
        function dat = getallPos(obj)
            steps  = obj.squaregrid.getrange();
            dat = zeros(steps(1)*steps(2)*steps(3),2);
            cnt = 1;
            if obj.flag3d == 0
                for i = 1:steps(1)
                    for j = 1:steps(2)
                        dat(cnt) = obj.squaregrid.getpos(i,j);
                        cnt = cnt + 1;
                    end
                end    
            elseif obj.flag3d == 1
                for i = 1:steps(1)
                    for j = 1:steps(2)
                        for k = 1:steps(3)
                            dat(cnt) = obj.squaregrid.getpos(i,j,k);
                            cnt = cnt + 1;
                        end
                    end
                end
            end
        end
        
        
    end
    
    methods(Static)
        function map = reserveMap(flag3d, grid)
            if flag3d
                map = cell(ceil((grid.Xmax(1)-grid.Xmin(1))/grid.dx), ceil((grid.Xmax(2)-grid.Xmin(2))/grid.dx), ceil((grid.Zmax-grid.Zmin)/grid.dz));
            else
                map = cell(ceil((grid.Xmax(1)-grid.Xmin(1))/grid.dx), ceil((grid.Xmax(2)-grid.Xmin(2))/grid.dx));
            end
        end
        
        function denmap = genDensityMap(grid, trajs, params)
            flag3d = params.flag3d;
            tempmap = ScalarMap.reserveMap(flag3d, grid);
            %trajs = trajs{1,1};
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
                            tmp = zeros(1,1);
                        end
                        tmp = tmp+1;
                        tempmap{gpos(1), gpos(2)} = tmp;
                    end
                end
                
                  for i = 1:size(tempmap,1)
                    for j = 1:size(tempmap,2)
                        if isempty(tempmap{i,j})
                            tempmap{i,j} = [0];
                        end
                    end
                  end
                
                if params.dopt == "DENS"
                    tmp = cellfun(@(x) x/(grid.dx^2),tempmap);
                    tempmap = tmp;  
                elseif params.dopt == "LOGDENS"
                    tempmap = cellfun(@(x) log(x/(grid.dx^2)),tempmap);
                elseif params.dopt == "NPTS"
                end
                denmap = ScalarMap(grid, tempmap, params, flag3d);
                
                if params.filtNhSize > 1
                    denmap = genDensityMapFiltered(tempmap, params);
                end
  
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
                            tmp = zeros(1,1);
                        end
                        tmp = tmp+1;
                        tempmap{gpos(1), gpos(2), gpos(3)} = tmp;
                    end
                 end
                
                 for i = 1:size(tempmap,1)
                    for j = 1:size(tempmap,2)
                        for k = 1:size(tempmap,3)
                            if isempty(tempmap{i,j,k})
                                tempmap{i,j,k} = [0];
                            end
                        end
                    end
                 end 
                
                if params.dopt == "DENS"
                    tmp = cellfun(@(x) x/(grid.dz*grid.dx^2),tempmap);
                    tempmap = tmp;  
                elseif params.dopt == "LOGDENS"
                    tempmap = cellfun(@(x) log(x/(grid.dz*grid.dx^2)),tempmap);
                elseif params.dopt == "NPTS"
                end
                denmap = ScalarMap(grid, tempmap, params, flag3d);
                if params.filtNhSize > 1
                    denmap = genDensityMapFiltered(tempmap, params);
                end
            end
        end
        
        function diffmap = genDiffusionMap(grid, trajs, params)
            tempmap = ScalarMap.reserveMap(params.flag3d, grid);
            %trajs = trajs.trajs(:);
            flag3d = params.flag3d;
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
                        else
                            a= 1;
                        end
                        x = (p2(3)-p1(3))^2/(p2(2)-p1(2));
                        y = (p2(4)-p1(4))^2/(p2(2)-p1(2));
                        tmp(1) = tmp(1)+1;
                        tmp(2) = tmp(2)+x;
                        tmp(3) = tmp(3)+y;
                        
                        tempmap{gpos(1), gpos(2)} = tmp;
                        tmp = [];
                    end
                end
                
                for i = 1:size(tempmap,1)
                    for j = 1:size(tempmap,2)
                        if isempty(tempmap{i,j})
                            tempmap{i,j} = [0,0,0];
                        end
                    end
                end
                
                tmp = cellfun(@(x) sqrt(x(2)+x(3))/x(1),tempmap);
                diffmap = ScalarMap(grid, tmp, params, flag3d);
                
            elseif params.flag3d == 1
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
                        x = (p2(3)-p1(3))^2/(p2(2)-p1(2));
                        y = (p2(4)-p1(4))^2/(p2(2)-p1(2));
                        z = (p2(5)-p1(5))^2/(p2(2)-p1(2));
                        tmp(1) = tmp(1)+1;
                        tmp(2) = tmp(2)+x;
                        tmp(3) = tmp(3)+y;
                        tmp(4) = tmp(4)+z;
                        
                        tempmap{gpos(1), gpos(2), gpos(3)} = tmp;
                        tmp = [];
                    end
               end
               
               for i = 1:size(tempmap,1)
                    for j = 1:size(tempmap,2)
                        for k = 1:size(tempmap,3)
                            if isempty(tempmap{i,j,k})
                                tempmap{i,j,k} = [0,0,0,0];
                            end
                        end
                    end
                end 
               
               
                tmp = cellfun(@(x) sqrt(x(2)+x(3)+x(4))/x(1),tempmap);
                diffmap = ScalarMap(grid, tmp, params, flag3d);
            end
        end
        
        function scalmap = genDiffusionMapFiltered(grid, trajs, params, flag3d)
            diffu = reserveMap(flag3d, grid);
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

                curDiff = 0;
                curSumW = 0;
                npts = 0;
                
                for i = 1:pos
                    IdxKDT = rangesearch(KdTree,gridpos(i,:),r);
                    filteredtracks = treetracks(IdxKDT,:);
 
                    point1 = filteredtracks(i,1:4);
                    dist = appUtilsDistance(point1 ,gridpos(i,:));
                    if dist < params.filterSize
                        point2 = filteredtracks(i+1,1:4);
                        w = cos(pi/2 * d/params.filterSize);
                        x = ((point2(3)-point1(3))^2)/(2*(point2(2)-point1(2)));
                        y = ((point2(4)-point1(4))^2)/(2*(point2(2)-point1(2)));
                        curDiff(1) = curDiff(1)+w*(x+y);
                        curSumW = curSumW+w;
                        npts = npts +1;
                    end
                    if npts > params.nPts
                        finaldif = curDiff(1)/curSumW;
                        
                        diffu(gridpos(i)) = finaldif;
                    end
                end
                scalmap = ScalarMap(grid, diffu, params, 0, flag3d);
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
                gridpos = zeros(range(1)*range(2),2);
                
                pos = 1;
                for i = 1:grid.Xmax(1)
                    for j = 1:grid.Xmax(2)
                        for k = 1:grid.Zmax
                             gridpos(pos,:) = grid.getpos(i,j,k);
                             pos = pos+1;
                        end
                    end
                end

                curDiff = 0;
                curSumW = 0;
                npts = 0;
                
                for i = 1:pos
                    IdxKDT = rangesearch(KdTree,gridpos(i,:),r);
                    filteredtracks = treetracks(IdxKDT,:);
 
                    point1 = filteredtracks(i,1:5);
                    dist = appUtilsDistance(point1 ,gridpos(i,:));
                    if dist < params.filterSize
                        point2 = filteredtracks(i+1,1:5);
                        w = cos(pi/2 * d/params.filterSize);
                        x = ((point2(3)-point1(3))^2)/(2*(point2(2)-point1(2)));
                        y = ((point2(4)-point1(4))^2)/(2*(point2(2)-point1(2)));
                        z = ((point2(5)-point1(5))^2)/(2*(point2(2)-point1(2)));
                        curDiff(1) = curDiff(1)+w*(x+y+z);
                        curSumW = curSumW+w;
                        npts = npts +1;
                    end
                    if npts > params.nPts
                        finaldif = curDiff(1)/curSumW;
                        
                        diffu(gridpos(i)) = finaldif;
                    end
                end
                scalmap = ScalarMap(grid, diffu, params, 0, flag3d);
            end
        end
        
        function filDenmap = genDensityMapFiltered(map, params, flag3d)
            filter = params.filtNhSize;
            if mod(filter,2) ~= 0
                filter = filter - 1;
                filter = filter/2;
                filterz = floor(filter*params.xzrelation);
            else
                filter = filter/2;
                filterz = floor(filter*params.xzrelation);
            end
            
            if flag3d == 0
                resmap = reserveMap(flag3d, grid);
                minPos = map.squaregrid.pos_to_gpos(map.grid.Xmin);
                maxPos = map.squaregrid.pos_to_gpos(map.grid.Xmax);
                for i = minPos(1):maxPos(1)
                    for j = minPos(2):maxPos(2)
                        val = 0;
                        nhCnt = 0;
                        for u = i-filter:i+filter
                            for p = j-filter:j+filter
                                if u<minPos(1) || u>maxPos(1) || p<minPos(2) || p>maxPos(2)
                                    continue
                                elseif map.isSet(u,p)
                                    val = val + map.getDat(u,p);
                                else
                                    val = val + 0;
                                    nhCnt = nhCnt + 1;
                                end
                            end
                            if nhCnt > 0
                                resmap{i,j} = val/nhCnt;
                            end
                        end
                    end
                end
                filDenmap = ScalarMap(map.squaregrid, resmap, params);
            elseif flag3d == 1
                resmap = reseserveMap();
                minPos = map.squaregrid.pos_to_gpos(map.grid.Xmin);
                maxPos = map.squaregrid.pos_to_gpos(map.grid.Xmax);
                minzPos = map.squaregrid.pos_to_gpos(map.grid.Zmin);
                maxzPos = map.squaregrid.pos_to_gpos(map.grid.Zmax);
                for i = minPos(1):maxPos(1)
                    for j = minPos(2):maxPos(2)
                        for k = minzPos:maxzPos
                            val = 0;
                            nhCnt = 0;
                            for u = i-filter:i+filter
                                for p = j-filter:j+filter
                                    for m = k-filterz:k+filterz
                                        if u<minPos(1) || u>maxPos(1) || p<minPos(2) || p>maxPos(2) || m<minzPos || m>maxzPos
                                            continue
                                        elseif map.isSet(u,p,m)
                                            val = val + map.getDat(u,p,m);
                                        else
                                            val = val + 0;
                                            nhCnt = nhCnt + 1;
                                        end
                                    end
                                    if nhCnt > 0
                                        resmap{i,j,k} = val/nhCnt;
                                    end
                                end
                            end
                        end
                    end
                end
                filDenmap = ScalarMap(map.squaregrid, resmap, params);
            end
        end
    end
end