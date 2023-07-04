function SavePeaksAsSwift(Infilepath, Filename, NOC ,mode)
%Saves a a standart peaks file to a csv interpetable bz swift. Takes a path
%to a file and saves the new csv in the same location

%mode 0: need to open matlab files
if mode==0  
    path = Infilepath;
    resultpath = join([path '\csv']);
    mkdir(resultpath);
    file = load(join([path '\' Filename],''));
    file = file.dat;
    Filename = extractBefore(Filename,'.');
    
    newfile(:,1:5) = file(:,1:5);
    
    table = array2table(newfile); %convert to table to carry header
    table.Properties.VariableNames(1:5) = {'t', 'x', 'y', 'z', 'intensity'};
    savepath = join([resultpath '\' Filename '.csv'],'');
    writetable(table,savepath);
end
%mode 1: locs are in the matlab workspace
if mode == 1
    path = Infilepath;
    resultpath = join([path '\csv'],"");
    mkdir(resultpath);
    for i = 1: NOC
        data = Filename{i,1};
        newfile = [];
        newfile(:,1:5) = data(:,[2:5,8]);
        table = array2table(newfile); %convert to table to carry header
        table.Properties.VariableNames(1:5) = {'t', 'x', 'y', 'z', 'intensity'};
        name = Filename{i,2};
        name = split(name,"/");
        if size(name,1) <= 1
            name = split(name,"\");
        end
        name = name{end};
        name = name(1:end-4);
        savepath = join([resultpath '\' name '.csv'],'');
        writetable(table,savepath);
    end
end
end



