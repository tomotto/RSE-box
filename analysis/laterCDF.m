function y = laterCDF( x, mu, sigma )
%LATERCDF   Reci-normal cumulative distribution function (cdf).
% Y = LATERCDF(X,MU,SIGMA) returns the cdf of a reci-normal distribution at
% each value in X using the specified values for the mean MU and standard
% deviation SIGMA. The reci-normal distribution is defined as the
% distribution of a random variable, whose reciprocal is normally
% distributed with mean MU and standard deviation SIGMA (LATER model;
% Noorani & Carpenter, 2016).
%
% Reference:
% Noorani & Carpenter (2016). The LATER model of reaction time and
% decision. Neuroscience and Biobehavioral Reviews, 64, 229-251.
%
% See also demo02_later, simLater, fitLater, raceCDF

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument X
x( x<=0 ) = NaN;

% Compute the reciprocal of X
x = 1 ./ x;

% Compute cdf
y = 1 - normcdf( x, mu, sigma );

end