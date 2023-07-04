function result = appUtilsfilter_empty_squares(drift, cells, flag3d)
    if flag3d == 0
        result = zeros(size(cells,1),size(cells,2));
        for i = 1:size(cells,1)
            for j = 1:size(cells,2)
                tmp = drift(i,j);
                test = sum(tmp) >= 0; %drift present
                if test
                    result(i,j) = 1;
                end
            end
        end
        
    elseif flag3d == 1
        result = zeros(size(cells,1),size(cells,2),size(cells,3));
        for i = 1:size(cells,1)
            for j = 1:size(cells,2)
                for p = 1:size(cells,3)
                    tmp = drift(i,j,p);
                    test = sum(tmp) >= 0; %drift present
                    if test
                        result(i,j,p) = 1;
                    end
                end
            end
        end
    end
end
    