function [fit, fitci] = fitLater( data )
%FITLATER   Fitting of the LATER model.
% [FIT, FITCI] = FITLATER(DATA) returns best-fitting estimates for the
% parameters of a reci-normal distribution, which can be used to describe
% reaction time distributions (LATER model; Noorani & Carpenter, 2016). The
% reci-normal distribution is defined as the distribution of a random
% variable X, whose reciprocal Y = 1/X is normally distributed with mean mu
% and standard deviation sigma. The minimum variance unbiased estimator
% (MVUE) is used to estimate mu and sigma. Input argument DATA is a vector
% that contains reaction times. Output argument FIT returns the MVUEs of
% the parameters mu and sigma. FITCI returns the 95% confidence intervals
% of the parameters.
%
% Reference:
% Noorani & Carpenter (2016). The LATER model of reaction time and
% decision. Neuroscience and Biobehavioral Reviews, 64, 229-251.
%
% Prerequisites: 
% Requires function NORMFIT (Matlab's Statistics and Machine Learning
% Toolbox)
%
% See also demo02_later, simLater, bootLater, laterCDF, fitRace

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if ~isvector( data )
    error('The input argument DATA needs to be a vector.')
end

% Compute the reciprocal of DATA
data = 1 ./ data;

% Get the minimum variance unbiased estimator (MVUE)
[mu, sigma, muci, sigmaci] = normfit( data );

% Output variables
fit   = [mu,   sigma];
fitci = [muci, sigmaci];

end