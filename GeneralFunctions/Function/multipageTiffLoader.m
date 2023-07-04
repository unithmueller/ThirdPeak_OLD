function multitiff = multipageTiffLoader(tiffimagepath)
    %Input: Filepath as String, Output: cell containing the images
    %Function to load 3D tiff files ( usually time) in matlab as the standart
    %imread function does not support it. Will save the separate images in a
    %cell so they can be easyily accessed.
    arguments
        tiffimagepath {mustBeFile}
    end
    %get the image properties and necessary info
    path = tiffimagepath;
    info = imfinfo(path);
    frames = size(info,1);
    
    image = cell(1,frames); %make empty cell
    
    for i = 1:size(info,1)
        image{i} = imread(tiffimagepath,i, "Info", info);
    end
    
    multitiff = image;
end