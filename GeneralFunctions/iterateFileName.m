function filename = iterateFileName(Reference, filename, counter)
%Function to find a file name that has not been used yet. Uses a array as
%reference.
%Input: Referece - Array of names that have been used already
        % filename - name of the new file
        % counter - counter value for the new file name and to count the
        % iterations
%Output: filename - the new filename
    filename = strcat(filename,"_",string(counter));
    if any(string(Reference) == filename)
        counter = counter + 1;
        tmp = split(filename,"_");
        filename = tmp(1);
        filename = iterateFileName(Reference, filename, counter);
    else
        return
    end
end