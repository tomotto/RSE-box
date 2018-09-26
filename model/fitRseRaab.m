function [fit, logL] = fitRseRaab( rt1, rt2, rtR )
%FITRSERAAB   Maximum likelihood estimation of the overall RSE model (4 parameters).
% [FIT, LOGL] = FITRSERAAB( RT1, RT2, RTR ) performs a joint model fitting
% for the three conditions of the redundant signals paradigm. It returns
% maximum likelihood estimates (MLEs) for the two LATER units (mu1, mu2,
% sigma1, and sigma2). For the redundant signals condition, the model
% assumes statistical independence (rho=0) and context invariance (eta=0;
% see Otto & Mamassian, 2012), which corresponds to Raab's (1962)
% independent race model. Input arguments RT1, RT2, and RTR are vectors
% that contain reaction times in the paradigm's three conditions. Output
% argument FIT returns the MLEs of the parameters in the order mu1, mu2,
% sigma1, and sigma2. LOGL contains the log-likelihood of the MLE.
%
% Reference:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
% Raab (1962). Statistical Facilitation of Simple Reaction Times.
% Transactions of the New York Academy of Sciences, 24(5), 574-590.
%
% Prerequisites:
% Requires function MLE (Matlab's Statistics and Machine Learning Toolbox)
%
% See also demo03_race, fitRse, fitRace, fitLater, simRace

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details


% -------------------------------------------------------------------------
%  Check input arguments and prepare data
% -------------------------------------------------------------------------

if ~isvector( rt1 )
    error( 'The input argument RT1 needs to be a vector.' )
end
if ~isvector( rt2 )
    error( 'The input argument RT2 needs to be a vector.' )
end
if ~isvector( rtR )
    error( 'The input argument RTR needs to be a vector.' )
end

% Compute the reciprocal of RTs and collate data
data = 1 ./ [ rt1(:); rt2(:); rtR(:) ];

% Create index of RSE conditions
idx = [     ones( length(rt1), 1 ); ...
        2 * ones( length(rt2), 1 ); ...
        3 * ones( length(rtR), 1 ) ];

% -------------------------------------------------------------------------
%  Fitting procedure
% -------------------------------------------------------------------------

% Start values for LATER model parameters [ MU1, MU2, SIGMA1, SIGMA2 ]
startVal = zeros(1,4);
for cc=1:2
    startVal(cc)   = mean( data(idx==cc) );
    startVal(cc+2) =  std( data(idx==cc) );
end

% Lower and upper bounds for the fitting procedure
lowBound = 0.75 * startVal;
uppBound = 1.25 * startVal;

% Function handel for the fitting procedure
custpdf = @( data, mu1, mu2, sigma1, sigma2 ) ...
   modelpdf( data, mu1, mu2, sigma1, sigma2, idx );

% Get the MLE...
fit = mle( data, 'pdf',        custpdf,  ... 
                 'start',      startVal, ...
                 'lowerbound', lowBound, ...
                 'upperbound', uppBound, ...
                 'optimfun',   'fmincon' );

% Get the log-likelihood
logL = sum( log( modelpdf( data, fit(1), fit(2), fit(3), fit(4), idx ) ) );

end


% -------------------------------------------------------------------------
%  Model PDF function
% -------------------------------------------------------------------------
function y = modelpdf( data, mu1, mu2, sigma1, sigma2, idx )
        
% Single signal conditions
y1 = normpdf( data(idx==1), mu1, sigma1 );
y2 = normpdf( data(idx==2), mu2, sigma2 );

% Redundant signals condition
yR = maxNormPDF( data(idx==3), [mu1 mu2], [sigma1 sigma2], 0 );

% Collate likelihoods
y = [ y1; y2; yR];

end