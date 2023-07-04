function paramsout = packmainparams(app)
%Gets the values from the edit fields in the main app and stores them in a
%struct so it can be passed to the different functions when necessary
    paramsout.Pixelsize = app.PixelsizemEditField.Value;
    paramsout.Timestep = app.TimestepmsEditField.Value;
    paramsout.Staticerror = app.StaticerrornmEditField.Value;
    paramsout.Dynamicerror = app.DynamicerrornmEditField.Value;
    paramsout.XYresolution = app.XYresolutionnmEditField.Value;
    paramsout.ZResolution = app.ZresolutionnmEditField;
    paramsout.flag3d = app.Analyzein3DSwitch.Value;
    paramsout.useTimeWind = app.UseTimeWindowsCheckBox.Value;
    paramsout.TimeWinDur = app.TimeWindowDurationsEditField.Value;
end

    