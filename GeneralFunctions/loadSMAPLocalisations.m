function localisations = loadSMAPLocalisations(file)
%Loads localisation data from SMAP .mat files
    matfile = load(file);
    locs = matfile.saveloc.loc;

    %newfile(:,1) = [];
    newfile(:,2) = locs.frame; %t
    newfile(:,3) = locs.xnm; %x
    newfile(:,4) = locs.ynm; %y
    try
        newfile(:,5) = locs.znm; %z
    catch
    end
    if size(newfile,2)<5
        newfile(:,5) = 0;
    end
    newfile(:,6) = locs.locprecnm; %xyerr
    try
        newfile(:,7) = locs.locprecznm; %zerr
    catch
    end
    newfile(:,8) = locs.phot; %photons
    newfile(:,9) = locs.photerr; %photon error
    newfile(:,10) = locs.bg; %bg
    
    localisations = newfile;
end