function res = appUtilsremove_overlapping_wells(wells)
    to_rm = zeros(size(wells));
    
    for i = 1:size(wells)
        for j = 1:size(wells)
            if i~= j && to_rm(i) == 0 && wells(i).ellips.intersect(wells(j).ellips)
                if wells(i).score.betterThan(wells(j).score)
                    to_rm(j) = 1;
                else
                    to_rm(i) = 1;
                end
            end
        end
    end
    keep = ~to_rm;
    res = wells(keep);
end