function [fit, logL] = fitRace( data, mu, sigma )
%FITRACE   Maximum likelihood estimation of the race model.
% [FIT, LOGL] = FITRACE(DATA,MU,SIGMA) returns maximum likelihood estimates
% (MLEs) for the two race model parameter rho and eta (Otto & Mamassian,
% 2012). Input argument DATA is a vector that contains reaction times in
% the redundant signals condition. Input arguments MU and SIGMA are two
% element vectors that specify the recinormal distributions as eistimated
% in the single signal conditions. Output argument FIT returns the MLEs of
% the parameters rho and eta. LOGL contains the log-likelihood of the MLE.
%
% Reference:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
%
% Prerequisites:
% Requires function MLE (Matlab's Statistics and Machine Learning Toolbox)
%
% See also demo03_race, simRace, bootRace, raceCDF, fitLater

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if ~isvector( data )
    error('The input argument DATA needs to be a vector.')
end

% Compute the reciprocal of DATA
data = 1 ./ data;

% Lower bound for ETA
etalim = 0.9 * min( sigma );

% Function handel for the fitting procedure
custpdf = @(data, rho, eta) racepdf( data, rho, eta, mu, sigma );

% Get the MLE
try
    fit = mle( data, 'pdf',         custpdf, ... 
                     'start',    	[ 0,  0 ], ...
                     'lowerbound', 	[-1, -etalim ], ...
                     'upperbound',	[ 1,  Inf ], ...
                     'optimfun',    'fmincon' );        
catch
    fprintf('Fitting failed, probably because RHO is close to bound\n')
    fprintf('Will restrict RHO from taking extreme values and try again...\n')
    fit = mle( data, 'pdf',         custpdf, ... 
                     'start',    	[ 0,      0 ], ...
                     'lowerbound', 	[-0.999, -etalim ], ...
                     'upperbound',	[ 0.999,  Inf ], ...
                     'optimfun',    'fmincon' ); 
end

% Log-likelihood of the MLE
logL = sum( log( racepdf( data, fit(1), fit(2), mu, sigma ) ) );

end

% Race model PDF
function y = racepdf( data, rho, eta, mu, sigma )

    sigma = sigma + eta;
    y = maxNormPDF( data, mu, sigma, rho );

end

