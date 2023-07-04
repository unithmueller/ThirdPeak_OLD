function foldername = iterateSaveFoldername(foldername, counter)
    %Will find a folder name that has not be used to save in
    foldername = join([foldername, "_", counter],"");
    if exist(foldername, 'dir')
        counter = counter + 1;
        foldername = iterateSaveFoldername(foldername, counter);
    else
        mkdir(foldername);
    end
end