function y = raceCDF( x, mu, sigma, rho, eta )
%RACECDF   Race model cumulative distribution function (cdf).
% Y = RACECDF(X,MU,SIGMA,RHO,ETA) returns the cdf of the race model
% prediction at each value in X using the specified model parameters (Otto
% & Mamassian, 2012). Input arguments MU and SIGMA are two element vectors
% that specify the recinormal distributions as eistimated in the single
% signal conditions. Optional input argument RHO sets the correlation
% between the two random processes (default is 0). Optional input argument
% ETA sets the additional noise (default is 0). When both parameters are 0,
% the function returns the independent race model prediction (Raab, 1962).
%
% References:
% Otto & Mamassian (2012). Noise and correlations in parallel perceptual
% decision making. Current Biology, 22(15), 1391-1396.
% Raab (1962). Statistical Facilitation of Simple Reaction Times.
% Transactions of the New York Academy of Sciences, 24(5), 574-590.
%
% See also demo03_race, simRace, fitRace, laterCDF

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument RHO
if exist( 'rho', 'var' )
    if ~isscalar( rho )
        error( 'The input argument RHO needs to be a scalar.' )
    elseif abs(rho)>1
        error( 'RHO needs to be between -1 and 1.' )
    end
else
    rho = 0;
end

% Check input argument ETA
if exist( 'eta', 'var' )
    if ~isscalar( eta )
        error( 'The input argument ETA needs to be a scalar.' )
    end
else
    eta = 0;
end

% Check input argument X
x( x<=0 ) = NaN;

% Compute the reciprocal of X
x = 1 ./ x;

y = 1 - maxNormCDF( x, mu, sigma + eta, rho );

end