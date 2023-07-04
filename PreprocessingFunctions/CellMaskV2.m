function finaldat = CellMaskV2(data, ImDim, selpath, i)
% function CellMask(path, N, ImDim, ResultFolder) allows the user to define
% a cell mask and removes all positions outside this mask from the list.
% The resolution is only one pixel!
% ImDim = [120 120]
% MaxImDim = floor(max(data(:,2)));
% ImDim = [MaxImDim MaxImDim];
% par == 1 to select the coordinates of a cell mask (first time the function is called)
% par == 2 to load previously determined coordinates of a cell mask 
    multicell = 1;
    counter = 1;
    finaldat = {};
    while multicell
        dat_out = data;
        ind_del_init = [];
        figure1 = figure('units','normalized','outerposition',[0 0 1 1]);
        plot(data(:,3), data(:,4), 'b.');
        set(gca,'Ydir','reverse')
        axis equal
        title({'Press Space Key to start drawing the mask. Left Click with your mouse to draw the shape. Double click to finish. Press Enter to Skip or End the current cell'});
        pause
        name_x = ['x' num2str(i)];
        name_y = ['y' num2str(i)];
        [name_x,name_y] = getline(figure1, 'closed');

        save(join([selpath '/x' num2str(i) "_" num2str(counter) '.mat'],""), 'name_x', '-ascii');
        save(join([selpath '/y' num2str(i) "_" num2str(counter) '.mat'],""), 'name_y', '-ascii');
        close(figure1);
        
        if size(name_x,1) < 3
            break
        end

        BW1 = poly2mask(name_x, name_y, ImDim(1), ImDim(2));

        size_dat = size(data);
        for j = 1:size_dat(1)
            pxcoor = floor(data(j, 3:4));
            if pxcoor(1) == 0
                pxcoor(1) = 1;
            else
            end
            if pxcoor(2) == 0
                pxcoor(2) = 1;
            else
            end
            if pxcoor(1) > ImDim(1)-1
                pxcoor(1) = ImDim(1)-1;
            else
            end
            if pxcoor(2) > ImDim(2)-1
                pxcoor(2) = ImDim(2)-1;
            else
            end
            if BW1(pxcoor(2), pxcoor(1)) == 0
                ind_del = cat(1, ind_del_init, j);
                ind_del_init = ind_del;
            else
            end
        end
        dat_out(ind_del, :) = [];
        finaldat{counter} = dat_out;
        counter = counter + 1;
    end
end