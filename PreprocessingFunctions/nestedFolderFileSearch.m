function filelocations = nestedFolderFileSearch(mainpath, searchstring)
    %get the folder and the file name to search in/for
    filestring = searchstring;
    mainfolder = mainpath;
    %deconstruct the filename so we know what we are looking for
    filename = split(filestring,".");
    extensions = filename{end};
    filename = filestring(1:end-size(extensions,2));
    %part before and after the counter number %d
    try
        numberpos = strfind(filename, "%d");
    catch
        msgbox("You are missing the placeholder for the number %d");
        return
    end
    splitname = split(filename,"%d");
    if numberpos == 1 %number first
        expression = ['\d*', (splitname{1}), extensions];
    else %number not first
        if size(splitname,1) == 2
            expression = [(splitname{1}),'\d*', (splitname{2}), extensions];
        else
            expression = [(splitname{1}),'\d*', extensions];
        end
    end

    %now that we know what we are looking for, we need to find it
    %get all the files with the matching extension
    extensions = sprintf("**/*.%s", extensions);
    cd(mainfolder);
    files = dir(extensions);
    %now get the files that match the expression
    interest = regexpi({files.name}, expression, "match");
    interestIndex = [];
    for i = 1:size(interest,2)
        if isempty(interest{i})
            %nothing to do here
        else
            interestIndex = [interestIndex, i];
        end
    end
    interestFilePath = {};
    for i = 1:size(interestIndex,2)
        k = interestIndex(i);
        interestFilePath(i) = {join([files(k).folder, "/", files(k).name],"")};
    end
    filelocations = interestFilePath.';
end