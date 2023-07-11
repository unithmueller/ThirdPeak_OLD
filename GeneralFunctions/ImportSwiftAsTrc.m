function Trc = ImportSwiftAsTrc(SwiftFilePath, mode)

%mode = 0: small output,
%mode = 1: big output

path = SwiftFilePath;
file = readtable(path);

trouble = file.seg_motion;
notrouble = zeros(size(trouble));
for i = 1:size(trouble)
    switch string(trouble(i))
        case 'none'
            notrouble(i) = 1;
        case 'immobile'
            notrouble(i) = 2;
        case 'diffusion'
            notrouble(i) = 3;
        case "directed"
            notrouble(i) = 4;
        case "dir_diffusion"
            notrouble(i) = 5;
        otherwise
            notrouble(i) = 6;
    end
end

file.seg_motion = notrouble;
file = table2array(file);

%mode = 0
if mode == 0
        
    %id t x y z
    newfile(:,1) = file(:,24); %segment-id
    newfile(:,2) = file(:,1);
    newfile(:,3) = file(:,2);
    newfile(:,4) = file(:,3);
    newfile(:,5) = file(:,4);
elseif mode == 1
     %id t x y z segmentD segmentDerr segmentDR segmeanjumpd sgmeanjumderr
     %motiontype
    newfile(:,1) = file(:,30); %id
    newfile(:,2) = file(:,1); %t
    newfile(:,3) = file(:,2); %x
    newfile(:,4) = file(:,3); %y
    newfile(:,5) = file(:,4); %z
    newfile(:,6) = file(:,6); %jumpdist
    newfile(:,7) = file(:,11); %segmentD
    newfile(:,8) = file(:,13); %segmentDerr
    newfile(:,9) = file(:,14); %segmentDR
    newfile(:,10) = file(:,15); %segmentmeanjumpdist
    newfile(:,11) = file(:,16); %segmeanjumpdisterr
    newfile(:,12) = file(:,18); %segment-MSD
    newfile(:,13) = file(:,19); %segment_MSDERR
    newfile(:,14) = file(:,21); %motiontype
    newfile(:,15) = file(:,22); %segmentSTart
    newfile(:,16) = file(:,23); %segmentLifetime
    newfile(:,17) = file(:,26); %numberofsegmentintrack 
    newfile(:,18) = file(:,5); %intensity
    newfile(:,19) = file(:,17); %segmentmeanjumpdistN
    newfile(:,20) = file(:,7); %timelag
    newfile(:,21) = file(:,30); %trackID
    newfile(:,22) = file(:,32); %tracksegments
    
end

sortfile = sortrows(newfile,1);
Trc = sortfile;
end