function [newMatrix, startIdx] = allocateSaveMatrixbyCells(LocalisationsInCell, ColumnNumber)
%Function to preallocate some memory for saving track data. Should speed up
%some code. Returns the total size of all cells.
    %save variable
    totalSize = 0;
    startIdx = zeros(size(LocalisationsInCell,1)+1,1);
    startIdx(1) = 1;
    %iterate the cells
    for i = 1:size(LocalisationsInCell,1)
        tmpSize = size(LocalisationsInCell{i,1},1);
        totalSize = totalSize + tmpSize;
        startIdx(i+1) = tmpSize+startIdx(i);
    end
    newMatrix = zeros(totalSize, ColumnNumber);
end