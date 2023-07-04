function Peaksfile = SaveSMAPAsPeaks (InFile)

%InFile = strcat(SMAPFolder,'/',SMAP_file);
InFile = load(InFile);
loc = InFile.saveloc.loc;
newPeaks = [];

newPeaks(:,1) = loc.frame;
newPeaks(:,2) = loc.xnm;
newPeaks(:,3) = loc.ynm;
try
    newPeaks(:,4) = loc.znm;
end
newPeaks(:,5) = loc.locprecnm.^2;
newPeaks(:,6) = loc.phot;
newPeaks(:,7) = loc.bg;
newPeaks(:,8) = loc.PSFxpix;
newPeaks(:,9) = loc.xnmerr;
newPeaks(:,10) = loc.ynmerr;
try
    newPeaks(:,11) = loc.zerr;
    newPeaks(:,12) = loc.zerr;
end
%newPeaks(:,12) = loc.locprecnm;
newPeaks(:,13) = loc.photerr;
newPeaks(:,14) = loc.bg.*0.01;
newPeaks(:,15) = loc.PSFxpix;
newPeaks(:,16) = loc.xpixerr;
newPeaks(:,17) = loc.frame;
newPeaks(:,18) = loc.frame;
newPeaks(:,19) = loc.frame;

Peaksfile = real(newPeaks);
return

    %output frame,X0,Y0,Z0,Width,Intensity,Offset,Ellipticity, variance dX0,dY0,dZ0,dW,dI,dO,dE,chi,test]
    

%save([SMAPFolder '/Peaks.mat'], 'newPeaks','-ascii')


