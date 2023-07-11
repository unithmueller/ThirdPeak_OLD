        function manageBackgroundImage(app)
            %controls how and if a background image is shown
            ax = app.UIAxes;
            imagedata = [];
            %colormap(ax,gray);
            switch app.Switch_5.Value
                case "Off"
                    %nothing
                    
                case "On"
                    %plot the background image
                    if app.AverageIntensityCheckBox.Value == 0
                        %select a frame for the image
                        frame = app.FrameEditField.Value;
                        imagedata = app.ImageData(:,:,frame);
                    else
                        %use the average intensity projection
                        %if isempty(app.AveragedImageData)
                        imagedata = generateAverageIntensityProjection(app);
                        
                            %app.AveragedImageData = imagedata;
                        %end
                        %imagedata = app.AveragedImageData;
                    end
                    %Create surface for the image
                    startx = 0+app.OffsetXEditField.Value;
                    starty = 0+app.OffsetYEditField.Value;
                    x = startx:startx+size(imagedata,1)-1;
                    y = starty:starty+size(imagedata,2)-1;
                    z = app.OffsetZEditField.Value;
                    [X,Y,Z] = meshgrid(x,y,z);
                    
                    %get the image
                    %I = image(ax,imagedata,'CDataMapping','scaled');
                    I = imagedata;
                    
                    %need to normalize image to fit into the colormap
                    minval = min(min(imagedata));
                    maxval = max(max(imagedata));
                    
                    scale = 65535;
                    
                    normImage = ((I-minval)/(maxval-minval))*scale;

                    %place the image on the surface
                    %axes(ax);
                    %hold(app.UIAxes,"on");
                    h1 = figure();
                    set(h1,"Visible","off");
                    warp(X,Y,Z,normImage,scale);  
                    colormap(ax,"parula"); 
                    copyobj(h1.Children.Children,ax);
                    %hold(app.UIAxes,"off");
            end
        end