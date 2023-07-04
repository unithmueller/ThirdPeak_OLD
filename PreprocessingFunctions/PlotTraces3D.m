function h = PlotTraces3D(result)
% function PlotTraces(result)
% plots all traces color coded 
% first drag result.trc in the workspace
figure; 
zlim = [-800 800];
%result = result(find(result(:,5)<800 & result(:,5)>-800),:); %remove unreasonable z coordinates in nm
%result = result(find(result(:,5)<0.800 & result(:,5)>-0.800),:); %remove unreasonable z coordinates in ym
for i = 1:result(end,1)
    ind = find(result(:,1) == i);
    hold on
    %h = plot3(result(ind, 3).*0.16, result(ind,4).*0.16,result(ind, 5).*5); %for home/made localisation in px and z in nm
    h = plot3(result(ind, 3), result(ind,4),result(ind, 5)); % for localisations in nm in x y and z
    set(gca,'Ydir','reverse')
    %axis equal
end
axis equal
end