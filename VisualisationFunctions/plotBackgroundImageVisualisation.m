function plotBackgroundImageVisualisation(axes, ImageData, offsetX, offsetY, offsetZ, scalexy)
    %Function to decide if a backgorund image will be plotted and what kind of
    %image will be plotted. 
    %Input: App to grab the axes from; ImageData to be used for the
    %background; 
    %Output: Axes object for the figure
    %% Get the axes
    ax = axes;
    %% Create a surface in 3D space to house the image
    startx = 0+offsetX;
    starty = 0+offsetY;
    x = startx:startx+size(ImageData,1)-1;
    y = starty:starty+size(ImageData,2)-1;
    x = x*(scalexy);
    y = y*(scalexy);
    z = offsetZ;
    [X,Y,Z] = meshgrid(x,y,z);
    %% Normalize the image to fit the color map
    %set image data type to dobule
    ImageData = double(ImageData);
    %set the data range to 8bit
    dataRange = 255;
    %get the min and max values in the image
    minval = min(min(ImageData));
    maxval = max(max(ImageData));
    %normalize the image
    normImage = ((ImageData-minval)/(maxval-minval))*dataRange;
    %% add the image to the generated surface
    %generate a figur to work in and hide it
    h1 = figure();
    set(h1,"Visible","off");
    %add the image to the surface
    warp(X,Y,Z,normImage,dataRange);  
    colormap(ax,"parula"); 
    %transfer the image to the axes object
    copyobj(h1.Children.Children,ax);
end