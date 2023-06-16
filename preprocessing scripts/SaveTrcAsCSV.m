function SaveTrcAsCSV(Infilepath, Filename, NOC ,mode)

%Saves a a standart trc file to a csv . Takes a path
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
    table.Properties.VariableNames(1:5) = {'id', 't', 'x', 'y', 'z'};
    savepath = join([resultpath '\' Filename '.csv'],'');
    writetable(table,savepath);
end
%mode 1: locs are in the matlab workspace
if mode == 1
    path = Infilepath;
    resultpath = join([path '\csv']);
    mkdir(resultpath);

    for i = 1: NOC
        cells = strcat('v',num2str(i));
        file = Filename.(cells);
        newfile = [];
            if size(file,1) > 50
                newfile(:,1:5) = file(:,1:5);
                table = array2table(newfile); %convert to table to carry header
                table.Properties.VariableNames(1:5) = {'id', 't', 'x', 'y', 'z'};
                savepath = join([resultpath '\' cells '.csv'],'');
                writetable(table,savepath);
            end
    end
end
end