function [ bootci, y ] = bootLater( data, x, bootn )
%BOOTLATER   Bootstrapping 95% confidence intervals for LATER model fits.
% [BOOTCI,Y] = BOOTLATER(DATA,X,BOOTN) uses a bootstrap procedure to return
% 95% confidence intervals (CIs) for minimum variance unbiased estimator
% (MVUEs) of the reci-normal distribution (LATER model; Noorani &
% Carpenter, 2016). Input argument DATA is a vector that contains reaction
% times, to which the LATER model is fitted. Output argument BOOTCI returns
% the 95% confidence intervals for MVUEs of the parameters mu and sigma.
% For values in the optional input argument X, 95% CIs on the fitted
% distribution are estimated and returned in optional output Y. Optional
% input argument BOOTN sets the number of Bootstrap samples (default is
% 1000).
%
% Reference:
% Noorani & Carpenter (2016). The LATER model of reaction time and
% decision. Neuroscience and Biobehavioral Reviews, 64, 229-251.
%
% See also demo02_later, simLater, fitLater, laterCDF, bootRace

% Copyright (C) 2017-18 Thomas Otto, University of St Andrews
% See rseBox_license for details

% Check input argument DATA
if ~isvector( data )
    error('Input argument DATA needs to be a vector.')
end

% Check input argument NBOOT
if ~exist( 'bootn', 'var' )
    bootn = 1000;
end

% Check input argument X
if ~exist( 'x', 'var' )
    if nargout > 1
        warning('Input argument X is needed to compute Y.')
    end
    x = NaN;
else
    if ~isvector( x )
        error('Input argument X needs to be a vector.')
    end
end

% Sample size
n = length( data );

% Bootstrap samples
bootdata = data( randi( n, n, bootn ) );

% Index for 95% CI
ci = round( bootn * [0.025, 0.975] ); 

% Fit model to bootstrap samples
bootci = zeros( bootn, 2 );
for b = 1:bootn
    bootci(b,:) = fitLater( bootdata(:,b) );
end

% Get 95% CI on best fitting distribution
y = zeros( bootn, length( x ) );
for b = 1:bootn
    y(b,:) = laterCDF( x, bootci(b,1), bootci(b,2)  );
end
y = sort( y );
y = y(ci,:);

% Get 95% CIs on best fitting model parameters
bootci = sort( bootci );
bootci = bootci(ci,:);

end