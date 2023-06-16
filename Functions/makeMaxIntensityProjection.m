function adjmaxIntProj = makeMaxIntensityProjection(CellWithImage, PercentageOfFrames)
    %Generates a maximum intensity projection of the cell containing the
    %images, per pixel. Uses a number of frames defined by the percentage
    %of cells to be used to save some time.
    arguments
        CellWithImage 
        PercentageOfFrames (1,1)
    end
    
    %Get image dimensions
    frames = size(CellWithImage,3);
    [w,l] = size(CellWithImage,1:2);
    
    frameNumUsed = ceil(frames*(PercentageOfFrames/100));
    if frameNumUsed < 100
        warning("Using less then 100 frames for MIP");
    end
    
    framesKeeped = floor(linspace(1, frames, frameNumUsed));
    
    reducedImage = CellWithImage(:,:, framesKeeped);
    %allocate max intensity image
    maxIntProj = zeros(w,l);
    
    %iteration: Per X, Per Y, Per T
    for i = 1:w
        for j = 1:l
             values = reducedImage(i,j,:);
             maxvalue = max(values);
             maxIntProj(i,j) = maxvalue;
        end
    end
    
    %adjust values between 0 and 1
    maxval = max(max(maxIntProj));
    adjmaxIntProj = maxIntProj./maxval;
    adjmaxIntProj = imadjust(adjmaxIntProj);
end