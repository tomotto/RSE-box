function [fit, logL] = fitRaceEta( data, mu, sigma )
%FITRACEETA   Maximum likelihood estimation of the race model.
% [FIT, LOGL] = FITRACEETA(DATA,MU,SIGMA) returns the maximum likelihood
% estimate (MLE) of eta as the only free race model parameter (Otto &
% Mamassian, 2012). Input argument DATA is a vector that contains reaction
% times in the redundant signals condition. Input arguments MU and SIGMA
% are two element vectors that specify the recinormal distributions as
% eistimated in the single signal conditions. Output argument FIT returns
% the MLE of eta. LOGL contains the log-likelihood of the MLE.
%
% Reference:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
%
% Prerequisites:
% Requires function MLE (Matlab's Statistics and Machine Learning Toolbox)
%
% See also demo03_race, simRace, raceCDF, fitLater, fitRace, fitRaceRho

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
custpdf = @(data, eta) racepdf( data, eta, mu, sigma );

% Get the MLE
fit = mle( data, 'pdf',          custpdf, ... 
                 'start',    	 0, ...
                 'lowerbound', 	-etalim, ...
                 'upperbound',	 Inf, ...
                 'optimfun',     'fmincon' );        

% Log-likelihood of the MLE
logL = sum( log( racepdf( data, fit, mu, sigma ) ) );

end

% Race model PDF
function y = racepdf( data, eta, mu, sigma )

    sigma = sigma + eta;
    y = maxNormPDF( data, mu, sigma, 0 );

end

