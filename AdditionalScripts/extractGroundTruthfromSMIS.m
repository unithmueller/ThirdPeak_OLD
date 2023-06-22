function extractGroundTruthfromSMIS(filepath)
%Allows to extract the ground truth data of the SMIS simulation into a
%matlab .mat so it can be imported into Thirdpeak. Saves is the same
%location as the original file
    path = filepath;
    file = load(path);

    locs = file.sms.sm;
    clear file
    newtracks = [];

    numberofElements = size(locs,2);

    for i = 1:numberofElements
        tmpx = locs(i).x_track;
        tmpy = locs(i).y_track;
        tmpz = locs(i).z_track;

        tracklen = size(tmpx,1);

        tmptrack = zeros(tracklen,5);
        %format id tp x y z
        tmptrack(:,1) = i;
        tmptrack(:,2) = tmpx(:,2);
        tmptrack(:,3) = tmpx(:,1);
        tmptrack(:,4) = tmpy(:,1);
        tmptrack(:,5) = tmpz(:,1);

        newtracks = [newtracks; tmptrack];
    end
    [p,f] = fileparts(path);
    name = split(f,".");
    name = name(1);
    name = join([name "_groundtruth.mat"],"");
    newpath = join([p "/" name],"");
    save(newpath,'newtracks');
end