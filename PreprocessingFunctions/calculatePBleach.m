 function bleachvaluestring = calculatePBleach(tracks, timestepsize, timeunit, plotFlag)
    %the probability of a particle to vanish in the next frame via
    %bleaching. it is calculated via exponential decay
    %a*exp(-dt*k).
    %k can then be used for cumulative distribution function
    %1-exp(-dt*k) = probability of bleaching during one frame
    
    %% get the MJD-N
    %get MJD-N frequencies
    if size(tracks,2) >= 19 %swift has already calculated it for us
        tmpdat = tracks(:,19);
    else %had to calculate it ourselves
        tmpdat = tracks;
    end
    tmpdat = tmpdat(tmpdat>0); %remove spots
    %% calculate the decay
    %bin the track lengths
    [N,edges] = histcounts(tmpdat,'BinMethod','integers');
    timediff = timestepsize;
    edges = edges(1:end-1) + diff(edges) - 0.5;
    edges = edges*timediff;
    edges = edges.';
    %build the decay
    decfreq = zeros(size(N,2),1);
    freqsum = sum(N);
    decfreq(1) = freqsum;
    for i = 1:size(N,2)-1
        freqsum = freqsum - N(i);
        decfreq(i+1) = freqsum;
    end
    %normalize it
    normdec = decfreq/sum(N);
    %fit exponential decay
    f = fit(edges,normdec,'exp1','StartPoint',[1,0]);

    pbleach = 1-exp(-(timediff)*-f.b);
    bleachvaluestring = sprintf('%.6f',pbleach);
    
    %% plot
    if plotFlag
        h1 = figure;
        plot(edges,normdec);
        hold on
        plot(f);
        ylabel("Normalized Tracklength");
        labeltext = sprintf("Time [%s]", timeunit);
        xlabel(labeltext);
        text(gca, 1, 0.2, sprintf("pBleachValue: %.6f",pbleach));

        savefig(gcf, "Bleachdecay");
        saveas(gcf, "Bleachdecay.svg");
        close(gcf);
    end
end