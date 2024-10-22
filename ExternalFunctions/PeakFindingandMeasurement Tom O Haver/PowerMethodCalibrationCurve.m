% PowerMethodCalibrationCurve simulates the calibration of a flow injection
% system or other technique that produces signal peaks that are related to
% an underlying concentration or amplitude ('amp'). In this example, six
% known standards are measured sequentially, resulting in six peaks in the
% observed signal. To simulate a realistic measurement, three sources of
% random disturbance are added to the observed signal: Noise - random white
% noise added to the signal data points; background - broad curved random
% background; and broadening - random exponential broadening of the peaks.
% In the power method, the raw time-series signal is raised to a positive
% power ('power') in order to sharpen the peaks and reduce overlap. The
% resulting peaks are measured by the measurepeaks.m function, which
% determines the absolute peak height, the peak-valley difference, the
% perperdicular drop area, and the tangent skim area. Each of these
% measures are raised to the 1/power in order to compensate for the power,
% then compared by plotting them in figures 2-5 against the true underlying
% amplitudes ("amp") and computing the slope, intercept, and R2. If all the
% random disturbances are set to zero (in lines 33-36), the R2 values will
% all be 1.000. Otherwise the measurements will not be perfect and some
% methods will result in better measurements (R2 closer to 1.000) than
% others. Note: you can expand the number of calibration standards by
% adding additinal elements to "amp", "pos", and "wid". 
% You must have gaussian.m, expgaussian.m, measurepeaks.m, and plotit.m in
% the path. Download from http://tinyurl.com/cey8rwh
% Tom O'Haver (toh@umd.edu) March 2017
%
format compact
format SHORT G
increment=1; % Interval between data points in the signal
x=1:increment:700; % defines the "time" axis.

% For each simulated peak, compute the amplitude, position, and width
amp=[1 2 3 4 5 6];  % True amplitudes of the peaks  (Change if desired)
pos=[100 200 300 400 500 600];   % Positions of the peaks (Change if desired)
wid=60.*ones(size(amp));   % Widths of the peaks (Change if desired)
% Signal disturbances. Change as desired: 0=perfect situation; larger=bad
Noise=0.0; % Amount of random noise added to the signal.  
background=0; % Amplitude of broad random background/baseline under the peaks
broadening=0; % Random broadening of peaks; try 0 to 5  
FinalSmooth=6; % Final smoothing by the detector or electronics 
power=1; % Exponent for power method (1-normal method)
% A = matrix containing one of the unit-amplidude peak in each of its rows
A = zeros(length(pos),length(x));
ActualPeaks=[0 0 0 0 0];
p=1;
for k=1:length(pos)
      % Create a series of peaks of different x-positions
      if broadening>0,
          A(k,:)=expgaussian(x,pos(k),wid(k),-(2+broadening*rand(1)))+.5.*expgaussian(x,pos(k)-10,wid(k),-(2+broadening*rand(1)));
      else
          A(k,:)=gaussian(x,pos(k),wid(k));
      end
      % Assembles actual parameters into ActualPeaks matrix: each row = 1
      % peak; columns are Peak #, Position, Height, Width, Area
      ActualPeaks(p,:) = [p pos(k) amp(k) wid(k) 1.0646.*amp(k).*wid(k)];
      TA(p,:)=trapz(x,A(k,:));
      p=p+1;
end
TrueAreas=amp.*TA';
z=amp*A;  % Multiplies each row by the corresponding amplitude and adds them up
nz=z+Noise.*randn(size(z));  % Optionally adds random noise
ry=nz+background*gaussian(x,700*rand(1),800); % Adds a broad background whose amplitude=background
if FinalSmooth<1;FinalSmooth=1;end
y=fastsmooth(ry,FinalSmooth,3,1); % Final smoothing
y=y.^power;  % Power method
demodata=[x' y']; % Assembles x and y vectors into data matrix

% Detect and measure peaks in the signal
SlopeThreshold=.001; % 
AmpThreshold=.2;
SmoothWidth=7;  % SmoothWidth should be roughly equal the peak width (in points)
FitWidth=11; % FitWidth should be roughly equal to the peak widths (in points)
sizex=size(x);
NumPoints=sizex(2);
figure(1)
Measured=measurepeaks(x,y,SlopeThreshold,AmpThreshold,SmoothWidth,FitWidth,1);
sizeP=size(Measured);
NumPeaks=sizeP(1);
disp(' ')
disp(['PowerMethodCalibrationCurve.m    Power = ' num2str(power) ])
title('Power method demo. Detected peaks are numbered. Peak table printed in Command Window')
% Label the x-axis with the parameter values
xlabel(['Power=' num2str(power) '    SlopeThresh.=' num2str(SlopeThreshold) '    AmpThresh.=' num2str(AmpThreshold) '    SmoothWidth=' num2str(SmoothWidth) '    FitWidth=' num2str(FitWidth)])
clear PeakHeight
clear PeakTable

disp('          Peak    Position      PeakMax    Peak-valley    Perp drop    Tan skim')

disp(Measured)
figure(2)
clf
[coef,APM]=plotit(amp,Measured(:,3).^(1/power),1);
title('Absolute Peak Maximum')
ylabel('Measured amplitude')
xlabel('True amplitude')

figure(3)
clf
[coef,PVD]=plotit(amp,Measured(:,4).^(1/power),1);
title('Peak - Valley difference')
xlabel('True amplitude')
ylabel('Measured amplitude')

figure(4)
clf
[coef,PDA]=plotit(amp,Measured(:,5).^(1/power),1);
title('Perpendicular drop Area');
xlabel('True amplitude')
ylabel('Measured peak area')

figure(5)
clf
[coef,TSA]=plotit(amp,Measured(:,6).^(1/power),1);
title('Tangent skim Area')
xlabel('True amplitude')
ylabel('Measured peak area')

figure(6)
clf
plotit(TrueAreas,Measured(:,6).^(1/power),1);
title('Correlation between true and measured tangent skim area (note that slope is less than 1)')
xlabel('True peak area')
ylabel('Measured peak area')

disp('R2 values')
disp('      PeakMax    Peak-valley    Perp drop    Tan skim')
disp([APM PVD PDA TSA])