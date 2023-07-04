%load into matlab
for i =1:44
    path = 'E:\Thomas\2023\230119_Ep1HaloTryps\Red_';
    filepath = join([path  string(i)  '\Red_'  string(i)  '_MMStack_Default.ome_sml.mat'],'');
    file = open(filepath);
    file = SaveSMAPAsPeaks (filepath);
    cells = strcat('v',num2str(i));
    variable.(cells) = file;
end

%run cellmask to remove unecessary signal
for i =1:44
    cells = strcat('v',num2str(i));
    dat_out = CellMaskV1(variable.(cells), [18000 18000], 'E:\Thomas\2023\230119_Ep1HaloTryps\Analysis\Coormask', i, 1)
    maskLocs.(cells) = dat_out;
end

%filter for z precision to 200nm
for i =1:44
    cells = strcat('v',num2str(i));
    zfilterlocs.(cells) = maskLocs.(cells)(find(maskLocs.(cells)(:,11)<200),:);
end

%filter for z position between =- 800nm
for i =1:44
    cells = strcat('v',num2str(i));
    zfilterlocs2.(cells) = zfilterlocs.(cells)(find(zfilterlocs.(cells)(:,4)<800 & zfilterlocs.(cells)(:,4)>-800),:);
end


%filter for z position between =- 250nm == when focused on the endosomes,
%maybe will give only intracellular signal... far stretched
for i =1:44
    cells = strcat('v',num2str(i));
    zfilterlocs2.(cells) = zfilterlocs.(cells)(find(zfilterlocs.(cells)(:,4)<250 & zfilterlocs.(cells)(:,4)>-250),:);
end

%save for swift analysis
SavePeaksAsSwift('E:\Thomas\2023\230119_Ep1HaloTryps\Analysis', zfilterlocs2, 44 ,1);

%run swift outside matlab

