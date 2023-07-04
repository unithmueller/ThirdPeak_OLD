function expNoiseRateValueString = calculateExpNoiseRate(intensityFilteredLocalisations)
    %Calculates the expected noise rate by:
    %nmbr of locs that: (phot-photerr)<= 2*mean(bg) devided by the nmbr of locs that: (phot-photerr)> 2*mean(bg)
    %8 pho, 9 photerr, 10 bg
    %generate array to save to
    expnoise = zeros(size(intensityFilteredLocalisations,1),1);
    %for every file
    for i = 1:size(intensityFilteredLocalisations,1)
        %get the data
        tmpdat = intensityFilteredLocalisations{i,1};
        tmpdat = tmpdat(:,8:10);
        %calculate the mean background
        meanbg = mean(tmpdat(:,3));
        %get the photon numbers
        photvals = tmpdat(:,1)-tmpdat(:,2);
        %determine the number of locs that are in and out
        locsin = size(photvals(photvals > 4*meanbg),1);
        locsout = size(photvals(photvals <= 4*meanbg),1);
        %get the relations and save it for every file
        relation = locsout/locsin;
        expnoise(i) = relation;
    end
    %get the mean of all files
    expnoise = mean(expnoise);
    expNoiseRateValueString = sprintf('%.6f',expnoise);
end