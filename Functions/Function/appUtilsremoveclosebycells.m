function finalcells = appUtilsremoveclosebycells(dens, cells, distthresh, flag3d)
    finalcells = [];
    progres = zeros(size(cells));
 
    if flag3d == 0
        for i = 1:size(cells)
            if progres(i) == 1
                continue
            else
                gridpos1 = cells(i);
                neighbor = zeros(size(cells));
                neighbdens = zeros(size(cells));
                for j = 1:size(cells)
                    if progres(j) == 1
                        continue
                    else
                        gridpos2 = cells(j);
                        if abs(gridpos1(1)-gridpos2(1)) <= distthresh && abs(gridpos1(2)-gridpos2(2)) <= distthresh
                            neighbor(j) = j;
                            neighbdens(j) = dens{gridpos2(1),gridpos2(2)};
                            progres(j) = 1;
                        end
                    end
                end
                bestdens = max(neighbdens);
                cell = cells((neighbdens == bestdens),:);
                finalcells = [finalcells, cell];
            end
        end
        
    elseif flag3d == 1
        for i = 1:size(cells)
            if progres(i) == 1
                continue
            else
                gridpos1 = cells(i);
                neighbor = zeros(size(cells));
                neighbdens = zeros(size(cells));
                for j = 1:size(cells)
                    if progres(j) == 1
                        continue
                    else
                        gridpos2 = cells(j);
                        if abs(gridpos1(1)-gridpos2(1)) <= distthresh && abs(gridpos1(2)-gridpos2(2)) <= distthresh && abs(gridpos1(3)-gridpos2(3)) <= distthresh*flag3d.relation
                            neighbor(j) = j;
                            neighbdens(j) = dens{gridpos2(1),gridpos2(2),gridpos2(3)};
                            progres(j) = 1;
                        end
                    end
                end
                bestdens = max(neighbdens);
                cell = cells((neighbdens == bestdens),:);
                finalcells = [finalcells, cell];
            end
        end
    end
end

            
            
            
                        
            
            