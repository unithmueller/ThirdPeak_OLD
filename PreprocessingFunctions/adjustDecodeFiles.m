function LocalisationData = adjustDecodeFiles(LocalisationData, Pixelsize)
%DECODE for some reason has the xy coordiantes in px, the z in nm. Need to
%adjust them all to nm

szLocdata = size(LocalisationData);
data = LocalisationData(:,1);

for i = 1:szLocdata(1)
    tmpdat = data{i};
    tmpdat(:,3) = tmpdat(:,3)*Pixelsize;
    tmpdat(:,4) = tmpdat(:,4)*Pixelsize;
    data{i} = tmpdat;
end
LocalisationData(:,1) = data;
end