function calculateFromWellDetection(app)
%Performes the calculations originating from the Well Detection Window in
%the Main app so that all information is stored at the main app. A script
%to manage the necessary function calls in a certain order. 

    %Check that all parameters are passed to the function
    arguments
        app.MainappImageParams {mustBeNonempty}
        app.MainappVisulParams {mustBeNonempty}
        app.WelldetectProperties {mustBeNonempty}
        app.MapdetectProperties {mustBeNonempty}
    end
    
    %Check if timewindows are used and if necessary generate them. Else
    %just use the whole movie as a single window
    finaltimewins = [];
    if app.MainappImageParams.useTimeWind == 1
        maxTimepoint = max(app.SelectedCell(:,2));
        winLength = app.TimeWinDur;
        if winLength < 0 || winLength > maxTimepoint %check if window length is in range
            return
        else
            
        end
            
        
    else
    end
end