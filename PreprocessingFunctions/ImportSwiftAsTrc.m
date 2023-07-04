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
            notrouble(i) = 0;
        case 'immobile'
            notrouble(i) = 1;
        case 'diffusion'
            notrouble(i) = 2;
        otherwise
            notrouble(i) = 3;
    end
end

file.seg_motion = notrouble;
file = table2array(file);

%mode = 0
if mode == 0
        
    %id t x y z
    newfile(:,1) = file(:,30);
    newfile(:,2) = file(:,1);
    newfile(:,3) = file(:,2);
    newfile(:,4) = file(:,3);
    newfile(:,5) = file(:,4);
elseif mode == 1
     %id t x y z segmentD segmentDerr segmentDR segmeanjumpd sgmeanjumderr
     %motiontype
    newfile(:,1) = file(:,30);
    newfile(:,2) = file(:,1);
    newfile(:,3) = file(:,2);
    newfile(:,4) = file(:,3);
    newfile(:,5) = file(:,4);
    newfile(:,6) = file(:,11);
    newfile(:,7) = file(:,13);
    newfile(:,8) = file(:,14);
    newfile(:,9) = file(:,15);
    newfile(:,10) = file(:,16);
    newfile(:,11) = file(:,21);
end

sortfile = sortrows(newfile,1);
Trc = sortfile;
end