function [out]=fitDbyCumulativeJumpDistancesbyTrackItModified(x, y, trackingRadius, startD, nRates, flag3d, timestep)
%
%[out]=dispfit_cumulative(x, y, trackingRadius, startD, nRates)
%
% Analyse diffusion properties of single-molecule tracks based on the 
% distribution of their jump distances. This function fits one, two or three exponential 
% components to the cumulative histogram of squared jump distances (see TrackIt manual).
% Modified after: 
  %  1.Weimann, L. et al. A Quantitative Comparison of Single-Dye Tracking Analysis Tools Using Monte Carlo Simulations. PLoS ONE 8, e64287 (2013).
  
%
%
% Input:
%   x               -   bin centres of cumulative histogram of squared jump distances (Column vector)
%   y            	-   counts normalized to 1 (Column vector)
%   trackingRadius 	-   Maximum allowed jump distance that was used for tracking.
%   startD         	-   numeric array containing starting values of D for the fit (as many starting values as exponential rates)
%   nRates         	-   numeric value of 2 or 3 for fitting two or three rates respectively
%   flag3d          -   determines if 2d or 3d diff coefficient will be
%                       calculated
%   timestep        -   deltaT for the calculation of the diffusion
%   coefficient
%
% Output: Struct out with fields
%   D               -   Diffusion constants
%   Derr            -   95% confidence interval of D
%   A               -   Amplitudes
%   Aerr            -   95% confidence interval of A
%   Adj. R-squared  -   To evaluate the goodness of the fit
%   Message         -   lsqnonlin-status
%   SSE             -   Summed squared of residuals
%   xy              -   bin centers of histogram (as input) and corresponding fit function values
%

%Run Fit
options=optimoptions('lsqnonlin','Display','none');

if nRates == 1
    [para,SSE,~,~,fit_out,~,J] =...
        lsqnonlin(@(D)oneRate(D,x,y,trackingRadius, flag3d),startD(1),[],[],options);
    
    %Calculate fitted function values
    f=oneRate(para,x,0,trackingRadius, flag3d);
    
    %Calculate Error
    [confint,R] = lsqnonlinerror(para,SSE,J,x,y);
    
    %Generate out-struct
    D = para(1);
    Derr = confint';
    A = 1;
    Aerr = [];
elseif nRates == 2
    [para,SSE,~,~,fit_out,~,J] =...
        lsqnonlin(@(D)twoRates(D,x,y,trackingRadius, flag3d),[startD(1),startD(2),0.3],[0, 0, 0],[inf, inf, 1],options);
    
    %Calculate fitted function values
    f=twoRates(para,x,0,trackingRadius, flag3d);
    
    %Calculate Error
    [confint,R] = lsqnonlinerror(para,SSE,J,x,y);
    
    %Generate out-struct
    D = para(1:2);
    A = [para(3) 1-para(3)];
    Derr = confint(1:2)';
    Aerr = [confint(3)' confint(3)'];
elseif nRates == 3    
    [para,SSE,~,~,fit_out,~,J] = lsqnonlin(@(D)threeRates(D,x,y,trackingRadius, flag3d),[startD(1),startD(2),startD(3),0.3,0.3],[0, 0, 0, 0, 0],[inf, inf, inf, 1, 1],options);
%     [para,SSE,~,~,fit_out,~,J] = lsqnonlin(@(D)threeRates(D,x,y,trackingRadius),[startD(1),startD(2),startD(3),0.3,0.3],[0, 0, 7, 0, 0],[inf, inf, 7, 1, 1],options);
        
    %Calculate fitted function values
    f=threeRates(para,x,0,trackingRadius, flag3d);
    
    %Calculate Error
    [confint,R] = lsqnonlinerror(para,SSE,J,x,y);
    
    %Generate out-struct
    D = para(1:3);
    A = [para(4) para(5) 1-para(4)-para(5)];
    Derr = confint(1:3)';
    Aerr = [confint(4:5)' confint(4)+confint(5)];
end

if flag3d == 1
    D = D./(6*timestep);
    Derr = Derr./(6*timestep);
    effectiveD = sum(D.*A);
    out=struct('D',D,'Derr',Derr, 'A', A, 'Aerr',Aerr,'EffectiveD',effectiveD,'Ajd_R_square',R,'Message',fit_out,'SSE',SSE,'xy',[x,f]);
else
    D = D./(4*timestep);
    Derr = Derr./(4*timestep);
    effectiveD = sum(D.*A);
    out=struct('D',D,'Derr',Derr, 'A', A, 'Aerr',Aerr,'EffectiveD',effectiveD,'Ajd_R_square',R,'Message',fit_out,'SSE',SSE,'xy',[x,f]);
end

end

function d=oneRate(para,x,y,trackingRadius, flag3d)

    D1=para(1);
    if flag3d
        f=(1-exp(-x.^3/D1))/(1-exp(-trackingRadius^3/D1));
    else
        f=(1-exp(-x.^2/D1))/(1-exp(-trackingRadius^2/D1));
    end
  
    d=f-y;
end

function d=twoRates(para,x,y,trackingRadius, flag3d)

    D1=para(1);
    D2=para(2);
    
    A=para(3);
    if flag3d
        f=A*(1-exp(-x.^3/D1))+(1-A)*(1-exp(-x.^3/D2))/(1-exp(-trackingRadius^3/D2));
    else
        f=A*(1-exp(-x.^2/D1))+(1-A)*(1-exp(-x.^2/D2))/(1-exp(-trackingRadius^2/D2));
        %f=A*(1-exp(-x/D1))+(1-A)*(1-exp(-x/D2))/(1-exp(-trackingRadius/D2));
    end
    
  
    d=f-y;
end

function d=threeRates(para,x,y,trackingRadius, flag3d)

    D1=para(1);
    D2=para(2);
    D3=para(3);
  
    A=para(4);
    B=para(5);
    if flag3d
        f=A*(1-exp(-x.^3/D1))+B*(1-exp(-x.^3/D2))+(1-A-B)/(1-exp(-trackingRadius^3/D3))*(1-exp(-x.^3/D3));
    else
        f=A*(1-exp(-x.^2/D1))+B*(1-exp(-x.^2/D2))+(1-A-B)/(1-exp(-trackingRadius^2/D3))*(1-exp(-x.^2/D3));
        %f=A*(1-exp(-x/D1))+B*(1-exp(-x/D2))+(1-A-B)/(1-exp(-trackingRadius/D3))*(1-exp(-x/D3));
    end
    
  
    d=f-y;

end



function [confint,R] = lsqnonlinerror(para,SSE,J,x,y)

    %Prepare degrees of freedom 
    numf=numel(x);
    nump=numel(para);
    %Prepare measure for distance between fit and model
    SST=var(y);
    %Prepare diagonal of inverse designmatrix
    J=full(J);
    invdesign=inv(J'*J);
    invdesign=diag(invdesign);
    
    %Adjusted R-squared
    R=1-SSE/(SST*(numf-nump));  
    
    %Error of coeficients
    confint=tinv(1-0.05/2,numf-nump)*sqrt(invdesign*SSE/(numf-nump));

end