%import swift data
for i = 1: 44
        try
            path = join(['E:\Thomas\2023\230119_Ep1HaloTryps\Analysis\csv\tracked' '\' 'v' string(i) '.tracked.csv'],'');
            file = ImportSwiftAsTrc (path,1);
            tracks = strcat('v',num2str(i));
            variable.(tracks) = file;
        end
end

%filter tracks of at least 3 steps
for i =1:44
    try
    cells = strcat('v',num2str(i));
    file = variable.(cells);
    maxint = max(file(:,1));
    edges = unique(file(:,1));
    counts = histc(file(:,1),edges);
    interest = find(counts > 3);
    intracksnr = edges(interest);
    filtertracks = [];
    for j = 1:length(intracksnr)
        k = intracksnr(j);
        intresttrackind = find(file(:,1) == k);
        filtertracks = cat(1,filtertracks, file(intresttrackind,:));
    end
    filteredtracks.(cells) = filtertracks;
    end
end





%plot the tracks to find good cells
for i =1:44
    cells = strcat('v',num2str(i));
    try
        PlotTraces3D(filteredtracks.(cells))
        title(cells)
    end
end

SaveTrcAsCSV('E:\Thomas\2023\230119_Ep1HaloTryps\Analysis\trccsv', filteredtracks, 44 ,1);

%end of workflow, rest is just trial and error stuff





%import swift data
for i = 19: 31
        try
            path = join(['E:\Thomas\2022\221207_Ep1Halo3DGel\Analysis\csv\10ms\tracked' '\' 'v' string(i) '.tracked.csv'],'');
            file = ImportSwiftAsTrc (path,1);
            tracks = strcat('v',num2str(i));
            variable.(tracks) = file;
        end
end

%filter tracks of at least 5 steps
for i =19:31
    try
    cells = strcat('v',num2str(i));
    file = variable.(cells);
    maxint = max(file(:,1));
    edges = unique(file(:,1));
    counts = histc(file(:,1),edges);
    interest = find(counts > 5);
    intracksnr = edges(interest);
    filtertracks = [];
    for j = 1:length(intracksnr)
        k = intracksnr(j);
        intresttrackind = find(file(:,1) == k);
        filtertracks = cat(1,filtertracks, file(intresttrackind,:));
    end
    filteredtracks.(cells) = filtertracks;
    end
end





for i = 1: 40
        path = join(['C:\Users\zeb\Desktop\Thomas\2022\220615_NospinDoubleBeads\Analysis\200csv\tracked' '\' 'v' string(i) '.tracked.csv'],'');
        file = ImportSwiftAsTrc (path);
        tracks = strcat('v',num2str(i));
        variable.(tracks) = file;
end

for i =1:40
    cells = strcat('v',num2str(i));
    PlotTraces3D(variable.(cells))
    title(cells)
end










for i =1:40
    cells = strcat('v',num2str(i));
    x = zfilterlocs.(cells)(:,2);
    y = zfilterlocs.(cells)(:,3);
    z = zfilterlocs.(cells)(:,4);
    subplot(8,5,i)
    scatter(x,y)
    mygca(i) = gca;
    title(cells)
end



for i =1:28
    cells = strcat('v',num2str(i));
    zerr = variable.(cells)(:,11);
    subplot(6,6,i)
    boxplot(zerr)
    ylim([0 300])
    mygca(i) = gca;
    title(cells)
end


for i =1:28
    g = 
    cells = strcat('v',num2str(i));
    variable.(cells)(:,11);
end

for i =1:45
    cells = strcat('v',num2str(i));
    x = variable.(cells)(:,2);
    y = variable.(cells)(:,3);
    z = variable.(cells)(:,4);
    subplot(7,7,i)
    scatter(x,y)
    mygca(i) = gca;
    title(cells)
end

for i =1:28
    cells = strcat('v',num2str(i));
    x = variable.(cells)(:,2);
    y = variable.(cells)(:,3);
    z = variable.(cells)(:,4);
    subplot(6,6,i)
    scatter3(x,y,z)
    mygca(i) = gca;
    title(cells)
end


for i =1:56
    cells = strcat('v',num2str(i));
    dat_out = CellMaskV1(variable.(cells), [18000 18000], 'C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\Copyred\Output\cells\Coormask', i, 1)
    save(['C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\Copyred\Output\cells' '\' cells '.mat'],"dat_out","-mat");
    x = dat_out(:,2);
    y = dat_out(:,3);
    z = dat_out(:,4);
    subplot(6,6,i)
    scatter(x,y)
    mygca(i) = gca;
    title(cells)
end

for i =1:40
    cells = strcat('v',num2str(i));
    dat_out = CellMaskV1(variable.(cells), [18000 18000], 'C:\Users\zeb\Desktop\Thomas\2022\220615_NospinDoubleBeads\Analysis\Coormask', i, 1)
    maskLocs.(cells) = dat_out;
end

for i =1:31
    cells = strcat('v',num2str(i));
    dat_out = CellMaskV1(variable.(cells), [18000 18000], 'C:\Users\zeb\Desktop\Thomas\2022\220614_NoSpinTryps\Analysis\Coormask', i, 1);
    close all
    mkdir(['C:\Users\zeb\Desktop\Thomas\2022\220614_NoSpinTryps\Analysis\MaskfilterLocs' cells '\' cells]);
    save(['C:\Users\zeb\Desktop\Thomas\2022\220614_NoSpinTryps\Analysis\MaskfilterLocs' cells '\' cells '.mat'],"dat_out","-mat");
end


for i =1:28
    allNOF(i,1) = 10000;
end


    path = "C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\Copyred\Output";
    files = dir(path);
    names = strings([size(files),1]);
    for i = 1:size(files)
    names(i) = files(i).name;
    end
    interest = find(endsWith(names,'.mat'));
    intenames = names(interest);

    for i = 1: size(intenames)
        path = join(['C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\Copyred\Output' '\' intenames(i)],'');
        file = SaveSMAPAsPeaks (path);
        cells = strcat('v',num2str(i));
        variable.(cells) = file;
    end


cells = getNamesOfFiles('C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\Copyred\Output\cells\masked', '.mat');
for i = 1: 56
    SavePeaksAsSwift(join(['C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\Copyred\Output\cells\masked' '\' cells(i)],''));
end


cells = getNamesOfFiles('C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\Copyred\Output\cells\masked\csv\tracked', '.csv');

for i = 1: size(cells)
        path = join(['C:\Users\zeb\Desktop\Thomas\2022\220614_NoSpinTryps\Analysis\tracks' '\' cells(i)],'');
        file = ImportSwiftAsTrc (path);
        tracks = strcat('v',num2str(i));
        variable.(tracks) = file;
    end


for i =31
    cells = strcat('v',num2str(i));
    PlotTraces3D(variable.(cells))
    title(cells)
end




TrackingV1_DinVSDout_3D_SMAP('v', 'C:\Users\zeb\Desktop\Thomas\2022\220601_Tryps_Atto643\TestTrack\cells', y, 1000, 0.01, 0, ...
10, [0.1,5,25], allNOF, 10000, 9999999999,0, 9999999999, 0);

%filter data with mask
 dat_out = CellMaskV1(cell25, [18000 18000], path, i, 1);
