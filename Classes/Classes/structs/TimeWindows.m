classdef TimeWindows
    %Stores the time duration if time windows are used. Will split track
    %data in given windows to be analysed after each other
    properties
        duration (1,1)  = 20 %time in s from main app
        overlap (1,1)  = 0 %overlap in percent for time windows
        tMin (1,1)  = 0 %startpoint
        tMax (1,1)  = 1 %endpoint
    end
    
    methods(Static)
        %If no time windows are needed, just generate a single window with
        %all the tracks inside
        function win = generateSingleWindow(trajs)
            arguments
                trajs TrajectoryEnsemble
            end
            ti = trajs.getTimeRange();
            dur = ti(2)-ti(1)+1;
            over = 0;
            win = TimeWindows(dur, over, ti(1), ti(2));
        end
    end
    
    methods
        %Constructor
        function obj = TimeWindows(duration, overlap, tmin, tmax)
            obj.duration = duration;
            obj.overlap = overlap;
            obj.tMin = tmin;
            obj.tMax = tmax;
        end
        %gets Duration for each timestep
        function dur = getDuration(obj)
            dur = obj.duration;
        end
        %gets Overlap in percent between each time windows
        function ov = getOverlap(obj)
            ov = obj.overlap;
        end
       % sets properties depending on the trajectory ensemble 
        function obj = setTimeWindows(obj, trajs, duration, overlap)
            obj.duration = duration;
            obj.overlap = overlap;
            ti = trajs.getTimeRange();
            obj.tMin = ti(1);
            obj.tMax = ti(2);
        end
        % get the last time window index
        function id = idxMax(obj)
           id = ceil( (obj.tMax-obj.tMin) / (obj.duration * (1 - obj.overlap)))-1;
        end
        %get time window times by index
        function win = getWindow(obj, k)
            win = [obj.tMin+k*obj.duration*(1-obj.overlap), obj.tMin+k*obj.duration*(1-obj.overlap)+obj.duration];
        end
        %get the index of the timewindow by timepoint
        function idx = getIdx(obj, timepoint)
            a = floor((timepoint-obj.tMin)/(obj.duration*(1-obj.overlap)));
            if a < 0
                idx = 0;
            else
                idx = a;
            end
        end
    end
end
            
            
            