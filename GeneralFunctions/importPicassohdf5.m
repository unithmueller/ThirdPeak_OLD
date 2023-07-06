function locfile = importPicassohdf5(filepath, pixelsize)
%Opens localisation file generated in Picasso and brings it in the standart
%format of the software for localistions:
%(ID) T X Y Z XYerr Zerr Photons PhotonError BG
%Picasso gives the xy coordinates in pixel, z in nm

%open the file
locs = h5read(filepath,"/locs");

%save in a new array
%cast to double to keep precision
locfile(:,2) = double(locs.frame);
locfile(:,3) = locs.x;
%adjust to metric unit
locfile(:,3) = locfile(:,3)*pixelsize;

locfile(:,4) = locs.y;
%adust to metric unit
locfile(:,4) = locfile(:,4)*pixelsize;
locfile(:,5) = locs.z;
%localisation precision given for x and y separetly, need to fit in into
%one value
prec = [locs.lpx, locs.lpy];
prec =  mean(prec,2);
prec = prec*pixelsize;
locfile(:,6) = prec;

locfile(:,7) = locs.d_zcalib*pixelsize;
locfile(:,8) = locs.photons;
%photon error is not given by Picasso. Will assume an error of 10%
locfile(:,9) = locs.photons*0.1;
locfile(:,10) = locs.bg;

end