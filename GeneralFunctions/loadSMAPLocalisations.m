function localisations = loadSMAPLocalisations(file)
%Loads localisation data from SMAP .mat files
    matfile = load(file);
    locs = matfile.saveloc.loc;

    %newfile(:,1) = [];
    newfile(:,2) = locs.frame; %t
    newfile(:,3) = locs.xnm; %x
    newfile(:,4) = locs.ynm; %y
    newfile(:,5) = locs.znm; %z
    newfile(:,6) = locs.locprecnm; %xyerr
    newfile(:,7) = locs.locprecznm; %zerr
    newfile(:,8) = locs.phot; %photons
    newfile(:,9) = locs.photerr; %photon error
    newfile(:,10) = locs.bg; %bg
    
    localisations = newfile;
end