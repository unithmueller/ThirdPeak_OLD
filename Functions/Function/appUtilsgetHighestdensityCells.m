function res = appUtilsgetHighestdensityCells(dens, densitythresh, flag3d)
    tmp = cell2mat(dens);
    tmp = tmp(:);
    tmp = sort(tmp,"descend");
    
    sz = size(dens);
    num_cells = ceil(densitythresh/100*size(tmp));
    if flag3d == 0
        res = zeros(num_cells,2);
    elseif flag3d == 1
        res = zeros(num_cells,3);
    end
        
    for i = 1:num_cells
        val = tmp(i);
        ind = find([dens{:}] == val);
        
        if flag3d == 0
            [row, col] = ind2sub(sz, ind);
            res(i,:) = [row,col];
        elseif flag3d == 1
            [row, col, pln] = ind2sub(sz, ind);
            res(i,:) = [row, col, pln];
        end
    end
end
    
    
    
    
    