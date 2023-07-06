function processBeadsAndCellImage(fileToProcess, app)
%This function will take the file and their location to process the
%microscopy iamges. Tiffs will be loaded, Max Intenstiy Projections
%generated and an interactive drawing tool will be enabled to mark the
%bead. Then two separate tiffs will be saved, one for the bead, one for the
%cell. These can be used seperately for localisation and then for drift
%correction.
    %% Loading and generating the MaxIntProjection
    %Load the tiff
    d = uiprogressdlg(app.PreprocessingWindowUIFigure, "Title", "Loading Tiff");
    drawnow
    multitiff = loadtiff(fileToProcess);
    close(d)
    framenum = size(multitiff,3);
    percen = 0;
    %find at least 100 frames
    for i = 1:100
        if framenum*(i/100) >= 100
            percen = i;
            break
        else
            continue
        end
    end
    if percen == 0
        percen = 100;
    end
    
    %make the intensity projection
    adjmaxIntProj = makeMaxIntensityProjection(multitiff, percen);
    %% draw the mask
    try
        %make the mask on them
        BW = roipoly(adjmaxIntProj);
        close
    catch
    end
    %% filter the data
    %if a mask was generated, filter the images
    if isa(BW, "logical")
        %generate filterted image
        beadtiff = zeros(size(multitiff));
        celltiff = zeros(size(multitiff));
        %apply the mask to the original image
        for i = 1:size(multitiff,3)
            tmpframe = multitiff(:,:,i);
            tmpbead = zeros(size(tmpframe,1:2));
            tmpcell = zeros(size(tmpframe,1:2));
            tmpbead(BW) = tmpframe(BW);
            tmpcell(~BW) = tmpframe(~BW);
            beadtiff(:,:,i) = tmpbead;
            celltiff(:,:,i) = tmpcell;
        end
        %% save the data
        %save the images
        [path, name, ext] = fileparts(fileToProcess);
        beadname = [name "_bead"];
        cellname = [name "_cell"];
        
        d = uiprogressdlg(app.PreprocessingWindowUIFigure, "Title", "Saving Tiff");
        drawnow
        saveastiff(beadtiff, join([path "/" beadname ext],""));
        saveastiff(celltiff, join([path "/" cellname ext],""));

        close(d)
    else
        %no filter mask, do nothing
    end
end