function [fit, logL] = fitRaceRho( data, mu, sigma )
%FITRACERHO   Maximum likelihood estimation of the race model.
% [FIT, LOGL] = FITRACERHO(DATA,MU,SIGMA) returns the maximum likelihood
% estimate (MLE) of rho as the only free race model parameter (Otto &
% Mamassian, 2012). Input argument DATA is a vector that contains reaction
% times in the redundant signals condition. Input arguments MU and SIGMA
% are two element vectors that specify the recinormal distributions as
% eistimated in the single signal conditions. Output argument FIT returns
% the MLE of rho. LOGL contains the log-likelihood of the MLE.
%
% Reference:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
%
% Prerequisites:
% Requires function MLE (Matlab's Statistics and Machine Learning Toolbox)
%
% See also demo03_race, simRace, raceCDF, fitLater, fitRace, fitRaceEta

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if ~isvector( data )
    error('The input argument DATA needs to be a vector.')
end

% Compute the reciprocal of DATA
data = 1 ./ data;

% Function handel for the fitting procedure
custpdf = @(data, rho) racepdf( data, rho, mu, sigma );

% Get the MLE
try
    fit = mle( data, 'pdf',          custpdf, ... 
                     'start',    	 0, ...
                     'lowerbound',  -1, ...
                     'upperbound',	 1, ...
                     'optimfun',     'fmincon' );        
catch
    fprintf('Fitting failed, probably because RHO is close to bound\n')
    fprintf('Will restrict RHO from taking extreme values and try again...\n')
    fit = mle( data, 'pdf',          custpdf, ... 
                     'start',    	 0, ...
                     'lowerbound', 	-0.999, ...
                     'upperbound',	 0.999, ...
                     'optimfun',     'fmincon' ); 
end

% Log-likelihood of the MLE
logL = sum( log( racepdf( data, fit, mu, sigma ) ) );

end

% Race model PDF
function y = racepdf( data, rho, mu, sigma )

    y = maxNormPDF( data, mu, sigma, rho );
    
end

