function calculateAllIfNecessary(app)
            if isempty(app.CalculatedDataStruct.JumpDist.X)
               plotJumpDistances(app, 0);
               cla(app.UIAxes);
            end
            if isempty(app.CalculatedDataStruct.CumJumpDist.X)
               plotCumJumpDist(app, 0);
               cla(app.UIAxes);
            end
            if isempty(app.CalculatedDataStruct.MeanJumpDist.X)
               plotMeanJumpDist(app, 0);
               cla(app.UIAxes);
            end
            if isempty(app.CalculatedDataStruct.CumMeanJumpDist.X)
               plotMeanCumJumpDistances(app, 0);
               cla(app.UIAxes);
            end
           if isempty(app.CalculatedDataStruct.JumpAngles.XY)
               ids = unique(app.DataToAnalyze(:,1));
                for i = 1:size(ids,1)
                    data = app.DataToAnalyze(app.DataToAnalyze(:,1) == ids(i),:);
                    calculateJumpAngles(app, data, "Calc");
                end       
           end
           if isempty(app.CalculatedDataStruct.SwiftParams.MSD)
               plotDiffusionParameters(app, 0);
               cla(app.UIAxes);
           end
          if isempty(app.CalculatedDataStruct.InternMSD.XY.MSDclass)
               plotInternMSDValue(app, 0);
               cla(app.UIAxes);
          end
          if isempty(app.CalculatedDataStruct.SwiftParams.MSD)
               plotSwiftType(app, 0);
               cla(app.UIAxes);
          end 
          if isempty(app.CalculatedDataStruct.TrackLength.Steps)
               plotTrackSteps(app, 0);
               cla(app.UIAxes);
          end
          if isempty(app.CalculatedDataStruct.TrackLength.NetLength)
               plotTrackNetLength(app, 0);
               cla(app.UIAxes);
          end
          if isempty(app.CalculatedDataStruct.TrackLength.AbsLength)
               plotTrackAbsLength(app, 0);
               cla(app.UIAxes);
          end
          if isempty(app.CalculatedDataStruct.TrackLength.ConfRatio.XY)
               plotTrackRatio(app, 0);
               cla(app.UIAxes);
          end
          if isempty(app.CalculatedDataStruct.TrackLength.CumLen)
               plotCumTrackLength(app, 0);
               cla(app.UIAxes);
          end
          if isempty(app.CalculatedDataStruct.TrackLength.MeanLen)
               plotAvgTrackLength(app, 0);
               cla(app.UIAxes);
          end
          %managePlots(app);
        end