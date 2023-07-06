function expdisplacementvaluestring = calculateExpDisplacement(tracks)
    %calculates the expected displacement by the mean jump distance
    %and the amount of data points from swift analysis
    %Input: tracks: either array or structured array
    %       tracklengths: structured array, only necessary if structured
    %       array has been used for tracks
    %10=MJD, 14=motiontype 2 19 = n
    if size(tracks,2) == 22 %data from swift analysis
        tmpdat = tracks(tracks(:,14) == 2,:);%all diffusing things
        if size(tmpdat,1) < 1
            tmpdat = tracks; %nothing diffusive, take all
        end
        tmpdat = tmpdat(:,[10 19]);%MJD N
        tmpdat = tmpdat(tmpdat(:,1)~=0 | tmpdat(:,1)~=0,:);
        if size(tmpdat,2)>1
            avgWghtMJD = sum(tmpdat(:,1).*tmpdat(:,2))/sum(tmpdat(:,2));
        else
            warning("No tracks present");
        end
    else
        %can not filter, take all
        tmpdat = tracks(:,[10 19]);
        tmpdat = tmpdat(tmpdat(:,1)~=0 | tmpdat(:,1)~=0,:);
        avgWghtMJD = sum(tmpdat(:,1).*tmpdat(:,2))/sum(tmpdat(:,2));
    end
    expdisplacementvaluestring = sprintf('%.6f',avgWghtMJD);
end